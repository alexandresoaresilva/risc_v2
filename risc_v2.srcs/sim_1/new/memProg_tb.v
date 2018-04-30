`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/11/2018 11:11:31 PM
// Design Name:
// Module Name: memProg_tb
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


module memProg_tb( );

   reg [9:0] PC;
   wire [31:0] IR;

   memProg UUT(
      .PC(PC),
      .IR(IR)
    );
      integer i;
      initial begin
          for (i=0; i < 8; i = i + 1) begin
            PC <= i;
            #10;
          end
          $finish;
      end
endmodule
