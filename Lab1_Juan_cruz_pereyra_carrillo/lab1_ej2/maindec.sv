module maindec
	(input logic [10:0] Op,
	output logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,
	output logic [1:0] ALUOp);
	 
	logic [8:0] signalValue [0:5] = '{	9'b0_0_0_1_0_0_0_10, 
													9'b0_1_1_1_1_0_0_00,
													9'b1_1_0_0_0_1_0_00, 
													9'b1_0_0_0_0_0_1_01,
													9'b0_1_0_1_0_0_0_01,
													9'b0_0_0_0_0_0_0_00};
										
	int index;
	
	always_comb 
		begin
			casez(Op)
				11'b100_0101_1000: index = 0; // ADD
				11'b110_0101_1000: index = 0; // SUB 
				11'b100_0101_0000: index = 0; // AND 
				11'b101_0101_0000: index = 0; // ORR 
				11'b111_1100_0010: index = 1; // LDUR
				11'b111_1100_0000: index = 2; // STUR 	 
				11'b101_1010_0???: index = 3; // CBZ
				11'b110_1001_01??: index = 4; // MOVZ
				default: index = 5;
			endcase
			{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp} = signalValue[index];
		end

endmodule