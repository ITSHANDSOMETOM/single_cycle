module decoder3to8(
    input  logic i2, i1, i0,
    input  logic en,
    output logic y7, y6, y5, y4, y3, y2, y1, y0
);
    assign y0 = en & ~i2 & ~i1 & ~i0;
    assign y1 = en & ~i2 & ~i1 &  i0;
    assign y2 = en & ~i2 &  i1 & ~i0;
    assign y3 = en & ~i2 &  i1 &  i0;
    assign y4 = en &  i2 & ~i1 & ~i0;
    assign y5 = en &  i2 & ~i1 &  i0;
    assign y6 = en &  i2 &  i1 & ~i0;
    assign y7 = en &  i2 &  i1 &  i0;
endmodule
