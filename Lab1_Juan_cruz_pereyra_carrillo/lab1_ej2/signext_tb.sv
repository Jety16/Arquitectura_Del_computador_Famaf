module signext_tb ();
	
	logic [31:0] a;
	logic [63:0] y;
													  
	// instantiate device under test
	signext dut(a, y);
  
 /* apply inputs and check results
	one at a time */
 initial begin
		a = 32'b11111000000_000001000_00_00111_01100;#10ns ; //STUR x12 [x7 #8]
		if (y !== 64'b000001000) $display("STUR x12 [x7 #8] failed.");
		
		a = 32'b11111000000_111111100_00_00111_01100; #10ns;
		if (y !== 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100) $display("STUR x12 [x7 #-4] failed."); //62 bits en 1 + 2 en 0 {62{1'b1},1{2'0}}
		
		a = 32'b11111000010_000001000_00_00111_01100 ; #10ns;
		if (y !== 64'b000001000) $display("LDUR x12 [x7 #8] failed.");
		
		a = 32'b11111000010_111111100_00_00111_01100; #10ns
		if (y != 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100) $display("LDUR x12 [x7 #-4] failed."); //62 bits en 1 + 2 en 0
		
		a = 32'b10110100_0000000000000000100_00101; #10ns
		if (y !== 64'b0100) $display("CBZ x5 4 failed. y=%b", y);
		
		a = 32'b10110100_1111111111111111100_00101; #10ns
		if (y !== 64'b1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1100) $display("CBZ x5 -4 failed, y=%b", y); //60 bits en 1 + 4 bits en 0
		
	end

endmodule 