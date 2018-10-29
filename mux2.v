module /*to the*/ mux2
#(parameter width = 32)
(
	output [width-1:0] chosenOne, // Output
	input [width-1:0] harry, // Inputs, with arbitrary depth
	input [width-1:0] neville,
	input dumbledore // Address
);
	assign chosenOne = (dumbledore ? neville : harry);
endmodule
	
