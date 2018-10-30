`timescale 1 ns / 1 ps
include "cpu.v"
`define DELAY 5000

module testCPU();
  reg clk;

  reg begintest; //Set high to begin testing register file
  wire endtest; //Set high to signal test completion
  wire dutpassed; //Indicates whether register file passed tests

  //Instantiate dut
  cpu dut(.clk(clk));

  testbench tester(.begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .clk(clk));

initial clk = 0;
always #10 clk=!clk;

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars();
    begintest = 0;
    begintest = 1;
    #1000000;
    $finish();
  end

always @(posedge endtest) begin
  $display("DUT passed? %b", dutpassed);

end

endmodule

module testbench
(
  input begintest,
  output reg endtest,
  output reg dutpassed,

  input wire clk

  );
