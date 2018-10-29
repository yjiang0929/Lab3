module sign_ext
(
  input [15:0] imm,
  output [31:0] immExt
);
  assign immExt[15:0] = imm;
  assign immExt[16] = imm[15];
  assign immExt[17] = imm[15];
  assign immExt[18] = imm[15];
  assign immExt[19] = imm[15];
  assign immExt[20] = imm[15];
  assign immExt[21] = imm[15];
  assign immExt[22] = imm[15];
  assign immExt[23] = imm[15];
  assign immExt[24] = imm[15];
  assign immExt[25] = imm[15];
  assign immExt[26] = imm[15];
  assign immExt[27] = imm[15];
  assign immExt[28] = imm[15];
  assign immExt[29] = imm[15];
  assign immExt[30] = imm[15];
  assign immExt[31] = imm[15];
endmodule
