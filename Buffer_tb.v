/*
Test bench for the buffer

*/
`include "Buffer.v"
module Buffer_tb();
reg clk;
reg enb;
reg resetBuff;
reg modeBuffer;
reg CompareToThreshold;
reg [14:0] cout;
wire complete;

Buffer Buffer(.clk(clk),
            .enb(enb),
            .reset(resetBuff), //might want to seperate this 
            .mode(modeBuffer),
            .arrayIn(CompareToThreshold),
            .cnt(cout),
            .arrayOut(outvalues),
            .complete(complete)
);     

initial begin
    $dumpfile("Buffer_test.vcd");
    $dumpvars(0,Buffer_tb);
    clk <= 0;
    enb <= 0;
    modeBuffer <=0; // recive mode
    CompareToThreshold <=1;
    cout <=0;
    resetBuff <=1;
    #2
    for(cout = 0; cout < 22499; cout = cout +1) begin        
        #2;
    end
    #2
    modeBuffer <=1; // sending out data
    while(complete ==0) begin
        #2;
    end
    $finish;
end

always begin
    #1 clk =~clk;
end

endmodule 