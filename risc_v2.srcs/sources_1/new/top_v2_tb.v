`timescale 1ns / 1ps

module top_v2_tb;

reg reset, clock;

wire [9:0] PC_IF_output_wire;
wire [9:0] PC_2_out_wire;
wire [31:0] IR_IF_wire;

wire CS_DOF_wire;
wire [31:0] IM_filled_DOF_wire;

wire [4:0] AAddr_DOF_wire;
wire [31:0] regFile_Aout_DOF_wire;
wire [4:0] BAddr_DOF_wire ;
wire [31:0] regFile_Bout_DOF_wire;

wire [31:0] RAA_EX_reg_wire;//mux A out stored
wire [31:0] B_EX_reg_wire;//mux B out stored out stored

wire PS_EX_wire;
wire MW_EX_wire;
wire [1:0] BS_EX_wire;
wire [4:0] SH_EX_wire;

wire [4:0] FS_EX_wire;
wire V_EX_wire;
wire N_EX_wire;
wire C_EX_wire ;
wire Z_EX_wire;
wire [31:0] F_EX_wire;

wire [31:0] data_OUT_memory_EX_wire;
wire [9:0]  BrA_EX_wire;

wire [1:0]  MD_WB_wire;
wire [31:0] bus_D_WB_wire;

wire RW_WB_wire;
wire [4:0] DA_WB_wire;
wire [31:0] reg_DR_just_written_out_wire;
wire [31:0] mux_D_prime_output_wire;

top_v2 UUT(
    .reset(reset  ),
    .clock( clock ),
    //PC(  ), IR
    .PC_IF_output( PC_IF_output_wire  ),
    .PC_2_out( PC_2_out_wire ),
    .IR_IF_output( IR_IF_wire ),
    //CU
    .CS_DOF_output( CS_DOF_wire ),
    .IM_filled_DOF_output( IM_filled_DOF_wire ),
    //register read
    //register read(  ), addr input
    .AAddr_DOF_output( AAddr_DOF_wire ),
    .regFile_Aout_DOF_output( regFile_Aout_DOF_wire ),
    .BAddr_DOF_output(BAddr_DOF_wire  ),
    .regFile_Bout_DOF_output(  regFile_Bout_DOF_wire),
    //mux A(  ), B
    .RAA_EX_reg_output( RAA_EX_reg_wire ),//mux A out stored
    .B_EX_reg_output( B_EX_reg_wire  ),//mux B out stored out stored
    //storing instruction decoded
    .PS_EX_output(PS_EX_wire  ),
    .MW_EX_output( MW_EX_wire ),
    .BS_EX_output( BS_EX_wire ),
    .SH_EX_output( SH_EX_wire ),
    //function unit
    .FS_EX_output(FS_EX_wire  ),
    .V_EX_output(  V_EX_wire),
    .N_EX_output( N_EX_wire ),
    .C_EX_output( C_EX_wire  ),
    .Z_EX_output( Z_EX_wire ),
    .F_EX_output( F_EX_wire ),
    //memory read
    .data_OUT_memory_EX_output( data_OUT_memory_EX_wire ),
    .BrA_EX_output( BrA_EX_wire ),
    //MUX D
    .MD_WB_output( MD_WB_wire ),
    .bus_D_WB_output(bus_D_WB_wire  ),
    //register write
    .RW_WB_output(RW_WB_wire),
    .DA_WB_output( DA_WB_wire ),
    .reg_DR_just_written_out(reg_DR_just_written_out_wire ),
    .mux_D_prime_output(mux_D_prime_output_wire)
);
    initial begin
        clock = 0;
        reset = 1;
        #5
        reset = 0;
        #50000
        $finish;
    end
    always #5 clock = ~clock;
endmodule
