module fetch_tb();

	logic PCSrc_F, clk, reset;
	logic [63:0] PCBranch_F;
	logic [63:0] imem_addr_F;

	fetch #(64) dut(
		.PCSrc_F(PCSrc_F), .clk(clk), .reset(reset),
		.PCBranch_F(PCBranch_F),
		.imem_addr_F(imem_addr_F)
	);

	// Reloj
	always begin
		clk = 1; #5ns; clk = 0; #5ns;
	end

	initial begin
		reset = 1;
		#50ns;
		reset = 0;
	end

	logic [63:0] last_PC;
	int errors;
	initial begin
		errors = 0;
		last_PC = 0;
		PCSrc_F = 1'b0;
		PCBranch_F = 64'd69857;

		#50ns;
		for (int i=0; i<100; ++i) begin
			// posedge
			#5ns;

			// negedge
			if (last_PC + 4 !== imem_addr_F) begin
				$display("ERROR: last_PC + 4 !== imem_addr_F. last_PC = %d, imem_addr_F = %d", last_PC, imem_addr_F);
				errors++;
			end
			last_PC = imem_addr_F;

			#5ns;
		end

		// posedge
		#5ns;
		// negedge
		PCSrc_F = 1'b1;
		#10ns;
		if (64'd69857 !== imem_addr_F) begin
			$display("ERROR: 64'd69857 !== imem_addr_F");
			errors++;
		end

		$display("Total errors: %d", errors);
		$stop;

	end


endmodule