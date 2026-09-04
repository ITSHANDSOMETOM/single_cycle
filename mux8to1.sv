module mux_8to1(
    input  logic [7:0] d,
    input  logic [2:0] sel,
    output logic       y,
    input  logic       en  
);
    assign y = en & (
        (d[0] & ~sel[2] & ~sel[1] & ~sel[0]) |
        (d[1] & ~sel[2] & ~sel[1] &  sel[0]) |
        (d[2] & ~sel[2] &  sel[1] & ~sel[0]) |
        (d[3] & ~sel[2] &  sel[1] &  sel[0]) |
        (d[4] &  sel[2] & ~sel[1] & ~sel[0]) | 
        (d[5] &  sel[2] & ~sel[1] &  sel[0]) |
        (d[6] &  sel[2] &  sel[1] & ~sel[0]) |
        (d[7] &  sel[2] &  sel[1] &  sel[0])
    );

endmodule