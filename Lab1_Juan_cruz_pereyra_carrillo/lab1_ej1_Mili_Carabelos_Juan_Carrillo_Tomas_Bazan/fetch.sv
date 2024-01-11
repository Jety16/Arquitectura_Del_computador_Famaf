module fetch #(parameter N=64)(
				input logic PCSrc_F, clk, reset, enable,
				input logic [N-1:0] PCBranch_F,
				output logic [N-1:0] imem_addr_F
				);
	
	logic [N-1:0] adder_result;
	logic [N-1:0] mux_result;
	//tengo que conectar al mux la salida del adder y PCBranch_F con PCSrc_F 
	//como enable 
	
	mux2 dup (adder_result,PCBranch_F,PCSrc_F,mux_result);
	
	//creooo que el PC es flopr
	//lo que sale del mux va a PC y mas el clk y el reset
	flopre dup1 (.enable(enable), .clk(clk), .reset(reset), .d(mux_result), .q(imem_addr_F));
	
	// flopre 	#(96)		IF_ID   (.enable(hazard_detected), .clk(clk),
	// 									.reset(reset), 
	// 									.d({IM_addr, IM_readData}),
	// 									.q(qIF_ID));
	
	adder dup2 (imem_addr_F,(64'd4), adder_result);
endmodule 