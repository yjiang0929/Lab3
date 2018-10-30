module register32
(
  output reg[31:0] qout,
  input[31:0] din,
  input wrenable,
  input clk
  );

  always @(posedge clk) begin
      if(wrenable) begin
          qout <= din;
      end
  end



endmodule
