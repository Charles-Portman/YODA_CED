/*
Author: Thomas Greenwood

Takes the discrete derivative of the incomming data
*/

module Derivative
          (clk,
           reset,
           enb,
           In,
           d_in);


  input   clk;
  input   reset;
  input   enb;
  input   [7:0] In;  // input value
  output  [7:0] d_in;  // discrete derivative value

  reg [7:0] d_in;
  reg [7:0] Delay_out1;  // uint8
  reg [7:0] Add_out1;  // uint8


  always @(posedge clk or posedge reset)
    if(enb) begin
      begin : Delay_process
        if (reset == 1'b1) begin
          Delay_out1 <= 8'b00000000; // if it is the first item then set pretend the previous value was zero
        end
        else begin
          if (enb) begin
            Delay_out1 <= In; // time delay 1
          end
        end
    
  
        if(In > Delay_out1) begin // absoulate derivative
          Add_out1 = In - Delay_out1; 
        end
        else begin
          Add_out1 = Delay_out1 -In;
        end
      d_in <= Add_out1;
    end
  end
  else begin
    d_in <= 0; // just to stop x values
  end

endmodule  // Derivative

