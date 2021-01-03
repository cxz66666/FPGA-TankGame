


module SegAndLed_K7(
           input wire clk,
           input wire [ 2: 0 ] mode,
           input wire [ 15: 0 ] led_classic,
           input wire [ 15: 0 ] led_infinity,
           input wire [ 7: 0 ] score_classic,
           input wire [ 7: 0 ] score_infinity,
           input wire [ 31: 0 ] default_num,                                         //when mode is 0
           input wire [ 4: 0 ] timer,
           input wire enable_game_classic,
           input wire enable_game_infinity,
           input wire player1_tank_en,
           input wire player2_tank_en,
           output wire [ 3: 0 ] AN ,
           output wire [ 7: 0 ] Segment,
           output reg [ 7: 0 ] LED,
           output ledclk,
           output ledsout,
           output wire ledclrn,
           output LEDEN ,
           output seg_clk,
           output seg_sout,
           output SEG_PEN,
           output seg_clrn
       );


reg [ 31: 0 ] num;
initial begin
    LED <= 0;
    num <= 0;
end



always @( posedge clk ) begin
    if ( enable_game_classic == 0 && enable_game_infinity == 0 ) begin
        LED <= 0;
    end
    else begin
        if ( enable_game_classic ) begin
            LED <= led_classic;
        end
        else if ( enable_game_infinity ) begin
            LED <= led_infinity;
        end
    end
end
always @( posedge clk ) begin
    case ( mode )
        2'b00:
            num <= default_num;
        2'b01:
            num <= { 4'b1010, 3'b000, player1_tank_en, score_classic[ 3: 0 ], 4'b000, 4'b1011, 3'b000, player2_tank_en, score_classic[ 7: 4 ], 4'b000 };
        2'b10:
            num <= { 4'b1010, 3'b000, player1_tank_en, 3'b000, player2_tank_en, score_infinity[ 3: 0 ], 4'b1011, score_infinity[ 7: 4 ], 3'b000, timer };
        2'b11:
            num <= { 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1000, 4'b1000 };
        default num <= 0;

    endcase
end
endmodule
