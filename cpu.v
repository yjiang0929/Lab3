// this is a cpu

`include "regfile.v"
`include "dataMemory.v"
`include "alu.v"
`include "mux.v"
`include "signExt.v"
`include "decoder.v"

module cpu(
	input clk
	// output reg[31:0] cpuout[1023:0]
);

	wire [31:0] nextPc, Da, Db, DbOrImm, Dw, resAluRes, immExt, memAddr, memOut, cmd, pcAluRes, pcAdd, branchAluRes;
	wire zeroFlag;

	reg [31:0] pc;  // Program counter is registers; the last 2 bits are ignored because we always run words
	initial pc <=0; // Initialize at 0
	always @(posedge clk) pc <= nextPc; // Update every clock cycle


	// These are driven by the decoder
	wire immSel, regWrEn,  memWrEn;
	wire [1:0] DwSel, pcSel, jSel;
	wire [2:0] resAluOp;
	wire [4:0] Aa, Ab, Aw;
	wire [15:0] imm;
	wire [25:0] jumpAddr;

	// The decoder drives all of the control logic, based on the current instruction.
	decoder dec(cmd, immSel, memWrEn, regWrEn, DwSel, jSel, pcSel, Aa, Ab, Aw, resAluOp, imm, jumpAddr);


	// The main logic, which does the "execute" part of fetch / decode / execute

	mux3 DwMux(Dw, resAluRes, pcAluRes, memOut, DwSel); // Select which data to write
	regfile rf(Da, Db, Dw, Aa, Ab, Aw, regWrEn, clk); // The register file

	signExt immExter(imm, immExt); // Sign-extend the immediate
	mux2 DbMux(DbOrImm, Db, immExt, immSel); // Select either immediate or register for the main ALU's second input

	// The main ALU, used for math and jumping
	alu resAlu(resAluRes, , zeroFlag, , Da, DbOrImm, resAluOp);

	// Data memory has two read ports, for instruction and data.  The data port also does writes.
	// Divide PC by 4 so it gets that word, not that byte
	dataMemory dm(clk, memWrEn, resAluRes[9:0], pc[11:2], Db, memOut, cmd);

	// Adds 4 to the branch location, and multiplies it by 4
	alu branchAlu(branchAluRes, , , , 32'd4, {14'b0, imm, 2'b0}, 3'd0 /*add command*/);

	// What the PC will be if it doesn't branch
	assign pcAluRes = pc + ( (pcSel == 2'd1 && zeroFlag == 1) || (pcSel == 2'd2 && zeroFlag == 0) ? branchAluRes : 32'd4);

	// Iff jump instruction, then reset the pc; otherwise add some amount
	mux3 pcMux(nextPc, Da, {pc[31:28], jumpAddr, 2'b0}, pcAluRes, jSel);

endmodule
