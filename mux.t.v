// Tests mux2 and mux3
// Gives a width other than 1 or 32, to make sure it works

`include "mux.v"

module testMux();

	reg [23:0] in1, in2, in3;
	wire [23:0] out2, out3;
	reg select2;
	reg [1:0] select3;

	mux2 #(24) dut2(out2, in1, in2, select2);
	mux3 #(24) dut3(out3, in1, in2, in3, select3);

	initial begin

		in1 = 24'hDEDBEF;
		in2 = 24'hCFEBAE;
		in3 = 24'h002347;

		select2 = 0; #10;
		if (out2 != 24'hDEDBEF) $display("mux2 fails when select = 0: is %h, should be %h", out2, 24'hDEDBEF);
		select2 = 1; #10;
		if (out2 != 24'hCFEBAE) $display("mux2 fails when select = 1: is %h, should be %h", out2, 24'hCFEBAE);

		select3 = 2'b00; #10;
		if (out3 != 34'hDEDBEF) $display("mux3 fails when select = 0: is %h, should be %h", out3, 34'hDEDBEF);
		select3 = 2'b01; #10;
		if (out3 != 34'hCFEBAE) $display("mux3 fails when select = 1: is %h, should be %h", out3, 34'hCFEBAE);
		select3 = 2'b10; #10;
		if (out3 != 34'h002347) $display("mux3 fails when select = 2: is %h, should be %h", out3, 34'h002347);

	end

endmodule
