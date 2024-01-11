module forwarding_unit 
    (input logic exmem_regwrite, memwb_regwrite,
    input logic  [4:0] idex_rn1, idex_rm2, exmem_rd, memwb_rd,
    output logic [1:0] forwardA, forwardB);

    logic [1:0] forA, forB;

    always_comb 
        begin
        /* EX hazard rn1 && MEM hazard rn1 */
            if (exmem_regwrite && exmem_rd !== 31 && exmem_rd === idex_rn1)
                forA = 2'b10;
            else if (memwb_regwrite && memwb_rd !== 31 && memwb_rd === idex_rn1) //! Distinto a como estaba en el libro
                forA = 2'b01;
            else
                forA = 2'b00;
        /* EX hazard rm2 && MEM hazard rm2 */
            if (exmem_regwrite && exmem_rd !== 31 && exmem_rd === idex_rm2)
                forB = 2'b10;
            else if (memwb_regwrite && memwb_rd !== 31 && memwb_rd === idex_rm2)
                forB = 2'b01;
            else
                forB = 2'b00;
                
            forwardA = forA;
            forwardB = forB;
        end

endmodule