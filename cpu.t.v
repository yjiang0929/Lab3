// `timescale 1 ns / 1 ps
`include "cpu.v"
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
    $display("Before begintest");
    begintest = 0;
    $display("After begintest");
    #1000;
    $display("After delay");
    begintest = 1;
    $display("After begintest = 1");
    $finish();
  end

always @(posedge endtest) begin
  $display("DUT passed? %b", dutpassed);
end

endmodule

module testbench
(
  input wire begintest,
  output reg endtest,
  output reg dutpassed,

  input wire clk

  );
  wire[31:0] hanoi = 32'd270;
  // $display("Testbench start");
  always @(posedge begintest) begin
    dutpassed <= 1;
    $display("Entered always loop");
    $display("%b", dut.rf.reg2.quot);
    $display("%b", hanoi);
    if(dut.rf.reg2.qout != hanoi) begin
    $display("Test failed: Tower of Hanoi answer unexpected; expected %b but got %b", hanoi, dut.rf.reg2.qout);
    dutpassed <= 0;
    end

  endtest = 1;
  $display("Endtest: %b ", endtest);
  end

  endmodule
