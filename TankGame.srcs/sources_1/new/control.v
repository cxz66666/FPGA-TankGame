`timescale 1ns / 1ps



module control(
    input clk,
    input [9:0] ps2_output,
    output reg [1:0] player1_dir_feedback,
    output wire player1_fire,
    output wire player1_moving,
    output reg [1:0] player2_dir_feedback,
    output wire player2_fire,
    output wire player2_moving
    );
    assign player1_moving = | ps2_output[3:0];
    assign player2_moving = | ps2_output[7:4];
    assign player1_fire = ps2_output[8];
    assign player2_fire = ps2_output[9];

    always @(posedge clk) begin
        if     (ps2_output[0] == 1) player1_dir_feedback <= 2'b00;
        else if(ps2_output[1] == 1) player1_dir_feedback <= 2'b01;
        else if(ps2_output[2] == 1) player1_dir_feedback <= 2'b10;
        else if(ps2_output[3] == 1) player1_dir_feedback <= 2'b11;
        else player1_dir_feedback <= player1_dir_feedback;
    end

    always @(posedge clk) begin
        if     (ps2_output[4] == 1) player2_dir_feedback <= 2'b00;
        else if(ps2_output[5] == 1) player2_dir_feedback <= 2'b01;
        else if(ps2_output[6] == 1) player2_dir_feedback <= 2'b10;
        else if(ps2_output[7] == 1) player2_dir_feedback <= 2'b11;
        else player2_dir_feedback <= player2_dir_feedback;
    end

endmodule
