`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2020 05:09:19 PM
// Design Name: 
// Module Name: tank_data_selector
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


module tank_data_selector(
    input clk,
    input [11:0] UP,
    input [11:0] DOWN,
    input [11:0] LEFT,
    input [11:0] RIGHT,
    input [1:0] Dir,
    output reg [11:0] tankData 
    );

    always @(posedge clk) begin
        case(Dir)
        2'b00:
            tankData <= UP;
        2'b01:
            tankData <= DOWN;
        2'b10:
            tankData <= LEFT;
        2'b11:
            tankData <= RIGHT;
        endcase
    end
    
endmodule
