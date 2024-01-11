module hazard_detection_unit
	(input logic idex_memread,
	input logic [4:0] idex_rd, ifid_rn1, ifid_rm2,
	output logic stall);

	assign stall = idex_memread && ((idex_rd === ifid_rn1) || (idex_rd === ifid_rm2));

endmodule
