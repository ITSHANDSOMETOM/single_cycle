module d_ff(
    input  logic clk_i,
    input  logic d_i, 
    output logic q_o,
    output logic qn_o
);
always_ff @(posedge clk_i) begin: dff
    q_o <= d_i;
end
assign qn_o = ~q_o;
endmodule