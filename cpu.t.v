// `timescale 1 ns / 1 ps
`include "cpu.v"
`define DELAY 5000

module testCPU();
  reg clk;

  reg begintest = 0; //Set high to begin testing register file
  reg endtest = 0; //Set high to signal test completion
  reg dutpassed = 1; //Indicates whether register file passed tests

  wire[31:0] hanoi = 32'd270;

  //Instantiate dut
  cpu dut(.clk(clk));

initial clk = 0;
always #10 clk=!clk;

  initial begin
    $dumpfile("cpu.vcd");
    $dumpvars();
    $display("After begintest");
    #1000;
    $display("After delay");
    begintest = 1;
    // $display("Testbench start");

    $display("After begintest = 1");
    $finish();
  end

  always @(posedge begintest) begin
    dutpassed = 1;
    $display("Entered always loop");
    $display("%b", dut.rf.input2);
    $display("%b", hanoi);
    if(dut.rf.reg2.qout != hanoi) begin
    $display("Test failed: Tower of Hanoi answer unexpected; expected %b but got %b", hanoi, dut.rf.reg2.qout);
    dutpassed = 0;
    end

  endtest = 1;
  $display("Endtest: %b ", endtest);
  end

always @(posedge endtest) begin
  $display("DUT passed? %b", dutpassed);
end

endmodule
