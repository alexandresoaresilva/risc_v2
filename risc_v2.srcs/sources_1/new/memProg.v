module memProg(
    input [9:0] PC,
    output [31:0] IR
    );

    parameter [6:0]  NOP = 7'b0000000; // R[DR] <- R[SA] + R[SB]
    parameter [6:0]  ADD = 7'b0000010; // R[DR] <- R[SA] + R[SB]
    parameter [6:0]  ADDC = 7'b0000011; // R[DR] <- R[SA] + R[SB] + carry
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

    parameter [4:0]  R0  = 5'd0; // None
    parameter [4:0]  R1  = 5'd1; // R[DR] <- R[SA] + R[SB]
    parameter [4:0]  R2  = 5'd2; // R[DR] <- R[SA] + not(R[SB]) + 1
    parameter [4:0]  R3  = 5'd3;
    parameter [4:0]  R4  = 5'd4;
    parameter [4:0]  R5  = 5'd5;
    parameter [4:0]  R6  = 5'd6;
    parameter [4:0]  R7  = 5'd7;
    parameter [4:0]  R8  = 5'd8;
    parameter [4:0]  R9  = 5'd9;
    parameter [4:0]  R10 = 5'd10;
    parameter [4:0]  R11 = 5'd11;
    parameter [4:0]  R12 = 5'd12;
    parameter [4:0]  R13 = 5'd13;
    parameter [4:0]  R14 = 5'd14;
    parameter [4:0]  R15 = 5'd15;
    parameter [4:0]  R16 = 5'd16;
    parameter [4:0]  R17 = 5'd17;
    parameter [4:0]  R18 = 5'd18;
    parameter [4:0]  R19 = 5'd19;
    parameter [4:0]  R20 = 5'd20;
    parameter [4:0]  R21 = 5'd21;
    parameter [4:0] R22 = 5'd22;
    parameter [4:0] R23 = 5'd23;
    parameter [4:0] R24 = 5'd24;
    parameter [4:0] R25 = 5'd25;
    parameter [4:0] R26 = 5'd26;
    parameter [4:0] R27 = 5'd27;
    parameter [4:0] R28 = 5'd28;
    parameter [4:0] R29 = 5'd29;
    parameter [4:0] R30 = 5'd30;
    parameter [4:0] R31 = 5'd31;
    parameter [9:0]  TEN_B_Z = 10'd0;
    parameter [14:0]  FIFTEEN_B_Z = 15'd0;
    parameter [14:0]   END = 15'd32;

    integer i, j, k;
    reg [31:0] memword [1023:0];

    initial begin
        {i, j, k}  = 0;
//////  CLEAR used registers
        memword[0] = {MOV, R5, R0, FIFTEEN_B_Z}; memword[4] = {MOV, R6, R0, FIFTEEN_B_Z};
        memword[1] = {MOV, R7, R0, FIFTEEN_B_Z}; memword[5] = {MOV, R8, R0, FIFTEEN_B_Z};
        memword[2] = {MOV, R11, R0, FIFTEEN_B_Z}; memword[6] = {MOV, R12, R0, FIFTEEN_B_Z};
        memword[3] = {MOV, R13, R0, FIFTEEN_B_Z}; memword[7] = {MOV, R16, R0, FIFTEEN_B_Z};

