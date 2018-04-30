`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 06:30:14 AM
// Design Name:
// Module Name: constant_unit_tb
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


module constant_unit_tb( );

    reg CS;
    reg [14:0] IM;
    wire [31:0] IM_filled;

    constant_unit UUT(
        .CS(CS),
        .IM(IM),
        .IM_filled(IM_filled)
        );

        initial begin
            {CS, IM}= 0;
            #10
            {CS, IM}= {1'b1,15'd32767};
            #10
            CS = 1'b0;
            #10
            {CS, IM}= 0;
        end


endmodule
