/*
Author: Thomas Greenwood

This is the actual Testbench which is simulating the FPGA and creates files for matlab to post proccess into images

*/

`include "EdgeDetectionAllDirections.v"
`timescale 1ns/1ns
module VerilogEdgeDetector(
   // Outputs
   clk, data
   );


   //This is for the reading data from files 
   output clk;
   output [7:0] data;
   reg    clk;
   reg [7:0] data;
   integer   fdUD; //reading file
   integer fdLR;
   integer fout; // writing file
   integer   code, dummy;

   reg [8*10:1] str;    
   //testing with the smoothing filter
    reg lRBufferMode; // to set the left to right module
    reg uDBufferMode; // to set the up and down module
    reg[7:0] uDArray; // the up and down data array that will be inputted to the module (via a file)
    reg [7:0] lRArray; // the left to right array that will be inputted to the module (via a file)
    // to put the data in
    wire outputVal; // to see the output data
    reg reset; // to reset the data
    reg resetBuff; // reset the buffer
    reg enb; // to enable the module
    // need to test with a proper counter but for now will use this
    //reg [7:0] cnt;
    output wire complete;
// connecting the edgedectoralldirections module up and naming it EdgeDetector3000 because it sounds cooler
EdgeDetectionAllDirections EdgeDetector3000
    (   
    .clk(clk),
    .upDownArray(uDArray),
    .leftRightArray(lRArray),
    .reset(reset),
    .resetBuff(resetBuff),
    .enb(enb),
    .buffLRMode(lRBufferMode),
    .buffUDMode(uDBufferMode),
    .complete(complete),
    .OutArray(outputVal)
);



   initial begin
    // for gtkwave
    $dumpfile("VerilogEdgeDetector.vcd"); // for gtkwave
    $dumpvars(0,VerilogEdgeDetector);
    
    //reading all the data in
      fdUD = $fopen("UpdownData.txt","r"); //input file for up and down data
      fdLR = $fopen("LeftRightData.txt","r"); //input file for Left to right data
      
      // presetting all the values to zero
      lRArray <=0;
      uDArray <=0;
      clk = 0;
      data = 0;
      code = 1;
      reset = 1;
      resetBuff <=1;
      enb <=0;
      #2
      //sending all the data in
      reset = 0;
      resetBuff <=0;
      uDBufferMode <=0;
      lRBufferMode <=0;
      fout = $fopen("CannyFile2.txt","w");
      enb <=1;
      #2
      while (code) begin // while there is still data in files, read it
         //left right data
         code = $fgets(str, fdUD);
         dummy = $sscanf(str, "%d", data);
         lRArray <= data; //streaming the data to the input
         //up down data
         code = $fgets(str, fdLR);
         dummy = $sscanf(str, "%d", data);
         uDArray <= data;
         #2;
      end
      enb <=0; // disable for a clock cycle
      $fclose(fdLR);
      $fclose(fdUD);
      #2
      //sending the data out the buff
      uDBufferMode <=1; // turn buffer to sending mode
      lRBufferMode <=1; // turn buffer to sending mode
      enb <=1; // enable again
      #2;
      while(complete == 0) begin // repeat until all the data is sent out
        $fdisplay(fout,"%d",  outputVal); // will need to change this at some point
        #2;
      end
      enb <=0;

      #100; // delay for vibes
      $fclose(fout);  
      $finish;
   end 
   always #1 clk = ~clk; // toggle clock
endmodule 