module Barrel_shifter32bit (
  input logic  [31:0] d_i,
  input logic  [4:0]  positions_i,
  input logic  [1:0]  mode_i,
  output logic [31:0] d_o
);

  logic [31:0] data_in, rev_in, rev_out; 
  logic [31:0] stage [5:0]; 
  logic        padding_bit;

  genvar j;
  generate
    for (j = 0; j < 32; j = j + 1) begin
      assign rev_in[j] = d_i[31-j];
      assign rev_out[j] = stage[5][31-j];
    end
  endgenerate

  assign data_in     = (mode_i == 2'b00) ? rev_in : d_i;
  assign stage[0]    = data_in;
  assign padding_bit = (mode_i == 2'b10) ? d_i[31] : 1'b0;
  genvar k,i;
  generate
  for(k = 0; k < 5; k = k + 1) begin: layer
    for(i = 0; i < 32; i = i + 1) begin: internal_mux
      if (i + (2**k) < 32) begin
        mux2_1 internal_muxes(
          .I0_i  (stage[k][i]),
          .I1_i  (stage[k][i + (2**k)]),
          .sel_i (positions_i[k]),
          .y_o   (stage[k+1][i])
        );    
      end
      
      else begin
        mux2_1 internal_muxes(
          .I0_i  (stage[k][i]),
          .I1_i  (padding_bit),
          .sel_i (positions_i[k]),
          .y_o   (stage[k+1][i])
        );    
      end
    end
  end
  endgenerate

  assign d_o = (mode_i == 2'b00) ? rev_out : stage[5];
endmodule