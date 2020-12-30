`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/16/2020 05:57:23 PM
// Design Name:
// Module Name: game_mode
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


module game_mode(
           input clk,
           input btn_confirm,
           input btn_mode_sel,
           input btn_return,
           input gameover_classic,
           input gameover_infinity,

           output reg enable_shell1,
           output reg enable_shell2,
           output reg enable_shell3,
           output reg enable_shell4,

           output reg enable_enemytank1_control,
           output reg enable_enemytank2_control,
           output reg enable_enemytank3_control,
           output reg enable_enemytank4_control,

           output reg enable_enemytank1_display,
           output reg enable_enemytank2_display,
           output reg enable_enemytank3_display,
           output reg enable_enemytank4_display,


           output reg enable_myshell1,
           output reg enable_myshell2,

           output reg enable_mytank1_control,
           output reg enable_mytank2_control,
           output reg enable_mytank1_display,
           output reg enable_mytank2_display,


           output reg enable_game_classic,
           output reg enable_game_infinity,
           output reg enable_reward,
           output reg	start_protect,

           output reg enable_gamemusic,
           //	output		reg		enable_shootmusic,
           output reg	[ 2: 0 ] mode

       );

reg	[ 63: 0 ] start_protect_cnt;
reg	start_protect_flag;


initial begin
    mode <= 0;
    start_protect_flag <= 0;
    start_protect_cnt <= 0;
end


always @( posedge clk ) begin
    case ( mode )
        0: begin
            enable_shell1 <= 1'b0;
            enable_shell2 <= 1'b0;
            enable_shell3 <= 1'b0;
            enable_shell4 <= 1'b0;
            enable_enemytank1_control <= 1'b0;
            enable_enemytank2_control <= 1'b0;
            enable_enemytank3_control <= 1'b0;
            enable_enemytank4_control <= 1'b0;
            enable_enemytank1_display <= 1'b0;
            enable_enemytank2_display <= 1'b0;
            enable_enemytank3_display <= 1'b0;
            enable_enemytank4_display <= 1'b0;
            enable_myshell1 <= 1'b0;
            enable_myshell2 <= 1'b0;
            enable_mytank1_control <= 1'b0;
            enable_mytank2_control <= 1'b0;
            enable_mytank1_display <= 1'b0;
            enable_mytank2_display <= 1'b0;
            enable_game_classic <= 1'b0;
            enable_game_infinity <= 1'b0;
            enable_reward <= 1'b0;
            start_protect <= 1'b0;
            enable_gamemusic <= 1'b1;
            if ( btn_confirm ) begin
                if ( btn_mode_sel == 1'b0 ) begin
                    mode <= 1;
                end
                else begin
                    mode <= 2;
                end
            end
            else begin
                mode <= 0;
            end
        end


        1: begin
            enable_shell1 <= 1'b1;
            enable_shell2 <= 1'b1;
            enable_shell3 <= 1'b1;
            enable_shell4 <= 1'b1;
            enable_enemytank1_control <= 1'b1;
            enable_enemytank2_control <= 1'b1;
            enable_enemytank3_control <= 1'b1;
            enable_enemytank4_control <= 1'b1;
            enable_enemytank1_display <= 1'b1;
            enable_enemytank2_display <= 1'b1;
            enable_enemytank3_display <= 1'b1;
            enable_enemytank4_display <= 1'b1;
            enable_myshell1 <= 1'b1;
            enable_myshell2 <= 1'b1;
            enable_mytank1_control <= 1'b1;
            enable_mytank2_control <= 1'b1;
            enable_mytank1_display <= 1'b1;
            enable_mytank2_display <= 1'b1;
            enable_game_classic <= 1'b1;
            enable_game_infinity <= 1'b0;
            enable_reward <= 1'b1;
            enable_gamemusic <= 1'b0;

            if ( start_protect_flag == 1'b0 ) begin
                start_protect_cnt <= start_protect_cnt + 1;
                start_protect <= 1'b1;
                if ( start_protect_cnt >= 300000000 ) begin
                    start_protect_flag <= 1'b1;
                    start_protect <= 1'b0;
                    start_protect_cnt <= 0;
                end

            end
            if ( gameover_classic == 1'b1 ) begin
                mode <= 3;
            end
            else begin
                mode <= 1;
            end
        end
        2: begin
            enable_shell1 <= 1'b1;
            enable_shell2 <= 1'b1;
            enable_shell3 <= 1'b1;
            enable_shell4 <= 1'b1;
            enable_enemytank1_control <= 1'b1;
            enable_enemytank2_control <= 1'b1;
            enable_enemytank3_control <= 1'b1;
            enable_enemytank4_control <= 1'b1;
            enable_enemytank1_display <= 1'b1;
            enable_enemytank2_display <= 1'b1;
            enable_enemytank3_display <= 1'b1;
            enable_enemytank4_display <= 1'b1;
            enable_myshell1 <= 1'b1;
            enable_myshell2 <= 1'b1;
            enable_mytank1_control <= 1'b1;
            enable_mytank2_control <= 1'b1;
            enable_mytank1_display <= 1'b1;
            enable_mytank2_display <= 1'b1;
            enable_game_classic <= 1'b0;
            enable_game_infinity <= 1'b1;
            enable_reward <= 1'b1;
            start_protect <= 1'b0;
            start_protect_flag <= 1'b0;
            enable_gamemusic <= 1'b1;

            if ( gameover_infinity == 1 ) begin
                mode <= 3;
            end
            else begin
                mode <= 2;
            end
        end
        3: begin
            enable_shell1 <= 1'b0;
            enable_shell2 <= 1'b0;
            enable_shell3 <= 1'b0;
            enable_shell4 <= 1'b0;
            enable_enemytank1_control <= 1'b0;
            enable_enemytank2_control <= 1'b0;
            enable_enemytank3_control <= 1'b0;
            enable_enemytank4_control <= 1'b0;
            enable_enemytank1_display <= 1'b0;
            enable_enemytank2_display <= 1'b0;
            enable_enemytank3_display <= 1'b0;
            enable_enemytank4_display <= 1'b0;
            enable_myshell1 <= 1'b0;
            enable_myshell2 <= 1'b0;
            enable_mytank1_control <= 1'b0;
            enable_mytank2_control <= 1'b0;
            enable_mytank1_display <= 1'b0;
            enable_mytank2_display <= 1'b0;
            enable_game_classic <= 1'b0;
            enable_game_infinity <= 1'b0;
            enable_reward <= 1'b0;
            start_protect <= 1'b0;
            start_protect_flag <= 1'b0;
            enable_gamemusic <= 1'b1;
            if ( btn_return ) begin
                mode <= 0;
            end
            else begin
                mode <= 3;
            end
        end
    endcase
end
endmodule
