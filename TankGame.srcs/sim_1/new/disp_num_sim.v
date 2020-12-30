`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/16/2020 04:48:32 PM
// Design Name:
// Module Name: disp_num_sim
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


module disp_num_sim;
reg clk;
reg RST;
reg [ 31: 0 ] HEXS;
reg [ 7: 0 ] points;
reg [ 7: 0 ] LES;
wire [ 7: 0 ] AN;
wire [ 7: 0 ] Segment;


Disp_Num my_test_Num(
             .clk( clk ),
             .RST( 1'b0 ),
             .HEXS( HEXS ),
             .points( 8'b1 ),
             .LES( 8'b0 ),
             .AN( AN ),
             .Segment( SEGMENT1 )
         );

initial begin
    clk = 0;
    RST = 0;
    HEXS = 32'b0000_0001_0010_0011_0100_0101_0110_0111;

end
always begin
    #10 clk = 1;
    #10 clk = 0;
end
endmodule
