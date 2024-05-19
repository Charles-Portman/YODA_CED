/*
Author: Thomas Greenwood
This testbench test the functionality of an edge detector module without a buffer
*/

`include "EdgeDetection.v"
`timescale 1ns/1ns
module TestingEdgeDection_tb (
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
    reg[7:0] inputArray; // to put the data in
    wire[7:0] outputVal; // to see the output data
    reg reset; // to reset the data
    reg enb; // to enable the module
    // need to test with a proper counter but for now will use this
    reg [7:0] cnt;


    EdgeDetection DUT
    (
        .clk(clk),
        .reset(reset),
        .enb(enb),
        .In_Arrary(inputArray),
        .Edges(outputVal)
    );


   initial begin
    // for gtkwave
    $dumpfile("EdgeDetectionOneDirection.vcd");
    $dumpvars(0, TestingEdgeDection_tb);
    
    //reading all the data in
      fd = $fopen("UpdownData.txt","r"); 
      clk = 0;
      data = 0;
      code = 1;
      cnt <=0;
      reset = 1;
      inputArray <=0;
      #2;
    //writing file info
    

    // smoothing filter inputs
      reset = 0;
      #2
      enb <= 1;
      
      fout = $fopen("EdgeDetectionOneDirection.txt","w");
      while (code) begin
         if(cnt == 150) begin //reset every row
            cnt <= 0;
            reset = 1; 
            #2
            reset =0;
         end
         code = $fgets(str, fd);
         dummy = $sscanf(str, "%d", data);
         inputArray <= data; //streaming the data to the input
         $fdisplay(fout,"%d", outputVal);
         cnt = cnt +1; // will need to change this at some point
         @(posedge clk);
      end
      $fclose(fout);  
      $fclose(fd);
      
      $finish;
   end // initial begin
   always #1 clk = ~clk;
endmodule // stim_gen