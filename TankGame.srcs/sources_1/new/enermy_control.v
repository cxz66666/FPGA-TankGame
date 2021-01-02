`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/01/2021 10:06:10 PM
// Design Name:
// Module Name: enermy_control
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


module enermy_control(
           input clk_8Hz,
           input clk_2Hz,
           input clk_10ms,
           input [ 1: 0 ] flag,       //00 01 10 11 four tanks
           input [ 10: 0 ] player1_H,
           input [ 10: 0 ] player1_V,
           input [ 10: 0 ] player2_H,
           input [ 10: 0 ] player2_V,
           input [ 10: 0 ] player1_bullet_H,
           input [ 10: 0 ] player1_bullet_V,
           input [ 2: 0 ] player1_bullet_dir,
           input [ 10: 0 ] player2_bullet_H,
           input [ 10: 0 ] player2_bullet_V,
           input [ 2: 0 ] player2_bullet_dir,


           input [ 10: 0 ] enermy_H,
           input [ 10: 0 ] enermy_V,
           input enermy_tank_en,

           output reg [ 1: 0 ] enermy_dir_feedback,
           output reg enermy_fire,
           output wire enermy_moving

       );
parameter HEIGHT = 480;
parameter WIDTH = 640;
parameter TANK_HEIGHT = 32;
parameter TANK_WIDTH = 32;
parameter BULLET_LONGER = 10;
parameter BULLET_SHORTER = 5;
wire [ 10: 0 ] tank_DBound = enermy_V + TANK_HEIGHT;
wire [ 10: 0 ] tank_RBound = enermy_H + TANK_WIDTH;

wire[ 10: 0 ] player1_DBound = player1_V + TANK_HEIGHT;
wire [ 10: 0 ] player1_RBound = player1_H + TANK_WIDTH;


wire[ 10: 0 ] player2_DBound = player1_V + TANK_HEIGHT;
wire [ 10: 0 ] player2_RBound = player1_H + TANK_WIDTH;

reg [ 1: 0 ] enermy_dir_feedback_tmp;
reg [ 5: 0 ] counter_num;


wire [ 1: 0 ] rand_num;
reg rand; // 0 is player2 and 1 is player1
wire [ 10: 0 ] chase_tank_H = rand ? player1_H : player2_H;
wire [ 10: 0 ] chase_tank_V = rand ? player1_V : player2_V;

assign enermy_moving = enermy_tank_en;

initial begin
    enermy_fire <= 1'b0;
    counter_num <= flag;
    rand <= flag[ 0 ];
end

Random u_Random(
           .clk( clk_10ms ),
           .rst_n( 1'b1 ),
           .flag( flag ),
           .random( rand_num )
       );
always @( posedge clk_8Hz ) begin
    if ( !player1_bullet_dir[ 2 ] ) begin
        case ( player1_bullet_dir[ 1 ] )

            1'b0: begin
                if ( player1_bullet_H <= tank_RBound && player1_bullet_H + BULLET_SHORTER >= enermy_H ) begin
                    if ( ( enermy_V < player1_bullet_V && ~player1_bullet_dir[ 0 ] ) || ( enermy_V > player1_bullet_V && player1_bullet_dir[ 0 ] ) ) begin
                        if ( enermy_H < WIDTH / 6 ) begin

                            enermy_dir_feedback_tmp <= 2'b11;
                        end
                        else if ( enermy_H > 3 * WIDTH / 4 ) begin
                            enermy_dir_feedback_tmp <= 2'b10;
                        end
                        else begin
                            if ( enermy_H + TANK_WIDTH / 2 < player1_bullet_H + BULLET_SHORTER / 2 ) begin
                                enermy_dir_feedback_tmp <= 2'b10;
                            end
                            else begin
                                enermy_dir_feedback_tmp <= 2'b11;
                            end
                        end
                    end

                end
            end

            1'b1: begin
                if ( player1_bullet_V <= tank_DBound && player1_bullet_V + BULLET_SHORTER >= enermy_V ) begin
                    if ( ( enermy_H < player1_bullet_H && ~player1_bullet_dir[ 0 ] ) || ( enermy_H > player1_bullet_H && player1_bullet_dir[ 0 ] ) ) begin
                        if ( enermy_V < HEIGHT / 6 ) begin
                            enermy_dir_feedback_tmp <= 2'b01;
                        end
                        else if ( enermy_V > 3 * HEIGHT / 4 ) begin
                            enermy_dir_feedback_tmp <= 2'b00;
                        end
                        else begin
                            if ( enermy_V + TANK_HEIGHT / 2 < player1_bullet_V + BULLET_SHORTER / 2 ) begin
                                enermy_dir_feedback_tmp <= 2'b00;
                            end
                            else begin
                                enermy_dir_feedback_tmp <= 2'b01;
                            end
                        end
                    end
                end
            end
        endcase

    end


    else if ( !player2_bullet_dir[ 2 ] ) begin
        case ( player2_bullet_dir[ 1 ] )

            1'b0: begin
                if ( player2_bullet_H <= tank_RBound && player2_bullet_H + BULLET_SHORTER >= enermy_H ) begin
                    if ( ( enermy_V < player2_bullet_V && ~player2_bullet_dir[ 0 ] ) || ( enermy_V > player2_bullet_V && player2_bullet_dir[ 0 ] ) ) begin
                        if ( enermy_H < WIDTH / 6 ) begin

                            enermy_dir_feedback_tmp <= 2'b11;
                        end
                        else if ( enermy_H > 3 * WIDTH / 4 ) begin
                            enermy_dir_feedback_tmp <= 2'b10;
                        end
                        else begin
                            if ( enermy_H + TANK_WIDTH / 2 < player2_bullet_H + BULLET_SHORTER / 2 ) begin
                                enermy_dir_feedback_tmp <= 2'b10;
                            end
                            else begin
                                enermy_dir_feedback_tmp <= 2'b11;
                            end
                        end
                    end

                end
            end

            1'b1: begin
                if ( player2_bullet_V <= tank_DBound && player2_bullet_V + BULLET_SHORTER >= enermy_V ) begin
                    if ( ( enermy_H < player2_bullet_H && ~player2_bullet_dir[ 0 ] ) || ( enermy_H > player2_bullet_H && player2_bullet_dir[ 0 ] ) ) begin
                        if ( enermy_V < HEIGHT / 6 ) begin
                            enermy_dir_feedback_tmp <= 2'b01;
                        end
                        else if ( enermy_V > 3 * HEIGHT / 4 ) begin
                            enermy_dir_feedback_tmp <= 2'b00;
                        end
                        else begin
                            if ( enermy_V + TANK_HEIGHT / 2 < player2_bullet_V + BULLET_SHORTER / 2 ) begin
                                enermy_dir_feedback_tmp <= 2'b00;
                            end
                            else begin
                                enermy_dir_feedback_tmp <= 2'b01;
                            end
                        end
                    end
                end
            end
        endcase

    end
    else begin
        enermy_fire <= 1'b0;
        if ( rand ) begin
            if ( enermy_V + TANK_HEIGHT / 2 <= chase_tank_V ) begin
                enermy_dir_feedback_tmp <= 2'b01;
            end
            else if ( enermy_V >= chase_tank_V + TANK_HEIGHT / 2 ) begin
                enermy_dir_feedback_tmp <= 2'b00;
            end
            else begin
                enermy_fire <= 1'b1;
                if ( enermy_H < chase_tank_H ) begin
                    enermy_dir_feedback_tmp <= 2'b11;
                end
                else begin
                    enermy_dir_feedback_tmp <= 2'b10;
                end
            end
        end
        else begin
            if ( enermy_H + TANK_WIDTH / 2 <= chase_tank_H ) begin
                enermy_dir_feedback_tmp <= 2'b11;
            end
            else if ( enermy_H >= chase_tank_H + TANK_HEIGHT / 2 ) begin
                enermy_dir_feedback_tmp <= 2'b10;
            end
            else begin
                enermy_fire <= 1'b1;
                if ( enermy_V < chase_tank_V ) begin
                    enermy_dir_feedback_tmp <= 2'b01;
                end
                else begin
                    enermy_dir_feedback_tmp <= 2'b00;
                end
            end
        end

    end

end
always @( posedge clk_2Hz ) begin
    if ( counter_num % 3 > 0 ) begin
        enermy_dir_feedback <= enermy_dir_feedback_tmp;
    end
    else begin
        enermy_dir_feedback <= rand_num[ 1: 0 ];
    end
    counter_num <= counter_num + 1;
    if ( counter_num == 9 ) begin
        counter_num <= 0;
        rand <= rand_num[ 0 ] ;
    end
end

endmodule
