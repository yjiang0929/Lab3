//Sign extender test bench

`include "signExt.v"

module signExtTest();
  reg[15:0] in;
  wire [31:0] out;

  signExt dut(in, out);
  reg flag = 0;

  initial begin
  $display("Sign Extender Tests start");
  in = 15'd123; #10;
  if (out !== 32'd123) begin
    $display("Output should be %b, but is instead %b", 32'd123, out);
    flag = 1;
  end

  in = 15'd4; #10;
  if (out !== 32'd4) begin
    $display("Output should be %b, but is instead %b", 32'd4, out);
    flag = 1;
  end

  in = 15'd0; #10;
  if (out !== 32'd0) begin
    $display("Output should be %b, but is instead %b", 32'd0, out);
    flag = 1;
  end

  if (flag == 0)
    $display("Sign Extender test passed");
  end

endmodule
