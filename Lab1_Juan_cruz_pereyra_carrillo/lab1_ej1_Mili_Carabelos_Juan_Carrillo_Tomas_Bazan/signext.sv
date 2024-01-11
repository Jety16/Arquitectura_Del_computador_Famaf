module signext(input logic [31:0]a, output logic [63:0]y);
	always_comb
	
	casez(a[31:21])
		 11'b111_1100_00?0:	begin	
										y[8:0] = a[20:12];
										y[63:9] = {55{y[8]}}; //
									end
									
		 11'b101_1010_0???:	begin
										y[18:0] = a[23:5];
								//here i want to copy the 18th bit of y 45 times on y[63:19]
										y[63:19] = {45{y[18]}};
									end
		default y=64'b0;
	endcase 
endmodule 