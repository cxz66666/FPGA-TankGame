`timescale 1ns / 1ps


module Top(
           input wire clk,
           input wire PS2_CLK,
           input wire PS2_DAT,

           input wire BTNL,
           input wire BTNR,
           input wire BTNU,
           input wire BTND,
           input wire BTNC,
           //实现A,B两个操作数每按一下加1
           input wire [ 3: 0 ] SW,



           output wire [ 3: 0 ] VGARed,
           output wire [ 3: 0 ] VGABlue,
           output wire [ 3: 0 ] VGAGreen,
           output wire Hsync,
           output wire Vsync,
           output wire [ 7: 0 ] AN,
           output wire [ 7: 0 ] SEGMENT1,

           output wire [ 15: 0 ] LED

       );
wire clk_2Hz;
wire clk_4Hz;
wire clk_8Hz;
wire clk_100MHz;
wire clk_VGA;

wire [ 9: 0 ] KeyBoard_Output;

wire item_faster;
wire item_invincible;
wire item_addtime;
wire item_test;
wire [ 10: 0 ] vgaH, vgaV;
wire [ 11: 0 ] VGAData;
wire [ 11: 0 ] tankData;
wire [ 11: 0 ] backgroundData;
wire [ 1 : 0 ] player1_tank_dir, player2_tank_dir;
wire [ 10: 0 ] player1_tank_H, player1_tank_V, player2_tank_H, player2_tank_V;
wire [ 11: 0 ] player1_bullet_data;
wire [ 11: 0 ] player1_tank_data, player2_tank_data;
wire [ 2: 0 ] player1_tank_dir_feedback, player2_tank_dir_feedback;
wire player1_tank_en, player2_tank_en;
wire player1_tank_en_feedback, player2_tank_en_feedback;
wire [ 2: 0 ] player1_tank_moving_direction, player2_tank_moving_direction;

wire reset_n;

wire gameover_classic, gameover_infinity; //stop the game signal
wire enable_game_classic, enable_game_infinity; //the mode signal
wire start_protect; //when we button the begin button, it will continue 3000000 times until begin, and this will be 1 in this time
wire [ 2: 0 ] mode;
wire enable_music;
wire enable_player1_control, enable_player2_control, enable_player1_display,
     enable_player2_display, enable_player1_bullet, enable_player2_bullet;
wire enable_enermy1_control, enable_enermy2_control, enable_enermy3_control, enable_enermy4_control;
wire enable_enermy1_display, enable_enermy2_display, enable_enermy3_display, enable_enermy4_display;
wire enable_enermy1_bullet, enable_enermy2_bullet, enable_enermy3_bullet, enable_enermy4_bullet;

wire enable_reward;

wire	[ 3: 0 ] scorea1, scoreb1;
wire	[ 3: 0 ] scorea2, scoreb2;
wire	[ 3: 0 ] scorea3, scoreb3;
wire	[ 3: 0 ] scorea4, scoreb4;
wire [ 3: 0 ] player1_HP, player2_HP;

wire [ 15: 0 ] LED_classic, LED_infinity;
wire [ 7: 0 ] score_classic, score_infinity;
wire [ 4: 0 ] timer;

assign reset_n = ~BTNC;

clock MyClock(
          .clk_100MHz( clk ),
          .item_faster( item_faster ),
          .clk_2Hz( clk_2Hz ),
          .clk_4Hz( clk_4Hz ),
          .clk_8Hz( clk_8Hz )
      );
KeyBoard_PS2 My_Ps2(
                 .clk_in( clk ),
                 .rst_n_in( 1'b1 ),
                 .key_clk( PS2_CLK ),
                 .key_data( PS2_DAT ),
                 .out( KeyBoard_Output )
             );
clk_wiz_0 clk_vga( .clk_in1( clk ), .reset( 1'b0 ), .clk_25m( clk_VGA ) , .locked() );


game_mode u_game_mode(
              .clk( clk ),
              .btn_confirm( BTNC ),
              .btn_mode_sel( SW[ 0 ] ),
              .btn_return( BTNU ),                                          //the under button is used for return to the game
              .gameover_classic( gameover_classic ),
              .gameover_infinity( gameover_infinity ),
              .enable_shell1( enable_enermy1_bullet ),
              .enable_shell2( enable_enermy2_bullet ),
              .enable_shell3( enable_enermy3_bullet ),
              .enable_shell4( enable_enermy4_bullet ),
              .enable_enemytank1_control( enable_enermy1_control ),
              .enable_enemytank2_control( enable_enermy2_control ),
              .enable_enemytank3_control( enable_enermy3_control ),
              .enable_enemytank4_control( enable_enermy4_control ),
              .enable_enemytank1_display( enable_enermy1_display ),
              .enable_enemytank2_display( enable_enermy2_display ),
              .enable_enemytank3_display( enable_enermy3_display ),
              .enable_enemytank4_display( enable_enermy4_display ),

              .enable_myshell1( enable_player1_bullet ),
              .enable_myshell2( enable_player2_bullet ),
              .enable_mytank1_control( enable_player1_control ),
              .enable_mytank2_control( enable_player2_control ),
              .enable_mytank1_display( enable_player1_display ),
              .enable_mytank2_display( enable_player2_display ),

              .enable_game_classic( enable_game_classic ),
              .enable_game_infinity( enable_game_infinity ),
              .enable_reward( enable_reward ),
              .start_protect( start_protect ),
              .enable_gamemusic( enable_gamemusic ),
              .mode( mode )
          );
game_logic_classic u_game_logic_classic(
                       .clk( clk ),
                       .btn_return( BTNU ),
                       .btn_stop( BTND ),
                       .enable_game_classic( enable_game_classic ),
                       .mytank1_state( player1_tank_en ),
                       .mytank2_state( player2_tank_en ),
                       .scorea1( scorea1 ),
                       .scorea2( scorea2 ),
                       .scoreb1( scoreb1 ),
                       .scoreb2( scoreb2 ),
                       .scorec1( scorec1 ),
                       .scorec2( scorec2 ),
                       .scored1( scored1 ),
                       .scored2( scored2 ),
                       .item_invincible( item_invincible ),
                       .HP1_value( player1_HP ),
                       .HP2_value( player2_HP ),
                       .gameover_classic( gameover_classic ),
                       .led_classic( LED_classic ),
                       .score_classic( score_classic )
                   );
game_logic_infinity u_game_logic_infinity(
                        .clk( clk ),
                        .btn_return( BTNU ),
                        .btn_stop( BTND ),
                        .enable_game_infinity( enable_game_infinity ),
                        .mytank1_state( player1_tank_en ),
                        .mytank2_state( player2_tank_en ),
                        .scorea1( scorea1 ),
                        .scorea2( scorea2 ),
                        .scoreb1( scoreb1 ),
                        .scoreb2( scoreb2 ),
                        .scorec1( scorec1 ),
                        .scorec2( scorec2 ),
                        .scored1( scored1 ),
                        .scored2( scored2 ),
                        .item_addtime( item_addtime ),
                        .item_test( item_test ),
                        .item_invincible( item_invincible ),
                        .timer( timer ),
                        .gameover_infinity( gameover_infinity ),
                        .led_infinity( LED_infinity ),
                        .score_infinity( score_infinity )
                    );



vga_driver u_vga_driver(
               .clk_vga( clk_VGA ),
               .rst_n( 1'b1 ),
               .vga_en( 1'b1 ),
               .HSync( Hsync ),
               .VSync( Vsync ),
               .vgaRed( VGARed ),
               .vgaBlue( VGABlue ),
               .vgaGreen( VGAGreen ),
               .vgaData( VGAData ),
               .vgaH( vgaH ),
               .vgaV( vgaV )
           );

vga_data_background u_data_background(
                        .clk( clk ),
                        .vgaH( vgaH ),
                        .vgaV( vgaV ),
                        .sw_mode_sel( SW[ 0 ] ),
                        .mode( mode ),
                        .vgaData( backgroundData )
                    );

vga_data_selector u_vga_data_selector(
                      .clk( clk ),
                      .in1( backgroundData ),
                      .in2( player1_tank_data ),
                      .in3( player1_bullet_data ),
                      .in4( player2_tank_data ),
                      .out( VGAData )
                  );

tank_display u_tank1_display(
                 .clk( clk ),
                 .tankDir( player1_tank_dir ),
                 .tank_destroyed( ~player1_tank_en ),
                 .vgaH( vgaH ),
                 .vgaV( vgaV ),
                 .tankH( player1_tank_H ),
                 .tankV( player1_tank_V ),
                 .tankData( player1_tank_data )
             );

tank_display u_tank2_display(
                 .clk( clk ),
                 .tankDir( player2_tank_dir ),
                 .tank_destroyed( ~player2_tank_en ),
                 .vgaH( vgaH ),
                 .vgaV( vgaV ),
                 .tankH( player2_tank_H ),
                 .tankV( player2_tank_V ),
                 .tankData( player2_tank_data )
             );

tank_move player1_tank_move(
              clk, reset_n, 1,
              150, 150,
              player1_tank_dir, player1_tank_en, player1_tank_move_en, player1_moving,
              player1_tank_H, player1_tank_V, player1_tank_moving_direction
          );

tank_move player2_tank_move(
              clk, reset_n, 1,
              350, 350,
              player2_tank_dir, player2_tank_en, player2_tank_move_en, player2_moving,
              player2_tank_H, player2_tank_V, player2_tank_moving_direction
          );


control u_control(
            .clk( clk ),
            .ps2_output( KeyBoard_Output ),
            .player1_dir_feedback( player1_tank_dir ),
            .player1_fire( player1_fire ),
            .player1_moving( player1_moving ),
            .player2_dir_feedback( player2_tank_dir ),
            .player2_fire( player2_fire ),
            .player2_moving( player2_moving )
        );

wire player1_bullet_en_feedback, player2_bullet_en_feedback;
wire player1_bullet_en, player2_bullet_en;
wire [ 10: 0 ] player1_bullet_H, player1_bullet_V;
wire [ 2: 0 ] player1_bullet_dir;
wire player1_revive, player2_revive;
assign player1_revive = 0;
assign player2_revive = 0;

control_signals u_control_signals(
                    clk, rst_n,
                    player1_bullet_H, player1_bullet_V, player2_bullet_H, player2_bullet_V,
                    player1_bullet_dir, player2_bullet_dir,
                    player1_tank_H, player1_tank_V, player2_tank_H, player2_tank_V,
                    //    player1_tank_en, player2_tank_en,
                    player1_moving, player2_moving,
                    player1_tank_dir, player2_tank_dir,
                    player1_revive, player2_revive,
                    player1_tank_en, player2_tank_en,
                    player1_tank_move_en, player2_tank_move_en,
                    player1_bullet_en, player2_bullet_en
                );


bullet_control bullet_player1(
                   .clk( clk ),
                   .reset_n( 1 ),
                   .tank_H( player1_tank_H ),
                   .tank_V( player1_tank_V ),
                   //   .tank_en(player1_tank_en),
                   .tank_dir( player1_tank_dir ),
                   .tank_fire( player1_fire ),
                   .vgaV( vgaV ),
                   .vgaH( vgaH ),
                   .start( 1 ),
                   .ready( player1_bullet_en ),
                   .bulletData( player1_bullet_data ),
                   .bullet_H_feedback( player1_bullet_H ),
                   .bullet_V_feedback( player1_bullet_V ),
                   .bullet_direction( player1_bullet_dir )
               );



assign item_faster = 0;
assign item_addtime = 0;
assign item_invincible = 0;
assign item_test = 0;



wire [ 31: 0 ] num ;
// assign num = { 3'b000, KeyBoard_Output[ 0 ], 3'b000, KeyBoard_Output[ 1 ], 3'b000, KeyBoard_Output[ 2 ], 3'b000, KeyBoard_Output[ 3 ],
//                3'b000, KeyBoard_Output[ 4 ], 3'b000, KeyBoard_Output[ 5 ], 3'b000, KeyBoard_Output[ 6 ], 3'b000, KeyBoard_Output[ 7 ] };
// assign num = { 20'b0000_0000_0000_0000_0000, VGARed[ 3: 0 ], VGAGreen[ 3: 0 ], VGABlue[ 3: 0 ] };
// assign num = { 3'b000, player1_tank_collide[7], 3'b000, player1_tank_collide[6], 3'b000, player1_tank_collide[5], 3'b000, player1_tank_collide[4],
//               player1_bullet_H[7:0], player1_bullet_V[7:0] };

assign num = { 3'b000, player1_moving, 3'b000, player1_tank_dir[ 1 ], 3'b000, player1_tank_dir[ 0 ], 4'b0000, 3'b000, player1_moving, 3'b000, player1_tank_en, 3'b000, player2_tank_en, 3'b000, player1_tank_move_en };
// Disp_Num my_Disp_Num(
//              .clk( clk ),
//              .RST( 1'b0 ),
//              .HEXS( num ),
//              .points( 8'b1 ),
//              .LES( 8'b0 ),
//              .AN( AN ),
//              .Segment( SEGMENT1 )
//          );

SegAndLed u_SegAndLed(
              .clk( clk ),
              .mode( mode ),
              .led_classic( LED_classic ),
              .led_infinity( LED_infinity ),
              .score_classic( score_classic ),
              .score_infinity( score_infinity ),
              .timer( timer ),
              .default_num( num ),              //when mode ==00(before begin mode) then output num ,you can also use it as debug
              .enable_game_classic( enable_game_classic ),
              .enable_game_infinity( enable_game_infinity ),
              .AN( AN ),
              .Segment( SEGMENT1 ),
              .LED( LED )

          );
endmodule
