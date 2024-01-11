module imem_tb #(parameter N = 32)();
	
	logic [N-1:0] addr;
	logic [0:63] q;
	logic[N-1:0] yexpected [0:50];
	logic errores;
	
	// instantiate device under test
	imem dut(addr,q);

	
	initial begin
		yexpected[0:49] = '{64'hf8000001,
						64'hf8008002,
						64'hf8000203,
						64'h8b050083,
						64'hf8018003,
						64'hcb050083,
						64'hf8020003,
						64'hcb0a03e4,
						64'hf8028004,
						64'h8b040064,
						64'hf8030004,
						64'hcb030025,
						64'hf8038005,
						64'h8a1f0145,
						64'hf8040005,
						64'h8a030145,
						64'hf8048005,
						64'h8a140294,
						64'hf8050014,
						64'haa1f0166,
						64'hf8058006,
						64'haa030166,
						64'hf8060006,
						64'hf840000c,
						64'h8b1f0187,
						64'hf8068007,
						64'hf807000c,
						64'h8b0e01bf,
						64'hf807801f,
						64'hb4000040,
						64'hf8080015,
						64'hf8088015,
						64'h8b0103e2,
						64'hcb010042,
						64'h8b0103f8,
						64'hf8090018,
						64'h8b080000,
						64'hb4ffff82,
						64'hf809001e,
						64'h8b1e03de,
						64'hcb1503f5,
						64'h8b1403de,
						64'hf85f83d9,
						64'h8b1e03de,
						64'h8b1003de,
						64'hf81f83d9,
						64'hb400001f,
						64'h00000000,
						64'h00000000,
						64'h00000000};
						errores =0;
						#10ns
						
		for (int i = 0; i <= 49; i = i + 1) begin
            addr = i; #10ns;
				
				if(q !== yexpected[i])begin
				 $display("Error: addr = %b", i);
				 $display("Error: q = %b", q);
				 $display("Error: yexpected = %b", yexpected[i]);
				end
      end
		
		if(errores == 0)begin
				 $display("EAAAAAAAAAAAA %b", errores);
		end
	end

endmodule