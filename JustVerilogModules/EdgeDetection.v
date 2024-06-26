/*
This module connects all the other modules together

*/

`include "Smoothing_Filter.v"
`include "Derivative.v"
`include "CompareToThreshold.v"
`include "Counter.v"
`include "Buffer.v"

module EdgeDetection
          (clk,
           modeCounter,
           modeBuffer,
           reset,
           resetBuff,
           enb,
           In_Arrary,
           Edges,
           complete
           ); 


  input   clk; //input clock from test bench
  input [2:0] modeCounter; // from test bench will select if its going accross up or down
  input  modeBuffer;
  input   reset; // input reset from testbench
  input   enb;
  input   [7:0] In_Arrary;  // in array from file in test bench
  output reg Edges;  // output from the compare to threshold was a 7 bit number
  input resetBuff;
  output wire complete; //check this

  wire resetOut; // to reset all the other modules based off the counter
  wire [7:0] smoothed;  // uint8
  wire [7:0] diff;  // uint8
  wire  CompareToThreshold_out1; // wires to connect everything
  wire [14:0] cout;
  wire outvalues;
  
//the counter module
  Counter Counter(.mode(modeCounter),
                  .clk(clk),
                  .enb(enb),
                  .resetIn(reset),
                  .resetOut(resetOut),
                  .cout(cout)
  );


  // first goes into the smoothing filter
  Smoothing_Filter u_Smoothing_Filter (.clk(clk),
                                       .reset(resetOut),
                                       .enb(enb),
                                       .In_Arrary(In_Arrary),  // uint8
                                       .SmoothedArray(smoothed)  // uint8
                                       );
  //Then goes to the derivative                                     
  Derivative u_Derivative (.clk(clk),
                           .reset(resetOut),
                           .enb(enb),
                           .In(smoothed),  // uint8
                           .d_in(diff)  // uint8
                           );
  //Then compares to threshold
  CompareToThreshold u_CompareToThreshold ( .clk(clk),
                                            .enb(enb),
                                            .reset(resetOut),
                                            .In1(diff),  // uint8
                                           .u(CompareToThreshold_out1)  // double
                                           );
  //assigns the of the final module to compare to threshold
  Buffer Buffer(.clk(clk),
                .enb(enb),
                .reset(resetBuff), //might want to seperate this 
                .mode(modeBuffer),
                .arrayIn(CompareToThreshold_out1),
                .cnt(cout),
                .arrayOut(outvalues),
                .complete(complete)
  );     
  
  /* 
  Doing some filtering here
  This filters out some noice by only letting the output go high if the two consecutive values are high
  */
  reg oldEdge; 
  reg CurrentVal;
  
  always@(posedge reset)begin
    oldEdge<=0;
    CurrentVal <= 0;
  end
  
  always@(posedge clk) begin
     oldEdge <= CurrentVal;
     if((outvalues== 1)||(outvalues ==0)) begin
        CurrentVal <= outvalues;
     end
     Edges <= (CurrentVal&oldEdge);
  end

  



endmodule  // EdgeDetection

