`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/31/2020 03:55:24 PM
// Design Name:
// Module Name: cal_score
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


module cal_score(
           input clk,
           input reset_n,
           input enermy1_tank_en,
           input enermy2_tank_en,
           input enermy3_tank_en,
           input enermy4_tank_en,
           input player1_scored,
           input player2_scored,
           output reg [ 3: 0 ] scorea1,
           output reg [ 3: 0 ] scorea2,
           output reg [ 3: 0 ] scoreb1,
           output reg [ 3: 0 ] scoreb2,
           output reg [ 3: 0 ] scorec1,
           output reg [ 3: 0 ] scorec2,
           output reg [ 3: 0 ] scored1,
           output reg [ 3: 0 ] scored2
       );

reg enermy1_tank_en_last, enermy2_tank_en_last, enermy3_tank_en_last, enermy4_tank_en_last;
initial begin
    scorea1 <= 0;
    scorea2 <= 0;
    scoreb1 <= 0;
    scoreb2 <= 0;
    scorec1 <= 0;
    scorec2 <= 0;
    scored1 <= 0;
    scored2 <= 0;
end
always @( posedge clk ) begin
    if ( !reset_n ) begin
        scorea1 <= 0;
        scorea2 <= 0;
        scoreb1 <= 0;
        scoreb2 <= 0;
        scorec1 <= 0;
        scorec2 <= 0;
        scored1 <= 0;
        scored2 <= 0;
    end
    else begin
        if ( enermy1_tank_en_last && ~enermy1_tank_en ) begin
            if ( player1_scored ) begin
                scorea1 <= scorea1 + 1'b1;
            end
            else begin
                scorea2 <= scorea2 + 1'b1;
            end
        end
        else if ( enermy2_tank_en_last && ~enermy2_tank_en ) begin
            if ( player1_scored ) begin
                scoreb1 <= scoreb1 + 1'b1;
            end
            else begin
                scoreb2 <= scoreb2 + 1'b1;
            end
        end
        else if ( enermy3_tank_en_last && ~enermy3_tank_en ) begin
            if ( player1_scored ) begin
                scorec1 <= scorec1 + 1'b1;
            end
            else begin
                scorec2 <= scorec2 + 1'b1;
            end
        end
        else if ( enermy4_tank_en_last && ~enermy4_tank_en ) begin
            if ( player1_scored ) begin
                scored1 <= scored1 + 1'b1;
            end
            else begin
                scored2 <= scored2 + 1'b1;
            end
        end
    end
    enermy1_tank_en_last <= enermy1_tank_en;
    enermy2_tank_en_last <= enermy2_tank_en;
    enermy3_tank_en_last <= enermy3_tank_en;
    enermy4_tank_en_last <= enermy4_tank_en;

end
endmodule
