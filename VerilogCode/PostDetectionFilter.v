/*
Author: Harry Papanicolu and Thomas Greenwood
Module: PostDetectionFilter.v
Objective: Filter the noisey edge detectd image after going to buffer

*/

module PostDetectionFilter
          (clk,
           reset,
           enb,
           In_Array,
           Out_Array);

  input wire clk;
  input wire reset;
  input wire enb;
  input wire[7:0] In_Array;  // current value
  output reg [7:0] Out_Array;  // outputvalue

  reg [7:0] In_Array1; // 1 delay
  reg [7:0] In_Array2; // 2 delay



  always @(posedge clk or posedge reset)
    begin : reduced_process
      if (reset == 1'b1) begin //reset all the values to 1
        In_Array1 <= 8'b00000000;
        In_Array2 <= 8'b00000000;
      end
      else begin
        if (enb) begin
// Trying to implement a 2-wide filter
        In_Array2 <= In_Array1; //Current value -1
        In_Array1 <= In_Array; // current value divided by 2
        
        end
        else begin
          Out_Array <= 0;
        end

      end
        // average over 4 values
        // SmoothedArray <= In_Array4 + In_Array3 +In_Array2 + In_Array1  ; 
        Out_Array <= (In_Array1 + In_Array2) >>1;
    end

endmodule  // Post detection filter