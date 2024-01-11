// DATAPATH

module datapath 
	#(parameter N = 64)
	(input logic reset, clk,
	input logic reg2loc,									
	input logic AluSrc,
	input logic [3:0] AluControl,
	input logic	Branch,
	input logic memRead,
	input logic memWrite,
	input logic regWrite,	
	input logic memtoReg,									
	input logic [31:0] IM_readData,
	input logic [N-1:0] DM_readData,
	output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
	output logic DM_writeEnable, DM_readEnable, stall);					
	
	logic PCSrc, stall_signal;
	logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3; 
	logic [N-1:0] signImm_D, readData1_D, readData2_D;
	logic zero_E;
	logic [95:0] qIF_ID;
	logic [280:0] qID_EX;
	logic [202:0] qEX_MEM;
	logic [134:0] qMEM_WB;

	assign stall = stall_signal;
		
	fetch #(64) FETCH (.PCSrc_F(PCSrc),
							.clk(clk),
							.reset(reset),
							.PCBranch_F(qEX_MEM[197:134]),
							.imem_addr_F(IM_addr),
							.stall(stall_signal));							
					
	
	flopr_e #(96) IF_ID 	(.clk(clk),
						.reset(reset), 
						.enable(~stall_signal),
						.d({IM_addr, IM_readData}),
						.q(qIF_ID));
	
	logic [4:0] ra1_D, ra2_D; // Read addrs
	
	decode #(64)  DECODE 	(.regWrite_D(qMEM_WB[134]),
							.reg2loc_D(reg2loc), 
							.clk(clk),
							.writeData3_D(writeData3),
							.instr_D(qIF_ID[31:0]), 
							.signImm_D(signImm_D), 
							.readData1_D(readData1_D),
							.readData2_D(readData2_D),
							.wa3_D(qMEM_WB[4:0]),
							.ra1_D(ra1_D),
							.ra2_D(ra2_D));				

	// Hazard detection

	logic [9:0] IDEX_mux_out;

	hazard_detection_unit HAZARD (.idex_memread(qID_EX[264]), .idex_rd(qID_EX[4:0]), 
									.ifid_rn1(ra1_D), .ifid_rm2(ra2_D), .stall(stall_signal));

	mux2 #(10)	controlMUX (.d0({AluSrc, AluControl, Branch, memRead, memWrite, regWrite, memtoReg}), 
						.d1('0), 
						.s(stall_signal), 
						.y(IDEX_mux_out));


	flopr  #(281) ID_EX    (.clk(clk),
							.reset(reset), 
							.d({ra1_D, ra2_D, 
							IDEX_mux_out,
							qIF_ID[95:32], signImm_D, readData1_D, readData2_D, qIF_ID[4:0]}),
							.q(qID_EX));
	
	// Forwarding
	logic [N-1:0] f_Rd1, f_Rd2;
	logic [1:0] fwd1, fwd2;

	forwarding_unit FWD (.exmem_regwrite(qEX_MEM[199]), .memwb_regwrite(qMEM_WB[134]),
						.idex_rn1(qID_EX[280:276]), .idex_rm2(qID_EX[275:271]),
						.exmem_rd(qEX_MEM[4:0]), .memwb_rd(qMEM_WB[4:0]),
						.forwardA(fwd1), .forwardB(fwd2));

	mux4 #(N) MuxRd1 	(.d00(qID_EX[132:69]), 	// readData1_D
						.d01(writeData3), 		// WB return
						.d10(qEX_MEM[132:69]), 	// ALU Result
						.d11(qID_EX[132:69]), 	// Salida nula, no se usa
						.s(fwd1), 
						.y(f_Rd1));

	mux4 #(N) MuxRd2	(.d00(qID_EX[68:5]), 	// readData2_D
						.d01(writeData3),  		// WB return 	//! En el diagrama de patterson estan al reves 01 y 10
						.d10(qEX_MEM[132:69]), 	// ALU Result
						.d11(qID_EX[68:5]), 	// Salida nula, no se usa
						.s(fwd2), 
						.y(f_Rd2));
						


	execute  #(64) EXECUTE	(.AluSrc(qID_EX[270]),
									.AluControl(qID_EX[269:266]),
									.PC_E(qID_EX[260:197]), 
									.signImm_E(qID_EX[196:133]), 
									.readData1_E(f_Rd1), //* Resultado del fwd
									.readData2_E(f_Rd2), //* Resultado del fwd
									.PCBranch_E(PCBranch_E), 
									.aluResult_E(aluResult_E), 
									.writeData_E(writeData_E), 
									.zero_E(zero_E));											

	flopr #(203) EX_MEM	(.clk(clk),
						.reset(reset), 
						.d({qID_EX[265:261], PCBranch_E, zero_E, aluResult_E, writeData_E, qID_EX[4:0]}),
						.q(qEX_MEM));
	
										
	memory MEMORY	(.Branch_M(qEX_MEM[202]), 
						.zero_M(qEX_MEM[133]), 
						.PCSrc_M(PCSrc));
			
	// Salida de señales a Data Memory
	assign DM_writeData = qEX_MEM[68:5];
	assign DM_addr = qEX_MEM[132:69];
	
	// Salida de señales de control:
	assign DM_writeEnable = qEX_MEM[200];
	assign DM_readEnable = qEX_MEM[201];
	
	flopr #(135) MEM_WB	(.clk(clk),
								.reset(reset), 
								.d({qEX_MEM[199:198], qEX_MEM[132:69],	DM_readData, qEX_MEM[4:0]}),
								.q(qMEM_WB));
		
	
	writeback #(64) WRITEBACK	(.aluResult_W(qMEM_WB[132:69]), 
										.DM_readData_W(qMEM_WB[68:5]), 
										.memtoReg(qMEM_WB[133]), 
										.writeData3_W(writeData3));		
		
endmodule
