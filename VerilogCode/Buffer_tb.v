/*
Author: Thomas Greenwood
This code is used to test the buffer File
*/
`include "Buffer.v"
module Buffer_tb();
reg clk;
reg enb;
reg resetBuff;
reg modeBuffer;
reg inArray;
reg [14:0] cout;
wire complete;

Buffer Buffer(.clk(clk),
            .enb(enb),
            .reset(resetBuff), //might want to seperate this 
            .mode(modeBuffer),
            .arrayIn(inArray),
            .cnt(cout),
            .arrayOut(outvalues),
            .complete(complete)
);     

initial begin
    $dumpfile("Buffer_test.vcd"); // for gtk wave
    $dumpvars(0,Buffer_tb); // for gtkwave
    
    //setting all the values to zero
    clk <= 0; 
    enb <= 0;
    modeBuffer <=0; // recieve mode
    inArray <=1;
    cout <=0;
    resetBuff <=1;
    enb <=1;
    #2
    for(cout = 0; cout < 22499; cout = cout +1) begin        
        #2; // store all the data for enought values
    end
    #2
    modeBuffer <=1; // sending out data
    while(complete ==0) begin
        #2; // send out all the values 
    end
    $finish;
end

always begin
    #1 clk =~clk; // switch the clock
end

endmodule 