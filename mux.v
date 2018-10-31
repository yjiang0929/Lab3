module mux2 // 2 inputs of adjustable width, 1 address pin
#(parameter width = 32)
(
	output [width-1:0] chosenOne, // Output
	input [width-1:0] harry, // Inputs, with arbitrary depth
	input [width-1:0] neville,
	input dumbledore // Address
);

	assign chosenOne = (dumbledore ? neville : harry);

endmodule


module mux3 // 3 inputs of adjustable width, 2 address pins
#(parameter width = 32)
(
	output [width-1:0] chosenOne, // Output
	input [width-1:0] harry, // Inputs, with arbitrary depth
	input [width-1:0] neville,
	input [width-1:0] draco,
	input [1:0] dumbledore // Address
);

	assign chosenOne = (dumbledore[0] ? (dumbledore[1] ? draco : neville) : harry);

endmodule
