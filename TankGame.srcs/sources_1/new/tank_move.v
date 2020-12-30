`timescale 1ns / 1ps

module tank_move(
           clk, reset_n, start,
           init_H, init_V,
           tank_dir, tank_en, tank_move_en, moving,
           tank_H, tank_V, tank_dir_feedback
       );

input clk;
input moving;
input reset_n;
input start;
input [ 9: 0 ] init_H;
input [ 9: 0 ] init_V;
input [ 1: 0 ] tank_dir;
input tank_en;
input tank_move_en;
output reg [ 9: 0 ] tank_H;
output reg [ 9: 0 ] tank_V;
output reg [ 2: 0 ] tank_dir_feedback;

parameter HEIGHT = 480;
parameter WIDTH = 640;
parameter TANK_HEIGHT = 32;
parameter TANK_WIDTH = 32;

localparam
    WAIT = 0,
    INITIAL = 1,
    STAY = 2,
    UP = 4,
    DOWN = 5,
    LEFT = 6,
    RIGHT = 7;

reg [ 2: 0 ] current_state, next_state;


always @( posedge clk ) begin: state_flip_flop
    if ( !reset_n ) begin
        current_state <= WAIT;
    end
    else if ( !tank_en ) begin
        current_state <= WAIT;
    end
    else begin
        current_state <= next_state;
    end
end

reg init;
reg counter_en, counter_move_en;

always @( * ) begin: signals
    counter_en = 1'b0;
    init = 1'b0;
    tank_dir_feedback[ 2 ] = 1;
    case ( current_state )
        INITIAL: begin
            init = 1;
        end
        UP: begin
            counter_en = 1;
            tank_dir_feedback = 3'b000;
        end
        DOWN: begin
            counter_en = 1;
            tank_dir_feedback = 3'b001;
        end
        LEFT: begin
            counter_en = 1;
            tank_dir_feedback = 3'b010;
        end
        RIGHT: begin
            counter_en = 1;
            tank_dir_feedback = 3'b011;
        end
    endcase
end

always @( * ) begin: state_table
    case ( current_state )
        WAIT:
            next_state = tank_en ? INITIAL : WAIT;
        INITIAL:
            next_state = STAY;
        STAY, UP, DOWN, LEFT, RIGHT: begin
            if ( !tank_move_en || !moving ) begin
                next_state = STAY;
            end
            else begin
                case ( tank_dir )
                    2'b00:
                        next_state = UP;
                    2'b01:
                        next_state = DOWN;
                    2'b10:
                        next_state = LEFT;
                    2'b11:
                        next_state = RIGHT;
                endcase
            end
        end

        default:
            next_state = STAY;
    endcase
end

always @( posedge clk ) begin: tank_move_logic
    if ( !reset_n ) begin
        tank_H <= init_H;
        tank_V <= init_V;
    end
    else if ( init == 1 ) begin
        tank_H <= init_H;
        tank_V <= init_V;
    end
    else if ( counter_move_en && tank_move_en ) begin
        case ( tank_dir_feedback )
            3'b000: begin
                if ( tank_V > 0 ) begin
                    tank_V <= tank_V - 1;
                end
                else begin
                    tank_V <= tank_V;
                end
                tank_H <= tank_H;
            end
            3'b001: begin
                if ( tank_V + TANK_HEIGHT + 1 < HEIGHT ) begin
                    tank_V <= tank_V + 1;
                end
                else begin
                    tank_V <= tank_V;
                end
                tank_H <= tank_H;
            end
            3'b010: begin
                if ( tank_H > 0 ) begin
                    tank_H <= tank_H - 1;
                end
                else begin
                    tank_H <= tank_H;
                end
                tank_V <= tank_V;
            end
            3'b011: begin
                if ( tank_H + TANK_WIDTH + 1 < WIDTH ) begin
                    tank_H <= tank_H + 1;
                end
                else begin
                    tank_H <= tank_H;
                end
                tank_V <= tank_V;
            end
            default: begin
                tank_H <= tank_H;
                tank_V <= tank_V;
            end
        endcase
    end
    else begin
        tank_H <= tank_H;
        tank_V <= tank_V;
    end
end

reg [ 31: 0 ] counter;
always @( posedge clk ) begin
    if ( !reset_n ) begin
        counter <= 0;
        counter_move_en <= 0;
    end
    else if ( counter == 5_000_000 ) begin
        counter <= 0;
        counter_move_en <= 1;
    end
    else if ( counter_en == 0 ) begin
        counter <= 0;
        counter_move_en <= 0;
    end
    else begin
        counter <= counter + 1;
        counter_move_en <= 0;
    end
end
endmodule
