`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/06/2021 08:41:26 AM
// Design Name:
// Module Name: item_display
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


module item_display(
           input clk,
           input set_require,
           input enable_reward,
           input [ 10: 0 ] random_xpos,
           input [ 10: 0 ] random_ypos,
           input [ 1: 0 ] item_type,
           input [ 10: 0 ] VGA_h,
           input [ 10: 0 ] VGA_V,
           input enable_game_classic,
           input enable_game_infinity,
           output reg [ 11: 0 ] VGA_data
       );



wire [ 5: 0 ] ITEM_WIDTH ;
wire [ 5: 0 ] ITEM_HEIGHT;

assign ITEM_WIDTH = item_type == 2'b11 ? 32 : 20;
assign ITEM_HEIGHT = item_type == 2'b11 ? 32 : 20;
reg [ 8: 0 ] addra_add_heart, addra_add_timing, addra_frozen;
reg [ 9: 0 ] addra_invincible;

wire[ 11: 0 ] add_heart_pic, add_timing_pic, add_frozen_pic, invincible_pic;
// reg [ 11: 0 ] add_heart_reg, add_timing_reg, add_frozen_reg, invincible_reg;



always @( posedge clk ) begin
    if ( set_require == 1'b1 && enable_reward == 1'b1 ) begin
        if ( VGA_h >= random_xpos && VGA_h < random_xpos + ITEM_WIDTH && VGA_V >= random_ypos && VGA_V < random_ypos + ITEM_HEIGHT ) begin
            addra_add_heart <= ( VGA_h - random_xpos ) + ( VGA_V - random_ypos ) * 20;
            addra_add_timing <= ( VGA_h - random_xpos ) + ( VGA_V - random_ypos ) * 20;
            addra_frozen <= ( VGA_h - random_xpos ) + ( VGA_V - random_ypos ) * 20;
            addra_invincible <= ( VGA_h - random_xpos ) + ( VGA_V - random_ypos ) * 32;
            case ( item_type )
                2'b01: begin
                    if ( enable_game_classic == 1 ) begin
                        VGA_data <= add_heart_pic;
                    end
                    else if ( enable_game_infinity ) begin
                        VGA_data <= add_timing_pic;
                    end
                end
                2'b10: begin
                    VGA_data <= add_frozen_pic;
                end
                2'b11: begin
                    VGA_data <= invincible_pic;
                end
                default : begin
                    VGA_data <= 0;
                end
            endcase
        end
        else begin
            VGA_data <= 0;
        end
    end
    else begin
        VGA_data <= 0;
    end

end
add_heart_20_20 u_add_heart_20_20(
                    .clka( clk ),
                    .ena( 1'b1 ),
                    .addra( addra_add_heart ),
                    .douta( add_heart_pic )
                );
add_timing_20_20 u_add_timing_20_20(
                     .clka( clk ),
                     .ena( 1'b1 ),
                     .addra( addra_add_timing ),
                     .douta( add_timing_pic )
                 );
snowflake_20_20 u_snowflake_20_20(
                    .clka( clk ),
                    .ena( 1'b1 ),
                    .addra( addra_frozen ),
                    .douta( add_frozen_pic )
                );
invincible_star_32_32 u_invincible_star(
                          .clka( clk ),
                          .ena( 1'b1 ),
                          .addra( addra_invincible ),
                          .douta( invincible_pic )
                      );
endmodule
