module regfile
	(input logic clk, we3,
	input logic [4:0] ra1, ra2, wa3,
	input logic [63:0] wd3,
	output logic [63:0] rd1,rd2);
		
	logic [63:0] REGS [0:31];
	logic initialized = 0;
		
	always_ff @(posedge clk)
		begin
			if (!initialized)
				begin
					for(int i = 0; i < 31; ++i) REGS[i] = i;
					REGS[31] = 0;
					initialized = 1;
				end
			else if (we3 && wa3!= 5'd31) REGS[wa3] <= wd3;
		end

	always_comb 
		begin
			rd1 = (wa3 == ra1 && we3 && wa3!= 5'd31)? wd3: REGS[ra1];
			rd2 = (wa3 == ra2 && we3 && wa3!= 5'd31)? wd3: REGS[ra2];
		end		
	
endmodule