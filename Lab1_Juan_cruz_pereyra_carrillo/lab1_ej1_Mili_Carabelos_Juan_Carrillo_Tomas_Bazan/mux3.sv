// 3:1 MULTIPLEXER

module mux3 #(parameter N = 64)
				(input logic [N-1:0] d0, d1, d2,
				input logic [1:0]s,
				output logic [N-1:0] y);
	always_comb
	begin
		casez(s)
			2'b00:begin
						y = d0;
					end
			2'b01:begin
						y = d1;
					end
			2'b10:begin
						y = d2;
					end
			default:	begin
						y = 64'hD1AB102;
						end
		endcase
	end
endmodule