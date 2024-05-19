/*
Author: Thomas Greenwood
Test bench for the smoothing filter

*/

`include "Smoothing_Filter.v"

module SmoothingFilter_tb();

reg[7:0] inputArray; // to put the data in
wire[7:0] outputVal; // to see the output data
reg reset; // to reset the data
reg enb; // to enable the module
reg clk;  // for the clk of the module


Smoothing_Filter DUT(
            .clk(clk),
           .reset(reset),
           .enb(enb),
           .In_Arrary(inputArray),
           .SmoothedArray(outputVal)
           );
initial begin
    clk <= 0;
    $dumpfile("Smoothingfilter.vcd"); // for gtkwave for debugging
    $dumpvars(0, SmoothingFilter_tb); // for ^
    reset <= 1;// reset all the values
    #2;
    reset <=0;
    enb <= 1;
    inputArray <=4;
    for (inputArray = 4; inputArray<10; inputArray = inputArray +1) // counts up to five
        begin
          #2;
        end 
    #2;
    #2;
    #2; //gives enough time to let all the values pass through
    $finish;
end
always begin
    #1 clk <= ~clk; // toggling the clock
end
endmodule