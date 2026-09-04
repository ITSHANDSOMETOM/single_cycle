module encoder8to3 (  
    input  logic [7:0] i,
    output logic [2:0] y,
    output logic       gs
);
    assign gs = |i;   
    assign y[2] = i[7] | i[6] | i[5] | i[4];
    assign y[1] = i[7] | i[6] | i[3] | i[2];
    assign y[0] = i[7] | i[5] | i[3] | i[1];
endmodule

