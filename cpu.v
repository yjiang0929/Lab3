// this is a cpu

`include "regfile.v"
`include "dataMemory.v"
`include "alu.v"
`include "mux.v"
`include "signExt.v"
`include "decoder.v"

module cpu(
	input clk
);

	reg [31:0] pc;

	initial pc <= 32'd1024;

	always @(posedge clk) pc <= nextPc;



	wire [31:0] nextPc, Da, Db, DbOrImm, Dw, resAluRes, immExt, memAddr, memOut, cmdOut, pcAluRes, pcAdd, branchAluRes;
	wire zeroFlag;

	// These should be set by the decoder
	wire immSel, regWrEn,  memWrEn;
	wire [1:0] DwSel, pcSel, jSel;
	wire [2:0] resAluOp;
	wire [4:0] Aa, Ab, Aw;
	wire [15:0] imm;
	wire [25:0] jumpAddr;


	decoder dec(cmdOut, immSel, memWrEn, regWrEn, DwSel, jSel, pcSel, Aa, Ab, Aw, resAluOp, imm, jumpAddr);


	mux3 DwMux(Dw, resAluRes, pcAluRes, memOut, DwSel); // Select which data to write
	regfile rf(Da, Db, Dw, Aa, Ab, Aw, regWrEn, clk); // The register file

	signExt immExter(imm, immExt); // Sign-extend the immediate
	mux2 DbMux(DbOrImm, Db, immExt, immSel); // Select either immediate or register for the main ALU's second input
	alu resAlu(resAluRes, , zeroFlag, , Da, DbOrImm, resAluOp); // The main ALU (used for math, data memory ops)

	// Data memory has two read ports, for instruction and data.  The data port also does writes.
	dataMemory dm(clk, memWrEn, memAddr[9:0], pc[11:2] /* divide by 4 */, Db, memOut, cmdOut);

	// Adds 4 to the branch location
	alu branchAlu(branchAluRes, , , , 32'd4, {16'b0, imm}, 3'd0 /*add command*/);

	// Add branchAluRes instead of 4 iff it's a beq / bne, and the zero flag is appropriate
	mux2 pcAddMux(pcAdd, 32'd4, branchAluRes, pcSel[0] && (pcSel[1] ^ zeroFlag));

	// Add 4 (or some other value) to the pc
	alu pcAlu(pcAluRes, , , , pc, pcAdd, 3'd0 /*add command*/);

	// Iff jump instruction, then reset the pc; otherwise add some amount
	mux3 pcMux(nextPc, Da, {6'b0, jumpAddr}, pcAluRes, jSel);



endmodule
