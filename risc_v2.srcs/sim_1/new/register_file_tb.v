`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 06:48:25 AM
// Design Name:
// Module Name: register_file_tb
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


module register_file_tb( );
    reg clock_reg;
    reg reset_reg;
    reg write_now_reg;
    reg [4:0] SA_reg;
    reg [4:0] SB_reg;
    reg [4:0] DR_reg;
    reg [31:0] data_IN_reg;
    wire [31:0] data_A_OUT_wire;
    wire [31:0] data_B_OUT_wire;

    register_file UUT(
        .clock(clock_reg),
        .reset(reset_reg),
        .write_now(write_now_reg),
        .SA(SA_reg),
        .SB(SB_reg),
        .DR(DR_reg),
        .data_IN(data_IN_reg),
        .data_A_OUT(data_A_OUT_wire),
        .data_B_OUT(data_B_OUT_wire)
    );

        initial begin
            {reset_reg, clock_reg, write_now_reg} = {1'b1, 1'b1,1'b1};
            #20
            reset_reg = 0;
            SA_reg = 0;
            SB_reg = 0;
            DR_reg = 1;
            data_IN_reg = 1;
            #20
            reset_reg = 0;
            SA_reg = 5'd0;
            SB_reg = 5'd1;
            DR_reg = 5'd0;
            data_IN_reg = 32'd4_000_005;
            #20
            SA_reg = 5'd1;
            SB_reg = 5'd0;
            DR_reg = 5'd2;
            data_IN_reg = 32'd11;
            #20
            SA_reg = 5'd2;
            SB_reg = 5'd3;
            DR_reg = 5'd3;
            data_IN_reg = 32'd15;
            #20
            reset_reg = 1;
            #20
            reset_reg = 0;
            $finish;
        end
        always #5 clock_reg = ~clock_reg;
endmodule
