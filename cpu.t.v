// `timescale 1 ns / 1 ps
`include "cpu.v"
`define DELAY 5000

module testCPU();
  reg clk;

  reg begintest = 0; //Set high to begin testing register file
  reg endtest = 0; //Set high to signal test completion
  reg dutpassed = 1; //Indicates whether register file passed tests

  wire[31:0] hanoi = 32'd270;
  wire[31:0] fib = 32'd58;
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

  if (! $value$plusargs("test_num=%s", test_num)) begin
    $display("ERROR: Test name not specified. Provide +test_num=[test_num] argument");
    $finish();
    end

  test_str <= "fib_func";
  r_RESULT <= 0;


	// if (! $value$plusargs("dump_fn=%s", dump_fn)) begin
	//     $display("ERROR: provide +dump_fn=[path for VCD dump] argument");
	//     $finish();
        // end


    // $readmemh("asmtest/NINJA/fib_func/fib_func.text.hex", dut.dm.mem, 0);
    $readmemh(mem_text_fn, dut.dm.mem,0);
    // $readmemh("asmtest/bleep_vim/branch_test.text.hex", dut.dm.mem, 0);



    $dumpfile("cpuout.vcd");
    $dumpvars();

    begintest = 1;
    $display("Testbench start");

    $display("After begintest = 1");
    #200000;

    dutpassed = 1;


    $display("%b", test_num);
    case (test_num)
      3'd0  : r_RESULT <= 0;
      3'b001  : r_RESULT <= 1;
      3'b010  : r_RESULT <= 2;
      default : r_RESULT <= 9;
    endcase

    $display("R_RESULT: %b", r_RESULT);
    if(r_RESULT == 0) begin
      if(dut.rf.reg2.qout != fib) begin
      $display("Test failed: Tower of Hanoi answer unexpected; expected %b but got %b", hanoi, dut.rf.reg2.qout);
      dutpassed = 0;
      end
    end

    endtest = 1;
    $display("DUT passed? %b", dutpassed);
    $display("Endtest: %b ", endtest);

    $finish();
  end

endmodule
