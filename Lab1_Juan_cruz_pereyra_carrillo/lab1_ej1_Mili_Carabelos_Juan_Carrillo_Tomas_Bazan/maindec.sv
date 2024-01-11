module maindec (input logic [10: 0] Op,
					 output logic Reg2Loc, 
									  ALUSrc,
									  MemtoReg,
									  RegWrite,
									  MemRead,
									  MemWrite,
									  Branch,
									  MovIm,
					 output logic [1:0] ALUOp);
					 
	always_comb 
		casez (Op) 
			11'b111_1100_0010: begin //LDUR
									 Reg2Loc = 1'b0;
									 ALUSrc  = 1'b1;
									 MemtoReg= 1'b1;
									 RegWrite= 1'b1;
									 MemRead = 1'b1;
									 MemWrite= 1'b0;
									 Branch  = 1'b0;
									 ALUOp =  2'b00;
									 MovIm = 1'b0;
									 end
			11'b111_1100_0000: begin //STUR
									 Reg2Loc = 1'b1;
									 ALUSrc  = 1'b1;
									 MemtoReg= 1'b0;
									 RegWrite= 1'b0;
									 MemRead = 1'b0;
									 MemWrite= 1'b1;
									 Branch  = 1'b0;
									 ALUOp =  2'b00;
									 MovIm = 1'b0;
									 end
			11'b101_1010_0???: begin //CBZ
									 Reg2Loc = 1'b1;
									 ALUSrc  = 1'b0;
									 MemtoReg= 1'b0;
									 RegWrite= 1'b0;
									 MemRead = 1'b0;
									 MemWrite= 1'b0;
									 Branch  = 1'b1;
									 ALUOp =  2'b01;
									 MovIm = 1'b0;
									 end
			11'b100_0101_1000: begin //ADD
									 Reg2Loc = 1'b0;
									 ALUSrc  = 1'b0;
									 MemtoReg= 1'b0;
									 RegWrite= 1'b1;
									 MemRead = 1'b0;
									 MemWrite= 1'b0;
									 Branch  = 1'b0;
									 ALUOp =  2'b10;
									 MovIm = 1'b0;
									 end
			11'b100_0101_0000: begin //AND
									 Reg2Loc = 1'b0;
									 ALUSrc  = 1'b0;
									 MemtoReg= 1'b0;
									 RegWrite= 1'b1;
									 MemRead = 1'b0;
									 MemWrite= 1'b0;
									 Branch  = 1'b0;
									 ALUOp =  2'b10;
									 MovIm = 1'b0;
									 end
			11'b110_0101_1000: begin //SUB
									 Reg2Loc = 1'b0;
									 ALUSrc  = 1'b0;
									 MemtoReg= 1'b0;
									 RegWrite= 1'b1;
									 MemRead = 1'b0;
									 MemWrite= 1'b0;
									 Branch  = 1'b0;
									 ALUOp =  2'b10;
									 MovIm = 1'b0;
									 end
			11'b101_0101_0000: begin //ORR
									 Reg2Loc = 1'b0;
									 ALUSrc  = 1'b0;
									 MemtoReg= 1'b0;
									 RegWrite= 1'b1;
									 MemRead = 1'b0;
									 MemWrite= 1'b0;
									 Branch  = 1'b0;
									 ALUOp =  2'b10;
									 MovIm = 1'b0;
				   				 end		
			11'b110_1001_01??: begin //MWZ
									 Reg2Loc = 1'b1; //becouse RD is on bits [4:0]
									 ALUSrc  = 1'b0; // the alu isnt use 
									 MemtoReg= 1'b0; // the memory isnt use
									 //The register on the Write register [4:0] input is written with the value on the Write data input.
									 RegWrite= 1'b1; 
									 MemRead = 1'b0;// the memory isnt use
									 MemWrite= 1'b0;// the memory isnt use
									 Branch  = 1'b0;// the branch isnt use
									 ALUOp =  2'b00;// the alu isnt use
									 MovIm = 1'b1;  // this instrucction is type IM
									 end	 			 
			default:
							begin
							 Reg2Loc = 1'b0;
							 ALUSrc  = 1'b0;
							 MemtoReg= 1'b0;
							 RegWrite= 1'b0;
							 MemRead = 1'b0;
							 MemWrite= 1'b0;
							 Branch  = 1'b0;
							 ALUOp =  2'b00;
							 MovIm = 1'b0;
							 end
			
		endcase
			
endmodule

