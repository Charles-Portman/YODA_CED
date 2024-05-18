/*
Author: Thomas Greenwood
Test bench for the compare to threshold module
*/

`timescale 1ns/1ns // abritary timescale 
`include "CompareToThreshold.v"

module CompareToThreshold_tb();
// Inputs
  reg[7:0] value; 
  reg clk;
  reg reset;
  reg enb;

  // Outputs
  wire result;

  // Instantiate the DUT (Design Under Test)
  CompareToThreshold DUT(
    .In1(value),
    .u(result),
    .clk(clk),
    .enb(enb)
  );

  initial begin
    $dumpfile("compare_tb.vcd");
    $dumpvars(0, CompareToThreshold_tb);
    #10; // Wait for a few time units
    value = 0; // Set an example value
    clk <=0;
    reset <=1;
    #2; 
    reset <=0;
    enb <=1;
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
  
  always begin
    #1 clk = 	~clk; // toggle the clock
  end

endmodule