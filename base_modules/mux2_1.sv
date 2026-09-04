module mux2_1 #(
    parameter int WIDTH = 1
)(
    input  logic [WIDTH-1:0] I0_i,
    input  logic [WIDTH-1:0] I1_i,
    input  logic             sel_i,
    output logic [WIDTH-1:0] y_o
);
    assign y_o = sel_i ? I1_i : I0_i;
endmodule