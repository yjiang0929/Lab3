// this is a cpu

`include "regfile.v"
`include "datamemory.v"
`include "alu.v"
`include "mux2.v"

module cpu(
	input clk
);

	wire [31:0] Da, Db, DbOrImm, Dw, resAluRes;
	wire [4:0] Aa, Ab, Aw;
	wire regWrEn, zeroFlag;
	
	// These should be set by the decoder
	wire [2:0] resAluOp;
	wire [15:0] imm;
	wire [31:0] immExt;
	wire immSel;
	wire [2:0] thing[31:0];
	
	regfile rf(Da, Db, Dw, Aa, Ab, Aw, regWrEn, clk);

	mux2 DbMux(DbOrImm, Db, immExt, immSel);
	alu resAlu(resAluRes, , zeroFlag, , Da, DbOrImm, resAluOp);

	dataMemory dm(, , , ,);

endmodule

