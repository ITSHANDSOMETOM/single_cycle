module full_adder (
    input  logic a_i,    
    input  logic b_i,
    input  logic cin_i,
    output logic s_o,    
    output logic cout_o
);

always_comb begin: logic_computation
	s_o = a_i ^ b_i ^ cin_i;
	cout_o = (a_i & b_i) | cin_i & (a_i ^ b_i);
end
endmodule