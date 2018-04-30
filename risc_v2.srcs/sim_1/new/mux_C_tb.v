`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 09:55:55 AM
// Design Name:
// Module Name: mux_C_tb
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


module mux_C_tb( );
    reg reset;
    reg [1:0] sel;
    reg [31:0] RAA;
    reg [9:0] BrA, PC_IN;
    wire [9:0] PC_OUT;

    mux_C UUT(
        .reset(reset),
        .sel(sel),
        .RAA(RAA),
        .BrA(BrA),
        .PC_IN(PC_IN),
        .PC_OUT(PC_OUT)
    );

    initial begin
        {reset, sel, RAA, BrA, PC_IN} = 0;
        reset = 1;
        #10
        reset = 0;
        sel = 2'b11;
        RAA = 32'd1_000_000_000;
        BrA = 10'd5_000_000;
        PC_IN = 32'd2;
        #10
        sel = 2'b01;
        #10
        sel = 2'b10;
        #10
        sel = 2'b00;
        #10
        $finish;
    end

endmodule
