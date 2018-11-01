// Data memory, with automatic initialization
// Credit: Ben Hill, mostly
// Three ports: dataIn (write), dataOut (read), cmdOut (read)
// dataIn and dataOut share an address

module dataMemory
(
  input clk, regWE, // On rising edge, iff regWE, writes data to register
  input[9:0] dataAddr,
  input[9:0] cmdAddr,
  input[31:0] dataIn,
  output[31:0]  dataOut,
  output[31:0] cmdOut
);

  reg [31:0] mem[1023:0]; // The actual memory

  always @(posedge clk) begin // Write if necessary
    if (regWE) begin
      mem[dataAddr] <= dataIn;
    end
  end
  integer idx;


  assign dataOut = mem[dataAddr]; // Data output
  assign cmdOut = mem[cmdAddr]; // Command output
endmodule
