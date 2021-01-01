`timescale 1ns / 1ps

module collide_detection(
           input mode,
           input [ 10: 0 ] player1_tank_H,
           input [ 10: 0 ] player1_tank_V,
           input [ 1: 0 ] player1_tank_dir,
           input player1_tank_en,
           input [ 10: 0 ] player1_bullet_H,
           input [ 10: 0 ] player1_bullet_V,
           input player1_bullet_en,
           input [ 1: 0 ] player1_bullet_dir,
           output reg [ 7: 0 ] player1_collide,       // [bullet4, bullet3, bullet2, bullet1, tank4, tank3, tank2, tank1]

           input [ 10: 0 ] player2_tank_H,
           input [ 10: 0 ] player2_tank_V,
           input [ 1: 0 ] player2_tank_dir,
           input player2_tank_en,
           input [ 10: 0 ] player2_bullet_H,
           input [ 10: 0 ] player2_bullet_V,
           input player2_bullet_en,
           input [ 10: 0 ] player2_bullet_dir,
           output reg [ 7: 0 ] player2_collide      // Reserved for other bullets and tanks
       );

parameter TANK_WIDTH = 32;
parameter TANK_HEIGHT = 32;
parameter BULLET_LONGER = 10;
parameter BULLET_SHORTER = 5;

wire [ 10: 0 ] player1_bullet_RBound, player1_bullet_DBound;
wire [ 10: 0 ] player2_bullet_RBound, player2_bullet_DBound;
wire [ 10: 0 ] player1_tank_RBound, player1_tank_DBound;
wire [ 10: 0 ] player2_tank_RBound, player2_tank_DBound;
reg [ 3: 0 ] player1_tank_collide_dir, player2_tank_collide_dir;

assign player1_bullet_RBound = player1_bullet_H + ( player1_bullet_dir == 2'b11 || 2'b10 ) ? BULLET_LONGER : BULLET_SHORTER;
assign player1_bullet_DBound = player1_bullet_V + ( player1_bullet_dir == 2'b00 || 2'b01 ) ? BULLET_LONGER : BULLET_SHORTER;

assign player2_bullet_RBound = player2_bullet_H + ( player2_bullet_dir == 2'b11 || 2'b10 ) ? BULLET_LONGER : BULLET_SHORTER;
assign player2_bullet_DBound = player2_bullet_V + ( player2_bullet_dir == 2'b00 || 2'b01 ) ? BULLET_LONGER : BULLET_SHORTER;

assign player1_tank_RBound = player1_tank_H + TANK_WIDTH - 1;
assign player1_tank_DBound = player1_tank_V + TANK_HEIGHT - 1;

assign player2_tank_RBound = player2_tank_H + TANK_WIDTH - 1;
assign player2_tank_DBound = player2_tank_V + TANK_HEIGHT - 1;

initial begin
    player1_collide <= 0;
    player2_collide <= 0;
end

always @( * ) begin
    if ( player1_tank_en ) begin
        if ( player2_bullet_en ) begin
            if ( player1_tank_H >= player2_bullet_H && player1_tank_H <= player2_bullet_RBound &&
                    player1_tank_V >= player2_bullet_V && player1_tank_V <= player2_bullet_RBound ) begin
                player1_collide[ 5 ] <= 1;
            end
            else begin
                player1_collide[ 5 ] <= 0;
            end
        end

        if ( player2_tank_en && player1_tank_RBound <= player2_tank_RBound && player1_tank_RBound >= player2_tank_H &&
                ~( player1_tank_DBound < player2_tank_V || player1_tank_V > player2_tank_DBound ) ) begin
            player1_tank_collide_dir[ 3 ] <= 1;
        end
        else begin
            player1_tank_collide_dir[ 3 ] <= 0;
        end

        if ( player2_tank_en && player1_tank_H <= player2_tank_RBound && player1_tank_H >= player2_tank_H &&
                ~( player1_tank_DBound < player2_tank_V || player1_tank_V > player2_tank_DBound ) ) begin
            player1_tank_collide_dir[ 2 ] <= 1;
        end
        else begin
            player1_tank_collide_dir[ 2 ] <= 0;
        end

        if ( player2_tank_en && player1_tank_V <= player2_tank_DBound && player1_tank_V >= player2_tank_V
                && ~( player1_tank_RBound < player2_tank_H || player1_tank_H > player2_tank_RBound ) ) begin
            player1_tank_collide_dir[ 0 ] <= 1;
        end
        else begin
            player1_tank_collide_dir[ 0 ] <= 0;
        end

        if ( player2_tank_en && player1_tank_DBound <= player2_tank_DBound && player1_tank_DBound >= player2_tank_V
                && ~( player1_tank_RBound < player2_tank_H || player1_tank_H > player2_tank_RBound ) ) begin
            player1_tank_collide_dir[ 1 ] <= 1;
        end
        else begin
            player1_tank_collide_dir[ 1 ] <= 0;
        end
        player1_collide[ 1 ] <= player1_tank_collide_dir[ player1_tank_dir ];
    end
    /*
                object_collide_detection player1_2(
                    .object1_H(player1_tank_H),
                    .object1_V(player1_tank_V),
                    .object1_dir(player1_tank_dir),
                    .object1_en(player1_tank_en),
                    .object1_RBound(player1_tank_RBound),
                    .object1_DBound(player1_tank_DBound),
                    .object2_H(player2_tank_H),
                    .object2_V(player2_tank_V),
                    .object2_dir(player2_tank_dir),
                    .object2_en(player2_tank_en),
                    .object2_RBound(player2_tank_RBound),
                    .object2_DBound(player2_tank_DBound),
                    .object1_collide(),
                    .object2_collide());
    */
end

always @( * ) begin
    if ( player2_tank_en ) begin
        if ( player1_bullet_en ) begin
            if ( player2_tank_H >= player1_bullet_H && player2_tank_H <= player1_bullet_RBound &&
                    player2_tank_V >= player1_bullet_V && player2_tank_V <= player1_bullet_RBound ) begin
                player2_collide[ 4 ] <= 1;
            end
            else begin
                player2_collide[ 4 ] <= 0;
            end
        end

        if ( player1_tank_en && player2_tank_RBound <= player1_tank_RBound && player2_tank_RBound >= player1_tank_H &&
                ~( player2_tank_DBound < player1_tank_V || player2_tank_V > player1_tank_DBound ) ) begin
            player2_tank_collide_dir[ 3 ] <= 1;
        end
        else begin
            player2_tank_collide_dir[ 3 ] <= 0;
        end

        if ( player1_tank_en && player2_tank_H <= player1_tank_RBound && player2_tank_H >= player1_tank_H &&
                ~( player2_tank_DBound < player1_tank_V || player2_tank_V > player1_tank_DBound ) ) begin
            player2_tank_collide_dir[ 2 ] <= 1;
        end
        else begin
            player2_tank_collide_dir[ 2 ] <= 0;
        end

        if ( player1_tank_en && player2_tank_V <= player1_tank_DBound && player2_tank_V >= player1_tank_V
                && ~( player2_tank_RBound < player1_tank_H || player2_tank_H > player1_tank_RBound ) ) begin
            player2_tank_collide_dir[ 0 ] <= 1;
        end
        else begin
            player2_tank_collide_dir[ 0 ] <= 0;
        end

        if ( player1_tank_en && player2_tank_DBound <= player1_tank_DBound && player2_tank_DBound >= player1_tank_V
                && ~( player2_tank_RBound < player1_tank_H || player2_tank_H > player1_tank_RBound ) ) begin
            player2_tank_collide_dir[ 1 ] <= 1;
        end
        else begin
            player2_tank_collide_dir[ 1 ] <= 0;
        end
        player2_collide[ 1 ] <= player2_tank_collide_dir[ player2_tank_dir ];
    end
end


endmodule
