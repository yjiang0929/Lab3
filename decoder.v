`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module decoder(
	input cmd,
	output immSel, jSel, pcSel, bneSel, memWrEn, memAddrSel, regWrEn,
	output [1:0] DwSel,
	output [4:0] Aa, Ab, Aw, 
	output [2:0] resAluOp,
	output [15:0] imm,
	output [31:0] branchAddr
);

	wire opcode; assign opcode = cmd[31:26];
	wire funct; assign funct = cmd[5:0];

	wire lw; assign lw = (opcode == 6'h23);
	wire sw; assign sw = (opcode == 6'h2b);
	wire j; assign j = (opcode == 6'h2);
	wire jal; assign jal = (opcode == 6'h3);
	wire beq; assign beq = (opcode == 6'h4);
	wire bne; assign bne = (opcode == 6'h5);
	wire xori; assign xori = (opcode == 6'he);
	wire addi; assign addi = (opcode == 6'h8);
	wire jr; assign jr = (opcode == 6'h0  && funct == 6'h8);
	wire add; assign add = (opcode == 6'h0 && funct == 6'h20);
	wire sub; assign sub = (opcode == 6'h0 && funct == 6'h22);
	wire slt; assign slt = (opcode == 6'h0 && funct == 6'h2a);

	assign imm = cmd[15:0];

	assign Aa = cmd[25:21];
	assign Ab = cmd[20:16];
	assign Aw = jal ? 4'd31 : (lw ? Ab : cmd[15:11]);

	assign immSel = lw | sw | addi | xori;
	assign aluOp = xori ? `XOR : (slt ? `SLT : (beq | bne | sub ? `SUB : `ADD))

endmodule
