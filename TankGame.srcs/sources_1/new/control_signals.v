`timescale 1ns / 1ps

module control_signals(
    clk, reset_n,
    player1_bullet_H, player1_bullet_V, player2_bullet_H, player2_bullet_V,
    player1_bullet_dir, player2_bullet_dir,
    player1_tank_H, player1_tank_V, player2_tank_H, player2_tank_V,
//    player1_tank_en, player2_tank_en,
    player1_moving, player2_moving,
    player1_tank_dir, player2_tank_dir,
    player1_revive, player2_revive,
    player1_tank_en_feedback, player2_tank_en_feedback,
    player1_tank_move_en, player2_tank_move_en,
    player1_bullet_en, player2_bullet_en
);
input clk, reset_n;
input [10:0] player1_bullet_H, player1_bullet_V, player2_bullet_H, player2_bullet_V;
input [10:0] player1_tank_H, player1_tank_V, player2_tank_H, player2_tank_V;
// input player1_tank_en, player2_tank_en;
input [2:0] player1_bullet_dir, player2_bullet_dir;
input player1_revive, player2_revive;
input [1:0] player1_tank_dir, player2_tank_dir;
input player1_moving, player2_moving;
output reg player1_tank_en_feedback, player2_tank_en_feedback;
output reg player1_tank_move_en, player2_tank_move_en;
output reg player1_bullet_en, player2_bullet_en;

parameter HEIGHT = 480;
parameter WIDTH = 640;
parameter BULLET_LONGER = 10;
parameter BULLET_SHORTER = 5;
parameter TANK_WIDTH = 32;
parameter TANK_HEIGHT = 32;

wire [7:0] player1_bullet_collide, player2_bullet_collide;
wire [7:0] player1_tank_collide, player2_tank_collide;
reg player1_tank_destroyed, player2_tank_destroyed;

object_collide_detection bullet1_tank2(
    player1_bullet_H, player1_bullet_V, ~player1_bullet_dir[2], player1_bullet_dir[1:0],
    BULLET_LONGER, BULLET_SHORTER, 
    player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir[1:0],
    TANK_HEIGHT, TANK_WIDTH, 
    player1_bullet_collide[1], player2_tank_collide[4]
);

object_collide_detection tank1_tank2(
    player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
    TANK_HEIGHT, TANK_WIDTH,
    player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
    TANK_HEIGHT, TANK_WIDTH,
    player1_tank_collide[1], player2_tank_collide[0]
);


always @(*) begin: player1_bullet_enable_signal
    if(player1_bullet_dir[2]) player1_bullet_en <= 1;
    else if(player1_bullet_collide[1]) player1_bullet_en <= 1;
    else player1_bullet_en <= ~( (~player1_bullet_dir[2]) && (player1_bullet_V >= 0 && player1_bullet_V < HEIGHT - BULLET_LONGER &&
                player1_bullet_H >= 0 && player1_bullet_H < WIDTH - BULLET_SHORTER) );
end


always @(*) begin: player2_tank_enable_signal

    if(player2_revive) player2_tank_en_feedback <= 1;
    else if(!reset_n) player2_tank_en_feedback <= 1;
    else if(!player2_tank_en_feedback) player2_tank_en_feedback <= 0;
    else if(player1_bullet_collide[1]) player2_tank_en_feedback <= 0;
    else player2_tank_en_feedback <= 1;

    // player2_tank_en_feedback <= ~player1_bullet_collide[1];

    player2_tank_move_en <= 1;
    if(player2_tank_collide[0] && player2_moving) player2_tank_move_en <= 0;
end


always @(*) begin: player1_tank_enable_signal
    if(player1_revive) player1_tank_en_feedback <= 1;
    else if(!reset_n) player1_tank_en_feedback <= 1;
    else if(!player1_tank_en_feedback) player1_tank_en_feedback <= 0;
    else if(player1_tank_collide[5]) player1_tank_en_feedback <= 0;
    else player1_tank_en_feedback <= 1;

    player1_tank_move_en <= 1;
    if(player1_tank_collide[1] && player1_moving) player1_tank_move_en <= 0;
end

endmodule
