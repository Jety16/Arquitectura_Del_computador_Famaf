module hdu_tb;
  // Parameters and signals
  reg [4:0] dest_previous_MEM;
  reg [4:0] IF_ID_Rn;
  reg [31:0] instruction;
  wire hazard_detected, exe_hazard, mem_hazard, branch_hazard;

  // Instantiate the hdu module
  hdu uut (
    .dest_previous_MEM(dest_previous_MEM),
    .IF_ID_Rn(IF_ID_Rn),
    .instruction(instruction),
    .hazard_detected(hazard_detected),
    .exe_hazard(exe_hazard),
    .mem_hazard(mem_hazard),
    .branch_hazard(branch_hazard)
  );

  // Testbench logic
  initial begin
    // Test 1: R Type Instruction
    dest_previous_MEM = 5'b00001; // Example values for dest_previous_MEM and IF_ID_Rn
    IF_ID_Rn = 5'b00100;
    instruction = 32'h8b040064; // Replace with the R-type instruction you want to test
    #10;

    // Check the hazard detection outputs for each test
    if (hazard_detected)
      $display("Hazard detected");
    else
      $display("No hazard detected");

    if (exe_hazard)
      $display("Execution hazard detected");
    else
      $display("No execution hazard detected");
    // Test 2: D Type Instruction
    dest_previous_MEM = 5'b00000;
    IF_ID_Rn = 5'b00000;
    instruction = 32'hd2800000; // Replace with the D-type instruction you want to test
    #10;



    if (mem_hazard)
      $display("Memory hazard detected");
    else
      $display("No memory hazard detected");

    // Test 3: IM Type Instruction
    dest_previous_MEM = 5'b00000;
    IF_ID_Rn = 5'b00001;
    instruction = 32'hF84A6000; // Replace with the IM-type instruction you want to test
    #10;

    if (mem_hazard)
      $display("Memory hazard detected");
    else
      $display("No memory hazard detected");

    // Test 4: CB Type Instruction
    dest_previous_MEM = 5'b00000;
    IF_ID_Rn = 5'b00000;
    instruction = 32'hb40000c0; // Replace with the CB-type instruction you want to test
    #10;


    if (branch_hazard)
      $display("Branch hazard detected");
    else
      $display("No branch hazard detected");

    // End simulation
    $finish;
  end

endmodule