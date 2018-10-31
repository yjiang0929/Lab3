module mux2 // 2 inputs of adjustable width, 1 address pin
#(parameter width = 32)
(
	output [width-1:0] out, // Output
	input [width-1:0] in1, // Inputs, with arbitrary depth
	input [width-1:0] in2,
	input select // Address
);

	assign out = (select ? in2 : in1);

endmodule


module mux3 // 3 inputs of adjustable width, 2 address pins
#(parameter width = 32)
(
	output [width-1:0] out, // Output
	input [width-1:0] in1, // Inputs, with arbitrary depth
	input [width-1:0] in2,
	input [width-1:0] in3,
	input [1:0] select // Address
);

	assign out = (select[1] ? in3 : (select[0] ? in2 : in1));

endmodule
