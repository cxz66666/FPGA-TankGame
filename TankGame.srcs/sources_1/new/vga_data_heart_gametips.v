`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/03/2021 04:28:18 PM
// Design Name:
// Module Name: vga_data_heart_gametips
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


module vga_data_heart_gametips(
           input clk,
           input [ 2: 0 ] mode,
           input [ 10: 0 ] vgaH,
           input [ 10: 0 ] vgaV,
           input [ 1: 0 ] winner,
           input timeup,
           input gameover_classic,
           input gameover_infinity,
           input [ 3: 0 ] HP1_value,
           input [ 3: 0 ] HP2_value,
           input [ 3: 0 ] HP1_value_infinity,
           input [ 3: 0 ] HP2_value_infinity,
           input [ 7: 0 ] score_classic,
           output [ 11: 0 ] vgaData
       );

reg [ 11: 0 ] heart_reg1, heart_reg2, classic_gameover_tips_reg1, classic_gameover_tips_reg2, infinity_gameover_tips_reg;
wire [ 11: 0 ] heart_pic1 , heart_pic2, classic_gameover_tips_pic1, classic_gameover_tips_pic2, infinity_gameover_tips_pic;
reg [ 8: 0 ] addra_heart_pic1, addra_heart_pic2;
reg [ 12: 0 ] addr_classic_gameover_tips_pic1, addr_classic_gameover_tips_pic2, addr_infinity_gameover_tips_pic;

always @( posedge clk ) begin
    if ( mode == 0 || mode == 3 ) begin
        heart_reg1 <= 0;
        heart_reg2 <= 0;
    end
    else if ( mode == 1 || mode == 2 ) begin
        if ( vgaH >= 5 && vgaH < 25 && vgaV >= 180 && vgaV < 340 && ( vgaV - 180 ) < ( mode == 1 ? HP1_value : HP1_value_infinity ) * 20 ) begin
            addra_heart_pic1 <= ( vgaH - 5 ) + ( ( vgaV - 180 ) % 20 ) * 20;
            heart_reg1 <= heart_pic1;
        end
        else if ( vgaH >= 615 && vgaH < 635 && vgaV >= 180 && vgaV < 340 && ( vgaV - 180 ) < ( mode == 1 ? HP2_value : HP2_value_infinity ) * 20 ) begin
            addra_heart_pic2 <= ( vgaH - 615 ) + ( ( vgaV - 180 ) % 20 ) * 20;
            heart_reg2 <= heart_pic2;
        end
        else begin
            heart_reg1 <= 0;
            heart_reg2 <= 0;
        end
    end
    else begin
        heart_reg1 <= 0;
        heart_reg2 <= 0;
    end
end

always @( posedge clk ) begin
    if ( mode != 3 ) begin
        classic_gameover_tips_reg1 <= 0;
        classic_gameover_tips_reg2 <= 0;
        infinity_gameover_tips_reg <= 0;

    end
    else begin
        if ( winner > 0 ) begin
            if ( winner == 2'b10 ) begin
                if ( vgaH >= 230 && vgaH < 410 && vgaV >= 10 && vgaV < 42 ) begin
                    addr_classic_gameover_tips_pic1 <= ( vgaH - 230 ) + ( vgaV - 10 ) * 180;
                    classic_gameover_tips_reg1 <= classic_gameover_tips_pic1;
                end
                else begin
                    classic_gameover_tips_reg1 <= 0;
                end
                classic_gameover_tips_reg2 <= 0;
                infinity_gameover_tips_reg <= 0;
            end
            else if ( winner == 2'b11 ) begin
                if ( vgaH >= 230 && vgaH < 410 && vgaV >= 10 && vgaV < 42 ) begin
                    addr_classic_gameover_tips_pic2 <= ( vgaH - 230 ) + ( vgaV - 10 ) * 180;
                    classic_gameover_tips_reg2 <= classic_gameover_tips_pic2;
                end
                else begin
                    classic_gameover_tips_reg2 <= 0;
                end
                classic_gameover_tips_reg1 <= 0;
                infinity_gameover_tips_reg <= 0;

            end
            else begin
                classic_gameover_tips_reg1 <= 0;
                classic_gameover_tips_reg2 <= 0;
                infinity_gameover_tips_reg <= 0;
            end
        end
        else if ( timeup ) begin
            if ( vgaH >= 230 && vgaH < 410 && vgaV >= 10 && vgaV < 48 ) begin
                addr_infinity_gameover_tips_pic <= ( vgaH - 230 ) + ( vgaV - 10 ) * 180;
                infinity_gameover_tips_reg <= infinity_gameover_tips_pic;
            end
            else begin
                infinity_gameover_tips_reg <= 0;
            end
            classic_gameover_tips_reg1 <= 0;
            classic_gameover_tips_reg2 <= 0;
        end
        else begin
            classic_gameover_tips_reg1 <= 0;
            classic_gameover_tips_reg2 <= 0;
            infinity_gameover_tips_reg <= 0;
        end
    end
end
heart_20_20 player1_heart(
                .addra( addra_heart_pic1 ),
                .clka( clk ),
                .douta( heart_pic1 ),
                .ena( 1'b1 )
            );


heart_20_20 player2_heart(
                .addra( addra_heart_pic2 ),
                .clka( clk ),
                .douta( heart_pic2 ),
                .ena( 1'b1 )
            );

player1win_180_32 u_player1win_180_32(
                      .addra( addr_classic_gameover_tips_pic1 ),
                      .clka( clk ),
                      .douta( classic_gameover_tips_pic1 ),
                      .ena( 1'b1 )
                  );

player2win_180_32 u_player2win_180_32(
                      .addra( addr_classic_gameover_tips_pic2 ),
                      .clka( clk ),
                      .douta( classic_gameover_tips_pic2 ),
                      .ena( 1'b1 )
                  );

timeisup_180_38 u_timeisup_180_38(
                    .addra( addr_infinity_gameover_tips_pic ),
                    .clka( clk ),
                    .douta( infinity_gameover_tips_pic ),
                    .ena( 1'b1 )
                );
assign vgaData = heart_reg1 | heart_reg2 | classic_gameover_tips_reg1 | classic_gameover_tips_reg2 | infinity_gameover_tips_reg;
endmodule
