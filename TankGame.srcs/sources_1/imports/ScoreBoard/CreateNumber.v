`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    20:12:55 10/27/2020
// Design Name:
// Module Name:    CreateNumber
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module CreateNumber(
           input wire [ 2: 0 ] btn,
           output reg [ 7: 0 ] num
       );
wire [ 3: 0 ] heart_add, heart_minus, time_add, time_minus;
initial
    num <= 8'b1111_0100;

assign heart_add = num[ 3: 0 ] == 6 ? num[ 3 : 0 ] : num[ 3 : 0 ] + 1'b1;
assign heart_minus = num[ 3: 0 ] == 0 ? num[ 3 : 0 ] : num[ 3 : 0 ] - 1'b1;
assign time_add = num[ 7: 4 ] + 1'b1;
assign time_minus = num[ 7: 4 ] - 1'b1;

always @( posedge btn[ 1 ] )
    num[ 3: 0 ] <= btn[ 0 ] == 1'b1 ? heart_add : heart_minus;
always @( posedge btn[ 2 ] )
    num[ 7: 4 ] <= btn[ 0 ] == 1'b1 ? time_add : time_minus;

endmodule
