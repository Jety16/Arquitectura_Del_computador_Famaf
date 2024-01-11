// Etapa: WRITEBACK

module writeback #(parameter N = 64)
					(input logic [N-1:0] aluResult_W, DM_readData_W,
					input logic memtoReg,
					input logic [N-1:0] RD_mov,
					input logic MovIm,
					output logic [N-1:0] writeData3_W);					

	logic [N-1:0] writeData3_Internal; 
		
	mux2 #(64) MtoRmux (.d0(aluResult_W), .d1(DM_readData_W), .s(memtoReg), .y(writeData3_Internal));
	mux2 #(64) MtoRmux2 (.d0(writeData3_Internal), .d1(RD_mov), .s(MovIm), .y(writeData3_W));
	
endmodule
