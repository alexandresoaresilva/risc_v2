`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/09/2018 05:55:01 PM
// Design Name:
// Module Name: intr_dec_tb
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
//NOP
//ADD
//SUB
//SLT
//AND
//OR
//XOR
//ST
//LD
//ADI
//SBI
//NOT
//ANI
//ORI
//XRI
//AIU
//SIU
//MOV
//LSL
//LSR
//JMR
//BZ
//BNZ
//JMP
//JML
module intr_dec_tb( );
//    `include "opcodes.inc"
    reg reset_reg;
    reg [6:0] opcode_reg;
    reg [4:0] SA_reg, SB_reg, DR_reg;
    reg [14:0] IM_reg;
    reg [14:0] target_offset_reg;
    reg [9:0] null_ten_bits;
    reg [31:0] IR_reg;
    reg [4:0] SH_reg;
    //wire [6:0] opcode_wire;
    wire [4:0] SH_wire, FS_wire;
    wire [1:0] MD_wire, BS_wire;
    wire PS_wire, MW_wire, RW_wire, MA_wire, MB_wire, CS_wire;
    wire [4:0] SA_wire, SB_wire, DR_wire;
    //wire [14:0] IM_or_targ_offset_wire;

    parameter [6:0]  NOP = 7'b0000000; // None
    parameter [6:0]  ADD = 7'b0000010; // R[DR] <- R[SA] + R[SB]
    parameter [6:0]  SUB = 7'b0000101; // R[DR] <- R[SA] + not(R[SB]) + 1
    //SLT - set if less than
    parameter [6:0]  SLT = 7'b1100101; // if R[SA] < R[SB] then R[DR] = 1
    parameter [6:0]  AND = 7'b0001000; // R[DR] <- R[SA] and R[SB]
    parameter [6:0]  OR =  7'b0001010; // R[DR] <- R[SA] or R[SB]
    parameter [6:0]  XOR = 7'b0001100; // R[DR] <- R[SA] xor R[SB]
    //ST == store
    parameter [6:0]  ST =  7'b0000001; // M[R[SA]] <- R[SB]
    //LD == load
    parameter [6:0]  LD =  7'b0100001; // R[DR] <- M[R[SA]]
    //operations with IMMEDIATE  -
    parameter [6:0]  ADI = 7'b0100010; // R[DR] <- R[SA] + (se IM)
    parameter [6:0]  SBI = 7'b0100101; // R[DR] <- R[SA] + not(se IM) + 1
    parameter [6:0]  NOT = 7'b0101110; // R[DR] <- not R[SA]
    parameter [6:0]  ANI = 7'b0101000; // R[DR] <- R[SA] and (0 || IM )
    parameter [6:0]  ORI = 7'b0101010; // R[DR] <- R[SA] or  (0 || IM ) + 1
    parameter [6:0]  XRI = 7'b0101100; // R[DR] <- R[SA] xor (0 || IM ) + 1
    //AIU - add immediate unsigned
    parameter [6:0]  AIU = 7'b1100010; // R[DR] <- R[SA] + (0 || IM )
    //SIU - subtract immediate unsigned
    parameter [6:0]  SIU = 7'b1000101; // R[DR] <- R[SA] + (0 || IM ) + 1
    parameter [6:0]  MOV = 7'b1000000; // R[DR] <- R[SA]
    //logical shifts (by the amount in the tSH bits, which are [4:0] of IR
    parameter [6:0]  LSL = 7'b0110000; // R[DR] <- lsl R[SA] by SH
    parameter [6:0]  LSR = 7'b0110001; // R[DR] <- lsr R[SA] by SH
    //JMR == jump register
    parameter [6:0]  JMR = 7'b1100001; // PC <- R[RA]
    parameter [6:0]  BZ =  7'b0100000; // If R[SA] == 0, then PC <- PC + 1 + SE im
    parameter [6:0]  BNZ = 7'b1100000; // If R[SA] != 0, then PC <- PC + 1 + SE im
    parameter [6:0]  JMP = 7'b1000100; // PC <- PC + 1 + se IM
    //JML - jump and link
    parameter [6:0]  JML = 7'b0000111; // PC <- PC + 1 + se IM, R[DR] <- PC + 1

    instr_dec UUT(
        .reset(reset_reg),
        .IR(IR_reg),
        .SH(SH_wire),
        .FS(FS_wire),
        .MD(MD_wire),
        .BS(BS_wire),
        .PS(PS_wire),
        .MW(MW_wire),
        .RW(RW_wire),
        .MA(MA_wire),
        .MB(MB_wire),
        .CS(CS_wire),
        .SA(SA_wire),
        .SB(SB_wire),
        .DR(DR_wire)
        //,.IM_or_targ_offset(IM_or_targ_offset_wire)
    );

    initial begin
        {opcode_reg, DR_reg, SA_reg, SB_reg,
            IM_reg, target_offset_reg, null_ten_bits, SH_reg} = 0;
        //three register assingment
        IR_reg = {opcode_reg, DR_reg, SA_reg, SB_reg,  null_ten_bits};
        //2-register type
        //IR_reg = {opcode_reg, DR_reg, SA_reg, IM_reg};
        //branch
        //IR_reg = {opcode_reg, DR_reg, SA_reg, target_offset_reg};
        reset_reg=1;
        #10
        reset_reg=0;
        opcode_reg = NOP;
        DR_reg = 5'b10001;
        SA_reg = 5'b10000;
        SB_reg = 5'b00101;
        //IR_reg = {
        IR_reg = {opcode_reg, DR_reg, SA_reg, SB_reg,  null_ten_bits};
