// DATAPATH

module datapath #(parameter N = 64)
					(input logic reset, clk,
					input logic reg2loc,									
					input logic AluSrc,
					input logic [3:0] AluControl,
					input logic	Branch,
					input logic memRead,
					input logic memWrite,
					input logic regWrite,	
					input logic memtoReg,
					input logic MovIm,
					input logic [31:0] IM_readData,
					input logic [N-1:0] DM_readData,
					output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
					output logic DM_writeEnable, DM_readEnable,
					output logic hazard_detected);					

	logic PCSrc;
	logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3, RD_mov; 
	logic [N-1:0] signImm_D, readData1_D, readData2_D;
	logic zero_E;
	logic [95:0] qIF_ID;
	logic [299:0] qID_EX;
	logic [267:0] qEX_MEM;		// fixed
	logic [201:0] qMEM_WB;		// fixed x2
	logic [15:0] Immediate;
	logic [1:0]LSL;
	logic [10:0] hazard_mux2;

	//todo: si no anda adentro de decode 
	hdu HDU (
		.IF_ID_Rn(qIF_ID[9:5]),   
		.IF_ID_Rm(qIF_ID[20:16]),
		.ID_EX_Rd(qID_EX[4:0]),
		.ID_EX_mem_read(qID_EX[264]),
		.hazard_detected(hazard_detected)
	);
				
	mux2 #(11) HAZARDS_MUX2 (
		.d0({MovIm, AluSrc, AluControl, Branch, memRead, memWrite, regWrite, memtoReg}),
		.d1(11'b0),
		.s(hazard_detected),
		.y(hazard_mux2)
	);

	fetch 	#(64) 	FETCH 	(.PCSrc_F(PCSrc),
							.clk(clk),
							.enable(~hazard_detected),
							.reset(reset),
							.PCBranch_F(qEX_MEM[197:134]),
							.imem_addr_F(IM_addr));								
					
	// ahora tiene un enabe	
	flopre 	#(96)		IF_ID   (		.enable(~hazard_detected), 
										.clk(clk),
										.reset(reset), 
										.d({IM_addr, IM_readData}),
										.q(qIF_ID));

	decode 	#(64) 	DECODE 	(.regWrite_D(qMEM_WB[134]),
										.reg2loc_D(reg2loc), 
										.clk(clk),
										.writeData3_D(writeData3),
										.instr_D(qIF_ID[31:0]), 
										.signImm_D(signImm_D), 
										.readData1_D(readData1_D),
										.readData2_D(readData2_D),
										.wa3_D(qMEM_WB[4:0]),
										.Immediate(Immediate),
										.LSL(LSL));				
		


	flopr 	#(300)	ID_EX 	(.clk(clk),
										.reset(reset), 
										.d({qIF_ID[20:16], qIF_ID[9:5], hazard_mux2[10], LSL, Immediate, hazard_mux2[9:0],
											qIF_ID[95:32], signImm_D, readData1_D, readData2_D, qIF_ID[4:0]}),
										.q(qID_EX));
										//Immediate is 271: 286
										// LSL is 287:288
										//MovIm is 289
								
	// TODO: checkear la señal de control WB, creo que es memWrite y agregarla a los flopre de EX_MEM y MEM_WB
	// Update ^ : creo que es memtoReg y no memWrite en qID_EX es el bit 261		
	execute 	#(64) 	EXECUTE 	(	.writeBackResult(writeData3),
										.EX_MEM_regWrite(qEX_MEM[199]),    // fixed x2 
										.MEM_WB_regWrite(qMEM_WB[200]),		// fixzed x2
										.AluSrc(qID_EX[270]),
										.AluControl(qID_EX[269:266]),
										.PC_E(qID_EX[260:197]), 
										.signImm_E(qID_EX[196:133]), 
										.readData1_E(qID_EX[132:69]), 
										.readData2_E(qID_EX[68:5]), 
										.Immediate(qID_EX[286:271]),
										.LSL(qID_EX[288:287]),
										.PCBranch_E(PCBranch_E), 
										.aluResult_E(aluResult_E), 
										.writeData_E(writeData_E), 
										.zero_E(zero_E), 
										.RD_mov(RD_mov),
										.ID_EX_Rn(qID_EX[294:290]), 
										.ID_EX_Rm(qID_EX[299:295]), 
										.EX_MEM_Rd(qEX_MEM[4:0]),   
										.MEM_WB_Rd(qMEM_WB[4:0]));  
											
									
	flopr 	#(268)	EX_MEM 	(.clk(clk),
										.reset(reset), 
											 //MovIm               alusignals 
										.d({ qID_EX[289], RD_mov, qID_EX[265:261], PCBranch_E, zero_E, aluResult_E, writeData_E, qID_EX[4:0]}),
										.q(qEX_MEM));	
										// RD_mov is 203:266
										//MovIm is 267

										// memtoReg es bit 198
										// qID_EX no tiene sentido
										
	memory				MEMORY	(.Branch_M(qEX_MEM[202]), 
										.zero_M(qEX_MEM[133]), 
										.PCSrc_M(PCSrc));


										
	// Salida de señales a Data Memory
	assign DM_writeData = qEX_MEM[68:5];
	assign DM_addr = qEX_MEM[132:69];
	
	// Salida de señales de control:
	assign DM_writeEnable = qEX_MEM[200];
	assign DM_readEnable = qEX_MEM[201];
	
	flopr 	#(201)	MEM_WB 	(.clk(clk),    // fix size
										.reset(reset),   
										 //	EX/MEMmemtoReg										aluSRC	   	Read_data1_D
										.d({qEX_MEM[199], qEX_MEM[267], qEX_MEM[266:203], qEX_MEM[199:198], qEX_MEM[132:69],	DM_readData, qEX_MEM[4:0]}),
										.q(qMEM_WB));
										// agregar 64 bits para RD_mov [135: 198] de este registro
										// MovIm is in bit 199

										// Cambiar qEx_MEM[268] por 198
										
	writeback #(64) 	WRITEBACK (.aluResult_W(qMEM_WB[132:69]), 
										.DM_readData_W(qMEM_WB[68:5]), 
										.memtoReg(qMEM_WB[200]),
										.MovIm(qMEM_WB[199]),
										.writeData3_W(writeData3),
										.RD_mov(qMEM_WB[198:135]));		


endmodule
