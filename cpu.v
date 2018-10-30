// this is a cpu

`include "regfile.v"
`include "dataMemory.v"
`include "alu.v"
`include "mux.v"
`include "signExt.v"

module cpu(
	input clk
);

	reg [31:0] pc;

	wire [31:0] Da, Db, DbOrImm, Dw, resAluRes, immExt, memAddr, memOut, pcAluRes, pcAdd, branchAluRes;
	wire [4:0] Aa, Ab, Aw;
	wire zeroFlag;
	
	// These should be set by the decoder
	wire immSel, memAddrSel, regWrEn,  memWrEn, pcSel;
	wire [1:0] DwSel;
	wire [2:0] resAluOp;
	wire [15:0] imm;
	wire [31:0] branchAddr;
	
	mux3 DwMux(Dw, resAluRes, pcAluRes, memOut, DwSel);
	regfile rf(Da, Db, Dw, Aa, Ab, Aw, regWrEn, clk);

	signExt immExter(imm, immExt);
	mux2 DbMux(DbOrImm, Db, immExt, immSel);
	alu resAlu(resAluRes, , zeroFlag, , Da, DbOrImm, resAluOp);

	mux2 addrMux(memAddr, resAluRes, pc, memAddrSel);
	dataMemory dm(clk, memWrEn, memAddr[9:0], Db, memOut);

	mux2 pcAddMux(pcAdd, 32'd4, branchAluRes, pcSel);
	alu pcAlu(pcAluRes, , , , pc, pcAdd, 3'd0 /*add command*/);

	alu branchAlu(branchAluRes, , , , 32'd4, branchAddr, 3'd0 /*add command*/);

endmodule

