`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/18/2020 01:59:44 PM
// Design Name:
// Module Name: vga_data_background
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


module vga_data_background(
           input clk,
           input [ 10: 0 ] vgaH,
           input [ 10: 0 ] vgaV,
           input sw_mode_sel,
           input [ 2: 0 ] mode,
           output reg [ 11: 0 ] vgaData
       );
parameter WIDTH = 640;
parameter HEIGHT = 480;

reg [ 16: 0 ] addr_background_pic, addr_gameover_pic;
reg [ 16: 0 ] addr_start_pic;
reg [ 11: 0 ] start_reg, gameover_reg;
wire [ 11: 0 ] start_pic, gameover_pic, background_pic;

reg [ 11: 0 ] VGA_data_cursor ;
always @( posedge clk ) begin
    if ( vgaV >= 0 && vgaV < HEIGHT && vgaH >= 0 && vgaH < WIDTH ) begin
        addr_background_pic <= vgaV[ 10: 1 ] * 320 + vgaH[ 10: 1 ];
    end
end


background_320_240 u_background_320_240(
                       .addra( addr_background_pic ),
                       .clka( clk ),
                       .douta( background_pic ),
                       .ena( 1'b1 )
                   );


//game over pic
always @( posedge clk ) begin
    if ( vgaH >= 130 && vgaH < 510 && vgaV >= 120 && vgaV < 300 ) begin

        addr_gameover_pic <= ( vgaH - 130 ) + 380 * ( vgaV - 120 );
        gameover_reg <= gameover_pic;

    end
    else begin
        gameover_reg <= 0;
    end
end
gameover_380_180 u_gameover_pic(
                     .clka( clk ),
                     .addra( addr_gameover_pic ),
                     .ena( 1'b1 ),
                     .douta( gameover_pic )
                 );



always @( posedge clk ) begin
    if ( vgaH >= 95 && vgaH < 545 && vgaV >= 90 && vgaV < 290 ) begin
        addr_start_pic <= ( vgaH - 95 ) + 450 * ( vgaV - 90 );
        start_reg <= start_pic;
    end
    else begin
        start_reg <= 0;
    end
end

startpic_450_200 u_start_pic(
                     .clka( clk ),
                     .addra( addr_start_pic ),
                     .ena( 1'b1 ),
                     .douta( start_pic )
                 );

always@( posedge clk ) begin
    if ( !sw_mode_sel ) begin
        if ( vgaH >= 223 && vgaH <= 233 && vgaV >= 227 && vgaV <= 237 ) begin
            VGA_data_cursor <= 12'h0F0;
        end
        else begin
            VGA_data_cursor <= 12'h0;
        end
    end
    else begin
        if ( vgaH >= 223 && vgaH <= 233 && vgaV >= 246 && vgaV <= 256 ) begin
            VGA_data_cursor <= 12'h0F0;
        end
        else begin
            VGA_data_cursor <= 12'h0;
        end
    end

end


always@( posedge clk )
case ( mode )
    0 : begin
        vgaData[ 0 ] = background_pic[ 0 ] | start_reg[ 0 ] | VGA_data_cursor[ 0 ];
        vgaData[ 1 ] = background_pic[ 1 ] | start_reg[ 1 ] | VGA_data_cursor[ 1 ];
        vgaData[ 2 ] = background_pic[ 2 ] | start_reg[ 2 ] | VGA_data_cursor[ 2 ];
        vgaData[ 3 ] = background_pic[ 3 ] | start_reg[ 3 ] | VGA_data_cursor[ 3 ];
        vgaData[ 4 ] = background_pic[ 4 ] | start_reg[ 4 ] | VGA_data_cursor[ 4 ];
        vgaData[ 5 ] = background_pic[ 5 ] | start_reg[ 5 ] | VGA_data_cursor[ 5 ];
        vgaData[ 6 ] = background_pic[ 6 ] | start_reg[ 6 ] | VGA_data_cursor[ 6 ];
        vgaData[ 7 ] = background_pic[ 7 ] | start_reg[ 7 ] | VGA_data_cursor[ 7 ];
        vgaData[ 8 ] = background_pic[ 8 ] | start_reg[ 8 ] | VGA_data_cursor[ 8 ];
        vgaData[ 9 ] = background_pic[ 9 ] | start_reg[ 9 ] | VGA_data_cursor[ 9 ];
        vgaData[ 10 ] = background_pic[ 10 ] | start_reg[ 10 ] | VGA_data_cursor[ 10 ];
        vgaData[ 11 ] = background_pic[ 11 ] | start_reg[ 11 ] | VGA_data_cursor[ 11 ];
    end
    1: begin
        vgaData[ 0 ] = background_pic[ 0 ]	;
        vgaData[ 1 ] = background_pic[ 1 ]	;
        vgaData[ 2 ] = background_pic[ 2 ]	;
        vgaData[ 3 ] = background_pic[ 3 ]	;
        vgaData[ 4 ] = background_pic[ 4 ]	;
        vgaData[ 5 ] = background_pic[ 5 ]	;
        vgaData[ 6 ] = background_pic[ 6 ]	;
        vgaData[ 7 ] = background_pic[ 7 ]	;
        vgaData[ 8 ] = background_pic[ 8 ]	;
        vgaData[ 9 ] = background_pic[ 9 ]	;
        vgaData[ 10 ] = background_pic[ 10 ]	;
        vgaData[ 11 ] = background_pic[ 11 ]	;
    end
    2: begin
        vgaData[ 0 ] = background_pic[ 0 ]	;
        vgaData[ 1 ] = background_pic[ 1 ]	;
        vgaData[ 2 ] = background_pic[ 2 ]	;
        vgaData[ 3 ] = background_pic[ 3 ]	;
        vgaData[ 4 ] = background_pic[ 4 ]	;
        vgaData[ 5 ] = background_pic[ 5 ]	;
        vgaData[ 6 ] = background_pic[ 6 ]	;
        vgaData[ 7 ] = background_pic[ 7 ]	;
        vgaData[ 8 ] = background_pic[ 8 ]	;
        vgaData[ 9 ] = background_pic[ 9 ]	;
        vgaData[ 10 ] = background_pic[ 10 ]	;
        vgaData[ 11 ] = background_pic[ 11 ]	;
    end
    3: begin
        vgaData[ 0 ] = background_pic[ 0 ] | gameover_reg[ 0 ];
        vgaData[ 1 ] = background_pic[ 1 ] | gameover_reg[ 1 ];
        vgaData[ 2 ] = background_pic[ 2 ] | gameover_reg[ 2 ];
        vgaData[ 3 ] = background_pic[ 3 ] | gameover_reg[ 3 ];
        vgaData[ 4 ] = background_pic[ 4 ] | gameover_reg[ 4 ];
        vgaData[ 5 ] = background_pic[ 5 ] | gameover_reg[ 5 ];
        vgaData[ 6 ] = background_pic[ 6 ] | gameover_reg[ 6 ];
        vgaData[ 7 ] = background_pic[ 7 ] | gameover_reg[ 7 ];
        vgaData[ 8 ] = background_pic[ 8 ] | gameover_reg[ 8 ];
        vgaData[ 9 ] = background_pic[ 9 ] | gameover_reg[ 9 ];
        vgaData[ 10 ] = background_pic[ 10 ] | gameover_reg[ 10 ];
        vgaData[ 11 ] = background_pic[ 11 ] | gameover_reg[ 11 ];
    end

endcase
endmodule
