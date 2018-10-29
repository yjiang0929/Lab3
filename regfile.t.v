//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire  	endtest;    	// Set High to signal test completion
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest),
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite),
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("DUT passed?: %b", dutpassed);
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);
integer i;
integer verbosity=1;
  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;

  end

// A fully perfect register file. True when device works correctly, false for any errors.
// Write Enable is broken / ignored – Register is always written to.
// Decoder is broken – All registers are written to.
// Register Zero is actually a register instead of the constant value zero.
// Port 2 is broken and always reads register 14 (for example).

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Given test cases
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  //   (Passes because example register file is hardwired to return 42)
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    if(verbosity == 1)
      $display("Test Case Ben 1 Failed");
  end

  // Test Case 2:
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  //   (Fails with example register file, but should pass with yours)
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
    dutpassed = 0;
    if(verbosity == 1)
      $display("Test Case Ben 2 Failed");
  end



//My tests cases: first, make sure we can't write to the 0 register to each register and then clear the last one.
WriteRegister = 5'd0;
WriteData = 32'd42;
RegWrite = 1;
ReadRegister1 = 5'd0;
ReadRegister2 = 5'd0;
#5 Clk=1; #5 Clk=0;

//If one of them read 0, be sad
if((ReadData1 !== 0) || (ReadData2 !== 0)) begin
  dutpassed = 0;
  $display("Test 0 Failed; Register 0 isn't the constant 0 value. Check your zero register implementation.");
end


//Loop through every register to make sure that any broken register is caught
for (i = 1 ; i < 32 ; i=i+1) begin
  WriteRegister = i;
  WriteData = i;
  RegWrite = 1;
  ReadRegister1 = i;
  ReadRegister2 = i;
  #5 Clk=1; #5 Clk=0;

  //If one of them read 0, be sad and output error results if necessary
  if((ReadData1 !== i) || (ReadData2 !== i) && dutpassed == 1) begin
    dutpassed = 0;
    if(verbosity == 1) begin
    if(ReadData1 == i)
    $display("Test 1 Case %d Failed; Register %d is being written to successfully, but ReadData2 is broken displaying %d.", i, i, ReadData2);
    else if (ReadData2 == i)
    $display("Test 1 Case %d Failed; Register %d is being written to successfully, but ReadData1 is broken displaying %d.", i, i, ReadData1);
    else
    $display("Test 1 Case %d Failed; Register %d isn't being written to and/or read from successfully. Contained value: ", i, i, ReadData1);
    end
end


  if(dutpassed == 0) begin
    i = 32;
  end
end

//Not writing, loop through every register to ensure that nothing was overwritten. Write data is 33 to know if writenable is ignored (33 should never be encountered). Also tests for decoder being broken.
for (i = 0 ; i < 32 ; i=i+1) begin
  WriteRegister = i;
  WriteData = 33;
  RegWrite = 0;
  ReadRegister1 = i;
  ReadRegister2 = i;
  #5 Clk=1; #5 Clk=0;

  //If one of them read 0, say what the error was and suggest if
  if((ReadData1 !== i) || (ReadData2 !== i) && dutpassed == 1) begin
    dutpassed = 0;
    if(verbosity == 1) begin
    $display("Test 2 Case %d Failed; Register %d isn't following writeEnable. Contained value: ", i, i, ReadData1);
    end
  end

  if(dutpassed == 0) begin
    i = 32;
  end
end



  if(dutpassed == 1 && verbosity == 1) begin
    $display("Congrats! You have a \"perfect register file.\"");
  end

  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
