module LSU (
  input  logic [31:0] addr_i,          // Địa chỉ từ ALU
  input  logic [31:0] st_data_i,       // Dữ liệu cần ghi (từ rs2)
  input  logic [63:0] ld_data_i,       // Dữ liệu thô đọc từ Memory
  input  logic [2:0]  funct3_i,        // Kích thước lệnh (SB, SH, SW, LB, LH, LW...)
  input  logic        mem_write_i,     // Tín hiệu ghi từ Control Unit
  input  logic        mem_read_i,      // Tín hiệu đọc từ Control Unit
  
  // Giao tiếp với Memory Subsystem
  output logic [31:0] addr_o,          
  output logic [31:0] st_data_o,       // Dữ liệu đã dịch vòng (cho Store)
  output logic [3:0]  mask_lo_o,       
  output logic [3:0]  mask_hi_o,       
  output logic        mem_write_o,     
  
  // Trả dữ liệu sạch về cho Writeback / Register File của CPU
  output logic [31:0] ld_data_o        
);

  // --- KHAI BÁO CÁC BIẾN TRUNG GIAN ---
  logic [3:0]  base_mask;
  logic [7:0]  combined_mask;

  // 1. Chuyển tiếp địa chỉ và tín hiệu ghi
  assign addr_o      = addr_i;
  assign mem_write_o = mem_write_i;

  // 2. Data Barrel Shifter cho Store (Xoay vòng trái theo Byte)
  always_comb begin
    case (addr_i[1:0])
      2'b00:   st_data_o = st_data_i;
      2'b01:   st_data_o = {st_data_i[23:0], st_data_i[31:24]};
      2'b10:   st_data_o = {st_data_i[15:0], st_data_i[31:16]};
      2'b11:   st_data_o = {st_data_i[7:0],  st_data_i[31:8]};
      default: st_data_o = st_data_i;
    endcase
  end

  // 3. Tạo Base Mask từ funct3 khi có lệnh Ghi
  always_comb begin
    base_mask = 4'b0000;
    if (mem_write_i) begin
      case (funct3_i)
        3'b000:  base_mask = 4'b0001; // SB
        3'b001:  base_mask = 4'b0011; // SH
        3'b010:  base_mask = 4'b1111; // SW
        default: base_mask = 4'b0000;
      endcase
    end
  end

  // 4. Mask Splitter (Vẫn giữ để bảo toàn cấu trúc nếu có Store lệch)
  always_comb begin
    combined_mask = {4'b0000, base_mask} << addr_i[1:0];
    mask_hi_o     = combined_mask[7:4];
    mask_lo_o     = combined_mask[3:0];
  end

  // 5. Xử lý Dữ liệu Đọc 
  logic [63:0] shifted_data;
  logic [31:0] aligned_ld_data;
  
  always_comb begin
    case (addr_i[1:0])
        2'b00: aligned_ld_data = ld_data_i[31:0];
        2'b01: aligned_ld_data = ld_data_i[39:8];
        2'b10: aligned_ld_data = ld_data_i[47:16];
        2'b11: aligned_ld_data = ld_data_i[55:24];
        default: aligned_ld_data = 32'b0;
    endcase
end

  // Format theo funct3 
  always_comb begin
    ld_data_o = 32'b0; // Default chống Latch
    if (mem_read_i) begin
      case (funct3_i)
        3'b000:  ld_data_o = {{24{aligned_ld_data[7]}},  aligned_ld_data[7:0]};   // LB 
        3'b100:  ld_data_o = {24'b0,                     aligned_ld_data[7:0]};   // LBU
        3'b001:  ld_data_o = {{16{aligned_ld_data[15]}}, aligned_ld_data[15:0]};  // LH 
        3'b101:  ld_data_o = {16'b0,                     aligned_ld_data[15:0]};  // LHU
        3'b010:  ld_data_o = aligned_ld_data;                                     // LW 
        default: ld_data_o = aligned_ld_data;
      endcase
    end
  end
endmodule
