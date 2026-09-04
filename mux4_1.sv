module mux_4to1(
  input  logic [3:0] d,    
  input  logic [1:0] sel,  
  input  logic       en,
  output logic       y
);

  assign y = en & (
    (d[0] & ~sel[1] & ~sel[0]) | // Chọn d[0] khi sel = 00
    (d[1] & ~sel[1] &  sel[0]) | // Chọn d[1] khi sel = 01
    (d[2] &  sel[1] & ~sel[0]) | // Chọn d[2] khi sel = 10
    (d[3] &  sel[1] &  sel[0])   // Chọn d[3] khi sel = 11
  );
endmodule