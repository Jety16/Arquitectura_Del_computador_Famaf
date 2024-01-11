module regfile_tb ();

	logic clk, we3;
	logic [4:0] ra1,ra2,wa3;
	logic [63:0] wd3;
	logic [63:0] rd1,rd2,rdexpected;
	
	logic [31:0] vectornum, errors;    // bookkeeping variables 
	logic [63:0] testvectors [0:31] = '{ 64'b0,
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
												  
	logic [0:5] rd_vector [0:31] = '{5'd0, //0
												5'd1,	//1
												5'd2,	//2
												5'd3,	//3
												5'd4,	//4
												5'd5,	//5
												5'd6,	//6
												5'd7,	//7
												5'd8,	//8
												5'd9,	//9
												5'd10,//10
												5'd11,//11
												5'd12,//12
												5'd13,//13
												5'd14,//14
												5'd15,//15
												5'd16,//16
												5'd17,//17
												5'd18,//18
												5'd19,//19
												5'd20,//20
												5'd21,//21
												5'd22,//22
												5'd23,//23
												5'd24,//24
												5'd25,//25
												5'd26,//26
												5'd27,//27
												5'd28,//28
												5'd29,//29
												5'd30,//30
												5'd31};//31
																		  
	// instantiate device under test
	regfile dut(clk, we3,ra1,ra2,wa3, wd3,rd1,rd2);
  
	// generate clock
	always     // no sensitivity list, so it always executes
		begin
			clk = 1; #5ns; clk = 0; #5ns;
		end
		
 
	// at start of test pulse reset
	initial 	
		begin     
			vectornum = 0; errors = 0;
			wd3= 64'd15; wa3=5'd5;
			#316ns; we3=1; ra2 = 5'd5; #5ns; ra2 = 5'd5; //escribir 15 en el reg 5
			we3=0;wd3= 64'd4;ra2 = 5'd5;
			#10ns; wa3=5'd31;we3=1;wd3=64'd4;ra2 = 5'd31;
			#316ns;
			$display("%d tests completed with %d errors", vectornum, errors);
			//  $finish;
				$stop;
		end
	 
	 
	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
		if(testvectors[vectornum] !== 64'bx) begin
			#1;ra1 =rd_vector[vectornum];
				ra2 =rd_vector[vectornum];
			rdexpected = testvectors[vectornum];
		end
		end
		
 
	// check results on falling edge of clk
   always @(negedge clk)
		begin
			if (rd1 !== rdexpected) begin  
				$display("Error IN RD1: inputs = %b", rd1);
				$display("  outputs = %b (%b expected)",rd1,rdexpected);
				errors = errors + 1;
			end
			if (rd2 !== rdexpected && testvectors[vectornum] !== 64'bx) begin  
				$display("Error  IN RD2 : inputs = %b", rd2);
				$display("  outputs = %b (%b expected)",rd2,rdexpected);
				errors = errors + 1;
			end
			if(we3)begin
				#1ns
				if(ra2 === 5'd5 & rd2 !==  64'd15 & clk==1) begin
				//al registro 5 le pongo el valor 15
					$display("Error writing register 5 : reg_add %d output = %d",ra2 , rd2);
					$display("(%d expected)", 64'd15);
					errors = errors + 1;
				end
			
			
			end
		
		// increment array index and read next testvector
		if(testvectors[vectornum] !== 64'bx) begin
			vectornum = vectornum + 1;
		end
			/*if (testvectors[vectornum] === 64'bx) begin 
				$display("%d tests completed with %d errors", vectornum, errors);
			//  $finish;
				$stop;
			end
			*/ 
		end
		
endmodule