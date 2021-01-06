`timescale 1ns / 1ps

module control_signals(
           clk, reset_n,
           item_invincible,
           player1_bullet_H, player1_bullet_V, player2_bullet_H, player2_bullet_V,
           enermy1_bullet_H, enermy1_bullet_V,
           enermy2_bullet_H, enermy2_bullet_V,
           enermy3_bullet_H, enermy3_bullet_V,
           enermy4_bullet_H, enermy4_bullet_V,
           player1_bullet_dir, player2_bullet_dir,
           enermy1_bullet_dir, enermy2_bullet_dir, enermy3_bullet_dir, enermy4_bullet_dir,
           player1_tank_H, player1_tank_V, player2_tank_H, player2_tank_V,
           enermy1_tank_H, enermy1_tank_V,
           enermy2_tank_H, enermy2_tank_V,
           enermy3_tank_H, enermy3_tank_V,
           enermy4_tank_H, enermy4_tank_V,
           //    player1_tank_en, player2_tank_en,
           player1_moving, player2_moving,
           enermy1_moving, enermy2_moving, enermy3_moving, enermy4_moving,
           player1_tank_dir, player2_tank_dir,
           enermy1_tank_dir, enermy2_tank_dir, enermy3_tank_dir, enermy4_tank_dir,
           player1_revive, player2_revive,
           enermy1_revive, enermy2_revive, enermy3_revive, enermy4_revive,
           player1_tank_en_feedback, player2_tank_en_feedback,
           enermy1_tank_en_feedback, enermy2_tank_en_feedback, enermy3_tank_en_feedback, enermy4_tank_en_feedback,
           player1_tank_move_en, player2_tank_move_en,
           enermy1_tank_move_en, enermy2_tank_move_en, enermy3_tank_move_en, enermy4_tank_move_en,
           player1_bullet_en, player2_bullet_en,
           enermy1_bullet_en, enermy2_bullet_en, enermy3_bullet_en, enermy4_bullet_en, player1_scored, player2_scored
           //    scorea1, scorea2, scoreb1, scoreb2, scorec1, scorec2, scored1, scored2
       );
input clk, reset_n;
input item_invincible;
input [ 10: 0 ] player1_bullet_H, player1_bullet_V, player2_bullet_H, player2_bullet_V;
input [ 10: 0 ] enermy1_bullet_H, enermy1_bullet_V,
      enermy2_bullet_H, enermy2_bullet_V,
      enermy3_bullet_H, enermy3_bullet_V,
      enermy4_bullet_H, enermy4_bullet_V;

input [ 10: 0 ] player1_tank_H, player1_tank_V, player2_tank_H, player2_tank_V;
input [ 10: 0 ] enermy1_tank_H, enermy1_tank_V,
      enermy2_tank_H, enermy2_tank_V,
      enermy3_tank_H, enermy3_tank_V,
      enermy4_tank_H, enermy4_tank_V;
// input player1_tank_en, player2_tank_en;
input [ 2: 0 ] player1_bullet_dir, player2_bullet_dir;
input [ 2: 0 ] enermy1_bullet_dir, enermy2_bullet_dir, enermy3_bullet_dir, enermy4_bullet_dir;

input player1_revive, player2_revive;
input enermy1_revive, enermy2_revive, enermy3_revive, enermy4_revive;

input [ 1: 0 ] player1_tank_dir, player2_tank_dir;
input [ 1: 0 ] enermy1_tank_dir, enermy2_tank_dir, enermy3_tank_dir, enermy4_tank_dir;
input player1_moving, player2_moving;
input enermy1_moving, enermy2_moving, enermy3_moving, enermy4_moving;
output reg player1_tank_en_feedback, player2_tank_en_feedback;
output reg enermy1_tank_en_feedback, enermy2_tank_en_feedback, enermy3_tank_en_feedback, enermy4_tank_en_feedback;
output reg player1_tank_move_en, player2_tank_move_en;
output reg enermy1_tank_move_en, enermy2_tank_move_en, enermy3_tank_move_en, enermy4_tank_move_en;
output reg player1_bullet_en, player2_bullet_en;
output reg enermy1_bullet_en, enermy2_bullet_en, enermy3_bullet_en, enermy4_bullet_en;
output reg player1_scored, player2_scored;
// output reg [ 3: 0 ] scorea1, scorea2, scoreb1, scoreb2, scorec1, scorec2, scored1, scored2;
parameter HEIGHT = 480;
parameter WIDTH = 640;
parameter BULLET_LONGER = 10;
parameter BULLET_SHORTER = 5;
parameter TANK_WIDTH = 32;
parameter TANK_HEIGHT = 32;

initial begin
    player1_tank_en_feedback <= 1'b1;
    player2_tank_en_feedback <= 1'b1;
    enermy1_tank_en_feedback <= 1'b1;
    enermy2_tank_en_feedback <= 1'b1;
    enermy3_tank_en_feedback <= 1'b1;
    enermy4_tank_en_feedback <= 1'b1;

    player1_tank_move_en <= 1'b1;
    player2_tank_move_en <= 1'b1;
    enermy1_tank_move_en <= 1'b1;
    enermy2_tank_move_en <= 1'b1;
    enermy3_tank_move_en <= 1'b1;
    enermy4_tank_move_en <= 1'b1;

    player1_bullet_en <= 1'b1;
    player2_bullet_en <= 1'b1;
    enermy1_bullet_en <= 1'b1;
    enermy2_bullet_en <= 1'b1;
    enermy3_bullet_en <= 1'b1;
    enermy4_bullet_en <= 1'b1;
    // scorea1 <= 0;
    // scorea2 <= 0;
    // scoreb1 <= 0;
    // scoreb2 <= 0;
    // scorec1 <= 0;
    // scorec2 <= 0;
    // scored1 <= 0;
    // scored2 <= 0;
end

wire [ 3: 0 ] player1_bullet_collide, player2_bullet_collide;
wire [ 3: 0 ] player2_tank_collide_tmp, player1_tank_collide_tmp;
wire [ 7: 0 ] enermy_tank_collide;
wire [ 1: 0 ] enermy1_bullet_collide, enermy2_bullet_collide, enermy3_bullet_collide, enermy4_bullet_collide;

wire [ 3: 0 ] player1_tank_collide, player2_tank_collide;
wire [ 4: 0 ] enermy1_tank_collide, enermy2_tank_collide, enermy3_tank_collide, enermy4_tank_collide;
wire [ 3: 0 ] player1_tank_tmp, player2_tank_tmp;
wire [ 4: 0 ] enermy1_tank_tmp, enermy2_tank_tmp, enermy3_tank_tmp, enermy4_tank_tmp;

// reg player1_tank_destroyed, player2_tank_destroyed;
// object_collide_detection enermy1_mytank1(
//                              enermy1_bullet_H, enermy1_bullet_V, ~enermy1_bullet_dir[ 2 ], enermy1_bullet_dir[ 1: 0 ],
//                              BULLET_LONGER, BULLET_SHORTER,
//                              enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir[ 1: 0 ],
//                              TANK_HEIGHT, TANK_WIDTH,
//                              player1_bullet_collide[ 0 ], enermy_tank_collide[ 0 ]
//                          );

//tank's collide   not bullet
//player1 's tank
object_collide_detection tank1_enermy1(
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_tank_collide[ 0 ], player1_tank_tmp[ 0 ]
                         );
object_collide_detection tank1_enermy2(
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_tank_collide[ 1 ], player1_tank_tmp[ 1 ]
                         );
object_collide_detection tank1_enermy3(
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_tank_collide[ 2 ], player1_tank_tmp[ 2 ]
                         );
object_collide_detection tank1_enermy4(
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_tank_collide[ 3 ], player1_tank_tmp[ 3 ]
                         );


//player2 's tank
object_collide_detection tank2_enermy1(
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_tank_collide[ 0 ], player2_tank_tmp[ 0 ]
                         );
object_collide_detection tank2_enermy2(
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_tank_collide[ 1 ], player2_tank_tmp[ 1 ]
                         );
object_collide_detection tank2_enermy3(
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_tank_collide[ 2 ], player2_tank_tmp[ 2 ]
                         );
object_collide_detection tank2_enermy4(
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_tank_collide[ 3 ], player2_tank_tmp[ 3 ]
                         );




//here is enermy tank's collide
object_collide_detection enermy1_tank1(
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_collide[ 0 ], enermy1_tank_tmp[ 0 ]
                         );
object_collide_detection enermy1_tank2(
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_collide[ 1 ], enermy1_tank_tmp[ 1 ]
                         );
object_collide_detection enermy1_enermy2(
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_collide[ 2 ], enermy1_tank_tmp[ 2 ]
                         );
object_collide_detection enermy1_enermy3(
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_collide[ 3 ], enermy1_tank_tmp[ 3 ]
                         );
object_collide_detection enermy1_enermy4(
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_collide[ 4 ], enermy1_tank_tmp[ 4 ]
                         );



object_collide_detection enermy2_tank1(
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_collide[ 0 ], enermy2_tank_tmp[ 0 ]
                         );
object_collide_detection enermy2_tank2(
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_collide[ 1 ], enermy2_tank_tmp[ 1 ]
                         );
object_collide_detection enermy2_enermy1(
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_collide[ 2 ], enermy2_tank_tmp[ 2 ]
                         );
object_collide_detection enermy2_enermy3(
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_collide[ 3 ], enermy2_tank_tmp[ 3 ]
                         );
object_collide_detection enermy2_enermy4(
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_collide[ 4 ], enermy2_tank_tmp[ 4 ]
                         );


object_collide_detection enermy3_tank1(
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_collide[ 0 ], enermy3_tank_tmp[ 0 ]
                         );
object_collide_detection enermy3_tank2(
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_collide[ 1 ], enermy3_tank_tmp[ 1 ]
                         );
object_collide_detection enermy3_enermy1(
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_collide[ 2 ], enermy3_tank_tmp[ 2 ]
                         );
object_collide_detection enermy3_enermy2(
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_collide[ 3 ], enermy3_tank_tmp[ 3 ]
                         );
object_collide_detection enermy3_enermy4(
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_collide[ 4 ], enermy3_tank_tmp[ 4 ]
                         );


object_collide_detection enermy4_tank1(
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_collide[ 0 ], enermy4_tank_tmp[ 0 ]
                         );
object_collide_detection enermy4_tank2(
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_collide[ 1 ], enermy4_tank_tmp[ 1 ]
                         );
object_collide_detection enermy4_enermy1(
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_collide[ 2 ], enermy4_tank_tmp[ 2 ]
                         );
object_collide_detection enermy4_enermy2(
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_collide[ 3 ], enermy4_tank_tmp[ 3 ]
                         );
object_collide_detection enermy4_enermy3(
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_tank_collide[ 4 ], enermy4_tank_tmp[ 4 ]
                         );

//here is bullet collide
object_collide_detection enermy1_mytank1(
                             enermy1_bullet_H, enermy1_bullet_V, ~enermy1_bullet_dir[ 2 ], enermy1_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_bullet_collide[ 0 ], player1_tank_collide_tmp[ 0 ]
                         );
object_collide_detection enermy2_mytank1(
                             enermy2_bullet_H, enermy2_bullet_V, ~enermy2_bullet_dir[ 2 ], enermy2_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_bullet_collide[ 0 ], player1_tank_collide_tmp[ 1 ]
                         );
object_collide_detection enermy3_mytank1(
                             enermy3_bullet_H, enermy3_bullet_V, ~enermy3_bullet_dir[ 2 ], enermy3_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_bullet_collide[ 0 ], player1_tank_collide_tmp[ 2 ]
                         );
object_collide_detection enermy4_mytank1(
                             enermy4_bullet_H, enermy4_bullet_V, ~enermy4_bullet_dir[ 2 ], enermy4_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_bullet_collide[ 0 ], player1_tank_collide_tmp[ 3 ]
                         );
object_collide_detection enermy1_mytank2(
                             enermy1_bullet_H, enermy1_bullet_V, ~enermy1_bullet_dir[ 2 ], enermy1_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy1_bullet_collide[ 1 ], player2_tank_collide_tmp[ 0 ]
                         );
object_collide_detection enermy2_mytank2(
                             enermy2_bullet_H, enermy2_bullet_V, ~enermy2_bullet_dir[ 2 ], enermy2_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy2_bullet_collide[ 1 ], player2_tank_collide_tmp[ 1 ]
                         );
object_collide_detection enermy3_mytank2(
                             enermy3_bullet_H, enermy3_bullet_V, ~enermy3_bullet_dir[ 2 ], enermy3_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy3_bullet_collide[ 1 ], player2_tank_collide_tmp[ 2 ]
                         );
object_collide_detection enermy4_mytank2(
                             enermy4_bullet_H, enermy4_bullet_V, ~enermy4_bullet_dir[ 2 ], enermy4_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             enermy4_bullet_collide[ 1 ], player2_tank_collide_tmp[ 3 ]
                         );


object_collide_detection mytank1_enermy1(
                             player1_bullet_H, player1_bullet_V, ~player1_bullet_dir[ 2 ], player1_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_bullet_collide[ 0 ], enermy_tank_collide[ 0 ]
                         );
object_collide_detection mytank1_enermy2(
                             player1_bullet_H, player1_bullet_V, ~player1_bullet_dir[ 2 ], player1_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_bullet_collide[ 1 ], enermy_tank_collide[ 1 ]
                         );
object_collide_detection mytank1_enermy3(
                             player1_bullet_H, player1_bullet_V, ~player1_bullet_dir[ 2 ], player1_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_bullet_collide[ 2 ], enermy_tank_collide[ 2 ]
                         );
object_collide_detection mytank1_enermy4(
                             player1_bullet_H, player1_bullet_V, ~player1_bullet_dir[ 2 ], player1_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             player1_bullet_collide[ 3 ], enermy_tank_collide[ 3 ]
                         );
object_collide_detection mytank2_enermy1(
                             player2_bullet_H, player2_bullet_V, ~player2_bullet_dir[ 2 ], player2_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             enermy1_tank_H, enermy1_tank_V, enermy1_tank_en_feedback, enermy1_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_bullet_collide[ 0 ], enermy_tank_collide[ 4 ]
                         );
object_collide_detection mytank2_enermy2(
                             player2_bullet_H, player2_bullet_V, ~player2_bullet_dir[ 2 ], player2_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             enermy2_tank_H, enermy2_tank_V, enermy2_tank_en_feedback, enermy2_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_bullet_collide[ 1 ], enermy_tank_collide[ 5 ]
                         );
object_collide_detection mytank2_enermy3(
                             player2_bullet_H, player2_bullet_V, ~player2_bullet_dir[ 2 ], player2_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             enermy3_tank_H, enermy3_tank_V, enermy3_tank_en_feedback, enermy3_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_bullet_collide[ 2 ], enermy_tank_collide[ 6 ]
                         );
object_collide_detection mytank2_enermy4(
                             player2_bullet_H, player2_bullet_V, ~player2_bullet_dir[ 2 ], player2_bullet_dir[ 1: 0 ],
                             BULLET_LONGER, BULLET_SHORTER,
                             enermy4_tank_H, enermy4_tank_V, enermy4_tank_en_feedback, enermy4_tank_dir[ 1: 0 ],
                             TANK_HEIGHT, TANK_WIDTH,
                             player2_bullet_collide[ 3 ], enermy_tank_collide[ 7 ]
                         );

// object_collide_detection bullet1_tank2(
//                              player1_bullet_H, player1_bullet_V, ~player1_bullet_dir[ 2 ], player1_bullet_dir[ 1: 0 ],
//                              BULLET_LONGER, BULLET_SHORTER,
//                              player2_tank_H, player2_tank_V, player2_tank_en_feedback, player2_tank_dir[ 1: 0 ],
//                              TANK_HEIGHT, TANK_WIDTH,
//                              player1_bullet_collide[ 1 ], player2_tank_collide[ 4 ]
//                          );

// object_collide_detection bullet2_tank1(
//                              player2_bullet_H, player2_bullet_V, ~player2_bullet_dir[ 2 ], player2_bullet_dir[ 1: 0 ],
//                              BULLET_LONGER, BULLET_SHORTER,
//                              player1_tank_H, player1_tank_V, player1_tank_en_feedback, player1_tank_dir[ 1: 0 ],
//                              TANK_HEIGHT, TANK_WIDTH,
//                              player2_bullet_collide[ 1 ], player1_tank_collide[ 4 ]
//                          );



// always @( posedge player1_bullet_collide[ 0 ] or posedge player1_bullet_collide[ 1 ] or posedge player1_bullet_collide[ 2 ] or posedge player1_bullet_collide[ 3 ] ) begin
//     if ( reset_n ) begin
//         scorea1 <= 0;
//         scoreb1 <= 0;
//         scorec1 <= 0;
//         scored1 <= 0;
//     end
//     else begin
//         if ( player1_bullet_collide[ 0 ] ) begin
//             scorea1 <= scorea1 + 1'b1;
//         end
//         else if ( player1_bullet_collide[ 1 ] ) begin
//             scoreb1 <= scoreb1 + 1'b1;
//         end
//         else if ( player1_bullet_collide[ 2 ] ) begin
//             scorec1 <= scorec1 + 1'b1;
//         end
//         else if ( player1_bullet_collide[ 3 ] ) begin
//             scored1 <= scored1 + 1'b1;
//         end
//     end
// end

// always @( posedge player2_bullet_collide[ 0 ] or posedge player2_bullet_collide[ 1 ] or posedge player2_bullet_collide[ 2 ] or posedge player2_bullet_collide[ 3 ] ) begin
//     if ( reset_n ) begin
//         scorea2 <= 0;
//         scoreb2 <= 0;
//         scorec2 <= 0;
//         scored2 <= 0;
//     end
//     else begin
//         if ( player2_bullet_collide[ 0 ] ) begin
//             scorea2 <= scorea2 + 1'b1;
//         end
//         else if ( player2_bullet_collide[ 1 ] ) begin
//             scoreb2 <= scoreb2 + 1'b1;
//         end
//         else if ( player2_bullet_collide[ 2 ] ) begin
//             scorec2 <= scorec2 + 1'b1;
//         end
//         else if ( player2_bullet_collide[ 3 ] ) begin
//             scored2 <= scored2 + 1'b1;
//         end
//     end
// end



always @( * ) begin: enermy1_bullet_enable_signal
    if ( enermy1_bullet_dir[ 2 ] ) begin
        enermy1_bullet_en <= 1;
    end
    else if ( | enermy1_bullet_collide ) begin
        enermy1_bullet_en <= 1;
    end

    else begin
        enermy1_bullet_en <= ~( ( ~enermy1_bullet_dir[ 2 ] ) && ( enermy1_bullet_V >= 0 && enermy1_bullet_V < HEIGHT - BULLET_LONGER &&
                                enermy1_bullet_H >= 0 && enermy1_bullet_H < WIDTH - BULLET_SHORTER ) );
    end
end

always @( * ) begin: enermy2_bullet_enable_signal
    if ( enermy2_bullet_dir[ 2 ] ) begin
        enermy2_bullet_en <= 1;
    end
    else if ( | enermy2_bullet_collide ) begin
        enermy2_bullet_en <= 1;
    end

    else begin
        enermy2_bullet_en <= ~( ( ~enermy2_bullet_dir[ 2 ] ) && ( enermy2_bullet_V >= 0 && enermy2_bullet_V < HEIGHT - BULLET_LONGER &&
                                enermy2_bullet_H >= 0 && enermy2_bullet_H < WIDTH - BULLET_SHORTER ) );
    end
end
always @( * ) begin: enermy3_bullet_enable_signal
    if ( enermy3_bullet_dir[ 2 ] ) begin
        enermy3_bullet_en <= 1;
    end
    else if ( | enermy3_bullet_collide ) begin
        enermy3_bullet_en <= 1;
    end

    else begin
        enermy3_bullet_en <= ~( ( ~enermy3_bullet_dir[ 2 ] ) && ( enermy3_bullet_V >= 0 && enermy3_bullet_V < HEIGHT - BULLET_LONGER &&
                                enermy3_bullet_H >= 0 && enermy3_bullet_H < WIDTH - BULLET_SHORTER ) );
    end
end
always @( * ) begin: enermy4_bullet_enable_signal
    if ( enermy4_bullet_dir[ 2 ] ) begin
        enermy4_bullet_en <= 1;
    end
    else if ( | enermy4_bullet_collide ) begin
        enermy4_bullet_en <= 1;
    end

    else begin
        enermy4_bullet_en <= ~( ( ~enermy4_bullet_dir[ 2 ] ) && ( enermy4_bullet_V >= 0 && enermy4_bullet_V < HEIGHT - BULLET_LONGER &&
                                enermy4_bullet_H >= 0 && enermy4_bullet_H < WIDTH - BULLET_SHORTER ) );
    end
end
always @( * ) begin: player1_bullet_enable_signal
    if ( player1_bullet_dir[ 2 ] ) begin
        player1_bullet_en <= 1;
    end
    else if ( player1_bullet_collide[ 0 ] ) begin
        player1_bullet_en <= 1;
        // scorea1 <= scorea1 + 1'b1;
    end
    else if ( player1_bullet_collide[ 1 ] ) begin
        player1_bullet_en <= 1;
        // scoreb1 <= scoreb1 + 1'b1;
    end
    else if ( player1_bullet_collide[ 2 ] ) begin
        player1_bullet_en <= 1;
        // scorec1 <= scorec1 + 1'b1;
    end
    else if ( player1_bullet_collide[ 3 ] ) begin
        player1_bullet_en <= 1;
        // scored1 <= scored1 + 1'b1;
    end
    else begin
        player1_bullet_en <= ~( ( ~player1_bullet_dir[ 2 ] ) && ( player1_bullet_V >= 0 && player1_bullet_V < HEIGHT - BULLET_LONGER &&
                                player1_bullet_H >= 0 && player1_bullet_H < WIDTH - BULLET_SHORTER ) );
    end
end

always @( * ) begin: player2_bullet_enable_signal
    if ( player2_bullet_dir[ 2 ] ) begin
        player2_bullet_en <= 1;
    end
    else if ( player2_bullet_collide[ 0 ] ) begin
        player2_bullet_en <= 1;
        // scorea2 <= scorea2 + 1'b1;
    end
    else if ( player2_bullet_collide[ 1 ] ) begin
        player2_bullet_en <= 1;
        // scoreb2 <= scoreb2 + 1'b1;
    end
    else if ( player2_bullet_collide[ 2 ] ) begin
        player2_bullet_en <= 1;
        // scorec2 <= scorec2 + 1'b1;
    end
    else if ( player2_bullet_collide[ 3 ] ) begin
        player2_bullet_en <= 1;
        // scored2 <= scored2 + 1'b1;
    end
    else begin
        player2_bullet_en <= ~( ( ~player2_bullet_dir[ 2 ] ) && ( player2_bullet_V >= 0 && player2_bullet_V < HEIGHT - BULLET_LONGER &&
                                player2_bullet_H >= 0 && player2_bullet_H < WIDTH - BULLET_SHORTER ) );
    end
end

always @( posedge clk ) begin: enermy_tank_enable_signal
    player1_scored <= 0;
    player2_scored <= 0;
    if ( !reset_n ) begin
        enermy1_tank_en_feedback <= 1;
        enermy2_tank_en_feedback <= 1;
        enermy3_tank_en_feedback <= 1;
        enermy4_tank_en_feedback <= 1;
    end
    if ( enermy1_revive ) begin
        enermy1_tank_en_feedback <= 1;
    end
    else if ( enermy2_revive ) begin
        enermy2_tank_en_feedback <= 1;
    end
    else if ( enermy3_revive ) begin
        enermy3_tank_en_feedback <= 1;
    end
    else if ( enermy4_revive ) begin
        enermy4_tank_en_feedback <= 1;
    end
    if ( player1_bullet_collide[ 0 ] || player2_bullet_collide[ 0 ] ) begin
        enermy1_tank_en_feedback <= 0;
        if ( player1_bullet_collide[ 0 ] ) begin
            player1_scored <= 1;
        end
        else begin
            player2_scored <= 1;
        end
    end
    else if ( player1_bullet_collide[ 1 ] || player2_bullet_collide[ 1 ] ) begin
        enermy2_tank_en_feedback <= 0;
        if ( player1_bullet_collide[ 1 ] ) begin
            player1_scored <= 1;
        end
        else begin
            player2_scored <= 1;
        end
    end
    else if ( player1_bullet_collide[ 2 ] || player2_bullet_collide[ 2 ] ) begin
        enermy3_tank_en_feedback <= 0;
        if ( player1_bullet_collide[ 2 ] ) begin
            player1_scored <= 1;
        end
        else begin
            player2_scored <= 1;
        end
    end
    else if ( player1_bullet_collide[ 3 ] || player2_bullet_collide[ 3 ] ) begin
        enermy4_tank_en_feedback <= 0;
        if ( player1_bullet_collide[ 3 ] ) begin
            player1_scored <= 1;
        end
        else begin
            player2_scored <= 1;
        end
    end
    enermy1_tank_move_en <= ~( | enermy1_tank_collide );
    enermy2_tank_move_en <= ~( | enermy2_tank_collide );
    enermy3_tank_move_en <= ~( | enermy3_tank_collide );
    enermy4_tank_move_en <= ~( | enermy4_tank_collide );

end
// always @( posedge clk ) begin: enermy1_tank_enable_signal
//     player1_scored <= 0;
//     player2_scored <= 0;
//     if ( enermy1_revive ) begin
//         enermy1_tank_en_feedback <= 1;
//     end
//     else if ( !reset_n ) begin
//         enermy1_tank_en_feedback <= 1;
//         // scorea1 <= 0;
//         // scorea2 <= 0;
//     end
//     else if ( player1_bullet_collide[ 0 ] || player2_bullet_collide[ 0 ] ) begin
//         enermy1_tank_en_feedback <= 0;
//         if ( player1_bullet_collide[ 0 ] ) begin
//             player1_scored <= 1;
//         end
//         else begin
//             player2_scored <= 1;
//         end
//     end
//     enermy1_tank_move_en <= 1;
//     // if ( player2_tank_collide[ 0 ] && player2_moving ) begin
//     //     player2_tank_move_en <= 0;
//     // end
// end


// always @( posedge clk ) begin: enermy2_tank_enable_signal
//     player1_scored <= 0;
//     player2_scored <= 0;
//     if ( enermy2_revive ) begin
//         enermy2_tank_en_feedback <= 1;
//     end
//     else if ( !reset_n ) begin
//         enermy2_tank_en_feedback <= 1;
//         // scoreb1 <= 0;
//         // scoreb2 <= 0;
//     end
//     else if ( player1_bullet_collide[ 1 ] || player2_bullet_collide[ 1 ] ) begin
//         enermy2_tank_en_feedback <= 0;
//         if ( player1_bullet_collide[ 1 ] ) begin
//             player1_scored <= 1;
//         end
//         else begin
//             player2_scored <= 1;
//         end
//     end
//     enermy2_tank_move_en <= 1;
//     // if ( player2_tank_collide[ 0 ] && player2_moving ) begin
//     //     player2_tank_move_en <= 0;
//     // end
// end


// always @( posedge clk ) begin: enermy3_tank_enable_signal
//     player1_scored <= 0;
//     player2_scored <= 0;
//     if ( enermy3_revive ) begin
//          enermy3_tank_en_feedback <= 1;
//     end
//     else if ( !reset_n ) begin
//         enermy3_tank_en_feedback <= 1;
//         // scorec1 <= 0;
//         // scorec2 <= 0;
//     end
//     else if ( player1_bullet_collide[ 2 ] || player2_bullet_collide[ 2 ] ) begin
//         enermy3_tank_en_feedback <= 0;
//         if ( player1_bullet_collide[ 2 ] ) begin
//             player1_scored <= 1;
//         end
//         else begin
//             player2_scored <= 1;
//         end
//     end
//     enermy3_tank_move_en <= 1;
//     // if ( player2_tank_collide[ 0 ] && player2_moving ) begin
//     //     player2_tank_move_en <= 0;
//     // end
// end


// always @( posedge clk ) begin: enermy4_tank_enable_signal
//     player1_scored <= 0;
//     player2_scored <= 0;
//     if ( enermy4_revive ) begin
//         enermy4_tank_en_feedback <= 1;
//     end
//     else if ( !reset_n ) begin
//         enermy4_tank_en_feedback <= 1;
//         // scored1 <= 0;
//         // scored2 <= 0;
//     end
//     else if ( player1_bullet_collide[ 3 ] || player2_bullet_collide[ 3 ] ) begin
//         enermy4_tank_en_feedback <= 0;
//         if ( player1_bullet_collide[ 3 ] ) begin
//             player1_scored <= 1;
//         end
//         else begin
//             player2_scored <= 1;
//         end
//     end
//     enermy4_tank_move_en <= 1;
//     // if ( player2_tank_collide[ 0 ] && player2_moving ) begin
//     //     player2_tank_move_en <= 0;
//     // end
// end
always @( posedge clk ) begin: player2_tank_enable_signal

    if ( player2_revive || item_invincible ) begin
        player2_tank_en_feedback <= 1;
    end
    else if ( !reset_n ) begin
        player2_tank_en_feedback <= 1;
    end

    else if ( enermy1_bullet_collide[ 1 ] || enermy2_bullet_collide[ 1 ] || enermy3_bullet_collide[ 1 ] || enermy4_bullet_collide[ 1 ] ) begin
        player2_tank_en_feedback <= 0;
    end


    // player2_tank_en_feedback <= ~player1_bullet_collide[1];

    player2_tank_move_en <= ~( | player2_tank_collide );
end


always @( posedge clk ) begin: player1_tank_enable_signal
    if ( player1_revive || item_invincible ) begin
        player1_tank_en_feedback <= 1;
    end
    else if ( !reset_n ) begin
        player1_tank_en_feedback <= 1;
    end

    else if ( enermy1_bullet_collide[ 0 ] || enermy2_bullet_collide[ 0 ] || enermy3_bullet_collide[ 0 ] || enermy4_bullet_collide[ 0 ] ) begin
        player1_tank_en_feedback <= 0;
    end


    player1_tank_move_en <= ~( | player1_tank_collide );
end

endmodule
