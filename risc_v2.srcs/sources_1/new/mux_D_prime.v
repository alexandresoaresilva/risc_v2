`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/22/2018 07:43:54 PM
// Design Name: 
// Module Name: mux_D_prime
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

module mux_D_prime(
    input reset,
    input [1:0] select_in_MD_EX_REG,
    input [31:0] in2_V_xor_N_WB_reg,
    input [31:0] in1_F_EX_wire,
    input [31:0] in0_data_OUT_memory_EX_wire,
    output reg [31:0] bus_D_prime
    );
    
    always@(*) begin
        if (reset)
            bus_D_prime <= 0;
        else begin
            case(select_in_MD_EX_REG)
//                    2'b00: bus_D_prime <= in0_data_OUT_memory_EX_wire;
//                    2'b01: bus_D_prime <= in1_F_EX_wire;
                    2'b00: bus_D_prime <= in1_F_EX_wire;
                    2'b01: bus_D_prime <= in0_data_OUT_memory_EX_wire;
                    2'b10: bus_D_prime <= in2_V_xor_N_WB_reg;
                default: bus_D_prime <= 0;
            endcase      
        end
    end
endmodule