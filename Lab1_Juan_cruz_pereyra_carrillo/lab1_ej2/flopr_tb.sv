module flopr_tb #(parameter n = 	64)();

	logic        clk, reset;
	logic        [n-1:0]d;
	logic        [n-1:0]q;
	logic [n-1 :0] vectornum, errors;    // bookkeeping variables 
	logic [n-1:0] testvectors [0:9] = '{'b0001,	// array of testvectors
													'b0010,
													'b0011,
													'b0100,
													'b0101,
													'b0110,
													'b0111,
													'b1000,
													'b1001,
													'b1010};
													  
	// instantiate device under test
	// si no lo aclaro esta en 64 bits
	flopr dut(clk, reset, d, q);
  
  
	// generate clock
	always     // no sensitivity list, so it always executes
		begin
			clk = 1; #5ns ; clk = 0; #5ns;
		end
		
 
	// at start of test pulse reset
	initial 	
		begin     
			vectornum = 0; errors = 0;
			reset = 1; #49ns ; reset = 0;		//??????????
		end
	 
	 
	// apply test vectors on falling edge of clk
	always @(negedge clk)
		begin
		//if(!reset)
			#1; d = testvectors[vectornum];
		end
		
 
	// check results on rising edge of clk
   always @(posedge clk) begin
		if( reset) begin
		#2ns
			if (q !== 64'b0) begin  
				$display("Error: inputs = %b", q);
				$display("  outputs = %b (%b expected)",q ,64'b0);
				errors = errors + 1;
			end
		end
			
		if (~reset) begin // skip during reset
			#2ns;
			if (d !== q) begin
				$display("Error: inputs = %b", d);
				$display("  outputs = %b (%b expected)",q ,d);
				errors = errors + 1;
			end
		end
	
		
		// increment array index and read next testvector
      vectornum = vectornum + 1;
			if (testvectors[vectornum] === 64'bx) begin 
				$display("%d tests completed with %d errors", 
                vectornum, errors);
			//  $finish;
				$stop;
			end
		end
		
endmodule