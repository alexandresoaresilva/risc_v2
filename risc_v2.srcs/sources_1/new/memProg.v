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

    parameter [4:0]  R0 = 5'd0; // None
    parameter [4:0]  R1 = 5'd1; // R[DR] <- R[SA] + R[SB]
    parameter [4:0]  R2 = 5'd2; // R[DR] <- R[SA] + not(R[SB]) + 1
    parameter [4:0]  R3  = 5'd3 ;
    parameter [4:0]  R4  = 5'd4 ;
    parameter [4:0]  R5  = 5'd5 ;
    parameter [4:0]  R6  = 5'd6 ;
    parameter [4:0]  R7  = 5'd7 ;
    parameter [4:0]  R8  = 5'd8 ;
    parameter [4:0]  R9  = 5'd9 ;
    parameter [4:0]  R10 = 5'd10;
    parameter [4:0]  R11 = 5'd11;
    parameter [4:0]  R12 = 5'd12;
    parameter [4:0]  R13 = 5'd13;
    parameter [4:0]  R14 = 5'd14;
    parameter [4:0]  R15 = 5'd15;
    parameter [4:0]  R16 = 5'd16;
    parameter [9:0]  TEN_B_Z = 10'd0;
    parameter [14:0]  Fifteen_B_Z = 15'd0;
    parameter [14:0]   END = 15'd32;


    integer i;
    reg [31:0] memword [1023:0];

    initial begin
        i  = 0;
        //IR_reg = {opcode_reg, DR_reg, SA_reg, IM_reg};
        //IR_reg = {opcode_reg, DR_reg, SA_reg, SB_reg,  null_ten_bits};
//        memword[0] = {NOP, 5'b10001, 5'b10000, 5'b00101, TEN_B_Z};
        //IR_reg = {opcode_reg, DR_reg, SA_reg, IM_reg};
        //memword[0] =  {NOP, 5'd0,  5'd0, 15'h0};
//

/*
Three register Type
31_______25 | 24_______20 | 19______15 | 14_____10 | 9______0
  OPCODE          DR            SA          SB         xxx

Two register Type
31_______25 | 24_______20 | 19______15 | 14__________________0
  OPCODE          DR            SA             Immediate

Branch register Type
31_______25 | 24_______20 | 19______15 | 14__________________0
  OPCODE           DR           SA            Target offset


*/


        //Move and check if Zero
        memword[i] =  {MOV, R3, R2, Fifteen_B_Z};
        i = i + 1;
        memword[i] =  {MOV, R2, R0, Fifteen_B_Z};
        i = i + 1;
        memword[i] =  {BZ,  R0,  R1, 15'd10};  //Branch to the end if R2 is Zero
        //i = i + 11;
        i = i + 5;
        //Move and check if Zero
        memword[i] =  {MOV, R4, R14, Fifteen_B_Z};
        i = i + 6;
        //i = i + 1;
        memword[i] =  {BZ,  R0,  R2, 15'd10}; // Branch to the end if R1 is Zero
        i = i + 5;
        memword[i] =  {MOV, R10, R15, Fifteen_B_Z};
        i = i + 6;
        memword[i] =  {MOV, R17, R20, Fifteen_B_Z};
        i = i + 1;

        for(i=i + 1; i< 1024; i = i+1)
            memword[i] = 32'd0;
    end

    assign IR = (memword[PC] === 32'dx )?
                                 32'd0:
                            memword[PC];
endmodule
