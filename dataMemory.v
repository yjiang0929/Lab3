// Data memory, with automatic initialization
// Credit: Ben Hill

module dataMemory
(
  input clk, regWE,
  input[9:0] Addr,
  input[9:0] CmdAddr,
  input[31:0] DataIn,
  output[31:0]  DataOut,
  output[31:0] CmdOut
);

  reg [31:0] mem[1023:0];

  //TODO: Divide by 4?

  always @(posedge clk) begin
    if (regWE) begin
      mem[Addr] <= DataIn;
    end
  end

	// initial $readmemh("fib.dat", mem);

  assign DataOut = mem[Addr];
  assign CmdOut = mem[CmdAddr];
endmodule
