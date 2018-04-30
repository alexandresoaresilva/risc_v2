`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 08:01:51 AM
// Design Name:
// Module Name: mux_A_B_tb
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


module mux_A_B_tb();
    reg reset;
	reg [31:0]  data_A;
	reg [31:0]  data_B;
	reg [9:0] PC_1; //PC - 1
	reg [31:0] const_unit; //constant unit
	reg [1:0] MA_MB;
	wire[31:0] bus_A_wire;
	wire [31:0] bus_B_wire;

    mux_A_B UUT(
         .reset(reset),
         .data_A(data_A),
         .data_B(data_B),
         .PC_1(PC_1), //PC - 1
         .const_unit(const_unit), //constant unit
         .MA_MB(MA_MB),
         .bus_A(bus_A_wire),
         .bus_B(bus_B_wire)
    );
    initial begin
        reset = 1;
        {data_A, data_B, PC_1, const_unit, MA_MB} = 0;
        #10
        reset = 0;
        data_A = 32'h5555AAAA;
        data_B = 32'hAAAA5555;
        PC_1 = 10'b11_1111_1111;
        const_unit = 32'd1;
        MA_MB = 2'b00;
        #10
        MA_MB = 2'b11;
        #10
        MA_MB = 2'b01;
        #10
        MA_MB = 2'b10;
        #10
        $finish;
    end
endmodule
