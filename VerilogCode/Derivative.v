// -------------------------------------------------------------
// 
// File Name: hdlsrc\edgeDetector\Derivative.v
// Created: 2024-05-06 23:19:59
// 
// Generated by MATLAB 23.2, HDL Coder 23.2, and Simulink 23.2
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: Derivative
// Source Path: edgeDetector/EdgeDetection/Derivative
// Hierarchy Level: 1
// Model version: 1.2
// 
// -------------------------------------------------------------


/*
This takes the discrete time derivative of the data incoming, this should work


*/

module Derivative
          (clk,
           reset,
           enb,
           In1,
           u);


  input   clk;
  input   reset;
  input   enb;
  input   [7:0] In1;  // uint8
  output  [7:0] u;  // uint8

  reg [7:0] u;
  reg [7:0] Delay_out1;  // uint8
  wire [7:0] Add_out1;  // uint8


  always @(posedge clk or posedge reset)
    begin : Delay_process
      if (reset == 1'b1) begin
        Delay_out1 <= 8'b00000000;
      end
      else begin
        if (enb) begin
          Delay_out1 <= In1;
        end
      end
  
 
      if(In1 > Delay_out1) begin
        assign Add_out1 = In1 - Delay_out1;
      end
      else begin
        assign Add_out1 = Delay_out1 -In1;
      end
    assign u = Add_out1;
  end

endmodule  // Derivative
