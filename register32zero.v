module register32zero
(
  output reg[31:0] qout,
  input[31:0] din,
  input wrenable,
  input clk
  );

  always @(posedge clk) begin
    if(wrenable) begin
      qout <= 32'h00000000;
      end
  end



endmodule
