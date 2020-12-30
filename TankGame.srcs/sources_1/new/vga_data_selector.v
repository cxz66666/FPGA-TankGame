`timescale 1ns / 1ps


module vga_data_selector(
    input clk,
    input [11:0] in1,
    input [11:0] in2,
    input [11:0] in3,
    input [11:0] in4,
    output [11:0] out
    );

    assign out[0] = in1[0] | in2[0] | in3[0] | in4[0];
    assign out[1] = in1[1] | in2[1] | in3[1] | in4[1];
    assign out[2] = in1[2] | in2[2] | in3[2] | in4[2];
    assign out[3] = in1[3] | in2[3] | in3[3] | in4[3];
    assign out[4] = in1[4] | in2[4] | in3[4] | in4[4];
    assign out[5] = in1[5] | in2[5] | in3[5] | in4[5];
    assign out[6] = in1[6] | in2[6] | in3[6] | in4[6];
    assign out[7] = in1[7] | in2[7] | in3[7] | in4[7];
    assign out[8] = in1[8] | in2[8] | in3[8] | in4[8];
    assign out[9] = in1[9] | in2[9] | in3[9] | in4[9];
    assign out[10] = in1[10] | in2[10] | in3[10] | in4[10];
    assign out[11] = in1[11] | in2[11] | in3[11] | in4[11];

endmodule
