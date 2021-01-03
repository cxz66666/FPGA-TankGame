`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/28/2020 08:31:42 PM
// Design Name:
// Module Name: game_logic_infinity
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


module game_logic_infinity(
           input clk,
           input btn_return,
           input btn_stop,
           input enable_game_infinity,
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
           input item_addtime,
           input item_test,

           input item_invincible,

           output reg [ 4: 0 ] timer,

           output reg gameover_infinity,

           output wire [ 15: 0 ] led_infinity,
           output reg [ 7: 0 ] score_infinity,       //[7:4] is player2 ,[3:0] is player1
           output reg timeup
       );


reg [ 31: 0 ] cnt;
reg [ 3: 0 ] score1;
reg [ 3: 0 ] score2;
reg add_flag;
reg item_flag;
reg [ 1: 0 ] HP1_value, HP2_value;
reg mytank1_state_last, mytank2_state_last;

initial begin
    gameover_infinity <= 0;
    cnt <= 0;
    timer <= 16;
    score_infinity <= 0;
    score1 <= 0;
    score2 <= 0;
    add_flag <= 0;
    item_flag <= 0;
    HP1_value <= 2;
    HP2_value <= 2;
    timeup <= 0;
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
    if ( enable_game_infinity == 1'b0 ) begin
        HP1_value <= 2;
        HP2_value <= 2;
    end
    mytank1_state_last <= mytank1_state;
    mytank2_state_last <= mytank2_state;
end

// always @( negedge mytank1_state ) begin
//     if ( item_invincible == 0 ) begin
//         HP1 <= HP1 - 1;
//     end
//     else begin
//         HP1 <= HP1;
//     end
//     if ( enable_game_infinity == 1'b0 ) begin
//         HP1 <= 2;
//     end
// end

// always @( negedge mytank2_state ) begin
//     if ( item_invincible == 0 ) begin
//         HP2 <= HP2 - 1;
//     end
//     else begin
//         HP2 <= HP2;
//     end
//     if ( enable_game_infinity == 1'b0 ) begin
//         HP2 <= 2;
//     end
// end


always @( posedge clk ) begin
    if ( !enable_game_infinity ) begin
        gameover_infinity <= 0;
        cnt <= 0;
        timer <= 16;
        if ( btn_return ) begin
            score1 <= 0;
            score2 <= 0;
            score_infinity <= 0;
            timeup <= 0;
        end
        else begin
            score_infinity[ 7: 4 ] <= score2[ 3: 0 ];
            score_infinity[ 3: 0 ] <= score1[ 3: 0 ];
        end
    end

    else begin
        if ( timer == 0 || btn_stop || ( | HP1_value == 0 ) || ( | HP2_value == 0 ) ) begin
            timer <= 16;
            gameover_infinity <= 1;
            timeup <= 1'b1;
        end
        else begin
            if ( score1 < scorea1 + scoreb1 + scorec1 + scored1 ) begin
                if ( add_flag == 0 && timer > 0 && timer < 16 ) begin
                    timer <= timer + 4;
                    cnt <= 0;
                    add_flag = 1;
                end
            end
            else begin
                add_flag = 0;
            end
            if ( score2 < scorea2 + scoreb2 + scorec2 + scored2 ) begin
                if ( add_flag == 0 && timer > 0 && timer < 16 ) begin
                    timer <= timer + 4;
                    cnt <= 0;
                    add_flag = 1;
                end
            end
            else begin
                add_flag = 0;
            end

            score1 <= scorea1 + scoreb1 + scorec1 + scored1 ;
            score2 <= scorea2 + scoreb2 + scorec2 + scored2;

            if ( item_addtime == 1 || item_test ) begin
                if ( item_flag == 0 && timer > 0 && timer < 16 ) begin
                    begin
                        if ( timer == 15 ) begin
                            timer <= timer + 1;
                        end
                        else if ( timer == 14 ) begin
                            timer <= timer + 2;
                        end
                        else begin
                            timer <= timer + 3;
                        end
                        item_flag <= 1;
                    end
                end
                else begin
                    timer <= timer;
                    item_flag <= 1;
                end
            end
            else begin
                item_flag <= 0;
            end
            score_infinity[ 7: 4 ] <= score2[ 3: 0 ];
            score_infinity[ 3: 0 ] <= score1[ 3: 0 ];
            cnt <= cnt + 1;
            if ( cnt >= 100_000_000 ) begin
                timer <= timer - 1;
                cnt <= 0;
            end
        end

    end
end
assign led_infinity[ 0 ] = enable_game_infinity ? ( timer > 0 ) : 0;
assign led_infinity[ 1 ] = enable_game_infinity ? ( timer > 1 ) : 0;
assign led_infinity[ 2 ] = enable_game_infinity ? ( timer > 2 ) : 0;
assign led_infinity[ 3 ] = enable_game_infinity ? ( timer > 3 ) : 0;
assign led_infinity[ 4 ] = enable_game_infinity ? ( timer > 4 ) : 0;
assign led_infinity[ 5 ] = enable_game_infinity ? ( timer > 5 ) : 0;
assign led_infinity[ 6 ] = enable_game_infinity ? ( timer > 6 ) : 0;
assign led_infinity[ 7 ] = enable_game_infinity ? ( timer > 7 ) : 0;

assign led_infinity [ 8 ] = enable_game_infinity ? ( timer > 8 ) : 0;
assign led_infinity [ 9 ] = enable_game_infinity ? ( timer > 9 ) : 0;
assign led_infinity [ 10 ] = enable_game_infinity ? ( timer > 10 ) : 0;
assign led_infinity [ 11 ] = enable_game_infinity ? ( timer > 11 ) : 0;
assign led_infinity [ 12 ] = enable_game_infinity ? ( timer > 12 ) : 0;
assign led_infinity [ 13 ] = enable_game_infinity ? ( timer > 13 ) : 0;
assign led_infinity [ 14 ] = enable_game_infinity ? ( timer > 14 ) : 0;
assign led_infinity [ 15 ] = enable_game_infinity ? ( timer > 15 ) : 0;
endmodule