//////  BIT mask from sign bits in A & B - 8000_0000
        memword[8] = {LSL, R6, R1, TEN_B_Z, 5'd31};
        // ****************************************************************************
        memword[9] = {MOV, R3, R3, 15'd0};
        memword[10] = {MOV, R4, R4, 15'd0};
//////  operands (numbers to be multiplied)
   ///////// 1 : large
        //multiplier
//        memword[9] = {ADI, R3, R0, 15'd5};
//        //and multiplicand
//        memword[10] = {ADI, R4, R0, 15'hFFF};
//        memword[11] = {LSL, R4, R4, 15'd12};
//        memword[12] = {ORI, R4, R4, 15'hfff};
//        memword[13] = {LSL, R4, R4, 15'd8};
//        memword[14] = {ORI, R4, R4, 15'h01};
    ///////// 2 : small
       // //  //multiplier
//         memword[9] = {ADI, R3, R0, 15'd10};
//        //and multiplicand
//         memword[10] = {ADI, R4, R0, 15'd1};
        // ****************************************************************************
////// A masked in R6 & R7, so only their sign bits
    //// A /////
        memword[15] = {AND, R7, R6, R3, TEN_B_Z};//sign of A IN r7
       // Absolute value or not for A ///////////////////////////////////////
        memword[16] = {BZ, R0, R7, 15'd2};
        memword[17] = {SUB, R9, R0, R3, TEN_B_Z}; //two's complement
        memword[18] = {JMP, R9, R0, 15'd1}; //needed for not rewriting the register
        memword[19] = {MOV, R9, R3, FIFTEEN_B_Z};///default for positive
        ////// B masked in R6 & R7, so only their sign bits
    //// B /////
        memword[20] = {AND, R8, R6, R4, TEN_B_Z}; //sign of B IN r8
            // Absolute value or not B  ///////////////////////////////////////
        memword[21] = {BZ, R0, R8, 15'd2};
        memword[22] = {SUB, R10, R0, R4, TEN_B_Z}; //two's complement
        memword[23] = {JMP, R10, R0, 15'd1}; //needed for not rewriting the register
        memword[24] = {MOV, R10, R4, FIFTEEN_B_Z}; //default for positive

        ////// sign of RESULT
        memword[25] = {XOR, R11, R7, R8, TEN_B_Z};
        memword[26] = {AIU, R16, R0, 15'd29}; //addr of jump
////// multiply
    //1st time multiplication
        memword[27] = {ADD, R12, R10, R0, TEN_B_Z};
        memword[28] = {ADDC, R13, R13, R0, TEN_B_Z};

        memword[29] = {SUB, R9, R9, R1, TEN_B_Z}; //test if 1 remains
        memword[30] = {BZ, R0, R9, 15'd4};//if one remains, add one time multiplicand to the result
        memword[31] = {ADD, R12, R12, R10, TEN_B_Z};
        memword[32] = {ADDC, R13, R13, R0, TEN_B_Z};
        memword[33] = {JMR, R0, R16, FIFTEEN_B_Z};
        //memword[33] = {OR, R13, R13, R11, TEN_B_Z};
        memword[34] = {AND, R11, R11, R6, TEN_B_Z};
        memword[35] = {BZ, R0, R11, 15'd4};
        //IF previous == 1, two's complement onto the results
        memword[36] = {NOT, R12, R12, FIFTEEN_B_Z};
        memword[37] = {NOT, R13, R13, FIFTEEN_B_Z};
        //memword[38] = {ADD, R13, R13, R1, TEN_B_Z};
        memword[38] = {ADD, R12, R12, R1, TEN_B_Z};
        memword[39] = {ADDC, R13, R13, R0, TEN_B_Z};

        memword[40] = {MOV, R13, R13, FIFTEEN_B_Z};
        memword[41] = {MOV, R12, R12, FIFTEEN_B_Z};
        i=50;
/*
Three register Type
31_______25 | 24_______20 | 19______15 | 14_____10 | 9______0
  OPCODE          DR            SA          SB         xxx

Two register Type
31_______25 | 24_______20 | 19______15 | 14__________________0
  OPCODE          DR            SA             Immediate

Branch register Type
31_______25 | 24_______20 | 19______15 | 14__________________0
  OPCODE           DR           SA            Target offset */

        for(i=i; i< 1024; i = i+1)
            memword[i] = 32'd0;
    end

    assign IR = (memword[PC] === 32'dx )?
                                 32'd0:
                            memword[PC];
endmodule
