/*
Author Thomas Greenwood and some help from matlab before I realised that it is easier to just code it myself

This module compares a the dervivative to a threshold that is manually set and if the derivate is above a certain value it outputs one
else it outputs zero

*/


module CompareToThreshold
          (In1,
            enb,
            reset,
           u,
           clk
           );


  input wire clk;
  input wire reset;
  input wire enb;
  input   [7:0] In1;  // uint8
  output  reg u;  // double


  // internal registers need a counter to get rid of the intial values that will develop edges on start
  reg [7:0] intCount;


  wire switch_compare_1;
  wire  Zero_out1;  // ufix64
  wire  Constant_out1;  // ufix64
  wire  Switch_out1;  // ufix64
  
  assign switch_compare_1 = In1 > 18; // 20 is best so far this is the original threshold 8'b00001010; // need to see if we can try make a threshold that is dynamic

  assign Zero_out1 = 1'b0;

  assign Constant_out1 = 1'b1;

  assign Switch_out1 = (switch_compare_1 == 1'b0 ? Zero_out1 :
              Constant_out1);

  initial begin 
    u <=0;
  end

  always@(posedge(reset)) begin
    intCount <=0;
  end

  always@(posedge clk) begin
    if((enb)&&(intCount > 4)) begin
      u <=  Switch_out1;
    end
    else begin
      u <= 0;
    end
    intCount <= intCount +1;
  end


/*
  assign u <= Switch_out1;
*/
endmodule  // CompareToThreshold

