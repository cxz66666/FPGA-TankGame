`timescale 1ns / 1ps


module display_scene(
    input clk,
    input player1_H,
    input player1_V
    );

    tank_display u_tank_display(
    .clk(clk),
    .tankDir(2'b01),
    .vgaH(vgaH),
    .vgaV(vgaV),
    .tankH(player1_H),
    .tankV(player1_V),
    .tankData(tankData)

    
);
endmodule
