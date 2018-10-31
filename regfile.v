//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------

// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]  out,
input         enable,
input[4:0]    address
);
    assign out = enable<<address;
endmodule

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

module register32zero
(
  output [31:0] qout,
  input[31:0] din,
  input wrenable,
  input clk
  );

 	assign qout = 32'h0;
endmodule

module register32sp
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
	initial qout = 32'h3ffc;
endmodule

module mux32to1by32
(
output[31:0]  out,
input[4:0]    address,
input[31:0]   input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31
);

  wire[31:0] mux[31:0];			// Create a 2D array of wires
  assign mux[0] = input0;
  assign mux[1] = input1;
  assign mux[2] = input2;
  assign mux[3] = input3;
  assign mux[4] = input4;
  assign mux[5] = input5;
  assign mux[6] = input6;
  assign mux[7] = input7;
  assign mux[8] = input8;
  assign mux[9] = input9;
  assign mux[10] = input10;
  assign mux[11] = input11;
  assign mux[12] = input12;
  assign mux[13] = input13;
  assign mux[14] = input14;
  assign mux[15] = input15;
  assign mux[16] = input16;
  assign mux[17] = input17;
  assign mux[18] = input18;
  assign mux[19] = input19;
  assign mux[20] = input20;
  assign mux[21] = input21;
  assign mux[22] = input22;
  assign mux[23] = input23;
  assign mux[24] = input24;
  assign mux[25] = input25;
  assign mux[26] = input26;
  assign mux[27] = input27;
  assign mux[28] = input28;
  assign mux[29] = input29;
  assign mux[30] = input30;
  assign mux[31] = input31;


  assign out = mux[address];	// Connect the output of the array
endmodule

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		RegWrite,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);

  wire[31:0] input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31;
  wire[31:0] writeEnable;
  wire[31:0] outputs;
  decoder1to32 dec0(writeEnable, RegWrite, WriteRegister);

  register32zero reg0(input0, WriteData,writeEnable[0], Clk);
  register32 reg1(input1, WriteData,writeEnable[1], Clk);
  register32 reg2(input2, WriteData,writeEnable[2], Clk);
  register32 reg3(input3, WriteData,writeEnable[3], Clk);
  register32 reg4(input4, WriteData,writeEnable[4], Clk);
  register32 reg5(input5, WriteData,writeEnable[5], Clk);
  register32 reg6(input6, WriteData,writeEnable[6], Clk);
  register32 reg7(input7, WriteData,writeEnable[7], Clk);
  register32 reg8(input8, WriteData,writeEnable[8], Clk);
  register32 reg9(input9, WriteData,writeEnable[9], Clk);
  register32 reg10(input10, WriteData,writeEnable[10], Clk);
  register32 reg11(input11, WriteData,writeEnable[11], Clk);
  register32 reg12(input12, WriteData,writeEnable[12], Clk);
  register32 reg13(input13, WriteData,writeEnable[13], Clk);
  register32 reg14(input14, WriteData,writeEnable[14], Clk);
  register32 reg15(input15, WriteData,writeEnable[15], Clk);
  register32 reg16(input16, WriteData,writeEnable[16], Clk);
  register32 reg17(input17, WriteData,writeEnable[17], Clk);
  register32 reg18(input18, WriteData,writeEnable[18], Clk);
  register32 reg19(input19, WriteData,writeEnable[19], Clk);
  register32 reg20(input20, WriteData,writeEnable[20], Clk);
  register32 reg21(input21, WriteData,writeEnable[21], Clk);
  register32 reg22(input22, WriteData,writeEnable[22], Clk);
  register32 reg23(input23, WriteData,writeEnable[23], Clk);
  register32 reg24(input24, WriteData,writeEnable[24], Clk);
  register32 reg25(input25, WriteData,writeEnable[25], Clk);
  register32 reg26(input26, WriteData,writeEnable[26], Clk);
  register32 reg27(input27, WriteData,writeEnable[27], Clk);
  register32 reg28(input28, WriteData,writeEnable[28], Clk);
  register32sp reg29(input29, WriteData,writeEnable[29], Clk);
  register32 reg30(input30, WriteData,writeEnable[30], Clk);
  register32 reg31(input31, WriteData,writeEnable[31], Clk);
  // outputs <= input2;


  mux32to1by32 read1(ReadData1, ReadRegister1, input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31);
  mux32to1by32 read2(ReadData2, ReadRegister2, input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31);

endmodule
