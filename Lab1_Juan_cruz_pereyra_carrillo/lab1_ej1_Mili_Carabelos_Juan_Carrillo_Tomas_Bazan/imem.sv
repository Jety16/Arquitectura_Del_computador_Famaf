module imem #(parameter N = 32)(input logic [6:0] addr, output logic [N-1:0] q);

	logic [N-1:0] ROM [0:255];

	initial begin
		  
		  for (int i = 0; i <= 255; i = i + 1) begin
            ROM[i] = 0;
        end
		  
		ROM [0:55] ='{32'hf8000001,
32'hf8008002,
32'hf8000203,
32'h8b050083,
32'hf8018003,
32'hcb050083,
32'hf8020003,
32'hcb0a03e4,
32'hf8028004,
32'h8b040064,
32'hf8030004,
32'hcb030025,
32'hf8038005,
32'h8a1f0145,
32'hf8040005,
32'h8a030145,
32'hf8048005,
32'h8a140294,
32'hf8050014,
32'haa1f0166,
32'hf8058006,
32'haa030166,
32'hf8060006,
32'hf840000c,
32'h8b1f0187,
32'hf8068007,
32'hf807000c,
32'h8b0e01bf,
32'hf807801f,
32'hb4000040,
32'hf8080015,
32'hf8088015,
32'h8b0103e2,
32'hcb010042,
32'h8b0103f8,
32'hf8090018,
32'h8b080000,
32'hb4ffff82,
32'hf809001e,
32'h8b1e03de,
32'hcb1503f5,
32'h8b1403de,
32'hf85f83d9,
32'h8b1e03de,
32'h8b1003de,
32'hf81f83d9,
32'hd297d7da,
32'hd2800000,
32'hd2b577d1,
32'hd2d81952,
32'hd2e24693,
32'hf80d001a,
32'hf80d8011,
32'hf80e0012,
32'hf80e8013,
32'hb400001f};

	end
	
	assign q = ROM[addr];

endmodule