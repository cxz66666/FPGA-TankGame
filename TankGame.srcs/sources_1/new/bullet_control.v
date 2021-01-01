`timescale 1ns / 1ps


module bullet_control(
           input clk,
           input reset_n,
           input start,

           input [ 10: 0 ] tank_H,
           input [ 10: 0 ] tank_V,
           input tank_en,
           input [ 1: 0 ] tank_dir,
           input tank_fire,
           input [ 10: 0 ] vgaH,
           input [ 10: 0 ] vgaV,
           input ready,

           output [ 11: 0 ] bulletData,
           output reg [ 10: 0 ] bullet_H_feedback,
           output reg [ 10: 0 ] bullet_V_feedback,
           output reg [ 2: 0 ] bullet_direction
       );

parameter BULLET_LONGER = 10;
parameter BULLET_SHORTER = 5;
parameter BULLET_LONGER_CENTER = 5;
parameter BULLET_SHORTER_CENTER = 2;
parameter HEIGHT = 480;
parameter WIDTH = 640;
parameter TANK_V_CENTER = 16;
parameter TANK_H_CENTER = 16;
parameter TANK_HEIGHT = 32, TANK_WIDTH = 32;

localparam
    UP = 3'd0,
    DOWN = 3'd1,
    LEFT = 3'd2,
    RIGHT = 3'd3,
    WAIT = 3'd4,
    READY = 3'd5;

reg counter_en;
reg [ 31: 0 ] counter;
reg [ 2: 0 ] current_state, next_state;

always @( posedge clk ) begin:state_flip_flop
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

always @( * ) begin: state_table
    case ( current_state )
        WAIT:
            next_state = start ? READY : WAIT;
        READY: begin
            if ( !tank_fire ) begin
                next_state = READY;
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
        UP:
            next_state = ready ? READY : UP;
        DOWN:
            next_state = ready ? READY : DOWN;
        LEFT:
            next_state = ready ? READY : LEFT;
        RIGHT:
            next_state = ready ? READY : RIGHT;
        default:
            next_state = READY;
    endcase
end

always @( * ) begin: bullet_logic
    counter_en = 0;
    bullet_direction = 3'b111;
    case ( current_state )
        READY: begin
            counter_en = 0;
            bullet_direction = 3'b111;
        end
        UP: begin
            counter_en = 1;
            bullet_direction = 3'b000;
        end
        DOWN: begin
            counter_en = 1;
            bullet_direction = 3'b001;
        end
        LEFT: begin
            counter_en = 1;
            bullet_direction = 3'b010;
        end
        RIGHT: begin
            counter_en = 1;
            bullet_direction = 3'b011;
        end
    endcase
end

reg bullet_move_en;
always @( posedge clk ) begin: counter_logic
    if ( !reset_n ) begin
        counter <= 0;
        bullet_move_en <= 0;
    end
    else if ( counter == 1_000_000 ) begin
        counter <= 0;
        bullet_move_en <= 1;
    end
    else if ( counter_en == 0 ) begin
        counter <= 0;
        bullet_move_en <= 0;
    end
    else begin
        counter <= counter + 1;
        bullet_move_en <= 0;
    end
end

always @( posedge clk ) begin: bullet_move
    if ( bullet_direction[ 2 ] ) begin   //if no direction
        case ( tank_dir )
            2'b00: begin
                bullet_H_feedback <= tank_H + TANK_H_CENTER - BULLET_SHORTER_CENTER;
                bullet_V_feedback <= ( ( tank_V >= BULLET_LONGER ) ? ( tank_V - BULLET_LONGER ) : 0 );
            end
            2'b01: begin
                bullet_H_feedback <= tank_H + TANK_H_CENTER - BULLET_SHORTER_CENTER;
                bullet_V_feedback <= ( ( tank_V + TANK_HEIGHT + BULLET_LONGER <= HEIGHT ) ? ( tank_V + TANK_HEIGHT + BULLET_LONGER ) : HEIGHT );
            end
            2'b10: begin
                bullet_H_feedback <= ( ( tank_H >= BULLET_LONGER ) ? ( tank_H - BULLET_LONGER ) : 0 );
                bullet_V_feedback <= tank_V + TANK_V_CENTER - BULLET_SHORTER_CENTER;
            end
            2'b11: begin
                bullet_H_feedback <= ( ( tank_H + BULLET_LONGER + TANK_WIDTH <= WIDTH ) ? ( tank_H + BULLET_LONGER + TANK_WIDTH ) : WIDTH ) ;
                bullet_V_feedback <= tank_V + TANK_V_CENTER - BULLET_SHORTER_CENTER;
            end
        endcase
    end
    else if ( bullet_move_en ) begin
        case ( bullet_direction[ 1: 0 ] )
            2'b00: begin
                bullet_V_feedback <= bullet_V_feedback - 1;
                bullet_H_feedback <= bullet_H_feedback;
            end

            2'b01: begin
                bullet_V_feedback <= bullet_V_feedback + 1;
                bullet_H_feedback <= bullet_H_feedback;
            end
            2'b10: begin
                bullet_H_feedback <= bullet_H_feedback - 1;
                bullet_V_feedback <= bullet_V_feedback;
            end
            2'b11: begin
                bullet_H_feedback <= bullet_H_feedback + 1;
                bullet_V_feedback <= bullet_V_feedback;
            end
        endcase
    end
    else begin
        bullet_H_feedback <= bullet_H_feedback;
        bullet_V_feedback <= bullet_V_feedback;
    end
end

wire [ 11: 0 ] UP_data, DOWN_data, LEFT_data, RIGHT_data;
wire [ 7: 0 ] bulletAddr;
reg bullet_bound;

always @( * ) begin
    case ( bullet_direction[ 1: 0 ] )
        2'b00: begin
            bullet_bound <= ( bullet_H_feedback <= vgaH && bullet_H_feedback > vgaH - BULLET_SHORTER && bullet_V_feedback <= vgaV && bullet_V_feedback > vgaV - BULLET_LONGER ) ? 1 : 0;
        end
        2'b01: begin
            bullet_bound <= ( bullet_H_feedback <= vgaH && bullet_H_feedback > vgaH - BULLET_SHORTER && bullet_V_feedback <= vgaV && bullet_V_feedback > vgaV - BULLET_LONGER ) ? 1 : 0;
        end
        2'b10: begin
            bullet_bound <= ( bullet_H_feedback <= vgaH && bullet_H_feedback > vgaH - BULLET_LONGER && bullet_V_feedback > vgaV - BULLET_SHORTER && bullet_V_feedback <= vgaV ) ? 1 : 0;
        end
        2'b11: begin
            bullet_bound <= ( bullet_H_feedback <= vgaH && bullet_H_feedback > vgaH - BULLET_LONGER && bullet_V_feedback <= vgaV && bullet_V_feedback > vgaV - BULLET_SHORTER ) ? 1 : 0;
        end
    endcase
end
reg [ 5: 0 ] bullet_addr;
always @( * ) begin
    case ( bullet_direction[ 1: 0 ] )
        2'b00: begin
            bullet_addr <= bullet_bound ? ( ( vgaV - bullet_V_feedback ) * BULLET_SHORTER + ( vgaH - bullet_H_feedback ) ) : 15;
        end
        2'b01: begin
            bullet_addr <= bullet_bound ? ( ( vgaV - bullet_V_feedback ) * BULLET_SHORTER + ( vgaH - bullet_H_feedback ) ) : 15;
        end
        2'b10: begin
            bullet_addr <= bullet_bound ? ( ( vgaV - bullet_V_feedback ) * BULLET_LONGER + ( vgaH - bullet_H_feedback ) ) : 15;
        end
        2'b11: begin
            bullet_addr <= bullet_bound ? ( ( vgaV - bullet_V_feedback ) * BULLET_LONGER + ( vgaH - bullet_H_feedback ) ) : 15;
        end
    endcase

end

wire [ 11: 0 ] outData;

bullet_left_img left( .addra( bullet_addr ), .clka( clk ), .douta( LEFT_data ), .ena( 1'b1 ) );
bullet_right_img right( .addra( bullet_addr ), .clka( clk ), .douta( RIGHT_data ), .ena( 1'b1 ) );
bullet_up_img up( .addra( bullet_addr ), .clka( clk ), .douta( UP_data ), .ena( 1'b1 ) );
bullet_down_img down( .addra( bullet_addr ), .clka( clk ), .douta( DOWN_data ), .ena( 1'b1 ) );

tank_data_selector bullet_selector( .clk( clk ), .UP( UP_data ), .DOWN( DOWN_data ), .LEFT( LEFT_data ),
                                    .RIGHT( RIGHT_data ), .Dir( bullet_direction[ 1: 0 ] ), .tankData( outData ) );

assign bulletData = ( ~ready & bullet_bound ) ? outData : 0;

endmodule
