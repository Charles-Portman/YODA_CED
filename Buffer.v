/*
This module will be connected the output of the edge detection and the counter
This allows the storage of the data in the correct order for oring the data


*/

module Buffer(
    input wire clk,
    input wire enb,
    input wire reset,
    input wire mode,
    input wire arrayIn,
    input wire [14:0] cnt,
    output reg arrayOut,
    output reg complete
);

//internal register
reg storedData [0:22499]; // this is to store all the incoming data

reg [0:14] indexOut;
localparam maxVal = 22500;

localparam RECIEVE = 1'b0;
localparam SEND = 1'b1;

initial begin 
    complete <=0;
end


always@(posedge(reset)) begin
    indexOut = 0;
end


always@(posedge clk) begin
    case(mode)
        RECIEVE: begin
            storedData[cnt] <= arrayIn;
        end
        SEND: begin 
           if(maxVal>indexOut) begin
                arrayOut <= storedData[indexOut];
                complete <=0;
                indexOut = indexOut+1;
           end 
           else begin
                complete <=1;
           end
        end
    endcase

end

endmodule