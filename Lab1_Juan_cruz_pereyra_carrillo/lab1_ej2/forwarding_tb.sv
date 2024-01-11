module forwarding_tb ();
    
    logic exmem_regwrite, memwb_regwrite;
    logic  [4:0] idex_rn1, idex_rm2, exmem_rd, memwb_rd;
    logic [1:0] forwardA, forwardB, expectedA, expectedB;

    forwarding_unit dut (
        .exmem_regwrite(exmem_regwrite),
        .memwb_regwrite(memwb_regwrite),
        .idex_rn1(idex_rn1),
        .idex_rm2(idex_rm2),
        .exmem_rd(exmem_rd),
        .memwb_rd(memwb_rd),
        .forwardA(forwardA),
        .forwardB(forwardB)
    );

    initial begin
        expectedA = '0;
        expectedB = '0;

        exmem_regwrite = '0;
        memwb_regwrite = '0;
        idex_rn1 = '0;
        idex_rm2 = '0;
        exmem_rd = '0;
        memwb_rd = '0;
    
		  #1us;
        // ADD X5, --, --
        // ADD --, X5, X6
        expectedA = 2'b10;
        expectedB = 2'b00;

        exmem_regwrite = 1'b1;
        memwb_regwrite = 1'b0;
        idex_rn1 = 5'd5;
        idex_rm2 = 5'd6;
        exmem_rd = 5'd5;
        memwb_rd = 5'd0;
        #5;
        if (forwardA !== expectedA && forwardB !== expectedB) begin
            $display("Test 1 failed");
        end
		  
		  #1us;
        // ADD X6, --, --
        // ADD --, X5, X6
        expectedA = 2'b00;
        expectedB = 2'b10;

        exmem_regwrite = 1'b1;
        memwb_regwrite = 1'b0;
        idex_rn1 = 5'd5;
        idex_rm2 = 5'd6;
        exmem_rd = 5'd6;
        memwb_rd = 5'd0;
        #5;
        if (forwardA !== expectedA && forwardB !== expectedB) begin
            $display("Test 2 failed");
        end

		  #1us;
        // ADD X6, --, --
        // ADD --, X6, X6
        expectedA = 2'b10;
        expectedB = 2'b10;

        exmem_regwrite = 1'b1;
        memwb_regwrite = 1'b0;
        idex_rn1 = 5'd6;
        idex_rm2 = 5'd6;
        exmem_rd = 5'd6;
        memwb_rd = 5'd0;
        #5;
        if (forwardA !== expectedA && forwardB !== expectedB) begin
            $display("Test 3 failed");
        end

		  #1us;
        // LDUR X1, --
        // ADD --, X1, X5
        expectedA = 2'b00;
        expectedB = 2'b00;

        exmem_regwrite = 1'b0;
        memwb_regwrite = 1'b0;
        idex_rn1 = 5'd1;
        idex_rm2 = 5'd6;
        exmem_rd = 5'd0;
        memwb_rd = 5'd1;
        #5;
        if (forwardA !== expectedA && forwardB !== expectedB) begin
            $display("Test 4 failed");
        end

		  #1us;
        // X1, --
        // ADD --, X1, X5        expectedA = 2'b00;
        expectedB = 2'b00;

        exmem_regwrite = 1'b0;
        memwb_regwrite = 1'b1;
        idex_rn1 = 5'd1;
        idex_rm2 = 5'd6;
        exmem_rd = 5'd0;
        memwb_rd = 5'd1;
        #5;
        if (forwardA !== expectedA && forwardB !== expectedB) begin
            $display("Test 5 failed");
        end
   
    end

endmodule