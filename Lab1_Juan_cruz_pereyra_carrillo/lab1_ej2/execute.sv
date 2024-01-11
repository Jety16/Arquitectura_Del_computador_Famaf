module execute
	#(parameter N = 64)
	(input logic AluSrc,
	input logic [3:0] AluControl,
	input logic [N-1:0] PC_E, signImm_E, readData1_E, readData2_E,
	output logic [N-1:0] PCBranch_E, aluResult_E, writeData_E,
	output logic zero_E);
	 
	logic [N-1:0] slOut, muxOut;
	 
	sl2 #(N)		Shift(signImm_E, slOut);
	adder #(N)	Add(PC_E, slOut, PCBranch_E);
	mux2 #(N)	Mux(readData2_E, signImm_E, AluSrc, muxOut);
	alu #(N) 	Alu(readData1_E, muxOut, AluControl, aluResult_E, zero_E);

	assign writeData_E = readData2_E;
	
endmodule