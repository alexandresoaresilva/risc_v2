`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 09:04:40 PM
// Design Name:
// Module Name: adder_tb
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


module adder_tb();

reg reset;
reg [9:0] PC_2;
reg [31:0] bus_B;
wire [9:0] BrA;

adder UUT(
    .reset(reset),
    .PC_2(PC_2),
    .bus_B(bus_B),
    .BrA(BrA)
    );

    initial begin
        {bus_B, PC_2, reset} = 0;
        #10
        bus_B = 32'haaaa5555;
        PC_2 = 10'd1023;
        #10
        bus_B = 32'hffff_fffd;
        PC_2 = 10'd1;
        #10
        reset = 1;
        #10
        $finish;
    end
endmodule