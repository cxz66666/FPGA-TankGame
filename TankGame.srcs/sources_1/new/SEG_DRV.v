`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/03/2021 09:18:36 PM
// Design Name:
// Module Name: SEG_DRV
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




module SEG_DRV(
           input clk,
           input [ 31: 0 ] num,
           input ena,
           input [ 7: 0 ] point,
           output S_DT,
           output S_CLK,
           output S_CLR,
           output S_EN
       );

wire [ 63: 0 ] dto;

MYMC14495 m1( .D0( num[ 0 ] ), .D1( num[ 1 ] ), .D2( num[ 2 ] ), .D3( num[ 3 ] ), .LE( ~ena ), .point( point[ 0 ] ), .a( dto[ 0 ] ), .b( dto[ 1 ] ), .c( dto[ 2 ] ), .d( dto[ 3 ] ), .e( dto[ 4 ] ), .f( dto[ 5 ] ), .g( dto[ 6 ] ), .p( dto[ 7 ] ) );
MYMC14495 m2( .D0( num[ 4 ] ), .D1( num[ 5 ] ), .D2( num[ 6 ] ), .D3( num[ 7 ] ), .LE( ~ena ), .point( point[ 1 ] ), .a( dto[ 8 ] ), .b( dto[ 9 ] ), .c( dto[ 10 ] ), .d( dto[ 11 ] ), .e( dto[ 12 ] ), .f( dto[ 13 ] ), .g( dto[ 14 ] ), .p( dto[ 15 ] ) );
MYMC14495 m3( .D0( num[ 8 ] ), .D1( num[ 9 ] ), .D2( num[ 10 ] ), .D3( num[ 11 ] ), .LE( ~ena ), .point( point[ 2 ] ), .a( dto[ 16 ] ), .b( dto[ 17 ] ), .c( dto[ 18 ] ), .d( dto[ 19 ] ), .e( dto[ 20 ] ), .f( dto[ 21 ] ), .g( dto[ 22 ] ), .p( dto[ 23 ] ) );
MYMC14495 m4( .D0( num[ 12 ] ), .D1( num[ 13 ] ), .D2( num[ 14 ] ), .D3( num[ 15 ] ), .LE( ~ena ), .point( point[ 3 ] ), .a( dto[ 24 ] ), .b( dto[ 25 ] ), .c( dto[ 26 ] ), .d( dto[ 27 ] ), .e( dto[ 28 ] ), .f( dto[ 29 ] ), .g( dto[ 30 ] ), .p( dto[ 31 ] ) );
MYMC14495 m5( .D0( num[ 16 ] ), .D1( num[ 17 ] ), .D2( num[ 18 ] ), .D3( num[ 19 ] ), .LE( ~ena ), .point( point[ 4 ] ), .a( dto[ 32 ] ), .b( dto[ 33 ] ), .c( dto[ 34 ] ), .d( dto[ 35 ] ), .e( dto[ 36 ] ), .f( dto[ 37 ] ), .g( dto[ 38 ] ), .p( dto[ 39 ] ) );
MYMC14495 m6( .D0( num[ 20 ] ), .D1( num[ 21 ] ), .D2( num[ 22 ] ), .D3( num[ 23 ] ), .LE( ~ena ), .point( point[ 5 ] ), .a( dto[ 40 ] ), .b( dto[ 41 ] ), .c( dto[ 42 ] ), .d( dto[ 43 ] ), .e( dto[ 44 ] ), .f( dto[ 45 ] ), .g( dto[ 46 ] ), .p( dto[ 47 ] ) );
MYMC14495 m7( .D0( num[ 24 ] ), .D1( num[ 25 ] ), .D2( num[ 26 ] ), .D3( num[ 27 ] ), .LE( ~ena ), .point( point[ 6 ] ), .a( dto[ 48 ] ), .b( dto[ 49 ] ), .c( dto[ 50 ] ), .d( dto[ 51 ] ), .e( dto[ 52 ] ), .f( dto[ 53 ] ), .g( dto[ 54 ] ), .p( dto[ 55 ] ) );
MYMC14495 m8( .D0( num[ 28 ] ), .D1( num[ 29 ] ), .D2( num[ 30 ] ), .D3( num[ 31 ] ), .LE( ~ena ), .point( point[ 7 ] ), .a( dto[ 56 ] ), .b( dto[ 57 ] ), .c( dto[ 58 ] ), .d( dto[ 59 ] ), .e( dto[ 60 ] ), .f( dto[ 61 ] ), .g( dto[ 62 ] ), .p( dto[ 63 ] ) );



SEG_P2S m9( .clk( clk ), .data_in( dto ), .ena( ena ), .S_DT( S_DT ), .S_CLK( S_CLK ), .S_CLR( S_CLR ), .S_EN( S_EN ) );



endmodule
