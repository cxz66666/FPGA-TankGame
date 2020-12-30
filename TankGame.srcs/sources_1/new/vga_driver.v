`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/18/2020 01:43:30 PM
// Design Name:
// Module Name: vga_driver
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


// VGA 640*480 @ 60Hz
`define H_FRONT    11'd16
`define H_SYNC     11'd96
`define H_BACK     11'd48
`define H_DISPLAY  11'd640
`define H_TOTAL    11'd800

`define V_FRONT    11'd10
`define V_SYNC     11'd2
`define V_BACK     11'd33
`define V_DISPLAY  11'd480
`define V_TOTAL    11'd525

module vga_driver(
           input clk_vga,
           input rst_n,

           output vga_en,
           output HSync,
           output VSync,
           output [ 3: 0 ] vgaRed,
           output [ 3: 0 ] vgaGreen,
           output [ 3: 0 ] vgaBlue,

           input [ 11: 0 ] vgaData,
           output [ 10: 0 ] vgaH,
           output [ 10: 0 ] vgaV
       );


reg [ 10: 0 ] hCnt;


// Horizontal Sync
always @( posedge clk_vga or negedge rst_n ) begin
    if ( !rst_n ) begin
        hCnt <= 11'b0;
    end
    else begin
        if ( hCnt < `H_TOTAL - 1'b1 ) begin
            hCnt <= hCnt + 1'b1;
        end
        else begin
            hCnt <= 11'b0;
        end
    end
end

assign HSync = ( ( hCnt <= ( `H_DISPLAY + `H_FRONT - 1'b1 ) ) ||
                 ( hCnt > ( `H_TOTAL - `H_BACK - 1'b1 ) ) ) ? 1'b0 : 1'b1;

reg [ 10: 0 ] vCnt;

// Vertical Sync
always @( posedge clk_vga or negedge rst_n ) begin
    if ( !rst_n ) begin
        vCnt <= 11'b0;
    end
    else begin
        if ( hCnt == `H_DISPLAY - 1'b1 ) begin
            if ( vCnt < `V_TOTAL - 1'b1 ) begin
                vCnt <= vCnt + 1'b1;
            end
            else begin
                vCnt <= 11'b0;
            end
        end
    end
end

// Field Sync

assign VSync = ( ( vCnt <= ( `V_DISPLAY + `V_FRONT - 1'b1 ) ) ||
                 ( vCnt > ( `V_TOTAL - `V_BACK - 1'b1 ) ) ) ? 1'b0 : 1'b1;

assign vga_en = ( hCnt < `H_DISPLAY && vCnt < `V_DISPLAY ) ? 1'b1 : 1'b0;


assign vgaRed[ 3 ] = vga_en ? vgaData[ 3 ] : 1'b0;
assign vgaRed[ 2 ] = vga_en ? vgaData[ 2 ] : 1'b0;
assign vgaRed[ 1 ] = vga_en ? vgaData[ 1 ] : 1'b0;
assign vgaRed[ 0 ] = vga_en ? vgaData[ 0 ] : 1'b0;

assign vgaGreen[ 3 ] = vga_en ? vgaData[ 7 ] : 1'b0;
assign vgaGreen[ 2 ] = vga_en ? vgaData[ 6 ] : 1'b0;
assign vgaGreen[ 1 ] = vga_en ? vgaData[ 5 ] : 1'b0;
assign vgaGreen[ 0 ] = vga_en ? vgaData[ 4 ] : 1'b0;

assign vgaBlue[ 3 ] = vga_en ? vgaData[ 11 ] : 1'b0;
assign vgaBlue[ 2 ] = vga_en ? vgaData[ 10 ] : 1'b0;
assign vgaBlue[ 1 ] = vga_en ? vgaData[ 9 ] : 1'b0;
assign vgaBlue[ 0 ] = vga_en ? vgaData[ 8 ] : 1'b0;

/*
    assign vgaRed = (vgaX > 0) ? 4'b0000 : 4'b0000;
    assign vgaGreen = (vgaX > 0) ? 4'b0000 : 4'b0000;
    assign vgaBlue = (vgaX > 0) ? 4'b1111 : 4'b0000;
*/

assign vgaH = ( hCnt < `H_DISPLAY ) ? hCnt : 1'b0;
assign vgaV = ( vCnt < `V_DISPLAY ) ? vCnt : 1'b0;

endmodule
