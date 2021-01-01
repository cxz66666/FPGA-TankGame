`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/31/2020 05:00:13 PM
// Design Name:
// Module Name: tank_generate
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


module tank_generate(
           input clk_4Hz,
           input player1_tank_en,
           input player2_tank_en,
           input enermy1_tank_en,
           input enermy2_tank_en,
           input enermy3_tank_en,
           input enermy4_tank_en,
           output reg player1_revive,
           output reg player2_revive,
           output reg enermy1_revive,
           output reg enermy2_revive,
           output reg enermy3_revive,
           output reg enermy4_revive
       );

reg [ 4: 0 ] cnt_reg_player1, cnt_reg_player2;
reg [ 4: 0 ] cnt_reg_enermy1, cnt_reg_enermy2, cnt_reg_enermy3, cnt_reg_enermy4;
initial begin
    cnt_reg_player1 <= 0;
    cnt_reg_player2 <= 0;
    cnt_reg_enermy1 <= 0;
    cnt_reg_enermy2 <= 0;
    cnt_reg_enermy3 <= 0;
    cnt_reg_enermy4 <= 0;
    player1_revive <= 0;
    player2_revive <= 0;
    enermy1_revive <= 0;
    enermy2_revive <= 0;
    enermy3_revive <= 0;
    enermy4_revive <= 0;
end

always @( posedge clk_4Hz ) begin
    if ( !player1_tank_en ) begin
        cnt_reg_player1 <= cnt_reg_player1 + 1'b1;
    end
    if ( !player2_tank_en ) begin
        cnt_reg_player2 <= cnt_reg_player2 + 1'b1;
    end
    if ( !enermy1_tank_en ) begin
        cnt_reg_enermy1 <= cnt_reg_enermy1 + 1'b1;
    end
    if ( !enermy2_tank_en ) begin
        cnt_reg_enermy2 <= cnt_reg_enermy2 + 1'b1;
    end
    if ( !enermy3_tank_en ) begin
        cnt_reg_enermy3 <= cnt_reg_enermy3 + 1'b1;
    end
    if ( !enermy4_tank_en ) begin
        cnt_reg_enermy4 <= cnt_reg_enermy4 + 1'b1;
    end
    if ( cnt_reg_player1 >= 12 && cnt_reg_player1 <= 19 ) begin
        cnt_reg_player1 <= cnt_reg_player1 + 1'b1;
        player1_revive <= 1'b1;
    end
    if ( cnt_reg_player2 >= 12 && cnt_reg_player2 <= 19 ) begin
        cnt_reg_player2 <= cnt_reg_player2 + 1'b1;
        player2_revive <= 1'b1;
    end
    if ( cnt_reg_enermy1 >= 12 && cnt_reg_enermy1 <= 19 ) begin
        cnt_reg_enermy1 <= cnt_reg_enermy1 + 1'b1;
        enermy1_revive <= 1'b1;
    end
    if ( cnt_reg_enermy2 >= 12 && cnt_reg_enermy2 <= 19 ) begin
        cnt_reg_enermy2 <= cnt_reg_enermy2 + 1'b1;
        enermy2_revive <= 1'b1;
    end
    if ( cnt_reg_enermy3 >= 12 && cnt_reg_enermy3 <= 19 ) begin
        cnt_reg_enermy3 <= cnt_reg_enermy3 + 1'b1;
        enermy3_revive <= 1'b1;
    end
    if ( cnt_reg_enermy4 >= 12 && cnt_reg_enermy4 <= 19 ) begin
        cnt_reg_enermy4 <= cnt_reg_enermy4 + 1'b1;
        enermy4_revive <= 1'b1;
    end
    if ( cnt_reg_player1 == 20 ) begin
        cnt_reg_player1 <= 0;
        player1_revive <= 1'b0;
    end
    if ( cnt_reg_player2 == 20 ) begin
        cnt_reg_player2 <= 0;
        player2_revive <= 1'b0;
    end
    if ( cnt_reg_enermy1 == 20 ) begin
        cnt_reg_enermy1 <= 0;
        enermy1_revive <= 1'b0;
    end
    if ( cnt_reg_enermy2 == 20 ) begin
        cnt_reg_enermy2 <= 0;
        enermy2_revive <= 1'b0;
    end
    if ( cnt_reg_enermy3 == 20 ) begin
        cnt_reg_enermy3 <= 0;
        enermy3_revive <= 1'b0;
    end
    if ( cnt_reg_enermy4 == 20 ) begin
        cnt_reg_enermy4 <= 0;
        enermy4_revive <= 1'b0;
    end
end
endmodule
