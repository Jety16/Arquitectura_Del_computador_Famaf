module regfile(input logic clk, we3, 
					input logic [4:0] ra1,ra2,wa3, 
					input logic [63:0] wd3,
					output logic [63:0] rd1,rd2);
	
	logic [63:0] REG [0:31]= '{64'd0,
							  64'd1,
							  64'd2,
							  64'd3,
							  64'd4,
							  64'd5,
							  64'd6,
							  64'd7,
							  64'd8,
							  64'd9,
							  64'd10,
							  64'd11,
							  64'd12,
							  64'd13,
							  64'd14,
							  64'd15,
							  64'd16,
							  64'd17,
							  64'd18,
							  64'd19,
							  64'd20,
							  64'd21,
							  64'd22,
							  64'd23,
							  64'd24,
							  64'd25,
							  64'd26,
							  64'd27,
							  64'd28,
							  64'd29,
							  64'd30,
							  64'b0};

	//ra1 y ra2 son addres de los registros determinan quienes salen por rd1 y rd2
	// wa3 es addres de wd3 con flag we3 en 1 en un flanco positivo de clk 
	
		//Inicializar los registros X0 a X30 con los valores 0 a 30 respectivamente
	
	assign rd1= REG[ra1];
	assign rd2= REG[ra2];

	
	always_ff @(posedge clk) begin
		if(we3 == 1) begin 
			if(wa3 != 5'b11111) begin
				REG[wa3] <= wd3;
			end
		end
	end
	
endmodule 