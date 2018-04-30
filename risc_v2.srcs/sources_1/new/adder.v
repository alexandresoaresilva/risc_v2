`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 10:24:21 AM
// Design Name:
// Module Name: adder
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


module adder(
    input reset,
    input [9:0] PC_2,
    input [31:0] bus_B,
    output reg [9:0] BrA
    );

    always@(*) begin
        if (reset)
            BrA <= 0;
        else begin
            BrA <= {22'd0, PC_2} + bus_B; 
        end
    end
endmodule
