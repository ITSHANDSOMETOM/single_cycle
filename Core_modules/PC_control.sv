module PC_control(
  input  logic [6:0] opcode_i,
  input  logic       jump_i,
  input  logic       branch_i,
  output logic [1:0] pc_src_o
);
  logic is_jalr;

  assign is_jalr = (opcode_i == 7'b1100111) ? 1'b1 : 1'b0;
  
  always_comb begin
    if (is_jalr) begin 
      pc_src_o = 2'b10;
    end
    else if (jump_i || branch_i) begin 
      pc_src_o = 2'b01;
    end
    else begin
      pc_src_o = 2'b00;
    end
  end
endmodule