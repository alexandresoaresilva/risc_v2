`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/10/2018 04:11:53 PM
// Design Name:
// Module Name: ALU_tb
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

module ALU_tb( );
    reg reset_reg;
    reg [4:0] select_FS_reg;
    reg [31:0] A_reg;
    reg [31:0] B_reg;
    reg [4:0] SH_reg;

    //integer i = 0;
    wire [31:0] result_wire;
    wire V_wire, C_wire, N_wire, Z_wire;//, V_test_wire;

    //output V, V_test, C, N, Z

    ALU UUT(
        .reset(reset_reg),
        .select_FS(select_FS_reg),
        .A(A_reg),
        .B(B_reg),
        .SH(SH_reg),
        .result(result_wire),
        .V(V_wire),
        .C(C_wire),
        .N(N_wire),
        .Z(Z_wire)//,.V_test(V_test_wire)
        // V == overflow
        // C == carry out
        // N == negative
        // Z == zero
        );

        initial begin
//all tests
//        0 any A; so FF
//        1 0: FF + 1: tests 0 & carry & overflow

//        2. A5 + A5: tests overflow
//        3 A5 + A5: tests overflow;

//        4 A5 + ~A5 = A5 + 5A = : tests overflow;
//        5 A5, A5: tests zero, overflow;
//        5 5A - A5: tests subtraction (signed result)
//        6 A = -128 -1 : tests overflow;A5 -1 tests decrement

//        7 A = A5
//        8-9 - 5A & A5 = 00;
//        10 - 11 5A OR A5 == FF
//        12 - 13 5A ^ A5 == FF;

//        14 - 15 NOT A5 == 5A;
//        16 B = A5
//        20 SR B = A5 -> 52
//        24 SL B = A5 -> 4A: tests carry


/////////////////////////////////////////////////////////////////////////////////////////////////////////
            //1st run:
            // tests 0, 1, 7, 12-13, 16, 20, 24
            //        0: transfer A=FF
            //        1 FF + 1 CARRY & OVERFLOW & ZERO expECTED
            //        7: transfer A=FF
            //        12-13: FF XOR A5 = 5A expected
            //        16 transfer B=A5
            //        20 SR B = A5 -> 52
            //        24 SL B = A5 -> 4A: tests carry
            //2^32 -1 == 4,294,967,295

            reset_reg = 1;
            //SH_reg = 0;
            {select_FS_reg, A_reg, B_reg, SH_reg} = 0;
            //B_reg = 0;

            // 31'hAAAA5555 == 2,863,289,685 so adding this with iselft will cause oveflow
            #10
            reset_reg = 0;
            A_reg = 32'hFFFF_FFFF; //FFFFFFFF
            B_reg = 32'hAAAA_5555;
            select_FS_reg =  0; //transfer A=FF
            #10
            select_FS_reg =  1; //increment FF, so 0: CARRY & OVERFLOW & ZERO expECTED
            #10
            select_FS_reg =  7; //transfer A=FF
            #10
            select_FS_reg =  12; //FF XOR A5 = 5A expected
            // #10
            // select_FS_reg =  16; //transfer B=A5
            #10
            //shift right B=A5 == 52 excpeted
            //(also sets overflow flag because of both negative input signs but positive results)
            //B_reg = 32'hFFFF_FFFF;
            SH_reg = 31;
            select_FS_reg =  16;
            #10
            //shit left B=A5 == 4A & carry expected
            //(also sets overflow flag because of both negative input signs but positive results)
            B_reg = 32'hFFFF_FFFF;
            SH_reg = 31;
            select_FS_reg =  17;
            #10

/////////////////////////////////////////////////////////////////////////////////////////////////////////
            //2nd run - tests 2, 3, 4, 5, 14
            //        2. A5 + A5: tests overflow
            //        3 A5 + A5: tests overflow;
            //        4 A5 + ~A5 = A5 + 5A = : tests overflow;
            //        5 A5, A5: tests zero, overflow;
            //        14 - 15 NOT A5 == 5A;
            //{select_FS_reg, A_reg, B_reg} = 0;
            {select_FS_reg, A_reg, B_reg, SH_reg} = 0;
            reset_reg = 1;
            #15;
            reset_reg = 0;
            A_reg = 32'hAAAA_5555;
            B_reg = 32'hAAAA_5555;

//            A_reg = 8'hA5;
//            B_reg = 8'hA5;
            select_FS_reg =  2; //A + B == A5 + A5: 1 carry expected, 4A, tests overflow
            #10
            //ADD with increment A + B + 1 = A5 + A5: //
            //1 carry expected, 4B, tests overflow
            select_FS_reg =  3;
            #10
            select_FS_reg =  4; // A5 + ~A5 = A5 + 5A = FF//TESTS ADDITION;
            #10
            select_FS_reg =  5; //A5 - A5: tests zero
            #10
            select_FS_reg =  14; // ~A == ~A5 == 5A expected
            #10;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
            //3rd run - tests
            // 5 A = -128 -1 : tests overflow; carry will be present (should be ignored if signed)
            // 8-9 : 5A & A5 = 00;
            // 10 - 11: 5A OR A5 == FF
            // 12 - 13 : 5A ^ A5 == FF;
            reset_reg = 1;
            //{select_FS_reg, A_reg, B_reg} = 0;
            {select_FS_reg, A_reg, B_reg, SH_reg} = 0;

            #15;
            reset_reg = 0;
            A_reg = 32'h5555_AAAA;
            B_reg = 32'hAAAA_5555;

//            A_reg = 8'h5A;
//            B_reg = 8'hA5;
            select_FS_reg =  5; //5A - A5: tests negative result
            #10
            select_FS_reg =  8; // 5A & A5 = 00;
            #10
            select_FS_reg =  9; // 5A & A5 = 00;
            #10
            select_FS_reg =  10; // 5A OR A5 == FF
            #10
            select_FS_reg =  11; // 5A OR A5 == FF
            #10
            select_FS_reg =  12; // 5A ^ A5 == FF;
            #10
            select_FS_reg =  13; // 5A ^ A5 == FF;
            #10;
            A_reg = 32'h8888_0000;
            select_FS_reg =  6; // A - 1 == 7F
            #10
            {select_FS_reg, A_reg, B_reg} = 0;
            #30;
        end
endmodule
