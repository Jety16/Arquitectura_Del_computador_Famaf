module alu (input logic [63:0]a, b, 
				input logic [3:0] ALUcontrol, 
				output logic [63:0] result, 
				output logic zero);

	 
	always_comb 
		begin	

			casez (ALUcontrol)
				4'b0000: result = a & b ;

				4'b0001: result = a | b;

				4'b0010: result = a+b;

				4'b0110: result = a-b;
							
				4'b0111: result = b;
				
				default : result = {64{1'b1}};
			endcase
			
			 // Check if the result is 64 bits of 0
			 if (result == '0) begin
				  zero = 1'b1;
			 end 
			 else begin
				  zero = 1'b0;
			 end
		end
		
endmodule 
		