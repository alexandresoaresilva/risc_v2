`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 11:19:59 PM
// Design Name:
// Module Name: memory_data_tb
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


module memory_data_tb( );

reg clk, MW, reset;
reg [7:0] PC_addr;
reg [31:0] data_IN;
wire [31:0] data_OUT;

memory_data UUT(
    .clock(clk),
    .reset(reset),
    .PC_addr(PC_addr),
    .MW(MW),
    .data_IN(data_IN),
    .data_OUT(data_OUT)
);

    initial begin
        {clk, MW, PC_addr, data_IN} = 1;
        //reset = 0;
        
        #10
        reset = 0;
        MW = 1;
        PC_addr = 0;
        data_IN = 32'd1;
        #10
        PC_addr = 127;
        data_IN = 32'hffff_ffff;
        #10
        PC_addr = 50;
        data_IN = 32'hffff_ffff;
        #20
        PC_addr = 3;
        data_IN = 32'd2;
        #20
        reset = 1;
        #10
        $finish;
    end
    always #5 clk = ~clk;
endmodule
