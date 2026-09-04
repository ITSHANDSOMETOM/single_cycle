module Imgen_32bit(
  input  logic [31:0] instruction_i,
  output logic [31:0] imm_ext_o
);
  logic [6:0]  opcode;
  logic [31:0] imm_R_type;
  logic [31:0] imm_I_type;
  logic [31:0] imm_S_type;
  logic [31:0] imm_B_type;
  logic [31:0] imm_U_type;
  logic [31:0] imm_J_type;

  assign opcode = instruction_i[6:0];
  assign imm_R_type = 32'b0;
  assign imm_I_type = {{20{instruction_i[31]}}, instruction_i[31:20]};
  assign imm_S_type = {{20{instruction_i[31]}}, instruction_i[31:25], instruction_i[11:7]};
  assign imm_B_type = {{20{instruction_i[31]}}, instruction_i[7], instruction_i[30:25], instruction_i[11:8], 1'b0};
  assign imm_U_type = {instruction_i[31:12], 12'b0};
  assign imm_J_type = {{12{instruction_i[31]}}, instruction_i[19:12], instruction_i[20], instruction_i[30:21], 1'b0};

  always_comb begin
    case (opcode) 
        7'b0110011: imm_ext_o = imm_R_type;
        7'b0000011: imm_ext_o = imm_I_type; //load
        7'b0010011: imm_ext_o = imm_I_type; //immediate
        7'b0100011: imm_ext_o = imm_S_type;
        7'b1100011: imm_ext_o = imm_B_type;
        7'b0110111: imm_ext_o = imm_U_type;
        7'b1101111: imm_ext_o = imm_J_type;
        7'b1100111: imm_ext_o = imm_I_type; // JALR 
        7'b0010111: imm_ext_o = imm_U_type; // AUIPC
        default: imm_ext_o = 32'b0; 
    endcase
  end
endmodule