//////////////////////        //////////////////////    //////////////////////
        #50
        //STORING THE 1ST value in R[1]
        opcode_reg = AIU;
        IM_reg = 15'd1;
        SA_reg = 5'd0; // R0 == 0
        DR_reg = 5'd1; // R[DR] == R1
        IR_reg = {opcode_reg, DR_reg, SA_reg, IM_reg};
        //STORING r1 IN MEMORY 0
        //IM_reg = 15'd32767; //max value for immediate
//////////////////////        //////////////////////    //////////////////////
        #50
        opcode_reg = ST;
        DR_reg = 5'd0; //doesn't do antyhing here
        SA_reg = 5'd1; //loads from memory position M[ R[SA]== 1 ]
        SB_reg = 5'd1; //previous value stored in R[1] == 1
        IR_reg = {opcode_reg, DR_reg, SA_reg, SB_reg,  null_ten_bits};
//////////////////////        //////////////////////    //////////////////////
        #50
        //loading from memory
        opcode_reg = LD;
        DR_reg = 5'd2; //r2
        SA_reg = 5'd1; //loads from M[1]
        SB_reg = 5'dX; //not USED
        IR_reg = {opcode_reg, DR_reg, SA_reg, SB_reg,  null_ten_bits};
        #50
//////////////////////        //////////////////////    //////////////////////
        opcode_reg = LSL;
        DR_reg = 5'd3;
        SA_reg = 5'd2;
        SB_reg = 5'dX; //not USED
        SH_reg = 5'd2;
        IR_reg = {opcode_reg, DR_reg, SA_reg, SB_reg, {5'd0, SH_reg} };
//////////////////////        //////////////////////    //////////////////////
        #50
        opcode_reg = SLT;
        DR_reg = 5'd4;
        SA_reg = 5'd2;
        SB_reg = 5'd3;
        IR_reg = {opcode_reg, DR_reg, SA_reg, SB_reg,  null_ten_bits};
//////////////////////        //////////////////////    //////////////////////
        #50
        opcode_reg = JMR;
        DR_reg = 5'd0;//not used
        SA_reg = 5'd3;
        SB_reg = 5'd0;//not used
        IR_reg = {opcode_reg, DR_reg, SA_reg, SB_reg,  null_ten_bits};
//////////////////////        //////////////////////    //////////////////////
        #50
        opcode_reg = BNZ;
        DR_reg = 5'd0;//not used
        SA_reg = 5'd4;
        SB_reg = 5'd0;//not used
        IM_reg = 15'd1000;
        IR_reg = {opcode_reg, DR_reg, SA_reg, IM_reg};
//////////////////////        //////////////////////    //////////////////////
        #50
        opcode_reg = JML;
        DR_reg = 5'd5;
        SA_reg = 5'd0;//not used
        SB_reg = 5'd0;//not used
        IR_reg = {opcode_reg, DR_reg, SA_reg, IM_reg};
        #10
        reset_reg = 1;
        #10
        $finish;
    end
endmodule
