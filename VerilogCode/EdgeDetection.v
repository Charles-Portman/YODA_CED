/*
This module connects all the other modules together

*/

`include "Smoothing_Filter.v"
`include "Derivative.v"
`include "CompareToThreshold.v"

module EdgeDetection
          (clk,
           reset,
           enb,
           In_Arrary,
           Edges); 


  input   clk; //input clock from test bench
  input   reset; // input reset from testbench
  input   enb;
  input   [7:0] In_Arrary;  // in array from file in test bench
  output  [7:0] Edges;  // output from the compare to threshold


  wire [7:0] smoothed;  // uint8
  wire [7:0] diff;  // uint8
  wire  CompareToThreshold_out1; // wires to connect everything

  // first goes into the smoothing filter
  Smoothing_Filter u_Smoothing_Filter (.clk(clk),
                                       .reset(reset),
                                       .enb(enb),
                                       .In_Arrary(In_Arrary),  // uint8
                                       .SmoothedArray(smoothed)  // uint8
                                       );
  //Then goes to the derivative                                     
  Derivative u_Derivative (.clk(clk),
                           .reset(reset),
                           .enb(enb),
                           .In(smoothed),  // uint8
                           .d_in(diff)  // uint8
                           );
  //Then compares to threshold
  CompareToThreshold u_CompareToThreshold (.In1(diff),  // uint8
                                           .u(CompareToThreshold_out1)  // double
                                           );
  //assigns the of the final module to compare to threshold
  assign Edges = CompareToThreshold_out1;

endmodule  // EdgeDetection

