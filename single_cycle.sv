//----------------------------------------------------------------------//
//  Design Note
//----------------------------------------------------------------------//
//  1. Instruction Memory Depth (IMEM): At least 8 kB to run the "isa_1b.hex" or "isa_4b.hex"
//  2. Data        Memory Depth (DMEM): At least 2 kB (0x0000_0000 - 0x0000_07FF)
//  3. IMEM and DMEM are separate memory blocks (Harvard-like structure).


module single_cycle (
    input  logic        i_clk,
    input  logic        i_reset,
    input  logic [31:0] i_io_sw,
    output logic [31:0] o_io_ledr,
    output logic [31:0] o_io_ledg,
    output logic [31:0] o_io_lcd,
    output logic [ 6:0] o_io_hex0,
    output logic [ 6:0] o_io_hex1,
    output logic [ 6:0] o_io_hex2,
    output logic [ 6:0] o_io_hex3,
    output logic [ 6:0] o_io_hex4,
    output logic [ 6:0] o_io_hex5,
    output logic [ 6:0] o_io_hex6,
    output logic [ 6:0] o_io_hex7,
    output logic [31:0] o_pc_debug,
    output logic        o_insn_vld
);

// Tương thích tên tín hiệu clock và reset với code cũ của bạn
logic clk_i;
logic rst_i;
assign clk_i = i_clk;
assign rst_i = i_reset; // Đảo ngược để test thử xem có đúng pha không

// Top level file of your milestone 2
// Write your code here
//========================================================================
// 1. KHAI BÁO TOÀN BỘ DÂY DẪN (WIRES) THEO CỤM
//========================================================================

// --- Dây cụm Fetch (PC & Lệnh) ---
logic [31:0] w_pc_current;
logic [31:0] w_pc_plus4;
logic [31:0] w_pc_next;
logic [31:0] w_branch_target;
logic [31:0] w_instr;

// --- Dây cụm Decode (RegFile & ImmGen) ---
logic [31:0] w_rs1_data;
logic [31:0] w_rs2_data;
logic [31:0] w_imm_ext;
logic [31:0] w_wd_i; // Dữ liệu ghi ngược về RegFile (Writeback)

// --- Dây tín hiệu Control Unit ---
logic [1:0]  w_ctrl_mem_to_reg; // 2 bit vì điều khiển Mux 3-1-2
logic        w_ctrl_branch_en;
logic        w_ctrl_mem_read;
logic        w_ctrl_mem_write;
logic        w_ctrl_jump;
logic [1:0]  w_ctrl_alu_op;     
logic        w_ctrl_alu_src_b;
logic        w_ctrl_reg_write;
logic [1:0]  w_ctrl_alu_src_a;  // 2 bit vì điều khiển Mux 3-1-1

// --- Dây cụm Execute (ALU & Branch Control) ---
logic [3:0]  w_alu_ctrl;        
logic [31:0] w_alu_src_a_mux;   // Đầu ra của Mux 3-1-1
logic [31:0] w_alu_src_b_mux;   // Đầu ra của Mux 1
logic [31:0] w_alu_result;
logic        w_branch_o;        // Kết quả so sánh nhánh
logic [1:0]  w_pc_ctrl_sel;     // Tín hiệu chọn Mux 3-1 từ PC_control

// --- Dây cụm Memory (LSU) ---
logic [31:0] w_lsu_writeback;   // Dữ liệu đọc từ Memory (qua LSU)

// --- Khai báo dây trung gian kết nối giữa LSU và Data Memory ---
logic [31:0] w_lsu_addr;
logic [31:0] w_lsu_st_data;
logic [3:0]  w_lsu_mask_lo;
logic [3:0]  w_lsu_mask_hi;
logic        w_lsu_mem_write;
logic [63:0] w_mem_ld_data;

