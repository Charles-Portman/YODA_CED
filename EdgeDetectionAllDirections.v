/*
This module will implement Edge detection for all the directions 
*/

`include "EdgeDetection.v"

module EdgeDetectionAllDirections
(   clk,
    upDownArray,
    leftRightArray,
    reset,
    resetBuff,
    enb,
    buffLRMode,
    buffUDMode,
    complete,
    OutArray
);

input wire clk;
input wire [7:0] upDownArray;
input wire [7:0] leftRightArray;
input wire buffLRMode;
input wire buffUDMode;
input wire enb;
input wire reset;
input wire resetBuff;

output wire complete;
output wire [7:0] OutArray;

//internal Registers
wire [7:0] leftRightOut;
wire [7:0] upDownOut;
wire [7:0] leftRightUpDown;

//connecting the left right edge detector
EdgeDetection LeftRight(
    .clk(clk),
    .modeCounter(3'b000), //hardcoding it into the left right mode
    .modeBuffer(buffLRMode),
    .reset(reset),
    .resetBuff(resetBuff), // check how this works
    .enb(enb),
    .In_Arrary(leftRightArray),
    .Edges(leftRightOut),
    .complete(complete)
);

EdgeDetection upDown(
    .clk(clk),
    .modeCounter(3'b001), //hardcoding it into the upDown right mode
    .modeBuffer(buffLRMode),
    .reset(reset),
    .resetBuff(resetBuff), // check how this works
    .enb(enb),
    .In_Arrary(upDownArray),
    .Edges(upDownOut)
);


assign leftRightUpDown = (upDownOut|leftRightOut);

PostDetectionFilter filtering(
    .clk(clk),
    .reset(reset),
    .enb(enb),
    .In_Array(leftRightUpDown), // uint 8
    .Out_Array(OutArray)
);


//if need to add a filter can add it in here

endmodule