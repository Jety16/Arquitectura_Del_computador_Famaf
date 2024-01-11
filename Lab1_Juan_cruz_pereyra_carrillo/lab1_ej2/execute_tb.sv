module execute_tb(); 
	
	logic AluSrc;
	logic [3:0]AluControl;
	logic [63:0] signImm_E,PC_E,readData1_E,readData2_E;
	logic [63:0] PCBranch_E,aluResult_E,writeData_E;
	logic zero_E;
	
		
	execute #(64) dut(
	//input 1b
	.AluSrc(AluSrc),
	////input 4b
	.AluControl(AluControl),
	//Input 64 bits
	.PC_E(PC_E), .signImm_E(signImm_E), .readData1_E(readData1_E),.readData2_E(readData2_E),
	//output 64 bits
	.PCBranch_E(PCBranch_E), .aluResult_E(aluResult_E), .writeData_E(writeData_E),
	//output 1 bit
	.zero_E(zero_E));

	int errors, yey;
	initial begin
		errors= 0;
		yey = 0;
		signImm_E = 64'hFF0_0000_0000_0000F;
		//chequear sr2_result
		#5ns;
		PC_E = 64'b1;
		#5ns;
		if (PCBranch_E !== 64'hFC00_0000_0000_003D) begin
				errors = errors + 1 ;
				$display("error: in Adder, sl2 and PC %d", errors);
		end
		#5ns;
		readData1_E = 64'hFF00_0000_0000_000F; AluSrc= 1 ;

		#5ns;
		//chequear mux_result
		AluControl = 4'b0110;
		#5ns;
		if(aluResult_E !== 64'b0)begin
				errors = errors + 1 ;
				$display("error: in ALU con mux en 1 %d", errors);
		end
		if(zero_E !== 1'b1)begin
				errors = errors + 1 ;
				$display("error: in zero flag con mux en 1 %d", errors);
		end
		#5ns;
		//
		readData2_E = 64'h0000000F; AluSrc= 0;
		#10ns
		//chequear salida mux---
		if(aluResult_E !== 64'hFF00_0000_0000_0000)begin
				errors = errors + 1 ;
				$display("error: in ALU con mux en 0 %d", errors);
		end
		#5ns
		$display("Total errors: %d total sucess = %d", errors, -(errors-4));
		$stop;

	end




endmodule


//probar un CBZ un LDUR un STUR y un ADD