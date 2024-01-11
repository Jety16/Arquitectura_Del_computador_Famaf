module mov_im (//input logic En ,  // ver si el enable es necesario creo que no gg
					input logic [1: 0] LSL,
					input logic [15:0] Immediate,
					output logic [63:0] RD_mov);
	always_comb
		casez (LSL)
	
		2'b00: begin
					RD_mov[15:0] = Immediate;
					RD_mov[63:16] = 48'b0;
				 end
		2'b01: begin
					RD_mov[15:0] = 16'b0 ;
					RD_mov[31:16] = Immediate;
					RD_mov[63:32] = 32'b0;
				 end
		2'b10: begin
					RD_mov[31:0] = 32'b0 ;
					RD_mov[47:32] = Immediate;
					RD_mov[63:48] = 16'b0;
				 end
		2'b11: begin 
					RD_mov[47:0] = 48'b0;
					RD_mov[63:48] = Immediate;
				 end
		default: RD_mov = 64'b0;
		endcase
endmodule