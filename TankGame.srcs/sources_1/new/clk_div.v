`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/16/2020 03:28:34 PM
// Design Name:
// Module Name: clk_div
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module clk_div(
           input clk,
           input rst ,
           output reg[ 31: 0 ] clkdiv
       );

initial
    clkdiv <= 0;
always @( posedge clk or posedge rst ) begin
    if ( rst ) begin
        clkdiv <= 0;
    end
    else begin
        clkdiv <= clkdiv + 1'b1;
    end
end

endmodule