// --- Khai báo dây trung gian cho cụm 7-segment Hex (nếu data_memory xuất dạng 32-bit) ---
logic [31:0] w_hex3_0_data;
logic [31:0] w_hex7_4_data;

//========================================================================
// 2. KẾT NỐI CÁC MODULE (INSTANTIATION)
//========================================================================

// ------------------- CỤM FETCH -------------------
// Khối PC
PC pc_inst (
    .clk        (clk_i),
    .rst_n      (rst_i),
    .pc_next_i  (w_pc_next),
    .pc_o       (w_pc_current)
);

// Bộ cộng PC + 4 (Dùng code trực tiếp cho nhanh, không cần gọi module Add)
assign w_pc_plus4 = w_pc_current + 32'd4;

// Bộ cộng Branch Target
assign w_branch_target = w_pc_current + w_imm_ext;

// Instruction Memory
IMEM imem_inst (
    .pc_i             (w_pc_current),
    .instruction_o    (w_instr)
);

// ------------------- CỤM DECODE -------------------
Control_unit control_inst (
    .opcode_i     (w_instr[6:0]),
    .branch_o     (w_ctrl_branch_en),
    .jump_o       (w_ctrl_jump),
    .mem_read_o   (w_ctrl_mem_read),
    .mem_to_reg_o (w_ctrl_mem_to_reg),
    .Aluop_o      (w_ctrl_alu_op),
    .mem_write_o  (w_ctrl_mem_write),
    .AluSrcA_o    (w_ctrl_alu_src_a),
    .AluSrcB_o    (w_ctrl_alu_src_b),
    .Regwrite     (w_ctrl_reg_write)
);

Reg_file32 reg_inst (
    .reset_i    (rst_i),
    .clk_i      (clk_i),
    .Regwrite_i (w_ctrl_reg_write),
    .rd_i       (w_instr[11:7]),
    .rs1_i      (w_instr[19:15]),
    .rs2_i      (w_instr[24:20]),
    .wd_i       (w_wd_i),
    .rs1_o      (w_rs1_data),
    .rs2_o      (w_rs2_data)
);

Imgen_32bit imgen_inst (
    .instruction_i    (w_instr),
    .imm_ext_o        (w_imm_ext)
);

// ------------------- CỤM EXECUTE -------------------
// MUX 3-1-1 (Chọn đầu vào A cho ALU)
always_comb begin
    case(w_ctrl_alu_src_a)
        2'b00: w_alu_src_a_mux = w_rs1_data;
        2'b01: w_alu_src_a_mux = w_pc_current;
        2'b10: w_alu_src_a_mux = 32'b0;
        default: w_alu_src_a_mux = 32'b0;
    endcase
end

// MUX 1 (Chọn đầu vào B cho ALU)
assign w_alu_src_b_mux = (w_ctrl_alu_src_b) ? w_imm_ext : w_rs2_data;

ALU_control_unit alu_ctrl_inst (
    .ALUOp_i    (w_ctrl_alu_op),
    .funct3_i   (w_instr[14:12]),
    .funct7_bit30_i(w_instr[30]),
    .ALU_ctrl_o (w_alu_ctrl)
);

ALU_32bit alu_inst (
    .a_i        (w_alu_src_a_mux),
    .b_i        (w_alu_src_b_mux),
    .ALU_ctrl_i (w_alu_ctrl),
    .result     (w_alu_result)
);

Branch_control_unit branch_ctrl_inst (
    .funct3_i   (w_instr[14:12]),
    .a_i (w_rs1_data),
    .b_i (w_rs2_data),
    .branch_en_i(w_ctrl_branch_en),
    .branch_o   (w_branch_o)
);

PC_control pc_ctrl_inst (
    .opcode_i   (w_instr[6:0]),
    .jump_i     (w_ctrl_jump),
    .branch_i   (w_branch_o),
    .pc_src_o   (w_pc_ctrl_sel)
);

