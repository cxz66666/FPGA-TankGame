`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/02/2021 03:30:42 PM
// Design Name:
// Module Name: game_information_display
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


module game_information_display(
           input clk,
           input enable_game_classic,
           input enable_game_infinity,
           input [ 7: 0 ] score_classic,
           input [ 4: 0 ] timer,
           input [ 10: 0 ] vgaH,
           input [ 10: 0 ] vgaV,
           output [ 11: 0 ] VGA_data
       );
wire [ 11: 0 ] VGA_data1, VGA_data2, VGA_data3;
reg vga_en1, vga_en2, vga_en3, vga_en4, vga_en5;
reg	[ 13: 0 ] addr_info_classic;
reg	[ 12: 0 ] addr_info_infinity;

reg [ 8: 0 ] addr_redflag;

reg [ 7: 0 ] addr_timing;
wire [ 11: 0 ] VGA_data4, VGA_data5;
parameter RED	= 12'hF00;
parameter GREEN	= 12'h0F0;
parameter BLUE	= 12'h00F;
parameter WHITE	= 12'hFFF;
parameter BLACK	= 12'h000;
parameter YELLOW	= 12'hFF0;
parameter CYAN = 12'hF0F;
parameter ROYAL = 12'h0FF;

always @( posedge clk ) begin
    if ( enable_game_classic ) begin
        vga_en1 <= 1;
        if ( vgaH >= 130 && vgaH < 310 && vgaV >= 0 && vgaV < 46 ) begin
            addr_info_classic <= ( vgaV - 0 ) * 180 + vgaH - 130;
        end
        else begin
            vga_en1 <= 0;
        end
    end
    else begin
        vga_en1 <= 0;
    end
end

classic_info_180_46 u_classic_info_180_46(
                        .clka( clk ),
                        .addra( addr_info_classic ),
                        .ena( 1'b1 ),
                        .douta( VGA_data1 )
                    );

always @( posedge clk ) begin
    if ( enable_game_infinity ) begin
        vga_en2 <= 1;
        if ( vgaH >= 130 && vgaH < 310 && vgaV >= 0 && vgaV < 24 ) begin
            addr_info_infinity <= ( vgaV - 0 ) * 180 + vgaH - 130;
        end
        else begin
            vga_en2 <= 0;
        end
    end
    else begin
        vga_en2 <= 0;
    end
end
infinity_info_180_24 u_infinity_info_180_24(
                         .clka( clk ),
                         .addra( addr_info_infinity ),
                         .ena( 1'b1 ),
                         .douta( VGA_data2 )
                     );


always @( posedge clk ) begin
    if ( enable_game_classic ) begin
        vga_en3 <= 1;
        if ( vgaH >= 320 && vgaH < 480 && vgaV >= 1 && vgaV < 21 && ( vgaH - 320 ) < score_classic[ 3: 0 ] * 20 ) begin
            addr_redflag <= ( vgaH - 320 ) % 20 + ( vgaV - 1 ) * 20;
        end
        else if ( vgaH >= 320 && vgaH < 480 && vgaV >= 24 && vgaV < 44 && ( vgaH - 320 ) < score_classic[ 7: 4 ] * 20 ) begin
            addr_redflag <= ( vgaH - 320 ) % 20 + ( vgaV - 24 ) * 20;
        end
        else begin
            vga_en3 <= 0;
        end
    end
    else begin
        vga_en3 <= 0;
    end
end

redflag_20_20 u_redflag_20_20(
                  .clka( clk ),
                  .addra( addr_redflag ),
                  .ena( 1'b1 ),
                  .douta( VGA_data3 )
              );

always @( posedge clk ) begin
    if ( enable_game_infinity ) begin
        vga_en4 <= 1;
        if ( vgaH >= 320 && vgaH < 560 && vgaV >= 5 && vgaV < 20 && ( vgaH - 320 ) < timer * 15 ) begin
            addr_timing <= ( vgaH - 320 ) % 15 + ( vgaV - 5 ) * 15;
        end
        else begin
            vga_en4 <= 0;
        end
    end
    else begin
        vga_en4 <= 0;
    end
end

timing_15_15 u_timing_15_15(
                 .clka( clk ),
                 .addra( addr_timing ),
                 .ena( 1'b1 ),
                 .douta( VGA_data4 )
             );
assign VGA_data = ( vga_en1 ? VGA_data1 : 0 ) | ( vga_en2 ? VGA_data2 : 0 ) | ( vga_en3 ? VGA_data3 : 0 ) | ( vga_en4 ? VGA_data4 : 0 ) ;
endmodule
