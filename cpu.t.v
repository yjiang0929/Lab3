// `timescale 1 ns / 1 ps
`include "cpu.v"
`define DELAY 5000

module testCPU();
  reg clk;

  reg begintest = 0; //Set high to begin testing register file
  reg endtest = 0; //Set high to signal test completion
  reg dutpassed = 1; //Indicates whether register file passed tests

  //Order of tests: ours (bleep_vim), dazedandconfused, jumpingfoxes, ninja, sree, storemoney
  wire[31:0] hanoi = 32'd270; //0
  // wire[31:0] array_loop = ; //7 //another array test; come back to
  wire[31:0] fib = 32'd58; //8 $v0
  wire[31:0] yeet = 32'd121; //11 t0

  wire[31:0] simple = 32'd4;

  //Instantiate dut
  cpu dut(.clk(clk));

  reg [1023:0] mem_text_fn;
  // reg [1023:0] mem_data_fn;
  // reg [1023:0] dump_fn;

  reg[1023:0] r_RESULT;
  reg[1023:0] test_num;
  reg[1023:0] test_str;

initial clk = 0;
always #10 clk=!clk;

  initial begin
  if (! $value$plusargs("mem_text_fn=%s", mem_text_fn)) begin
	    $display("ERROR: memory location not provided. Provide +mem_text_fn=[path to .text memory image] argument");
	    $finish();
        end

  if (! $value$plusargs("test_num=%d", test_num)) begin
    $display("ERROR: Test name not specified. Provide +test_num=[test_num] argument");
    $finish();
    end

    $readmemh(mem_text_fn, dut.dm.mem,0);

    $dumpfile("cpuout.vcd");
    $dumpvars();

    begintest = 1;

    #200000;

    dutpassed = 1;


    if(test_num == 0) begin
    $display("got here");
      if(dut.rf.reg2.qout != hanoi) begin
      $display("Test failed: Tower of Hanoi answer unexpected; expected %b but got %b", hanoi, dut.rf.reg2.qout);
      dutpassed = 0;
      end
    end
    if(test_num == 1) begin
    $display("NOT IMPLMENTED YET");
      // if(dut.rf.reg2.qout != ) begin
      // $display("Test failed: answer unexpected; expected %b but got %b", , dut.rf.reg2.qout);
      // dutpassed = 0;
      // end
    end
    if(test_num == 2) begin
      if(dut.rf.reg2.qout != fib) begin
      $display("Test failed: answer unexpected; expected %b but got %b", fib, dut.rf.reg2.qout);
      dutpassed = 0;
      end
    end
    if(test_num == 3) begin
      if(dut.rf.reg2.qout != yeet) begin
      $display("Test failed: answer unexpected; expected %b but got %b", yeet, dut.rf.reg2.qout);
      dutpassed = 0;
      end
    end


    endtest = 1;
    $display("DUT passed? %b", dutpassed);
    $display("Endtest: %b ", endtest);

    $finish();
  end

endmodule
