module execute #(parameter N=64) ( input logic AluSrc,
					  input logic [3:0] AluControl,
					  input logic [N-1:0]PC_E, signImm_E, readData1_E, readData2_E,writeBackResult,
					  input logic [1:0] LSL, 
					  input logic [15:0] Immediate,
					  input logic [4:0] ID_EX_Rn, ID_EX_Rm, EX_MEM_Rd, MEM_WB_Rd,
					  input logic EX_MEM_regWrite, MEM_WB_regWrite,
					  output logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, RD_mov,
					  output logic zero_E);

	//instanciar  alu, sl2, adder y mux2

	logic [N-1: 0] sl2_result, mux_result;
	logic [1:0] forwardA, forwardB;
	logic [N-1:0] outMuxA, outMuxB; //chekcear el N-1
	assign writeData_E = readData2_E;
	
	alu f1_alu (outMuxA,mux_result,AluControl,aluResult_E,zero_E);
	sl2 f2_sl2(signImm_E,sl2_result);
	adder f3_adder(PC_E,sl2_result,PCBranch_E);
	forwarding_unit f9_ForwardingUnit(
	.MEM_WB_regWrite(MEM_WB_regWrite),
	.EX_MEM_regWrite(EX_MEM_regWrite),
	.MEM_WB_Rd(MEM_WB_Rd),
	.EX_MEM_Rd(EX_MEM_Rd),
	.ID_EX_Rn(ID_EX_Rn),
	.ID_EX_Rm(ID_EX_Rm),
	.forwardA(forwardA),
	.forwardB(forwardB));
	mux3 f6_mux3A(.d0(readData1_E),
	.d1(writeBackResult),
	.d2(aluResult_E),
	.s(forwardA),
	.y(outMuxA));
	mux3 f7_mux3B(.d0(readData2_E),
	.d1(writeBackResult),
	.d2(aluResult_E),
	.s(forwardB),.y(outMuxB));
	mux2 f4_mux2(outMuxB, signImm_E, AluSrc, mux_result);
	mov_im f5_mov_im (.LSL(LSL), .Immediate(Immediate), .RD_mov(RD_mov));

endmodule
