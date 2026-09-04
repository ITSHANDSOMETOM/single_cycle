module ALU_control_unit(
    input  logic [1:0] ALUOp_i,
    input  logic [2:0] funct3_i,
    input  logic       funct7_bit30_i,
    output logic [3:0] ALU_ctrl_o
);

  logic is_ldst, is_branch, is_rtype, is_itype, is_alu_op;
  assign is_ldst   = (~ALUOp_i[1] & ~ALUOp_i[0]); // 00
  assign is_branch = (~ALUOp_i[1] &  ALUOp_i[0]); // 01
  
  // Đã phân biệt được R-type và I-type nhờ ALUOp = 11
  assign is_rtype  = (ALUOp_i == 2'b10); 
  assign is_itype  = (ALUOp_i == 2'b11); 
  assign is_alu_op = is_rtype | is_itype;

  logic f3_000, f3_001, f3_010, f3_011, f3_100, f3_101, f3_110, f3_111;
  assign f3_000 = (~funct3_i[2] & ~funct3_i[1] & ~funct3_i[0]);
  assign f3_001 = (~funct3_i[2] & ~funct3_i[1] &  funct3_i[0]);
  assign f3_010 = (~funct3_i[2] &  funct3_i[1] & ~funct3_i[0]);
  assign f3_011 = (~funct3_i[2] &  funct3_i[1] &  funct3_i[0]);
  assign f3_100 = ( funct3_i[2] & ~funct3_i[1] & ~funct3_i[0]);
  assign f3_101 = ( funct3_i[2] & ~funct3_i[1] &  funct3_i[0]);
  assign f3_110 = ( funct3_i[2] &  funct3_i[1] & ~funct3_i[0]);
  assign f3_111 = ( funct3_i[2] &  funct3_i[1] &  funct3_i[0]);

  logic is_add, is_sub, is_and, is_or, is_xor, is_slt, is_sltu, is_sll, is_srl, is_sra;

  // Lệnh addi (is_itype) luôn luôn là phép cộng, bất chấp bit 30
  assign is_add  = is_ldst | (is_itype & f3_000) | (is_rtype & f3_000 & ~funct7_bit30_i);
  assign is_sub  = is_branch | (is_rtype & f3_000 & funct7_bit30_i);
  assign is_and  = is_alu_op & f3_111;
  assign is_or   = is_alu_op & f3_110;
  assign is_xor  = is_alu_op & f3_100;
  assign is_slt  = is_alu_op & f3_010;
  assign is_sltu = is_alu_op & f3_011;
  assign is_sll  = is_alu_op & f3_001;
  assign is_srl  = is_alu_op & f3_101 & ~funct7_bit30_i;
  assign is_sra  = is_alu_op & f3_101 & funct7_bit30_i;

  // Cập nhật lại mã cho SLTU thành 0101 (Binvert = 1 để làm phép trừ)
  assign ALU_ctrl_o[3] = is_sll | is_srl | is_sra; 
  assign ALU_ctrl_o[2] = is_xor | is_sub | is_slt | is_sltu; 
  assign ALU_ctrl_o[1] = is_add | is_sub | is_slt | is_sra; 
  assign ALU_ctrl_o[0] = is_or  | is_slt | is_srl | is_sltu;
endmodule