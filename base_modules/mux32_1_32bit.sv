module mux_32_1_32bit(
    input  logic [31:0] d [31:0],
    input  logic [4:0]  sel,
    input  logic        en,
    output logic [31:0] y
);
    assign y = 
        (d[0]  & {32{en & ~sel[4] & ~sel[3] & ~sel[2] & ~sel[1] & ~sel[0]}}) |
        (d[1]  & {32{en & ~sel[4] & ~sel[3] & ~sel[2] & ~sel[1] &  sel[0]}}) |
        (d[2]  & {32{en & ~sel[4] & ~sel[3] & ~sel[2] &  sel[1] & ~sel[0]}}) |
        (d[3]  & {32{en & ~sel[4] & ~sel[3] & ~sel[2] &  sel[1] &  sel[0]}}) |
        (d[4]  & {32{en & ~sel[4] & ~sel[3] &  sel[2] & ~sel[1] & ~sel[0]}}) |
        (d[5]  & {32{en & ~sel[4] & ~sel[3] &  sel[2] & ~sel[1] &  sel[0]}}) |
        (d[6]  & {32{en & ~sel[4] & ~sel[3] &  sel[2] &  sel[1] & ~sel[0]}}) |
        (d[7]  & {32{en & ~sel[4] & ~sel[3] &  sel[2] &  sel[1] &  sel[0]}}) |
        (d[8]  & {32{en & ~sel[4] &  sel[3] & ~sel[2] & ~sel[1] & ~sel[0]}}) |
        (d[9]  & {32{en & ~sel[4] &  sel[3] & ~sel[2] & ~sel[1] &  sel[0]}}) |
        (d[10] & {32{en & ~sel[4] &  sel[3] & ~sel[2] &  sel[1] & ~sel[0]}}) |
        (d[11] & {32{en & ~sel[4] &  sel[3] & ~sel[2] &  sel[1] &  sel[0]}}) |
        (d[12] & {32{en & ~sel[4] &  sel[3] &  sel[2] & ~sel[1] & ~sel[0]}}) |
        (d[13] & {32{en & ~sel[4] &  sel[3] &  sel[2] & ~sel[1] &  sel[0]}}) |
        (d[14] & {32{en & ~sel[4] &  sel[3] &  sel[2] &  sel[1] & ~sel[0]}}) |
        (d[15] & {32{en & ~sel[4] &  sel[3] &  sel[2] &  sel[1] &  sel[0]}}) |
        (d[16] & {32{en &  sel[4] & ~sel[3] & ~sel[2] & ~sel[1] & ~sel[0]}}) |
        (d[17] & {32{en &  sel[4] & ~sel[3] & ~sel[2] & ~sel[1] &  sel[0]}}) |
        (d[18] & {32{en &  sel[4] & ~sel[3] & ~sel[2] &  sel[1] & ~sel[0]}}) |
        (d[19] & {32{en &  sel[4] & ~sel[3] & ~sel[2] &  sel[1] &  sel[0]}}) |
        (d[20] & {32{en &  sel[4] & ~sel[3] &  sel[2] & ~sel[1] & ~sel[0]}}) |
        (d[21] & {32{en &  sel[4] & ~sel[3] &  sel[2] & ~sel[1] &  sel[0]}}) |
        (d[22] & {32{en &  sel[4] & ~sel[3] &  sel[2] &  sel[1] & ~sel[0]}}) |
        (d[23] & {32{en &  sel[4] & ~sel[3] &  sel[2] &  sel[1] &  sel[0]}}) |
        (d[24] & {32{en &  sel[4] &  sel[3] & ~sel[2] & ~sel[1] & ~sel[0]}}) |
        (d[25] & {32{en &  sel[4] &  sel[3] & ~sel[2] & ~sel[1] &  sel[0]}}) |
        (d[26] & {32{en &  sel[4] &  sel[3] & ~sel[2] &  sel[1] & ~sel[0]}}) |
        (d[27] & {32{en &  sel[4] &  sel[3] & ~sel[2] &  sel[1] &  sel[0]}}) |
        (d[28] & {32{en &  sel[4] &  sel[3] &  sel[2] & ~sel[1] & ~sel[0]}}) |
        (d[29] & {32{en &  sel[4] &  sel[3] &  sel[2] & ~sel[1] &  sel[0]}}) |
        (d[30] & {32{en &  sel[4] &  sel[3] &  sel[2] &  sel[1] & ~sel[0]}}) |
        (d[31] & {32{en &  sel[4] &  sel[3] &  sel[2] &  sel[1] &  sel[0]}});

endmodule