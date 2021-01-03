`timescale 1ns / 1ps


module object_collide_detection(
           input [ 10: 0 ] object1_H,
           input [ 10: 0 ] object1_V,
           input object1_en,
           input [ 1: 0 ] object1_dir,
           input [ 10: 0 ] object1_LONGER,
           input [ 10: 0 ] object1_SHORTER,
           input [ 10: 0 ] object2_H,
           input [ 10: 0 ] object2_V,
           input object2_en,
           input [ 1: 0 ] object2_dir,
           input [ 10: 0 ] object2_LONGER,
           input [ 10: 0 ] object2_SHORTER,
           output reg object1_collide,
           output reg object2_collide
       );

reg [ 3: 0 ] object1_collide_dir, object2_collide_dir;
wire [ 10: 0 ] object1_RBound, object1_DBound;
wire [ 10: 0 ] object2_RBound, object2_DBound;

assign object1_RBound = object1_H + ( ( object1_dir >= 2'b10 ) ? object1_LONGER : object1_SHORTER ) ;
assign object1_DBound = object1_V + ( ( object1_dir >= 2'b10 ) ? object1_SHORTER : object1_LONGER ) ;
assign object2_RBound = object2_H + ( ( object2_dir >= 2'b10 ) ? object2_LONGER : object2_SHORTER ) ;
assign object2_DBound = object2_V + ( ( object2_dir >= 2'b10 ) ? object2_SHORTER : object2_LONGER ) ;

always @( * ) begin
    if ( object1_en && object2_en && object1_RBound <= object2_RBound && object1_RBound >= object2_H &&
            ~( object1_DBound < object2_V || object1_V > object2_DBound ) ) begin
        object1_collide_dir[ 3 ] <= 1;
    end
    else begin
        object1_collide_dir[ 3 ] <= 0;
    end

    if ( object1_en && object2_en && object1_H <= object2_RBound && object1_H >= object2_H &&
            ~( object1_DBound < object2_V || object1_V > object2_DBound ) ) begin
        object1_collide_dir[ 2 ] <= 1;
    end
    else begin
        object1_collide_dir[ 2 ] <= 0;
    end

    if ( object1_en && object2_en && object1_V <= object2_DBound && object1_V >= object2_V
            && ~( object1_RBound < object2_H || object1_H > object2_RBound ) ) begin
        object1_collide_dir[ 0 ] <= 1;
    end
    else begin
        object1_collide_dir[ 0 ] <= 0;
    end

    if ( object1_en && object2_en && object1_DBound <= object2_DBound && object1_DBound >= object2_V
            && ~( object1_RBound < object2_H || object1_H > object2_RBound ) ) begin
        object1_collide_dir[ 1 ] <= 1;
    end
    else begin
        object1_collide_dir[ 1 ] <= 0;
    end
    object1_collide <= object1_collide_dir[ object1_dir ];
end

always @( * ) begin
    if ( object1_en && object2_en && object2_RBound <= object1_RBound && object2_RBound >= object1_H &&
            ~( object2_DBound < object1_V || object2_V > object1_DBound ) ) begin
        object2_collide_dir[ 3 ] <= 1;
    end
    else begin
        object2_collide_dir[ 3 ] <= 0;
    end

    if ( object1_en && object2_en && object2_H <= object1_RBound && object2_H >= object1_H &&
            ~( object2_DBound < object1_V || object2_V > object1_DBound ) ) begin
        object2_collide_dir[ 2 ] <= 1;
    end
    else begin
        object2_collide_dir[ 2 ] <= 0;
    end

    if ( object1_en && object2_en && object2_V <= object1_DBound && object2_V >= object1_V
            && ~( object2_RBound < object1_H || object2_H > object1_RBound ) ) begin
        object2_collide_dir[ 0 ] <= 1;
    end
    else begin
        object2_collide_dir[ 0 ] <= 0;
    end

    if ( object1_en && object2_en && object2_DBound <= object1_DBound && object2_DBound >= object1_V
            && ~( object2_RBound < object1_H || object2_H > object1_RBound ) ) begin
        object2_collide_dir[ 1 ] <= 1;
    end
    else begin
        object2_collide_dir[ 1 ] <= 0;
    end
    object2_collide <= object2_collide_dir[ object2_dir ];
end


endmodule
