/*
Author: Thomas Greenwood
To test the counter module

*/
`include "Counter.v"

module counterTb();
reg [2:0] mode;
reg clk;
reg enb;
reg resetIN;
wire resetOut;
wire [14:0] cout;



Counter DUT(
    .mode(mode),
    .clk(clk),
    .enb(enb),
    .resetIn(resetIN),
    .resetOut(resetOut),
    .cout(cout)
);

initial begin
clk <=0;
mode <=1; // see if it counts correctly in the mode
$dumpfile("counter.vcd");
$dumpvars(0,counterTb);

#200000; // wait enough time for the counter to reach 22500 the end of the array
$finish;
end

always begin
 #2 clk = ~clk; // toggle the clock
end
endmodule