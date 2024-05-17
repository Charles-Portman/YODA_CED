`include "Smoothing_Filter.v"
`timescale 1ns/1ns
`define CLKPERIOD 2
module ReadingFiles_tb (
   // Outputs
   clk, data
   );


   //This is for the reading data stuff
   output clk;
   output [7:0] data;
   reg    clk;
   reg [7:0] data;
   integer   fd;
   integer   code, dummy;
   reg [8*10:1] str;    
   //testing with the smoothing filter
    reg[7:0] inputArray; // to put the data in
    wire[7:0] outputVal; // to see the output data
    reg reset; // to reset the data
    reg enb; // to enable the module


    Smoothing_Filter DUT(
            .clk(clk),
           .reset(reset),
           .enb(enb),
           .In_Arrary(inputArray),
           .SmoothedArray(outputVal)
           );


   initial begin
    //reading all the data in
      fd = $fopen("UpdownData.txt","r"); 
      clk = 0;
      data = 0;
      code = 1;
      
      reset = 0;
      enb <= 1;
      inputArray =0;
      #2
      while (code) begin
         code = $fgets(str, fd);
         dummy = $sscanf(str, "%d", data);
         inputArray <= data;
         #2
         @(posedge clk);
      end

      $finish;
   end // initial begin
   always #CLKPERIOD clk = ~clk;
endmodule // stim_gen