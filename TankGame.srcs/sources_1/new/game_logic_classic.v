`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/29/2020 04:47:13 PM
// Design Name:
// Module Name: game_logic_classic
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



module game_logic_classic(
           input clk,
           input btn_return,
           input btn_stop,
           input enable_game_classic,
           input mytank1_state,
           input mytank2_state,
           input [ 3: 0 ] scorea1,
           input [ 3: 0 ] scorea2,
           input [ 3: 0 ] scoreb1,
           input [ 3: 0 ] scoreb2,
           input [ 3: 0 ] scorec1,
           input [ 3: 0 ] scorec2,
           input [ 3: 0 ] scored1,
           input [ 3: 0 ] scored2,
           input item_invincible,
           output reg [ 3: 0 ] HP1_value,
           output reg [ 3: 0 ] HP2_value,

           output reg gameover_classic,
           output wire [ 15: 0 ] led_classic,
           output reg [ 7: 0 ] score_classic //[7:4] is player2 ,[3:0] is player1
       );
reg [ 3: 0 ] score1;
reg [ 3: 0 ] score2;
reg mytank1_state_last, mytank2_state_last;
initial begin
    gameover_classic <= 0;

    score_classic <= 0;

    score1 <= 0;
    score2 <= 0;
    score_classic <= 0;
end

always @( posedge clk ) begin
    if ( ~item_invincible && mytank1_state_last && ~mytank1_state ) begin
        HP1_value <= HP1_value - 1;
    end
    else begin
        HP1_value <= HP1_value;
    end
    if ( ~item_invincible && mytank2_state_last && ~mytank2_state ) begin
        HP2_value <= HP2_value - 1;
    end
    else begin
        HP2_value <= HP2_value;
    end
    if ( enable_game_classic == 1'b0 ) begin
        HP1_value <= 4;
        HP2_value <= 4;
    end
    mytank1_state_last <= mytank1_state;
    mytank2_state_last <= mytank2_state;
end
// always@( negedge enable_game_classic or negedge mytank1_state ) begin
//     if ( item_invincible == 0 ) begin
//         HP1_value <= HP1_value - 1;
//     end
//     else begin
//         HP1_value <= HP1_value;
//     end
//     if ( enable_game_classic == 1'b0 ) begin
//         HP1_value <= 4;
//     end
// end

// always@( negedge enable_game_classic or negedge mytank2_state ) begin
//     if ( item_invincible == 0 ) begin
//         HP2_value <= HP2_value - 1;
//     end
//     else begin
//         HP2_value <= HP2_value;
//     end
//     if ( enable_game_classic == 1'b0 ) begin
//         HP2_value <= 4;
//     end
// end

always @( posedge clk ) begin
    if ( !enable_game_classic ) begin
        gameover_classic <= 0;
        if ( btn_return ) begin
            score1 <= 0;
            score2 <= 0;
            score_classic <= 0;
        end
        else begin
            score_classic[ 7: 4 ] <= score2[ 3: 0 ];
            score_classic[ 3: 0 ] <= score1[ 3: 0 ];
        end
    end
    else begin
        score_classic <= 0;
        score1 <= scorea1 + scoreb1 + scorec1 + scored1;
        score2 <= scorea2 + scoreb2 + scorec2 + scored2;
        score_classic[ 7: 4 ] <= score2[ 3: 0 ];
        score_classic[ 3: 0 ] <= score1[ 3: 0 ];
        if ( HP1_value == 0 || HP2_value == 0 || score1 >= 8 || score2 >= 8 ) begin
            gameover_classic <= 1;
        end

    end
end

assign led_classic[ 0 ] = enable_game_classic ? ( HP1_value > 0 ) : 0;
assign led_classic[ 1 ] = enable_game_classic ? ( HP1_value > 1 ) : 0;
assign led_classic[ 2 ] = enable_game_classic ? ( HP1_value > 2 ) : 0;
assign led_classic[ 3 ] = enable_game_classic ? ( HP1_value > 3 ) : 0;
assign led_classic[ 4 ] = enable_game_classic ? ( HP1_value > 4 ) : 0;
assign led_classic[ 5 ] = enable_game_classic ? ( HP1_value > 5 ) : 0;
assign led_classic[ 6 ] = enable_game_classic ? ( HP1_value > 6 ) : 0;
assign led_classic[ 7 ] = enable_game_classic ? ( HP1_value > 7 ) : 0;

assign led_classic[ 8 ] = enable_game_classic ? ( HP2_value > 0 ) : 0;
assign led_classic[ 9 ] = enable_game_classic ? ( HP2_value > 1 ) : 0;
assign led_classic[ 10 ] = enable_game_classic ? ( HP2_value > 2 ) : 0;
assign led_classic[ 11 ] = enable_game_classic ? ( HP2_value > 3 ) : 0;
assign led_classic[ 12 ] = enable_game_classic ? ( HP2_value > 4 ) : 0;
assign led_classic[ 13 ] = enable_game_classic ? ( HP2_value > 5 ) : 0;
assign led_classic[ 14 ] = enable_game_classic ? ( HP2_value > 6 ) : 0;
assign led_classic[ 15 ] = enable_game_classic ? ( HP2_value > 7 ) : 0;


endmodule
