`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/16/2020 04:47:54 PM
// Design Name:
// Module Name: Disp_Num
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


module Disp_Num(
           input clk,
           input RST,
           input [ 31: 0 ] HEXS,
           input [ 7: 0 ] points,
           input [ 7: 0 ] LES,
           output wire [ 7: 0 ] AN,
           output [ 7: 0 ] Segment
       );

wire [ 31: 0 ] clkdiv;


clk_div DispNum_clkdiv(
            .clk( clk ),
            .rst( RST ),
            .clkdiv( clkdiv )
        );
wire [ 3: 0 ] AN1, AN2;
wire [ 3: 0 ] HEX1, HEX2, HEX;
wire P1, P2, P;
wire LE1, LE2, LE;

DisplaySync Disp1(
                .Scan( clkdiv[ 18: 17 ] ),
                .Hexs( HEXS[ 15: 0 ] ),
                .point( points[ 3: 0 ] ),
                .LES( LES[ 3: 0 ] ),
                .AN( AN1 ),
                .HEX( HEX1 ),
                .LE( LE1 ),
                .p( P1 )
            );

DisplaySync Disp2(
                .Scan( clkdiv[ 18: 17 ] ),
                .Hexs( HEXS[ 31: 16 ] ),
                .point( points[ 7: 4 ] ),
                .LES( LES[ 7: 4 ] ),
                .AN( AN2 ),
                .HEX( HEX2 ),
                .LE( LE2 ),
                .p( P2 )
            );

assign AN = clkdiv[ 19 ] == 1'b1 ? { AN2, 4'b1111 } : { 4'b1111, AN1 };
assign D0 = clkdiv[ 19 ] == 1'b1 ? HEX2[ 0 ] : HEX1[ 0 ];
assign D1 = clkdiv[ 19 ] == 1'b1 ? HEX2[ 1 ] : HEX1[ 1 ];
assign D2 = clkdiv[ 19 ] == 1'b1 ? HEX2[ 2 ] : HEX1[ 2 ];
assign D3 = clkdiv[ 19 ] == 1'b1 ? HEX2[ 3 ] : HEX1[ 3 ];
assign LE = clkdiv[ 19 ] == 1'b1 ? LE2 : LE1;
assign P = clkdiv[ 19 ] == 1'b1 ? P2 : P1;

MyMC14495 MyMC14495_m( .D0( D0 ),
                       .D1( D1 ),
                       .D2( D2 ),
                       .D3( D3 ),
                       .LE( LE ),
                       .point( P ),
                       .a( Segment[ 0 ] ),
                       .b( Segment[ 1 ] ),
                       .c( Segment[ 2 ] ),
                       .d( Segment[ 3 ] ),
                       .e( Segment[ 4 ] ),
                       .f( Segment[ 5 ] ),
                       .g( Segment[ 6 ] ),
                       .p( Segment[ 7 ] ) );
endmodule
