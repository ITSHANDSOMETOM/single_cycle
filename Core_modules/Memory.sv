module Memory (
  input  logic        clk_i,
  input  logic        resetn_i,       // Active low reset
  input  logic [31:0] addr_i,         // Địa chỉ từ LSU
  input  logic [31:0] st_data_i,      // Dữ liệu ghi (đã dịch vòng)
  input  logic [3:0]  mask_lo_i,      // Mask cho hàng N
  input  logic [3:0]  mask_hi_i,      // Mask cho hàng N+1
  input  logic        mem_write_i,    // Tín hiệu ghi
  input  logic        mem_read_i,     // Tín hiệu đọc
  
  // Các cổng I/O ngoại vi theo bảng Memory Mapping
  output logic [31:0] o_io_ledr,      // Red LEDs (0x1000_0000)
  output logic [31:0] o_io_ledg,      // Green LEDs (0x1000_1000)
  output logic [31:0] o_io_hex3_0,    // 7-segment LEDs 3-0 (0x1000_2000)
  output logic [31:0] o_io_hex7_4,    // 7-segment LEDs 7-4 (0x1000_3000)
  output logic [31:0] o_io_lcd,       // LCD Control (0x1000_4000)
  input  logic [31:0] i_io_sw,        // Switches (0x1001_0000)
  
  output logic [63:0] ld_data_o       // Dữ liệu đọc trả về LSU
);

  // --- 1. GIẢI MÃ ĐỊA CHỈ (ADDRESS DECODER) ---
  // Dựa vào các mốc bit cao [31:12] và [31:11]
  logic is_memory;
  logic is_ledr, is_ledg, is_hex3_0, is_hex7_4, is_lcd, is_sw;

  assign is_memory = (addr_i[31:11] == 21'h0);         // 0x0000_0000 - 0x0000_07FF
  assign is_ledr   = (addr_i[31:12] == 20'h10000);     // 0x1000_0000 - 0x1000_0FFF
  assign is_ledg   = (addr_i[31:12] == 20'h10001);     // 0x1000_1000 - 0x1000_1FFF
  assign is_hex3_0 = (addr_i[31:12] == 20'h10002);     // 0x1000_2000 - 0x1000_2FFF
  assign is_hex7_4 = (addr_i[31:12] == 20'h10003);     // 0x1000_3000 - 0x1000_3FFF
  assign is_lcd    = (addr_i[31:12] == 20'h10004);     // 0x1000_4000 - 0x1000_4FFF
  assign is_sw     = (addr_i[31:12] == 20'h10010);     // 0x1001_0000 - 0x1001_0FFF


  // --- 2. 512 THANH GHI RAM (2KiB Data Memory) ---
  logic [31:0] memory [0:511];
  logic [8:0] word_addr;
  logic [8:0] next_word_addr;
  assign word_addr      = addr_i[10:2];
  assign next_word_addr = word_addr + 1'b1;

  // Ghi vào RAM (Chỉ ghi khi nằm trong vùng nhớ và có lệnh ghi)
  always_ff @(posedge clk_i) begin
    if (mem_write_i && is_memory) begin
      // Hàng N (mask_lo_i)
      if (mask_lo_i[0]) memory[word_addr][7:0]   <= st_data_i[7:0];
      if (mask_lo_i[1]) memory[word_addr][15:8]  <= st_data_i[15:8];
      if (mask_lo_i[2]) memory[word_addr][23:16] <= st_data_i[23:16];
      if (mask_lo_i[3]) memory[word_addr][31:24] <= st_data_i[31:24];

      // Hàng N+1 (mask_hi_i)
      if (mask_hi_i[0]) memory[next_word_addr][7:0]   <= st_data_i[7:0];
      if (mask_hi_i[1]) memory[next_word_addr][15:8]  <= st_data_i[15:8];
      if (mask_hi_i[2]) memory[next_word_addr][23:16] <= st_data_i[23:16];
      if (mask_hi_i[3]) memory[next_word_addr][31:24] <= st_data_i[31:24];
    end
  end


  // --- 3. MEMORY-MAPPED I/O (Ghi ra các ngoại vi) ---
  always_ff @(posedge clk_i) begin
    if (!resetn_i) begin
      o_io_ledr   <= 32'b0;
      o_io_ledg   <= 32'b0;
      o_io_hex3_0 <= 32'b0;
      o_io_hex7_4 <= 32'b0;
      o_io_lcd    <= 32'b0;
    end else if (mem_write_i) begin
      if (is_ledr)   o_io_ledr   <= st_data_i;
      if (is_ledg)   o_io_ledg   <= st_data_i;
      if (is_hex3_0) o_io_hex3_0 <= st_data_i;
      if (is_hex7_4) o_io_hex7_4 <= st_data_i;
      if (is_lcd)    o_io_lcd    <= st_data_i;
    end
  end


  // --- 4. MUX ĐỌC DỮ LIỆU (Load Path từ RAM hoặc Switches) ---
  always_comb begin
    ld_data_o = 64'b0; // Default chống sinh Latch
    if (mem_read_i) begin
      if (is_memory) begin
      // Ghép Hàng N+1 và Hàng N lại
        ld_data_o = {memory[next_word_addr], memory[word_addr]};
      end else if (is_sw) begin
      // Trả về I/O, nhét vào 32 bit thấp
        ld_data_o = {32'b0, i_io_sw};
      end
    end
  end

endmodule