// MUX 3-1 (Chọn PC tiếp theo)
always_comb begin
    case(w_pc_ctrl_sel)
        2'b00: w_pc_next = w_pc_plus4;
        2'b01: w_pc_next = w_branch_target;
        2'b10: w_pc_next = w_alu_result; // Dùng cho lệnh jalr
        default: w_pc_next = w_pc_plus4;
    endcase
end

// ------------------- CỤM MEMORY & WRITEBACK -------------------
// 1. Instantiation khối LSU (Xử lý shift dữ liệu store và căn chỉnh load)
LSU lsu_inst (
    .addr_i       (w_alu_result),
    .st_data_i    (w_rs2_data),
    .ld_data_i    (w_mem_ld_data),         // Nhận dữ liệu thô từ Data Memory
    .funct3_i     (w_instr[14:12]),
    .mem_write_i  (w_ctrl_mem_write),
    .mem_read_i   (w_ctrl_mem_read),
    
    // Ngõ ra kết nối sang Data Memory Subsystem
    .addr_o       (w_lsu_addr),
    .st_data_o    (w_lsu_st_data),
    .mask_lo_o    (w_lsu_mask_lo),
    .mask_hi_o    (w_lsu_mask_hi),
    .mem_write_o  (w_lsu_mem_write),
    
    // Ngõ ra dữ liệu sạch trả về Writeback
    .ld_data_o    (w_lsu_writeback)        
);

// 2. Instantiation khối Data Memory & IO Subsystem (Chứa 2KB RAM + Dual Decoder + MMIO)
Memory dmem_inst (
    .clk_i        (clk_i),
    .resetn_i     (rst_i),
    .addr_i       (w_lsu_addr),
    .st_data_i    (w_lsu_st_data),
    .mask_lo_i    (w_lsu_mask_lo),
    .mask_hi_i    (w_lsu_mask_hi),
    .mem_write_i  (w_lsu_mem_write),
    .mem_read_i   (w_ctrl_mem_read),
    
    // Ánh xạ các cổng ngoại vi ra thẳng chân Top-level của processor
    .o_io_ledr    (o_io_ledr),
    .o_io_ledg    (o_io_ledg),
    .o_io_hex3_0  (w_hex3_0_data),
    .o_io_hex7_4  (w_hex7_4_data),
    .o_io_lcd     (o_io_lcd),
    .i_io_sw      (i_io_sw),
    
    // Trả dữ liệu đọc thô về cho LSU xử lý
    .ld_data_o    (w_mem_ld_data)         
);

// Phân tách 32-bit Hex thành các cổng 7-bit riêng biệt cho đúng đặc tả chân Top
assign o_io_hex0 = w_hex3_0_data[6:0];
assign o_io_hex1 = w_hex3_0_data[14:8];
assign o_io_hex2 = w_hex3_0_data[22:16];
assign o_io_hex3 = w_hex3_0_data[30:24];
assign o_io_hex4 = w_hex7_4_data[6:0];
assign o_io_hex5 = w_hex7_4_data[14:8];
assign o_io_hex6 = w_hex7_4_data[22:16];
assign o_io_hex7 = w_hex7_4_data[30:24];

// MUX 3-1-2 (Chọn dữ liệu ghi về RegFile)
always_comb begin
    case(w_ctrl_mem_to_reg)
        2'b00: w_wd_i = w_alu_result;
        2'b01: w_wd_i = w_lsu_writeback;
        2'b10: w_wd_i = w_pc_plus4; // Dùng cho lệnh jump/link
        default: w_wd_i = w_alu_result;
    endcase
end

// Gán giá trị debug để scoreboard nhận diện được tiến trình PC và lệnh hợp lệ
    assign o_pc_debug  = w_pc_current;
    assign o_insn_vld  = 1'b1; // Hoặc gán theo tín hiệu hợp lệ của bạn
endmodule : single_cycle
// --- DEBUG MONITOR: In trạng thái CPU mỗi chu kỳ clock ---
