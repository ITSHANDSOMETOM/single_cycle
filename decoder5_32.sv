module decoder5_32(
    input  logic [4:0] i, 
    input  logic en,
    output logic [31:0] y
);
    assign y[0]  = en & ~i[4] & ~i[3] & ~i[2] & ~i[1] & ~i[0];
    assign y[1]  = en & ~i[4] & ~i[3] & ~i[2] & ~i[1] &  i[0];
    assign y[2]  = en & ~i[4] & ~i[3] & ~i[2] &  i[1] & ~i[0];
    assign y[3]  = en & ~i[4] & ~i[3] & ~i[2] &  i[1] &  i[0];
    
    assign y[4]  = en & ~i[4] & ~i[3] &  i[2] & ~i[1] & ~i[0];
    assign y[5]  = en & ~i[4] & ~i[3] &  i[2] & ~i[1] &  i[0];
    assign y[6]  = en & ~i[4] & ~i[3] &  i[2] &  i[1] & ~i[0];
    assign y[7]  = en & ~i[4] & ~i[3] &  i[2] &  i[1] &  i[0];
    
    assign y[8]  = en & ~i[4] &  i[3] & ~i[2] & ~i[1] & ~i[0];
    assign y[9]  = en & ~i[4] &  i[3] & ~i[2] & ~i[1] &  i[0];
    assign y[10] = en & ~i[4] &  i[3] & ~i[2] &  i[1] & ~i[0];
    assign y[11] = en & ~i[4] &  i[3] & ~i[2] &  i[1] &  i[0];
    
    assign y[12] = en & ~i[4] &  i[3] &  i[2] & ~i[1] & ~i[0];
    assign y[13] = en & ~i[4] &  i[3] &  i[2] & ~i[1] &  i[0];
    assign y[14] = en & ~i[4] &  i[3] &  i[2] &  i[1] & ~i[0];
    assign y[15] = en & ~i[4] &  i[3] &  i[2] &  i[1] &  i[0];
    
    assign y[16] = en &  i[4] & ~i[3] & ~i[2] & ~i[1] & ~i[0];
    assign y[17] = en &  i[4] & ~i[3] & ~i[2] & ~i[1] &  i[0];
    assign y[18] = en &  i[4] & ~i[3] & ~i[2] &  i[1] & ~i[0];
    assign y[19] = en &  i[4] & ~i[3] & ~i[2] &  i[1] &  i[0];
    
    assign y[20] = en &  i[4] & ~i[3] &  i[2] & ~i[1] & ~i[0];
    assign y[21] = en &  i[4] & ~i[3] &  i[2] & ~i[1] &  i[0];
    assign y[22] = en &  i[4] & ~i[3] &  i[2] &  i[1] & ~i[0];
    assign y[23] = en &  i[4] & ~i[3] &  i[2] &  i[1] &  i[0];
    
    assign y[24] = en &  i[4] &  i[3] & ~i[2] & ~i[1] & ~i[0];
    assign y[25] = en &  i[4] &  i[3] & ~i[2] & ~i[1] &  i[0];
    assign y[26] = en &  i[4] &  i[3] & ~i[2] &  i[1] & ~i[0];
    assign y[27] = en &  i[4] &  i[3] & ~i[2] &  i[1] &  i[0];
    
    assign y[28] = en &  i[4] &  i[3] &  i[2] & ~i[1] & ~i[0];
    assign y[29] = en &  i[4] &  i[3] &  i[2] & ~i[1] &  i[0];
    assign y[30] = en &  i[4] &  i[3] &  i[2] &  i[1] & ~i[0];
    assign y[31] = en &  i[4] &  i[3] &  i[2] &  i[1] &  i[0];

endmodule