// Test bench for the decoder
// Tests every instruction.

`include "decoder.v"

`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module testDecoder();

	reg [31:0] cmd; // The input to the decoder
	
	// The outputs from the decoder
	wire immSel, regWrEn,  memWrEn;
	wire [1:0] DwSel, pcSel, jSel;
	wire [2:0] aluOp;
	wire [4:0] Aa, Ab, Aw;
	wire [15:0] imm;
	wire [25:0] jumpAddr;

	decoder dut(cmd, immSel, memWrEn, regWrEn, DwSel, jSel, pcSel, Aa, Ab, Aw, aluOp, imm, jumpAddr);

	initial begin

		// LW
		cmd = 32'b100011_01010_10101_1100110011001100; #10;
		if (Aa !== 5'b01010) $display("LW Aa is %b, should be %b", Aa, 5'b01010);
		if (Ab !== 5'b10101) $display("LW Ab is %b, should be %b", Ab, 5'b10101);
		if (immSel !== 1) $display("LW immSel is %b, should be %b", immSel, 1);
		if (aluOp !== `ADD) $display("LW aluOp is %b, should be %b", aluOp, `ADD);
		if (DwSel !== 2'd2) $display("LW DwSel is %b, should be %b", DwSel, 2'd2);
		if (jSel !== 2'd2) $display("LW jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd0) $display("LW pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 0) $display("LW memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 1) $display("LW regWrEn is %b, should be %b", regWrEn, 1);

		// SW
		cmd = 32'b101011_01010_10101_1100110011001100; #10;
		if (Aa !== 5'b01010) $display("SW Aa is %b, should be %b", Aa, 5'b01010);
		if (Ab !== 5'b10101) $display("SW Ab is %b, should be %b", Ab, 5'b10101);
		if (immSel !== 1) $display("SW immSel is %b, should be %b", immSel, 1);
		if (aluOp !== `ADD) $display("SW aluOp is %b, should be %b", aluOp, `ADD);
		if (jSel !== 2'd2) $display("SW jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd0) $display("SW pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 1) $display("SW memWrEn is %b, should be %b", memWrEn, 1);
		if (regWrEn !== 0) $display("SW regWrEn is %b, should be %b", regWrEn, 0);

		// J
		cmd = 32'b000010_00110011001100110011001100; #10;
		if (jSel !== 2'd1) $display("J jSel is %b, should be %b", jSel, 2'd1);
		if (pcSel !== 2'd0) $display("J pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 0) $display("J memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 0) $display("J regWrEn is %b, should be %b", regWrEn, 0);

		// JR
		cmd = 32'b000000_01010_10101_11001_00110_001000; #10;
		if (Aa !== 5'b01010) $display("JR Aa is %b, should be %b", Aa, 5'b01010);
		if (jSel !== 2'd0) $display("JR jSel is %b, should be %b", jSel, 2'd0);
		if (memWrEn !== 0) $display("JR memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 0) $display("JR regWrEn is %b, should be %b", regWrEn, 0);


		// JAL
		cmd = 32'b000011_00110011001100110011001100; #10;
		if (jSel !== 2'd1) $display("JAL jSel is %b, should be %b", jSel, 2'd1);
		if (pcSel !== 2'd0) $display("JAL pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 0) $display("JAL memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 1) $display("JAL regWrEn is %b, should be %b", regWrEn, 1);
		if (Aw !== 5'd31) $display("JAL Aw is %b, should be %b", Aw, 5'd31);
		if (DwSel !== 2'd1) $display("JAL DwSel is %b, should be %b", DwSel, 2'd1);

		// BEQ
		cmd = 32'b000100_01010_10101_1100110011001100; #10;
		if (Aa !== 5'b01010) $display("BEQ Aa is %b, should be %b", Aa, 5'b01010);
		if (Ab !== 5'b10101) $display("BEQ Ab is %b, should be %b", Ab, 5'b10101);
		if (immSel !== 0) $display("BEQ immSel is %b, should be %b", immSel, 0);
		if (aluOp !== `SUB) $display("BEQ aluOp is %b, should be %b", aluOp, `SUB);
		if (jSel !== 2'd2) $display("BEQ jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd1) $display("BEQ pcSel is %b, should be %b", pcSel, 2'd1);
		if (memWrEn !== 0) $display("BEQ memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 0) $display("BEQ regWrEn is %b, should be %b", regWrEn, 0);

		// BNE
		cmd = 32'b000101_01010_10101_1100110011001100; #10;
		if (Aa !== 5'b01010) $display("BNE Aa is %b, should be %b", Aa, 5'b01010);
		if (Ab !== 5'b10101) $display("BNE Ab is %b, should be %b", Ab, 5'b10101);
		if (immSel !== 0) $display("BNE immSel is %b, should be %b", immSel, 0);
		if (aluOp !== `SUB) $display("BNE aluOp is %b, should be %b", aluOp, `SUB);
		if (jSel !== 2'd2) $display("BNE jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd2) $display("BNE pcSel is %b, should be %b", pcSel, 2'd2);
		if (memWrEn !== 0) $display("BNE memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 0) $display("BNE regWrEn is %b, should be %b", regWrEn, 0);

		// XORI
		cmd = 32'b001110_01010_10101_1100110011001100; #10;
		if (Aa !== 5'b01010) $display("XORI Aa is %b, should be %b", Aa, 5'b01010);
		if (Aw !== 5'b10101) $display("XORI Aw is %b, should be %b", Aw, 5'b10101);
		if (immSel !== 1) $display("XORI immSel is %b, should be %b", immSel, 1);
		if (aluOp !== `XOR) $display("XORI aluOp is %b, should be %b", aluOp, `XOR);
		if (jSel !== 2'd2) $display("XORI jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd0) $display("XORI pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 0) $display("XORI memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 1) $display("XORI regWrEn is %b, should be %b", regWrEn, 1);

		// ADDI
		cmd = 32'b001000_01010_10101_1100110011001100; #10;
		if (Aa !== 5'b01010) $display("ADDI Aa is %b, should be %b", Aa, 5'b01010);
		if (Aw !== 5'b10101) $display("ADDI Aw is %b, should be %b", Aw, 5'b10101);
		if (immSel !== 1) $display("ADDI immSel is %b, should be %b", immSel, 1);
		if (aluOp !== `ADD) $display("ADDI aluOp is %b, should be %b", aluOp, `ADD);
		if (jSel !== 2'd2) $display("ADDI jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd0) $display("ADDI pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 0) $display("ADDI memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 1) $display("ADDI regWrEn is %b, should be %b", regWrEn, 1);

		// ADD
		cmd = 32'b000000_01010_10101_11001_00110_100000; #10;
		if (Aa !== 5'b01010) $display("ADD Aa is %b, should be %b", Aa, 5'b01010);
		if (Ab !== 5'b10101) $display("ADD Ab is %b, should be %b", Ab, 5'b10101);
		if (immSel !== 0) $display("ADD immSel is %b, should be %b", immSel, 0);
		if (aluOp !== `ADD) $display("ADD aluOp is %b, should be %b", aluOp, `ADD);
		if (jSel !== 2'd2) $display("ADD jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd0) $display("ADD pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 0) $display("ADD memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 1) $display("ADD regWrEn is %b, should be %b", regWrEn, 1);

		// SUB
		cmd = 32'b000000_01010_10101_11001_00110_100010; #10;
		if (Aa !== 5'b01010) $display("SUB Aa is %b, should be %b", Aa, 5'b01010);
		if (Ab !== 5'b10101) $display("SUB Ab is %b, should be %b", Ab, 5'b10101);
		if (immSel !== 0) $display("SUB immSel is %b, should be %b", immSel, 0);
		if (aluOp !== `SUB) $display("SUB aluOp is %b, should be %b", aluOp, `SUB);
		if (jSel !== 2'd2) $display("SUB jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd0) $display("SUB pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 0) $display("SUB memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 1) $display("SUB regWrEn is %b, should be %b", regWrEn, 1);

		// SLT
		cmd = 32'b000000_01010_10101_11001_00110_101010; #10;
		if (Aa !== 5'b01010) $display("SLT Aa is %b, should be %b", Aa, 5'b01010);
		if (Ab !== 5'b10101) $display("SLT Ab is %b, should be %b", Ab, 5'b10101);
		if (immSel !== 0) $display("SLT immSel is %b, should be %b", immSel, 0);
		if (aluOp !== `SLT) $display("SLT aluOp is %b, should be %b", aluOp, `SLT);
		if (jSel !== 2'd2) $display("SLT jSel is %b, should be %b", jSel, 2'd2);
		if (pcSel !== 2'd0) $display("SLT pcSel is %b, should be %b", pcSel, 2'd0);
		if (memWrEn !== 0) $display("SLT memWrEn is %b, should be %b", memWrEn, 0);
		if (regWrEn !== 1) $display("SLT regWrEn is %b, should be %b", regWrEn, 1);

	end

endmodule
