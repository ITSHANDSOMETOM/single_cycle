module encoder_32to5_logic (
    input  logic [31:0] y,  // 32 ngõ vào
    output logic [4:0]  a   // 5 ngõ ra
);
    // A0:các số lẻ
    assign a[0] = y[1]  | y[3]  | y[5]  | y[7]  | y[9]  | y[11] | y[13] | y[15] |
                  y[17] | y[19] | y[21] | y[23] | y[25] | y[27] | y[29] | y[31];

    // A1:từng cụm 2 số
    assign a[1] = y[2]  | y[3]  | y[6]  | y[7]  | y[10] | y[11] | y[14] | y[15] |
                  y[18] | y[19] | y[22] | y[23] | y[26] | y[27] | y[30] | y[31];

    // A2:từng cụm 4 số
    assign a[2] = y[4]  | y[5]  | y[6]  | y[7]  | y[12] | y[13] | y[14] | y[15] |
                  y[20] | y[21] | y[22] | y[23] | y[28] | y[29] | y[30] | y[31];

    // A3:từng cụm 8 số
    assign a[3] = y[8]  | y[9]  | y[10] | y[11] | y[12] | y[13] | y[14] | y[15] |
                  y[24] | y[25] | y[26] | y[27] | y[28] | y[29] | y[30] | y[31];

    // A4:16 số cuối cùng (từ 16 đến 31)
    assign a[4] = y[16] | y[17] | y[18] | y[19] | y[20] | y[21] | y[22] | y[23] |
                  y[24] | y[25] | y[26] | y[27] | y[28] | y[29] | y[30] | y[31];
endmodule