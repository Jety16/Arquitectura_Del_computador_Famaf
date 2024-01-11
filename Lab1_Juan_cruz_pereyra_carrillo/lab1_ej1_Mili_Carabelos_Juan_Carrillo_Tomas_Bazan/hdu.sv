module hdu (
    input [4:0] ID_EX_Rd, IF_ID_Rn, IF_ID_Rm,//done
    input ID_EX_mem_read,//done
    output logic hazard_detected    // Indicates if any hazard is detected
);

    always_comb begin
        hazard_detected = 0;
        if (ID_EX_mem_read) begin
            hazard_detected = (IF_ID_Rn == ID_EX_Rd) || (IF_ID_Rm == ID_EX_Rd);
        end
    end
endmodule
