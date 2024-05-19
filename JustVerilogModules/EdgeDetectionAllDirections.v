/*
Author: Thomas Greenwood

This module takes intialises the creates the whole edge detection systems,
connecting an edge detection for all directions
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
output wire OutArray;



//internal Registers
wire leftRightOut; // data from the left to right array
wire upDownOut; // data from the up to down array
//wire [7:0] OutArray_Prefiltered; // only needed if you include the filter

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
//connecting the up and down edge detector
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

assign OutArray = (upDownOut|leftRightOut); // if it is a edge from either it is an edge

/* To include LP filter add this and uncommnet previous assign

assign OutArray_Prefiltered = (upDownOut|leftRightOut);

PostDetectionFilter LPFilter
          (.clk(clk),
           .reset(reset),
           .enb(enb),
           .In_Array(OutArray_Prefiltered),
           .Out_Array(OutArray)
           );

//if need to add a filter can add it in here
*/
endmodule