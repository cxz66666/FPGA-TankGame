`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/05/2021 10:54:29 PM
// Design Name:
// Module Name: item_logic
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


module item_logic(
           input clk,
           input clk_4Hz,
           input enable_reward,
           input enable_game_classic,
           input enable_game_infinity,
           input [ 10: 0 ] player1_tank_H,
           input [ 10: 0 ] player1_tank_V,
           input player1_tank_en,
           input [ 1: 0 ] player1_tank_dir,
           input [ 10: 0 ] player2_tank_H,
           input [ 10: 0 ] player2_tank_V,
           input [ 1: 0 ] player2_tank_dir,
           input player2_tank_en,
           input [ 10: 0 ] VGA_h,
           input [ 10: 0 ] VGA_V,
           input reset_n,

           output reg item_invincible,
           output reg item_addtime,
           output reg item_frozen,
           output reg item_addHP,
           output reg item_faster,
           output reg which_player,
           output [ 11: 0 ] VGA_data_reward
       );

wire [ 2: 0 ] item_type;
wire [ 10: 0 ] random_xpos, random_ypos;
reg [ 31: 0 ] cnt;

wire	set_require;
reg	set_finish;

wire	[ 11: 0 ] VGA_data_information;
assign	VGA_data_reward = VGA_data_information;

initial begin
    cnt <= 0;
    item_invincible <= 0;
    item_addtime <= 0;
    item_frozen <= 0;
    item_addHP <= 0;
    which_player <= 0;
    item_faster <= 0;
end

wire player1_tank_get, player1_tank_tmp;
wire player2_tank_get, player2_tank_tmp;
parameter TANK_WIDTH = 32;
parameter TANK_HEIGHT = 32;
parameter ITEM_WIDTH = 20;
parameter ITEM_HEIGHT = 20;
object_collide_detection tank1_item(
                             player1_tank_H, player1_tank_V, player1_tank_en, player1_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             random_xpos, random_ypos, set_require , player1_tank_dir,
                             ITEM_HEIGHT, ITEM_WIDTH,
                             player1_tank_get, player1_tank_tmp
                         );


//player2 's tank
object_collide_detection tank2_item(
                             player2_tank_H, player2_tank_V, player2_tank_en, player2_tank_dir,
                             TANK_HEIGHT, TANK_WIDTH,
                             random_xpos, random_ypos, set_require , player1_tank_dir,
                             ITEM_HEIGHT, ITEM_WIDTH,
                             player2_tank_get, player2_tank_tmp
                         );


always @( posedge clk ) begin
    if ( enable_reward ) begin
        if ( set_require == 1'b1 && ( player1_tank_get || player2_tank_get ) ) begin
            case ( item_type )
                1: begin
                    if ( enable_game_classic ) begin
                        item_addHP <= 1'b1;
                        which_player <= player2_tank_get;
                    end
                    if ( enable_game_infinity ) begin
                        item_addtime <= 1'b1;
                        which_player <= player2_tank_get;
                    end
                end
                2: begin
                    item_frozen <= 1'b1;
                    which_player <= player2_tank_get;
                end
                3: begin
                    item_invincible <= 1'b1;
                    which_player <= player2_tank_get;
                end
                4: begin
                    item_faster <= 1'b1;
                    which_player <= player2_tank_get;

                end
                default : begin
                    item_addHP <= 1'b0;
                    item_addtime <= 1'b0;
                    item_frozen <= 1'b0;
                    item_invincible <= 1'b0;
                    item_faster <= 1'b0;
                end

            endcase
            set_finish <= 1'b1;
        end
        else begin
            set_finish <= 1'b0;
        end
        if ( item_faster ) begin
            cnt <= cnt + 1;
            if ( cnt >= 900000000 ) begin
                item_faster <= 1'b0;
                cnt <= 0;
            end
        end
        if ( item_invincible ) begin
            cnt <= cnt + 1;
            if ( cnt >= 800000000 ) begin
                item_invincible <= 1'b0;
                cnt <= 0;
            end
        end
        if ( item_addHP ) begin
            cnt <= cnt + 1;
            if ( cnt >= 5000 ) begin
                item_addHP <= 1'b0;
                cnt <= 0;
            end
        end
        if ( item_addtime ) begin
            cnt <= cnt + 1;
            if ( cnt >= 5000 ) begin
                item_addtime <= 1'b0;
                cnt <= 0;
            end
        end
        if ( item_frozen ) begin
            cnt <= cnt + 1;
            if ( cnt >= 400000000 ) begin
                item_frozen <= 1'b0;
                cnt <= 0;
            end
        end
    end
    else begin
        cnt <= 0;
        item_invincible <= 0;
        item_addtime <= 0;
        item_frozen <= 0;
        item_faster <= 0;
        item_addHP <= 0;
        which_player <= 0;
    end
end

item_random_generator u_item_random_generator(
                          .clk( clk ),
                          .clk_4Hz( clk_4Hz ),
                          .set_finish( set_finish ),
                          .enable( enable_reward ),
                          .dout( random_out ),
                          .item_type( item_type ),
                          .set_require( set_require ),
                          .random_xpos( random_xpos ),
                          .random_ypos( random_ypos )
                      );
item_display u_item_display(
                 .clk( clk ),
                 .set_require( set_require ),
                 .enable_reward( enable_reward ),
                 .enable_game_classic( enable_game_classic ),
                 .enable_game_infinity( enable_game_infinity ),
                 .random_xpos( random_xpos ),
                 .random_ypos( random_ypos ),
                 .item_type( item_type ),
                 .VGA_h( VGA_h ),
                 .VGA_V( VGA_V ),
                 .VGA_data( VGA_data_information )
             );
endmodule
