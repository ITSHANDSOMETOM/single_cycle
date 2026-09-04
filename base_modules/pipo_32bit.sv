module pipo_32bit(
    input   logic         reset_i,
    input   logic         en_i,
    input   logic         clk_i,
    input   logic  [31:0] d_i,
    output  logic  [31:0] q_o
);
genvar i;
generate 
    for (i = 0; i < 32; i = i + 1) begin
        d_ff_clr_pre ff_inst(
            .en_i       (en_i),
            .clk_i      (clk_i),
            .d_i        (d_i[i]),
            .q_o        (q_o[i]),
            .clear_i    (reset_i),
            .preset_i   (1'b1)
        );
    end
endgenerate
endmodule 