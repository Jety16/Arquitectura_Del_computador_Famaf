// PIPELINED PROCESSOR

module processor_arm #(parameter N = 64)
							(input logic CLOCK_50, reset,
							output logic [N-1:0] DM_writeData, DM_addr,
							output logic DM_writeEnable,
							input	logic dump,
							output logic hazard_detected);
							
	logic [31:0] q;
	logic [3:0] AluControl;
	logic reg2loc, regWrite, AluSrc, Branch, memtoReg, memRead, memWrite, MovIm;
	logic [N-1:0] DM_readData, IM_address;  //DM_addr, DM_writeData
	logic DM_readEnable; //DM_writeEnable
	logic [10:0] instr;
		
	controller 		c 			(.instr(instr), 
									.AluControl(AluControl), 
									.reg2loc(reg2loc), 
									.regWrite(regWrite), 
									.AluSrc(AluSrc), 
									.Branch(Branch),
									.memtoReg(memtoReg), 
									.memRead(memRead), 
									.memWrite(memWrite),
									.MovIm(MovIm));
														
					
	datapath #(64) dp 		(.reset(reset), 
									.clk(CLOCK_50), 
									.reg2loc(reg2loc), 
									.AluSrc(AluSrc), 
									.AluControl(AluControl), 
									.Branch(Branch), 
									.memRead(memRead),
									.memWrite(memWrite), 
									.regWrite(regWrite), 
									.memtoReg(memtoReg), 
									.MovIm(MovIm),
									.IM_readData(q), 
									.DM_readData(DM_readData), 
									.IM_addr(IM_address), 
									.DM_addr(DM_addr), 
									.DM_writeData(DM_writeData), 
									.DM_writeEnable(DM_writeEnable), 
									.DM_readEnable(DM_readEnable),
									.hazard_detected(hazard_detected));		
					
					
	imem 				instrMem (.addr(IM_address[8:2]),
									.q(q));
									
	
	dmem 				dataMem 	(.clk(CLOCK_50), 
									.memWrite(DM_writeEnable), 
									.memRead(DM_readEnable), 
									.address(DM_addr[8:3]), 
									.writeData(DM_writeData), 
									.readData(DM_readData), 
									.dump(dump)); 							
		 
							
	flopre #(11)		IF_ID_TOP(.enable(~hazard_detected), .clk(CLOCK_50),
									.reset(reset), 
									.d(q[31:21]),  
									.q(instr));
									
									// agregar en este punto el in
 	
endmodule