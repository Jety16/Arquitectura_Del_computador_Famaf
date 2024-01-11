module fetch
	#(parameter N = 64)
	(input logic PCSrc_F, clk, reset, stall,
	input logic[N-1:0] PCBranch_F,
	output logic[N-1:0] imem_addr_F);
	
	logic [N-1:0] pc_in, add_out;
	logic [N-1:0] add_in = 3'd4;
	
	adder #(N)	Add(imem_addr_F, add_in, add_out);
	mux2 #(N)	Mux(add_out, PCBranch_F,PCSrc_F,pc_in);
	flopr_e #(N)	PC(clk, reset, ~stall, pc_in, imem_addr_F);
	
endmodule