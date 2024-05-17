// -------------------------------------------------------------
// 
// File Name: hdlsrc\edgeDetector\Smoothing_Filter.v
// Created: 2024-05-06 23:19:59
// 
// Generated by MATLAB 23.2, HDL Coder 23.2, and Simulink 23.2
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: Smoothing_Filter
// Source Path: edgeDetector/EdgeDetection/Smoothing Filter
// Hierarchy Level: 1
// Model version: 1.2
// 
// -------------------------------------------------------------
/*
This function takes a moving average of the data coming in
Need to test this to see if it works

bit shift for division
*/
module Smoothing_Filter
          (clk,
           reset,
           enb,
           In_Arrary,
           SmoothedArray);


  input wire clk;
  input wire reset;
  input wire enb;
  input wire[7:0] In_Arrary;  // current value
  output reg [7:0] SmoothedArray;  // outputvalue

  reg [7:0] In_Arrary1; // 1 delay
  reg [7:0] In_Arrary2; // 2 delay
  reg [7:0] In_Arrary3; // 3 delay
  reg [7:0] In_Arrary4; // current val


  always @(posedge clk or posedge reset)
    begin : reduced_process
      if (reset == 1'b1) begin //reset all the values to 1
        In_Arrary1 <= 8'b00000000;
        In_Arrary2 <= 8'b00000000;
        In_Arrary3 <= 8'b00000000;
        In_Arrary4 <= 8'b00000000;
      end
      else begin
        if (enb) begin
          In_Arrary4 <= In_Arrary3; // current value -3
          In_Arrary3 <= In_Arrary2; //current value -2
          In_Arrary2 <= In_Arrary1; //current value -1
          In_Arrary1 <= In_Arrary; // current value
          
        end
      end
        // average over 4 values
        SmoothedArray <= (In_Arrary4 + In_Arrary3 +In_Arrary2 + In_Arrary1) >> 2 ; 
    end
    
   
    //assign SmoothedArray <= (In_Arrary4 >> 2) + (In_Arrary3)

endmodule  // Smoothing_Filter