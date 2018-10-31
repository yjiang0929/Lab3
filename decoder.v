`define ADD  3'd0
`define SUB  3'd1
`define XOR  3'd2
`define SLT  3'd3
`define AND  3'd4
`define NAND 3'd5
`define NOR  3'd6
`define OR   3'd7

module decoder(
	input [31:0] cmd,
	output immSel, memWrEn, regWrEn,
	output [1:0] DwSel, jSel, pcSel, 
	output [4:0] Aa, Ab, Aw, 
	output [2:0] aluOp,
	output [15:0] imm,
	output [25:0] jumpAddr
);

	// Always in the same place in the command, though not always there
	wire [5:0] opcode; assign opcode = cmd[31:26];
	wire [5:0] funct; assign funct = cmd[5:0];

	assign imm = cmd[15:0];
	assign jumpAddr = cmd[25:0];

	// One-hot representation of opcodes / functs
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

	// Addresses of the registers we'll read from and/or write to
	assign Aa = cmd[25:21];
	assign Ab = cmd[20:16];
	assign Aw = jal ? 5'd31 : (lw | addi | xori ? Ab : cmd[15:11]);

	// Selectors for various things
	assign immSel = lw | sw | addi | xori; // Use an immediate?
	assign aluOp = xori ? `XOR : (slt ? `SLT : (beq | bne | sub ? `SUB : `ADD)); // What operation in the main ALU?
	assign DwSel = lw ? 2'd2 : (jal ? 2'd1 : 2'd0); // What data to write to the register file?
	assign jSel = jr ? 2'd0 : (jal || j ? 2'd1 : 2'd2); // What should the PC be next cycle?
	assign pcSel = beq ? 2'd1 : (bne ? 2'd2 : 2'd0); // What should we add to the PC (and maybe feed back into it)?
	assign memWrEn = sw; // Write to memeory?
	assign regWrEn = !(sw | j | beq | bne); // Write to register?

endmodule
