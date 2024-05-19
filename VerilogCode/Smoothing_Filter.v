/*
Author: Thomas Greenwood and Matlab for some help before I found out how much I prefer just coding in verilog

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
          In_Arrary4 <= In_Arrary3; // current value -3 units in time
          In_Arrary3 <= In_Arrary2; //current value -2 units in time
          In_Arrary2 <= In_Arrary1; //current value -1 units in time
          In_Arrary1 <= In_Arrary >> 2'b10; // current value divided by 4 to save operations this will pass it down to the above registers
          
        end
      end
        // average over 4 values
        SmoothedArray <= In_Arrary4 + In_Arrary3 +In_Arrary2 + In_Arrary1  ; 
    end

endmodule  // Smoothing_Filter