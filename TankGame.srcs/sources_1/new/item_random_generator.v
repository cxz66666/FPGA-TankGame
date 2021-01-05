`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/05/2021 10:41:37 PM
// Design Name:
// Module Name: item_random_generator
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


module item_random_generator(
           input clk,
           input clk_4Hz,
           input set_finish,
           input enable,
           output reg dout,
           output reg set_require,
           output reg [ 1: 0 ] item_type,
           output [ 10: 0 ] random_xpos,
           output [ 10: 0 ] random_ypos
       );
endmodule
