/*
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
  output reg [7:0] SmoothedArray;  // outputvalue

  reg [7:0] In_Array1; // 1 delay
  reg [7:0] In_Array2; // 2 delay
  reg [7:0] In_Array3; // 3 delay
  reg [7:0] In_Array4; // current val


  always @(posedge clk or posedge reset)
    begin : reduced_process
      if (reset == 1'b1) begin //reset all the values to 1
        In_Array1 <= 8'b00000000;
        In_Array2 <= 8'b00000000;
        In_Array3 <= 8'b00000000;
        In_Array4 <= 8'b00000000;
      end
      else begin
        if (enb) begin
        //   In_Array4 <= In_Array3; // current value -3
        //   In_Array3 <= In_Array2; //current value -2
        //   In_Array2 <= In_Array1; //current value -1
        //   In_Array1 <= In_Array >> 2'b10; // current value divided by 4

// Trying to implement a 2-wide filter
        In_Array2 <= In_Array1; //Current value -1
        In_Array1 <= In_Array >> 1'b1; // current value divided by 2
        
        end
      end
        // average over 4 values
        // SmoothedArray <= In_Array4 + In_Array3 +In_Array2 + In_Array1  ; 
        SmoothedArray <= In_Array1 + In_Array2
    end

endmodule  // Post detection filter