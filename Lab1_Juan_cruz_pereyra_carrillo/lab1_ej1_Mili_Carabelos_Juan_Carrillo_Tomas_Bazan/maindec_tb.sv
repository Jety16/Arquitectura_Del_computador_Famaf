module maindec_tb();

	logic [10:0] opcode;

	logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
	logic [1:0] ALUOp;

	maindec dut(
		.Op(opcode),
		.Reg2Loc(Reg2Loc), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg), .RegWrite(RegWrite),
		.MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .ALUOp(ALUOp)
	);

	logic expected_Reg2Loc, expected_ALUSrc, expected_MemtoReg, expected_RegWrite, expected_MemRead, expected_MemWrite, expected_Branch;
	logic [1:0] expected_ALUOp;


	logic [19:0] inputs_and_expected_outputs [0:6] = '{
		{11'b111_1100_0010, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 2'b00}, // LDUR
		{11'b111_1100_0000, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 2'b00}, // STUR
		{11'b101_1010_0000, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 2'b01}, // CBZ
		{11'b100_0101_1000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}, // ADD
		{11'b110_0101_1000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}, // SUB
		{11'b100_0101_0000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}, // AND
		{11'b101_0101_0000, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 2'b10}  // ORR
	};

	int errors;
	initial begin
		errors = 0;

		for (int i = 0; i < 7; ++i) begin
			#1ns;
			{opcode, expected_Reg2Loc, expected_ALUSrc, expected_MemtoReg, expected_RegWrite, expected_MemRead, expected_MemWrite, expected_Branch, expected_ALUOp} =
				inputs_and_expected_outputs[i];
			
			#1ns;

			if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp}
					!== {expected_Reg2Loc, expected_ALUSrc, expected_MemtoReg, expected_RegWrite, expected_MemRead, expected_MemWrite, expected_Branch, expected_ALUOp}
			) begin
				errors++;
				$display("ERROR: i = %d", i);
			end
		end

		$display("Total errors = %d", errors);
	end

endmodule