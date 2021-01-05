`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/18/2020 04:24:18 PM
// Design Name:
// Module Name: tank_display
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


module tank_display(
           input clk,
           input [ 1: 0 ] tankDir,
           input tank_destroyed,
           input [ 2: 0 ] mode,
           input tank_revive,
           input player_enermy,              //player is 0 and enermy is 1
           input [ 10: 0 ] vgaH,
           input [ 10: 0 ] vgaV,                              // Current VGA position
           input [ 10: 0 ] tankH,
           input [ 10: 0 ] tankV,                             // Current Y of tank
           output [ 11: 0 ] tankData
       );

parameter TANK_HEIGHT = 32;
parameter TANK_WIDTH = 32;
parameter HEIGHT = 480;
parameter WIDTH = 640;

wire tank_en;
assign tank_en = ( tankH + TANK_WIDTH > vgaH && tankH <= vgaH &&
                   tankV + TANK_HEIGHT > vgaV && tankV <= vgaV ) && ( mode == 1 || mode == 2 ) ? 1'b1 : 1'b0;


wire [ 9: 0 ] tankAddr;

wire [ 11: 0 ] tankLeftData;
wire [ 11: 0 ] tankRightData;
wire [ 11: 0 ] tankUpData;
wire [ 11: 0 ] tankDownData;

wire [ 11: 0 ] tankLeftData_enermy;
wire [ 11: 0 ] tankRightData_enermy;
wire [ 11: 0 ] tankUpData_enermy;
wire [ 11: 0 ] tankDownData_enermy;

wire [ 11: 0 ] outData;
wire [ 11: 0 ] outData_enermy;
wire [ 11: 0 ] outData_star;
assign tankAddr = tank_en ? ( ( vgaV - tankV ) * TANK_WIDTH + ( vgaH - tankH ) ) : 1'b0;

invincible_star_32_32 u_invincible_star_32_32(
                          .addra( tankAddr ), .clka( clk ), .douta( outData_star ), .ena( 1'b1 )
                      );

tank_left_img tank_left( .addra( tankAddr ), .clka( clk ), .douta( tankLeftData ), .ena( 1'b1 ) );
tank_right_img tank_right( .addra( tankAddr ), .clka( clk ), .douta( tankRightData ), .ena( 1'b1 ) );
tank_up_img tank_up( .addra( tankAddr ), .clka( clk ), .douta( tankUpData ), .ena( 1'b1 ) );
tank_down_img tank_down( .addra( tankAddr ), .clka( clk ), .douta( tankDownData ), .ena( 1'b1 ) );


enermy_tank_left e_tank_left( .addra( tankAddr ), .clka( clk ), .douta( tankLeftData_enermy ), .ena( 1'b1 ) );
enermy_tank_right e_tank_right( .addra( tankAddr ), .clka( clk ), .douta( tankRightData_enermy ), .ena( 1'b1 ) );
enermy_tank_up e_tank_up( .addra( tankAddr ), .clka( clk ), .douta( tankUpData_enermy ), .ena( 1'b1 ) );
enermy_tank_down e_tank_down( .addra( tankAddr ), .clka( clk ), .douta( tankDownData_enermy ), .ena( 1'b1 ) );


tank_data_selector tank_select( .clk( clk ), .UP( tankUpData ), .DOWN( tankDownData ), .LEFT( tankLeftData ),
                                .RIGHT( tankRightData ), .Dir( tankDir ), .tankData( outData ) );
tank_data_selector e_tank_select( .clk( clk ), .UP( tankUpData_enermy ), .DOWN( tankDownData_enermy ), .LEFT( tankLeftData_enermy ),
                                  .RIGHT( tankRightData_enermy ), .Dir( tankDir ), .tankData( outData_enermy ) );
assign tankData = ( ( tank_en & ~tank_destroyed ) ? ( player_enermy ? outData_enermy : outData ) : 0 ) | ( tank_revive ? outData_star : 0 );

endmodule
