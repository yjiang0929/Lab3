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

  reg [1023:0] mem_text_fn;
  reg [1023:0] mem_data_fn;
  reg [1023:0] dump_fn;

initial clk = 1;
always #10 clk=!clk;

  initial begin
  // if (! $value$plusargs("mem_text_fn=%s", mem_text_fn)) begin
	//     $display("ERROR: provide +mem_text_fn=[path to .text memory image] argument");
	//     $finish();
  //       end
  //
	// if (! $value$plusargs("dump_fn=%s", dump_fn)) begin
	//     $display("ERROR: provide +dump_fn=[path for VCD dump] argument");
	//     $finish();
  //       end

    $readmemh("fib_func.text.hex", dut.dm.mem, 0);

    $dumpfile("cpuout.vcd");
    $dumpvars();

    begintest = 1;
    $display("Testbench start");

    $display("After begintest = 1");
    #1000;

    dutpassed = 1;
    $display("%b", dut.nextPc);
    $display("%b", dut.Da);
    $display("%b", dut.jumpAddr);
    $display("%b", dut.pcAluRes);
    $display("%b", dut.jSel);

    $display("%b", dut.dm.mem[0]);
    $display("%b", hanoi);
    if(dut.rf.reg2.qout != hanoi) begin
    $display("Test failed: Tower of Hanoi answer unexpected; expected %b but got %b", hanoi, dut.rf.reg2.qout);
    dutpassed = 0;
    end

    endtest = 1;
    $display("DUT passed? %b", dutpassed);
    $display("Endtest: %b ", endtest);

    $finish();
  end

endmodule
