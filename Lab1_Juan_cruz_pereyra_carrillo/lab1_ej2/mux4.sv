// 4:1 MULTIPLEXER

module mux4
	#(parameter N = 64)
	(input logic [N-1:0] d00, d01, d10, d11,
	input logic [1:0] s,
	output logic [N-1:0] y);

    always_comb
        case (s)
            2'b00: y = d00;
            2'b01: y = d01;
            2'b10: y = d10;
            2'b11: y = d11;
            default: y = 2'b00;
        endcase

endmodule