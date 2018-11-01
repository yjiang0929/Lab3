// `timescale 1 ns / 1 ps
`include "cpu.v"
`define DELAY 5000

module testCPU();
  reg clk; //Declare clock

  reg begintest = 0; //Set high to begin testing register file
  reg endtest = 0; //Set high to signal test completion
  reg dutpassed = 1; //Indicates whether register file passed tests

  //Order of tests: ours (bleep_vim), dazedandconfused, jumpingfoxes, ninja, sree, storemoney
  wire[31:0] hanoi = 32'd270; //test 0
  wire[31:0] fib = 32'd58; //test 1
  wire[31:0] yeet = 32'd119; //test 2
  wire[31:0] test_1 = 32'hf; //test 3
  wire[31:0] test_3 = 32'd42; //test 4
  wire[31:0] slt = 32'd1; //test 5

  //Instantiate dut
  cpu dut(.clk(clk));

  //Declare inputs
  reg [1023:0] mem_text_fn;
  reg[1023:0] test_num;
  reg [1023:0] file_out;

//Set up clock
initial clk = 0;
always #10 clk=!clk;

//Read in the memory location
  initial begin
  if (! $value$plusargs("mem_text_fn=%s", mem_text_fn)) begin
	    $display("ERROR: memory location not provided. Provide +mem_text_fn=[path to .text memory image] argument");
	    $finish();
        end
//Read in the test number
  if (! $value$plusargs("test_num=%d", test_num)) begin
    $display("ERROR: Test name not specified. Provide +test_num=[test_num] argument");
    $finish();
    end
//Read in the vcd file we want to write to
    if (! $value$plusargs("file_out=%s", file_out)) begin
      $display("ERROR: Test file output (.vcd) not specified. Provide +file_out=[file_out] argument");
      $finish();
      end

      //Read into the datamemory
    $readmemh(mem_text_fn, dut.dm.mem,0);

    //Prep dumpfile
    $dumpfile(file_out);
    $dumpvars();

    $display("Starting test number: %d", test_num);


    //Note beginning of test
    begintest = 1;
    #200000;  //Wait a while to let the CPU do as it needs to
    dutpassed = 1;

    if(test_num == 0) begin //If we're test 0, check it against "hanoi"
      if(dut.rf.reg2.qout != hanoi) begin
      $display("Test failed: Tower of Hanoi answer unexpected; expected %b but got %b", hanoi, dut.rf.reg2.qout);
      dutpassed = 0;
      end
    end

    if(test_num == 1) begin //If we're test 1, check against fibinacci
      if(dut.rf.reg2.qout != fib) begin
      $display("Test failed: Fibinacci answer unexpected; expected %b but got %b", fib, dut.rf.reg2.qout);
      dutpassed = 0;
      end
    end
    if(test_num == 2) begin //If we're test 2, check against yeet
      if(dut.rf.reg8.qout != yeet) begin
      $display("Test failed: Yeet answer unexpected; expected %b but got %b", yeet, dut.rf.reg8.qout);
      dutpassed = 0;
      end
    end
    if(test_num == 3) begin //If we're test 3, check against test_1
      if(dut.rf.reg8.qout != test_1) begin
      $display("Test failed: test_1 answer unexpected; expected %b but got %b", test_1, dut.rf.reg8.qout);
      dutpassed = 0;
      end
    end
    if(test_num == 4) begin //If we're test 4, check against test_3
      if(dut.rf.reg11.qout != test_3) begin
      $display("Test failed: test_3 answer unexpected; expected %b but got %b", test_3, dut.rf.reg11.qout);
      dutpassed = 0;
      end
    end
    if(test_num == 5) begin //If we're test 5, check against slt
      if(dut.rf.reg2.qout != slt) begin
      $display("Test failed: Fibinacci answer unexpected; expected %b but got %b", slt, dut.rf.reg2.qout);
      dutpassed = 0;
      end
    end

    //Note if the device under test passed
    endtest = 1;
    $display("DUT passed? %b", dutpassed);
    $finish();
  end

endmodule
