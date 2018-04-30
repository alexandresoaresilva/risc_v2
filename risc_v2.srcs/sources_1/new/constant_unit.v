`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/10/2018 09:42:10 PM
// Design Name:
// Module Name: constant_unit
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


module constant_unit(
    input CS,
    input [14:0] IM,
    output [31:0] IM_filled
    );

    // assign IM_filled = {32{CS}} & { {17{IM[14]}} ,IM} //sign ext
    //                     |
    //                    {32{~CS}} & { 17'd0 ,IM}; //zero fill
    assign IM_filled = CS ? { {17{IM[14]}} , IM } :
                            {    17'b0     , IM }; //if CS, sign ext; else, zero fill
endmodule
