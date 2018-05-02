//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 02/03/2018 03:08:00 PM
// Design Name:
// Module Name: ALU & Shifter
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
// Implemented as the 2nd assingment for the 2018 Spring of the Microprocessor
// Architecture class (ECE-4375, Prof. Dr. Nutter) at Texas Tech University.
// Revision: 1
// Revision 0.01 - File Created
// Additional Comments:
//////////////////////////////////////////////////////////////////////////////////

module ALU(
    input reset,
    input carry_in,
    input [4:0]select_FS, [31:0] A, [31:0]B, [4:0] SH,
    output reg [31:0] result,
    output reg C, V, N, Z
    // V == overflow
    // C == carry out
    // N == negative
    // Z == zero
    );
    wire [63:0] logical_shift;
    reg Carry_In_reg;
    initial  begin
        C <= 0;
        result <= 0;
    end

    assign logical_shift = {32'b0, A};

    always@(*) begin
        if (reset) begin
            {C, V, N, Z, result, Carry_In_reg} <= 0;
        end
        else begin
            case(select_FS)
              5'b00000 :           {C, result} <= {1'b0, A}; //0 transfer A
              5'b00001 :           {C, result} <= {1'b0, A} + 1;  //1. increment A
              5'b00010 :           {C, result} <= {1'b0, A} + {1'b0, B}; //2. addition
              5'b00011 :           {C, result} <= {1'b0, A} +{1'b0,  B} + (Carry_In_reg | carry_in); //3. Add with carry input of 1
              5'b00100 :           {C, result} <= {1'b0, A}+ {1'b0, (~B)}; //4. A plus 1's complement of B
              5'b00101 :           {C, result} <= A + (~B) + 1; //5. Subtration or A + (~B) + 1
              5'b00110 :           {C, result} <= {1'b0, A} - 1; //6. Decrement A
              5'b00111 :           {C, result} <= {1'b0, A}; //7 Transfer A
              5'b01000, 5'b01001 : {C, result} <= (A & B); //8 - 9 AND
              5'b01010, 5'b01011 : {C, result} <= A | B; //10 - 11 OR
              5'b01100, 5'b01101 : {C, result} <= (A ^ B); // 12 - 13  XOR
              5'b01110, 5'b01111 : {C, result} <= ~A; // 14 - 15 NOT (1's complement)
            //  5'b10000 :           {C, result} = {1'b0, B};  // 16 transfer B
              5'b10000 :           {C, result} <= logical_shift << SH; // 16 shift left; CARRY doesn't work
              5'b10001 :           {C, result} <= logical_shift >> SH; // 17 shift right
              // 5'b10000 :           {C, result} <= logical_shift << SH; // 16 shift left; CARRY doesn't work
              // 5'b10001 :           {C, result} <= logical_shift >> SH; // 17 shift right
              default :            {C, result} <= 0;
            endcase
            //updates flags
            V <= ( (select_FS == 5'b00001 |  select_FS == 5'b00010 ) & //for addition
                       ( (~A[31] & ~B[31] & result[31])
                       | (A[31] & B[31] & ~result[31]) )
                       ) | ( (select_FS==5'b00101 | select_FS==5'b00110 )//for subtraction, dec
                       & ( (~A[31] & B[31] & result[31])
                       | (A[31] & ~B[31] & ~result[31])
                       ) ) ; //overflow's end - & NOT reset so it goes to ZERO if reset
            N <=  result[31];  //
            Z <=  ~|(result[31:0]);
         end
         //updaes carry in
         if (select_FS == 5'b00011)
             Carry_In_reg <= 0;
         else
             Carry_In_reg <= carry_in;
    end //end of always@
endmodule
