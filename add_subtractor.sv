module add_subtractor(
	input logic [3:0] x,
	input logic [3:0] y,
	input logic 	  mode,
	output logic [3:0] sum,
	output logic 	   cout1_o
	);
	logic [3:0] b_modified ;
	logic [3:1] c  ;
	always_comb begin
		b_modified[0] = y[0] ^ mode;
		b_modified[1] = y[1] ^ mode;
		b_modified[2] = y[2] ^ mode;
		b_modified[3] = y[3] ^ mode;
	end

	full_adder fa0(
		.a_i (x[0]),
		.b_i (b_modified[0]),
		.cin_i (mode),
		.s_o (sum[0]),
		.cout_o (c[1])
	);
	full_adder fa1(
		.a_i (x[1]),
		.b_i (b_modified[1]),
		.cin_i (c[1]),
		.s_o (sum[1]),
		.cout_o (c[2])
	);
	full_adder fa2(
		.a_i (x[2]),
		.b_i (b_modified[2]),
		.cin_i (c[2]),
		.s_o (sum[2]),
		.cout_o	 (c[3])
	);
	full_adder fa3(
		.a_i (x[3]),
		.b_i (b_modified[3]),
		.cin_i (c[3]),
		.s_o (sum[3]),
		.cout_o (cout1_o)
	);
endmodule