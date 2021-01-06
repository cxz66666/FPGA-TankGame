`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/05/2021 10:41:37 PM
// Design Name:
// Module Name: item_random_generator
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


module item_random_generator(
           input clk,
           input clk_4Hz,
           input set_finish,
           input enable,
           output reg dout,
           output reg set_require,
           output reg [ 1: 0 ] item_type,
           output reg [ 10: 0 ] random_xpos,
           output reg [ 10: 0 ] random_ypos
       );


parameter ITEM_BASE_TIME = 24;
parameter ITEM_STAY_TIME = 32;
parameter TANK_WIDTH = 32;
parameter TANK_HEIGHT = 32;
parameter WIDTH = 640;
parameter HEIGHT = 480;

wire [ 14: 0 ] random_num;
reg [ 31: 0 ] cnt;
reg lock;
initial begin
    random_xpos <= 0;
    random_ypos <= 0;
    item_type <= 0;
    lock <= 0;
end
Random u_Random(
           .clk( clk_4Hz ),
           .rst_n( 1'b1 ),
           .flag( 2'b00 ),
           .random( ),
           .random_14( random_num )
       );
always @( posedge clk ) begin
    if ( enable ) begin
        cnt <= cnt + 1'b1;
        if ( cnt >= ITEM_BASE_TIME * 25000000 ) begin
            dout <= 1'b1;
            set_require <= 1'b1;
            if ( cnt >= ( ITEM_BASE_TIME + ITEM_STAY_TIME ) * 25000000 || set_finish == 1'b1 ) begin
                dout <= 1'b0;
                cnt <= 0;
                set_require <= 1'b0;
            end
        end
        else begin
            dout <= 1'b0;
            set_require <= 1'b0;
        end
    end
end

always @( posedge clk ) begin
    if ( dout ) begin
        if ( !lock ) begin
            lock <= 1'b1;
            random_xpos <= random_num[ 14: 1 ] % ( WIDTH - TANK_WIDTH );
            random_ypos <= random_num[ 13: 0 ] % ( HEIGHT - TANK_HEIGHT );
            item_type <= ( random_num[ 14: 0 ] % 3 ) + 1;
        end
    end
    else begin
        random_xpos <= 0;
        random_ypos <= 0;
        lock <= 0;
        item_type <= 0;
    end
end
endmodule
