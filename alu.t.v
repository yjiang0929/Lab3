// ALU testbench
`timescale 1 ns / 1 ps
`include "alu.v"
`define DELAY 5000

`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module testALU();
    reg[31:0] a;
    reg[31:0] b;
    reg[2:0] control;
    wire[31:0] r;
    wire zero, co, ofl;

    alu dut(r, co, zero, ofl, a, b, control);

    initial begin
      $dumpfile("alu.vcd");
      $dumpvars();
      $display("32 Bit ADD tests");
      // $display("Control|                A                 |                B                 |                 R                  |COut | OFL |ZERO |Cout Exp| OFL Exp|ZERO Exp");
      control=`ADD; a = 32'h0000000; b = 32'h00000000; #`DELAY; //0+0
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   0    |   1", control, a, b, r, co, ofl, zero);
      if (r !== (a+b))
      $display("R Error, should be %b", (a+b));
      control=`ADD; a = 32'h01234567; b = 32'h0FFFFFFF; #`DELAY; //test pos+pos
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a+b))
      $display("R Error, should be %b", (a+b));
      control=`ADD; a = 32'h7FFFFFFF; b = 32'h7FFFFFFF; #`DELAY; //test pos+pos overflow
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   1    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a+b))
      $display("R Error, should be %b", (a+b));
      control=`ADD; a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; #`DELAY; //test neg+neg carryout
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a+b))
      $display("R Error, should be %b", (a+b));
      control=`ADD; a = 32'h90000000; b = 32'h80000000; #`DELAY; //test neg+neg carryout+overflow
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   1    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a+b))
      $display("R Error, should be %b", (a+b));
      control=`ADD; a = 32'h81234567; b = 32'h12345678; #`DELAY; //test pos+neg
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a+b))
      $display("R Error, should be %b", (a+b));
      control=`ADD; a = 32'h000000F; b = 32'hFFFFFFF1; #`DELAY; //test pos+neg=0
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   0    |   1", control, a, b, r, co, ofl, zero);
      if (r !== (a+b))
      $display("R Error, should be %b", (a+b));
      control=`ADD; a = 32'hE1234567; b = 32'h72345678; #`DELAY; //test pos+neg carryout
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a+b))
      $display("R Error, should be %b", (a+b));

      $display("32 Bit SUB tests");
      // $display("Control|                A                 |                B                 |                 R                  |COut | OFL |ZERO |Cout Exp| OFL Exp|ZERO Exp");
      control=`SUB; a = 32'h12345678; b = 32'h12345678; #`DELAY; //a-b=0
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   0    |   1", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'h7FFFFFFF; b = 32'h71234567; #`DELAY; //pos-pos=pos
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'h71234567; b = 32'h7FFFFFFF; #`DELAY; //pos-pos=neg
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'hFFFFFFFF; b = 32'hF1234567; #`DELAY; //neg-neg=pos
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'hF1234567; b = 32'hFFFFFFFF; #`DELAY; //neg-neg=neg
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'hFFFFFFFF; b = 32'h80000000; #`DELAY; //neg-neg=neg
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'h71234567; b = 32'hF1234567; #`DELAY; //pos-neg=pos overflow
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   1    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'h37654321; b = 32'hE1234567; #`DELAY; //pos-neg=pos
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   0    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'hE7654321; b = 32'h31234567; #`DELAY; //neg-pos=neg
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   0    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));
      control=`SUB; a = 32'hA7654321; b = 32'h71234567; #`DELAY; //neg-pos=neg overflow
      // $display("  %b  | %b | %b |  %b  |  %b  |  %b  |  %b  |   1    |   1    |   0", control, a, b, r, co, ofl, zero);
      if (r !== (a-b))
      $display("R Error, should be %b", (a-b));

      $display("32 Bit XOR tests");
      // $display("Control |                A                 |                B                 |                R                   ");
      control=`XOR; a = 32'h87654321; b = 32'h12345678; #`DELAY; //XOR two normal cases
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== (a^b))
      $display("R Error, should be %b", (a^b));
      control=`XOR; a = 32'hFFFFFFFF; b = 32'h12345678; #`DELAY; //XOR with all 1
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== (a^b))
      $display("R Error, should be %b", (a^b));
      control=`XOR; a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; #`DELAY; //XOR two all 1 cases
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== (a^b))
      $display("R Error, should be %b", (a^b));
      control=`XOR; a = 32'h00000000; b = 32'h12345678; #`DELAY; //XOR with all 0
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== (a^b))
      $display("R Error, should be %b", (a^b));
      control=`XOR; a = 32'h00000000; b = 32'h00000000; #`DELAY; //XOR two all 0 cases
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== (a^b))
      $display("R Error, should be %b", (a^b));
      control=`XOR; a = 32'hFFFFFFFF; b = 32'h00000000; #`DELAY; //XOR all 0 and all 1
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== (a^b))
      $display("R Error, should be %b", (a^b));

      $display("32 Bit SLT tests");
      // $display("Control |                A                 |                B                 |                R                   ");
      control=`SLT; a = 32'h00000000; b = 32'h00000000; #`DELAY; //0=0
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== 32'h00000000)
      $display("R Error, should be %b", 32'h00000000);
      control=`SLT; a = 32'h7FFFFFFF; b = 32'h12345678; #`DELAY; //pos>pos
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== 32'h00000000)
      $display("R Error, should be %b", 32'h00000000);
      control=`SLT; a = 32'h12345678; b = 32'h7FFFFFFF; #`DELAY; //pos<pos
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== 32'h00000001)
      $display("R Error, should be %b", 32'h00000001);
      control=`SLT; a = 32'hFFFFFFFF; b = 32'h81234567; #`DELAY; //neg>neg
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== 32'h00000000)
      $display("R Error, should be %b", 32'h00000000);
      control=`SLT; a = 32'h81234567; b = 32'hFFFFFFFF; #`DELAY; //neg<neg
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== 32'h00000001)
      $display("R Error, should be %b", 32'h00000001);
      control=`SLT; a = 32'h7FFFFFFF; b = 32'hFFFFFFFF; #`DELAY; //pos>neg
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== 32'h00000000)
      $display("R Error, should be %b", 32'h00000000);
      control=`SLT; a = 32'hFFFFFFFF; b = 32'h7FFFFFFF; #`DELAY; //neg<pos
      // $display("  %b   | %b | %b |  %b  ", control, a, b, r);
      if (r !== 32'h00000001)
      $display("R Error, should be %b", 32'h00000001);
    end

endmodule
