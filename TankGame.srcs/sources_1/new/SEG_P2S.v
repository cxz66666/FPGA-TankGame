`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 01/03/2021 09:20:53 PM
// Design Name:
// Module Name: SEG_P2S
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


module SEG_P2S( clk,
                data_in,
                ena,
                S_DT,
                S_CLK,
                S_CLR,
                S_EN );
parameter WIDTH = 64;
parameter DELAY = 12;

input clk;
input ena;
input [ WIDTH - 1: 0 ] data_in;
output S_DT;
output S_CLK;
output S_CLR;
output S_EN;

wire s_clk, s_data;
reg out_ena;

assign S_CLK = s_clk;
assign S_DT = s_data;
assign S_EN = out_ena;
assign S_CLR = 1'b1;

reg [ WIDTH: 0 ] shift;
reg [ DELAY - 1: 0 ] counter = -1;
wire s_clk_Ena;

assign s_clk_Ena = | shift[ WIDTH - 1: 0 ];
assign s_clk = ~clk && s_clk_Ena;
assign s_data = shift[ WIDTH ];

always @ ( posedge clk or negedge ena ) begin
    if ( ena == 0 ) begin
        shift <= 0;
        counter <= 0;
        out_ena <= 1'b1;
    end
    else if ( s_clk_Ena ) begin
        shift <= { shift[ WIDTH - 1: 0 ], 1'b0 };
    end
    else begin
        if ( & counter ) begin
            shift <= { data_in, 1'b1 };
            out_ena <= 1'b0;
        end
        else begin
            out_ena <= 1'b1;
        end

        counter <= counter + 1'b1;
    end
end

endmodule
