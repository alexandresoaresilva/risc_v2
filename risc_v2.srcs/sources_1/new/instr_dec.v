`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/08/2018 05:37:14 PM
// Design Name:
// Module Name: instr_dec
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
/////////////////////////////////////////////////////////////////////////////

module instr_dec(
    input reset,
    input [31:0] IR,
    //14:0 == IM (immediate address)
    // 4:0 == SH (shift amount
    //ouputs with negedge clock
    output [1:0] MD, BS,
    output PS, MW, RW,
    //passthrough outputs
    output [4:0] FS,
    output MA, MB, CS,
    output [4:0] SA, SB, DR
    //, output [14:0] IM_or_targ_offset
    );

    parameter [6:0]  NOP = 7'b0000000; // None
    parameter [6:0]  ADD = 7'b0000010; // R[DR] <- R[SA] + R[SB]
    parameter [6:0]  ADDC = 7'b0000011; // R[DR] <- R[SA] + R[SB] + carry_in
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



    assign DR = IR[24:20] | 5'd0;
    assign SA = IR[19:15] | 5'd0;
    assign SB = IR[14:10] | 5'd0;

    reg [14:0] control_word;

	always @(*) begin
        if (reset) begin
            control_word = 15'd0;
        end
        else begin
            case(IR[31:25])//opcode
                //  RW || MD[1:0] || BS[1:0] || PS || MW  || FS[4:0] || ( MB || MA || CS)
                NOP: control_word = 15'b0_00_00_0_0_00000_000;
                ADD: control_word = 15'b1_00_00_0_0_00010_000;
                ADDC:control_word = 15'b1_00_00_0_0_00011_000;
                SUB: control_word = 15'b1_00_00_0_0_00101_000;
                SLT: control_word = 15'b1_10_00_0_0_00101_000;
                AND: control_word = 15'b1_00_00_0_0_01000_000;
                OR : control_word = 15'b1_00_00_0_0_01010_000;
                XOR: control_word = 15'b1_00_00_0_0_01100_000;
                ST : control_word = 15'b0_00_00_0_1_00000_000;
                LD : control_word = 15'b1_01_00_0_0_00000_000;
                ADI: control_word = 15'b1_00_00_0_0_00010_101;
                SBI: control_word = 15'b1_00_00_0_0_00101_101;
                NOT: control_word = 15'b1_00_00_0_0_01110_000;
                ANI: control_word = 15'b1_00_00_0_0_01000_100;
                ORI: control_word = 15'b1_00_00_0_0_01010_100;
                XRI: control_word = 15'b1_00_00_0_0_01100_100;
                AIU: control_word = 15'b1_00_00_0_0_00010_100;
                SIU: control_word = 15'b1_00_00_0_0_00101_100;
                MOV: control_word = 15'b1_00_00_0_0_00000_000;
                LSL: control_word = 15'b1_00_00_0_0_10000_000;
                LSR: control_word = 15'b1_00_00_0_0_10001_000;
                JMR: control_word = 15'b0_00_10_0_0_00000_000;
                BZ : control_word = 15'b0_00_01_0_0_00000_101;
                BNZ: control_word = 15'b0_00_01_1_0_00000_101;
                JMP: control_word = 15'b0_00_11_0_0_00000_101;
                JML: control_word = 15'b1_00_11_0_0_00111_111;
                default: control_word = 15'd0;
            endcase
        end
	end
    assign RW  =                      control_word[14];
    assign MD  =                   control_word[13:12];
    assign BS =                    control_word[11:10];
    assign PS =                        control_word[9];
    assign MW =                        control_word[8];
    assign FS =                      control_word[7:3];
    assign MB  =                       control_word[2];
    assign MA  =                       control_word[1];
    assign CS  =                       control_word[0];
endmodule
