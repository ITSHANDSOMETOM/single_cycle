module Control_unit(
  input  logic  [6:0] opcode_i,
  output logic        branch_o,
  output logic        jump_o,
  output logic        mem_read_o,
  output logic  [1:0] mem_to_reg_o,
  output logic  [1:0] Aluop_o,
  output logic        mem_write_o,
  output logic  [1:0] AluSrcA_o,
  output logic        AluSrcB_o,
  output logic        Regwrite
);  
  logic [11:0] controls;
  assign {jump_o, AluSrcA_o, AluSrcB_o, mem_to_reg_o, Regwrite, mem_read_o, mem_write_o, branch_o, Aluop_o} = controls;
  always_comb begin
    case (opcode_i) 
      7'b0110011: controls = 12'b0_00_0_00_1_0_0_0_10; //R-type
      7'b0000011: controls = 12'b0_00_1_01_1_1_0_0_00; //I-type load
      7'b0010011: controls = 12'b0_00_1_00_1_0_0_0_11; //I-type ALU
      7'b0100011: controls = 12'b0_00_1_00_0_0_1_0_00; //store
      7'b1100011: controls = 12'b0_00_0_00_0_0_0_1_01; //Branch
      7'b1101111: controls = 12'b1_00_0_10_1_0_0_0_00; //JAL
      7'b1100111: controls = 12'b1_00_1_10_1_0_0_0_00; //JALR
      7'b0110111: controls = 12'b0_10_1_00_1_0_0_0_00; //LUI
      7'b0010111: controls = 12'b0_01_1_00_1_0_0_0_00; //AUIPC
      default:    controls = 12'b0_00_0_00_0_0_0_0_00; //default
    endcase
  end
endmodule

