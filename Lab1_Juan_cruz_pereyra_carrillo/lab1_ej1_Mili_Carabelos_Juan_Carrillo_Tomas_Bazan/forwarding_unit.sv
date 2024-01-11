module forwarding_unit #(parameter N=64) ( 
						input logic EX_MEM_regWrite, MEM_WB_regWrite, //fix
						input logic [4:0] MEM_WB_Rd, EX_MEM_Rd, ID_EX_Rn, ID_EX_Rm, // done
						output logic [1:0] forwardA, forwardB);
	

    always_comb
    begin
        // Initialize outputs to a default value
        forwardA = 2'b00;
        forwardB = 2'b00;

        // EX hazard:
        if (EX_MEM_regWrite == 1'b1 && EX_MEM_Rd != 5'd31 && EX_MEM_Rd == ID_EX_Rn) begin
            forwardA = 2'b10;
        end else 
        if (EX_MEM_regWrite == 1'b1 && EX_MEM_Rd != 5'd31 && EX_MEM_Rd == ID_EX_Rm) begin
            forwardB = 2'b10;
        end else
        // MEM hazard:
        if (MEM_WB_regWrite == 1'b1 && MEM_WB_Rd != 5'd31 && (~(EX_MEM_regWrite && (EX_MEM_Rd!=5'd31)) && (EX_MEM_Rd != ID_EX_Rn)) && MEM_WB_Rd == ID_EX_Rn) begin
                forwardA = 2'b01;
        end else
        if (MEM_WB_regWrite == 1'b1 && MEM_WB_Rd != 5'd31 && (~(EX_MEM_regWrite && (EX_MEM_Rd!=5'd31))&& (EX_MEM_Rd != ID_EX_Rm)) && MEM_WB_Rd == ID_EX_Rm) begin
                forwardB = 2'b01;
        end
    end
endmodule
