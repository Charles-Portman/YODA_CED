`timescale 1ns/1ns
`include "CompareToThreshold.v"

module CompareToThreshold_tb();
// Inputs
  reg[7:0] value;
  
  // Outputs
  wire result;

  // Instantiate the DUT (Design Under Test)
  CompareToThreshold DUT(
    .In1(value),
    .u(result)
  );

  // Generate clock (optional for this example)
  initial begin
    $dumpfile("compare_tb.vcd");
    $dumpvars(0, CompareToThreshold_tb);
    #10; // Wait for a few time units
    value = 0; // Set an example value
    #10; // Wait again
    for (value = 4; value<13; value = value +1)
        begin
          #10;
        end
    #10;
    value <= 0;
    #10;
    // Add more test cases as needed
    $finish;
  end

endmodule