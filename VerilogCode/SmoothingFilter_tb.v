/*


*/ 

`include "Smoothing_Filter.v"

module SmoothingFilter_tb();
// inputes
reg clk;
reg reset;
reg enb;
reg In_Arrary[7:0];
//output
wire SmoothedArray;

SmoothingFilter DUT(.clk(clk),
           .reset(reset),
           .enb(enb),
           .In_Arrary(In_Arrary),
           .SmoothedArray(SmoothedArray)
);


initial begin

$dumpfile("derivativeTest.vcd");
$dumpvars(0, derivative_tb);


clk <= 0;
In_Arrary = 1;
#1;
#1;
#1;

end

always begin
#1 clk = ~clk; // Toggle clock every 5 ticks
end

endmodule