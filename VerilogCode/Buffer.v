/*
This module will be connected the output of the edge detection and the counter
This allows the storage of the data in the correct order for oring the data


*/

module Buffer(
    input wire clk,
    input wire reset,
    input wire [1:0] mode,
    input wire  arrayIn,
    input wire [14:0] cnt,
    output reg arrayOut,
    output reg complete
);

//internal register
reg storedData [22499:0]; // this is to store all the incoming data
reg[14:0] maxVal;


localparam RECIEVE = 1'b0;
localparam SEND = 1'b1;

always@(posedge(reset)) begin
    maxVal <= 22500;
end


always@(posedge clk) begin
    case(mode)
        RECIEVE: begin
            storedData[cnt] <= arrayIn;
        end
        SEND: begin
           if(maxVal>0) begin
                maxVal <= maxVal -1;
                arrayOut <= storedData[maxVal];
           end 
        end
    endcase

end

endmodule