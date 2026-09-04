module ALU_32bit(
  input  logic [31:0] a_i,
  input  logic [31:0] b_i,
  input  logic [3:0]  ALU_ctrl_i,
  output logic [31:0] result
  );

  logic        Ainvert, Binvert;
  logic [1:0]  operation_sel;
  logic [31:0] a_transformed, b_transformed;
  logic [31:0] and_result, or_result, add_sub_result, xor_result, shift_result;
  logic [31:0] cout_internal;

  logic        less_result;
  logic        less_result_unsigned;
  logic        overflow;

  assign Ainvert       = ALU_ctrl_i[3];
  assign Binvert       = ALU_ctrl_i[2];
  assign operation_sel = ALU_ctrl_i[1:0]; 

  Barrel_shifter32bit shifter(
    .d_i        (a_i),
    .positions_i (b_i[4:0]),
    .mode_i     (operation_sel),
    .d_o        (shift_result)
  );

  mux2_1 #(.WIDTH(32)) inverted_a (
    .I0_i  (a_i),
    .I1_i  (~a_i),
    .sel_i (Ainvert),
    .y_o   (a_transformed)
);

  mux2_1 #(.WIDTH(32)) inverted_b (
    .I0_i  (b_i),
    .I1_i  (~b_i),
    .sel_i (Binvert),
    .y_o   (b_transformed)
);

  full_adder ff0(
    .a_i    (a_transformed[0]),
    .b_i    (b_transformed[0]),
    .cin_i  (Binvert),
    .s_o    (add_sub_result[0]),
    .cout_o (cout_internal[0])    
  );

  genvar i;
  generate 
    for(i = 1; i < 32; i= i + 1) begin: alu_1bit
      full_adder internal_fa(
        .a_i    (a_transformed[i]),
        .b_i    (b_transformed[i]),
        .cin_i  (cout_internal[i-1]),
        .s_o    (add_sub_result[i]),
        .cout_o (cout_internal[i])    
      );
    end 
  endgenerate 

  assign overflow             = cout_internal[30] ^ cout_internal[31];
  assign less_result          = add_sub_result[31] ^ overflow;
  assign less_result_unsigned = ~cout_internal[31];
  
  assign and_result           = a_i & b_i;
  assign or_result            = a_i | b_i;
  assign xor_result           = a_i ^ b_i;
  
  always_comb begin
    case (ALU_ctrl_i)
      4'b0000: result = and_result;
      4'b0001: result = or_result;
      4'b0100: result = xor_result;
      4'b0010: result = add_sub_result; //add
      4'b0110: result = add_sub_result; //sub
      4'b1000: result = shift_result;   // SLL 
      4'b1001: result = shift_result;   // SRL 
      4'b1010: result = shift_result;   // SRA
      4'b0111: result = {31'b0, less_result};
      4'b0101: result = {31'b0, less_result_unsigned};
      default: result = 32'b0;
    endcase
  end
endmodule



