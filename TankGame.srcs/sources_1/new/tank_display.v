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
    input [1:0] tankDir,
    input tank_destroyed,
    input [10:0] vgaH,
    input [10:0] vgaV,      // Current VGA position
    input [10:0] tankH,
    input [10:0] tankV,     // Current Y of tank
    output [11:0] tankData
    );

    parameter TANK_HEIGHT = 32;
    parameter TANK_WIDTH = 32;
    parameter HEIGHT = 480;
    parameter WIDTH = 640;

    wire tank_en;
    assign tank_en = (tankH + TANK_WIDTH > vgaH && tankH <= vgaH &&
                        tankV + TANK_HEIGHT > vgaV && tankV <= vgaV) ? 1'b1:1'b0;

    
    wire [9:0] tankAddr;

    wire [11:0] tankLeftData;
    wire [11:0] tankRightData;
    wire [11:0] tankUpData;
    wire [11:0] tankDownData;
    wire [11:0] outData;

    assign tankAddr = tank_en ? ( (vgaV - tankV) * TANK_WIDTH + (vgaH - tankH)) : 1'b0;

    tank_left_img tank_left(.addra(tankAddr), .clka(clk), .douta(tankLeftData), .ena(1'b1));
    tank_right_img tank_right(.addra(tankAddr), .clka(clk), .douta(tankRightData), .ena(1'b1));
    tank_up_img tank_up(.addra(tankAddr), .clka(clk), .douta(tankUpData), .ena(1'b1));
    tank_down_img tank_down(.addra(tankAddr), .clka(clk), .douta(tankDownData), .ena(1'b1));

    tank_data_selector tank_select(.clk(clk), .UP(tankUpData), .DOWN(tankDownData), .LEFT(tankLeftData), 
                                    .RIGHT(tankRightData), .Dir(tankDir), .tankData(outData));

    assign tankData = (tank_en & ~tank_destroyed) ? outData : 0;
    
endmodule
