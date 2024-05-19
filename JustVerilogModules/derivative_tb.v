/*
Author: Thomas Greenwood

This test the derivative module
*/


`timescale 1ns/1ns
`include "Derivative.v"

module derivative_tb();
// Inputs
  reg[7:0] values;
  reg reset;
  reg enb;
  reg clk;
  // Outputs
  wire[7:0] result;

  // Instantiate the DUT (Design Under Test)
  Derivative DUT(
           .clk(clk),
           .reset(reset),
           .enb(enb),
           .In(values),
           .d_in(result)
  );

  // Generate clock (optional for this example)
  initial begin
    clk <= 0;
    $dumpfile("derivativeTest.vcd");
    $dumpvars(0, derivative_tb);
    reset <= 1;
    #1;
    reset <=0;
    enb <= 1;
    values = 0;
    #2
  ; // Wait again
      for (values = 0; values<5; values = values +1) // derivate of 1
        begin
          #2;
        end 
    #10

    for (values = 0; values<20; values = values +4) // derivate of 2
        begin
          #2;
        end 
    values <= 0;
    #10
    // Add more test cases as needed
    $finish;
  end

  always begin
  #1 clk = ~clk; // Toggle clock every 5 ticks
  end

endmodule