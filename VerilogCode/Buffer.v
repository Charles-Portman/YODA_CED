/*
Author: Thomas Greenwood
This module will be connected the output of the edge detection and the counter
This allows the storage of the data in the correct order for oring the data
As when the data is coming from left to right it is coming in the correct order for the reconstruction of the image
When the data is coming in from up to down it is not in the right order, so this buffer accounts for that by getting input 
from the counter which in turn has two modes for the different data streams


*/

module Buffer(
    input wire clk, // general shared clock
    input wire enb, // general shared enable line
    input wire reset, //specific reset line as this does not need to be reset by the counter module 
    input wire mode, // for sending data are recieving data
    input wire arrayIn, // the incoming array
    input wire [14:0] cnt, // the counter from the clock
    output reg arrayOut, // the output array that can be 'order'
    output reg complete // will go high when finished sending data
);

//internal register
reg storedData [0:22499]; // this is to store all the incoming data the data is only 1 bit but there is 150^150 of them 

reg [0:14] indexOut;
localparam maxVal = 22500; // the total amount of pixels in a 150x150 image

//the modes
localparam RECIEVE = 1'b0; 
localparam SEND = 1'b1;

initial begin 
    complete <=0; // setting complete to zero by default
end


always@(posedge(reset)) begin
    indexOut = 0; // reseting to zero on reset
end


always@(posedge clk) begin
    case(mode) 
        RECIEVE: begin // if recieve start storing data
            storedData[cnt] <= arrayIn; // cnt is the counter index
        end
        SEND: begin 
           if(maxVal>indexOut) begin //send data out in the correct order
                arrayOut <= storedData[indexOut]; 
                complete <=0; // data not done yet
                indexOut = indexOut+1; 
           end 
           else begin
                complete <=1; // im done :)
           end
        end
    endcase

end

endmodule