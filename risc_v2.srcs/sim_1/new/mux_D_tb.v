`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 09:20:39 AM
// Design Name:
// Module Name: mux_D_tb
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


module mux_D_tb( );

   reg reset;
   reg  [1:0] MD;
   reg [31:0]mem_data_IN, F;//F is the result from FU
   reg V_xor_N;
   wire [31:0] bus_D;


   mux_D UUT(
    .reset(reset),
  	.MD(MD),
    .mem_data_IN(mem_data_IN),
    .F(F),//F is the result from FU
  	.V_xor_N(V_xor_N),
  	.bus_D(bus_D)
  );
  
  initial begin
    {MD, mem_data_IN, F, V_xor_N} = 0;
    reset = 1;
    #10
    reset = 0;
    MD = 2'b11;
    mem_data_IN = 32'd400000000;
    F = 32'd1;
    V_xor_N = 1;
    #10
    MD = 2'b10;
    #10
    MD = 2'b01;
    #10
    MD = 2'b00;
    #10
    $finish;
  end
endmodule
