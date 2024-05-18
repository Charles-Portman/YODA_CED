// This is what is actually simulating the FPGA

`include "EdgeDetectionAllDirections.v"
`timescale 1ns/1ns
module VerilogEdgeDetector(
   // Outputs
   clk, data
   );


   //This is for the reading data stuff
   output clk;
   output [7:0] data;
   reg    clk;
   reg [7:0] data;
   integer   fdUD; //reading file
   integer fdLR;
   integer fout; // writing file
   integer   code, dummy;

   integer backupcounter;
   reg [8*10:1] str;    
   //testing with the smoothing filter
    reg lRBufferMode;
    reg uDBufferMode;
    reg[7:0] uDArray; 
    reg [7:0] lRArray;
    // to put the data in
    wire[7:0] outputVal; // to see the output data
    reg reset; // to reset the data
    reg resetBuff;
    reg enb; // to enable the module
    // need to test with a proper counter but for now will use this
    //reg [7:0] cnt;
    output wire complete;

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
    $dumpfile("VerilogEdgeDetector.vcd");
    $dumpvars(0,VerilogEdgeDetector);
    
    //reading all the data in
      fdUD = $fopen("UpdownData.txt","r"); 
      fdLR = $fopen("LeftWriteData.txt","r");
      lRArray <=0;
      uDArray <=0;
      clk = 0;
      data = 0;
      code = 1;
      reset = 1;
      resetBuff <=1;
      enb <=0;

    //writing file info
      #2
      //sending all the data in
      reset = 0;
      resetBuff <=0;
      uDBufferMode <=0;
      lRBufferMode <=0;
      fout = $fopen("CannyFile.txt","w");
      enb <=1;
      #4
      while (code) begin
         code = $fgets(str, fdUD);
         dummy = $sscanf(str, "%d", data);
         lRArray <= data; //streaming the data to the input
         
         code = $fgets(str, fdLR);
         dummy = $sscanf(str, "%d", data);
         uDArray <= data;
         #2;
      end
      enb <=0;
      $fclose(fdLR);
      $fclose(fdUD);
      #2
      //sending the data out the buff
      uDBufferMode <=1;
      lRBufferMode <=1;
      enb <=1;
      #2;
      while(complete == 0) begin
        $fdisplay(fout,"%d",  outputVal); // will need to change this at some point
        //$display("made it here ,%d",backupcounter);
        #2;
      end
      enb <=0;

      #100;
      $fclose(fout);  
      $finish;
   end // initial begin
   always #1 clk = ~clk;
endmodule 