/*
This used to keep track of the index that is being counted
Therefore it needs 4 modes of counting
when going accross it needs to count up linearly 1,2,3,4...150^2
When going down it needs to count up in 150s ie 1,151,...22351 then 2, 152,302... then 3.. then 150
When going accross it needs to count 1 then 2 ,151 then 3
When going diagonally it needs to count 1 then 2,n+1 then 3,n+2
    * This can be done by having two counting indexes one for rows, one for columns and mulitplication
* also needs to provide a reset to the edgedetection system such that it will reset upon completion of a row
*/

//progress so far - up down and left right are working


module Counter(
    input wire [2:0] mode,
    input wire clk,
    input wire enb,
    input wire resetIn,
    output reg resetOut,
    output reg [14:0] cout //need 15 bits to store 150^2 
);

//these are all the different counting states
localparam LR=2'b00; //reading data left to right
localparam UD =2'b01; //reading data up to down
localparam DL =2'b10; //reading diagonally
localparam DR = 2'b11; // reading vertically

initial begin
    cout <=0;
end


always@(posedge resetIn) begin
    cout = 0; // reset the count
    resetOut <= 1;
end
always@(posedge clk) begin
    if (enb) begin
        case(mode) 
            LR: begin // reading from left to right is ez 
                cout <=cout+1;
                if((cout%150 == 0)&&(cout > 0)) begin
                    resetOut <=1; // we have reached the end of the line time to reset the edge detector
                end
                else begin
                    resetOut <=0; // we are still in the same line keep going
                end
            end
            UD: begin //counting down the array
                if(cout < 22350) begin
                    cout <= cout +150;
                    resetOut<=0;
                end
                else begin //end condition
                    cout <= cout - 22349;
                    resetOut <=1;
                end
            end
        endcase
    end
    else begin
        cout <=0;
    end
end

endmodule


