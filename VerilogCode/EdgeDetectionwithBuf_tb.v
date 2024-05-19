/*
Author: Thomas Greenwood

This test the edge detection modules entire operation with a buffer attatched to it
*/

`include "EdgeDetection.v"
`timescale 1ns/1ns
module TestingEdgeDectionWithBuff_tb (
   // Outputs
   clk, data
   );


   //This is for the reading data stuff
   output clk;
   output [7:0] data;
   reg    clk;
   reg [7:0] data;
   integer   fd; //reading file
   integer fout; // writing file
   integer   code, dummy;
   reg [8*10:1] str;    
   //testing with the smoothing filter
    reg modeBuffer;
    reg[7:0] inputArray; // to put the data in
    wire outputVal; // to see the output data
    reg reset; // to reset the data
    reg resetBuff;
    reg enb; // to enable the module
    // need to test with a proper counter but for now will use this
    //reg [7:0] cnt;
    output wire complete;

    EdgeDetection DUT
    (
        .clk(clk),
        .modeCounter(3'b000), // mode needs to correspond to the data coming in or it will transpose the image
        .modeBuffer(modeBuffer),
        .reset(reset),
        .resetBuff(resetBuff), // check this
        .enb(enb),
        .In_Arrary(inputArray),
        .Edges(outputVal),
        .complete(complete)
    );


   initial begin
    // for gtkwave
    $dumpfile("EdgeDetectionWithBuff.vcd");
    $dumpvars(0,TestingEdgeDectionWithBuff_tb);
    
    //reading all the data in
      fd = $fopen("UpdownData.txt","r"); 
      //fd = $fopen("ToTopLeftData.txt","r");
      inputArray <=0;
      clk = 0;
      data = 0;
      code = 1;
      reset = 1;
      resetBuff <=1;
      
    //writing file info
      #2
      //sending all the data in
      reset = 0;
      resetBuff <=0;
      modeBuffer <= 0;
      //fout = $fopen("Diagonal1.txt","w"); // writing file for matlab to reconstruct the image
      fout = $fopen("EdgeDetectionOneDirectionWithBuff.txt","w");
      
      enb <=1;
      #2
      while (code) begin
         code = $fgets(str, fd);
         dummy = $sscanf(str, "%d", data);
         inputArray <= data; //streaming the data to the input
         #2;
      end
      inputArray <=0;
      enb <=0;
      $fclose(fd);
      #2
      //sending the data out the buff
      
      modeBuffer <= 1;
      enb <=1;
      #2;
      while(complete == 0) begin // wait until all the data comes back
        $fdisplay(fout,"%d", outputVal); // will need to change this at some point
         #2;
      end
      $fclose(fout);  
      $finish;
   end // initial begin
   always #1 clk = ~clk; // toggle the clock
endmodule // stim_gen