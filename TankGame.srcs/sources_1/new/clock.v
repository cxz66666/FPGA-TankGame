`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 12/16/2020 02:29:20 PM
// Design Name:
// Module Name: clock
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


module clock(
           input wire clk_100MHz,
           output reg clk_2Hz,
           output reg clk_4Hz,
           output reg clk_8Hz,
           output reg clk_10ms
       );


reg [ 27: 0 ] cnt_2Hz, cnt_4Hz, cnt_8Hz, cnt_10ms;
reg [ 27: 0 ] ending_4Hz;

initial begin
    cnt_4Hz <= 0;
    cnt_2Hz <= 0;
    cnt_8Hz <= 0;
    cnt_10ms <= 0;
end



//calculate 2Hz clock
always @( posedge clk_100MHz ) begin
    cnt_2Hz <= cnt_2Hz + 1'b1;
    if ( cnt_2Hz >= 25000000 ) begin
        clk_2Hz <= 1;
    end
    else begin
        clk_2Hz <= 0;
    end
    if ( cnt_2Hz >= 50000000 ) begin
        cnt_2Hz <= 28'b0;
        // clk_2Hz <= 0;
    end
end

//calculate 4Hz clock
always @( posedge clk_100MHz ) begin
    cnt_4Hz <= cnt_4Hz + 1'b1;
    if ( cnt_4Hz >= ending_4Hz ) begin
        clk_4Hz <= 1;

    end
    else begin
        clk_4Hz <= 0;
    end

    if ( cnt_4Hz >= ending_4Hz * 2 ) begin
        cnt_4Hz <= 28'b0;
        // clk_4Hz <= 0;
    end
end

//calculate 8Hz clock
always @( posedge clk_100MHz ) begin
    cnt_8Hz <= cnt_8Hz + 1'b1;
    if ( cnt_8Hz >= 6250000 ) begin
        clk_8Hz <= 1;
    end
    else begin
        clk_8Hz <= 0;
    end
    if ( cnt_8Hz >= 12500000 ) begin
        cnt_8Hz <= 28'b0;
        // clk_8Hz <= 0;
    end
end

always @( posedge clk_100MHz ) begin

    ending_4Hz <= 12500000;

end

always @( posedge clk_100MHz ) begin
    cnt_10ms <= cnt_10ms + 1'b1;
    if ( cnt_10ms >= 500_000 ) begin
        clk_10ms <= 1;
    end
    else begin
        clk_10ms <= 0;
    end
    if ( cnt_10ms >= 1000_000 ) begin
        cnt_10ms <= 0;
    end
end
endmodule
