`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/02/2021 06:07:12 PM
// Design Name:
// Module Name: Random
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


module Random(
           input clk,
           input rst_n,
           input [ 1: 0 ] flag,
           output reg [ 1: 0 ] random
       );
reg [ 7: 0 ] rand_num;
always @( * ) begin
    case ( flag )
        2'b00:
            random <= rand_num[ 1: 0 ];
        2'b01:
            random <= rand_num[ 3: 2 ];
        2'b10:
            random <= rand_num[ 5: 4 ];
        2'b11:
            random <= rand_num[ 7: 6 ];
    endcase
end



initial begin
    rand_num = 8'b1111_1111;
end
always@( posedge clk ) begin
    if ( !rst_n ) begin
        rand_num <= 8'b1111_1111;
    end
    else begin
        rand_num[ 0 ] <= rand_num[ 7 ];
        rand_num[ 1 ] <= rand_num[ 0 ];
        rand_num[ 2 ] <= rand_num[ 1 ];
        rand_num[ 3 ] <= rand_num[ 2 ];
        rand_num[ 4 ] <= rand_num[ 3 ] ^ rand_num[ 7 ];
        rand_num[ 5 ] <= rand_num[ 4 ] ^ rand_num[ 7 ];
        rand_num[ 6 ] <= rand_num[ 5 ] ^ rand_num[ 7 ];
        rand_num[ 7 ] <= rand_num[ 6 ];
    end

end
endmodule
