`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/12/2018 04:58:54 PM
// Design Name:
// Module Name: top_v2
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

module top_v2(
    input reset, clock,
    //PC, IR
    output [9:0] PC_muxC_result_output,
    output [9:0] PC_2_out,
    output [31:0] IR_IF_output,
    //CU
    output CS_DOF_output,
    output [31:0] IM_filled_DOF_output,
    //register read
    //register read, addr input
    output [4:0] AAddr_DOF_output,
    output [31:0] regFile_Aout_DOF_output,
    output [4:0] BAddr_DOF_output,
    output [31:0] regFile_Bout_DOF_output,
    //mux A, B
    output [31:0] RAA_EX_reg_output,//mux A out stored
    output [31:0] B_EX_reg_output,//mux B out stored out stored
    //storing instruction decoded
    output PS_EX_output,
    output MW_EX_output,
    output [1:0] BS_EX_output,
    output [4:0] SH_EX_output,
    //function unit
    output [4:0] FS_EX_output,
    output V_EX_output,
    output N_EX_output,
    output C_EX_output,
    output Z_EX_output,
    output [31:0] F_EX_output,
    //memory read
    output [31:0] data_OUT_memory_EX_output,
    output [9:0] BrA_EX_output,
    //MUX D
    output [1:0] MD_WB_output,
    output [31:0] bus_D_WB_output,
    //register write
    output RW_WB_output,
    output [4:0] DA_WB_output,
    output [31:0] reg_DR_just_written_out
    , output [31:0] mux_D_prime_output
);

    wire [31:0] regFile_DAout_WB_wire;
    //wire [9:0] PC_2_out;
////// IF tick //////
    //regs
    reg [9:0] PC_IF_reg;
    //wires
    wire [31:0] IR_IF_wire;
    wire [9:0] PC_muxC_result_wire;
////// DOF tick //////
    //regs
    reg [9:0] PC_subs_1_DOF_reg;
    reg [31:0] IR_DOF_reg;
    //wire [1:0] MD_DOF_wire
    //wire [1:0] MD_EX_reg;
    //wires
    wire CS_DOF_wire, MA_DOF_wire, MB_DOF_wire,
        RW_DOF_wire, PS_DOF_wire, MW_DOF_wire,
        HA_wire, HB_wire;
    wire [1:0] MD_DOF_wire, BS_DOF_wire;
    wire [31:0] IM_filled_DOF_wire;
    wire [4:0] AAddr_DOF_wire, BAddr_DOF_wire, SH_DOF_wire, FS_DOF_wire, DA_DOF_wire;
    wire [31:0] regFile_Aout_DOF_wire, regFile_Bout_DOF_wire,
        muxA_bus_A_DOF_wire,  muxB_bus_B_DOF_wire;
////// EX tick //////
    //regs
    reg [9:0] PC_subs_2_EX_reg;
    reg [4:0] DA_EX_reg;
    reg [1:0] MD_EX_reg, BS_EX_reg;
    reg RW_EX_reg, PS_EX_reg, MW_EX_reg;
    reg C_in_WB_reg, C_in_IF_reg, C_in_DOF_reg, C_in_EX_reg;

    reg [4:0] FS_EX_reg, SH_EX_reg;
    reg [31:0] RAA_EX_reg, B_EX_reg;
    //wires
    wire V_EX_wire, N_EX_wire, C_EX_wire, Z_EX_wire;
    wire [31:0] data_OUT_memory_EX_wire, F_EX_wire;
    wire [9:0] BrA_EX_wire;
    wire [31:0] bus_D_prime_wire;
////// WB tick //////
    //regs
    reg [31:0] data_OUT_memory_WB_reg;
    reg [4:0] DA_WB_reg;
    reg [1:0] MD_WB_reg;
    reg RW_WB_reg, V_xor_N_WB_reg;
    reg [31:0] F_WB_reg;
    //wires
    wire [31:0] bus_D_WB_wire;
    wire [1:0] mux_c_sel_wire;
    wire branch_NOT_taken_wire;


//// counter for clock tick delay
    reg [1:0] counter_reg;
    assign mux_c_sel_wire = { BS_EX_reg[1] ,
                            (
                                (PS_EX_reg ^ Z_EX_wire)
                                | BS_EX_reg[1]
                            ) & BS_EX_reg[0] } ;
    assign branch_NOT_taken_wire = ~(| mux_c_sel_wire );
    //assign DA_(DA_EX_reg == AAddr_DOF_wire);
    //assign
    assign HA_wire = (DA_EX_reg == AAddr_DOF_wire)&(~MA_DOF_wire)
                 & RW_EX_reg & ( | DA_EX_reg );

    assign HB_wire =  (DA_EX_reg == BAddr_DOF_wire) & (~MB_DOF_wire)
                  & RW_EX_reg & ( | DA_EX_reg );
    //all regs to 0
    initial begin
        {PC_IF_reg, PC_subs_1_DOF_reg, IR_DOF_reg, PC_subs_2_EX_reg, DA_EX_reg,
            MD_EX_reg, BS_EX_reg, RW_EX_reg, PS_EX_reg, MW_EX_reg, FS_EX_reg,
            SH_EX_reg, RAA_EX_reg, B_EX_reg, data_OUT_memory_WB_reg, DA_WB_reg,
            MD_WB_reg, RW_WB_reg, V_xor_N_WB_reg, F_WB_reg, counter_reg,
            C_in_WB_reg, C_in_IF_reg, C_in_DOF_reg, C_in_EX_reg} = 0;
    end

///////////////  /IR / PC else sotring happens below  ///////////////
    always@(negedge clock) begin
        if (reset) begin
            {PC_IF_reg, PC_subs_1_DOF_reg, IR_DOF_reg,
                PC_subs_2_EX_reg, DA_EX_reg, MD_EX_reg,
                BS_EX_reg, RW_EX_reg, PS_EX_reg, MW_EX_reg,
                FS_EX_reg, SH_EX_reg, RAA_EX_reg, B_EX_reg,
                data_OUT_memory_WB_reg, DA_WB_reg, MD_WB_reg,
                RW_WB_reg, V_xor_N_WB_reg, F_WB_reg, counter_reg,
                C_in_WB_reg, C_in_IF_reg, C_in_DOF_reg, C_in_EX_reg} = 0;
        end
        else begin
        /////instruction fectch
            PC_IF_reg <= PC_muxC_result_wire;

        /////DOF
            // PC_subs_1_DOF_reg <= PC_IF_reg;
            PC_subs_1_DOF_reg <= PC_IF_reg + 1;

             IR_DOF_reg <= IR_IF_wire & {32{branch_NOT_taken_wire}};
//           IR_DOF_reg <= branch_NOT_taken_wire?
//                           IR_IF_wire & {32{branch_NOT_taken_wire}}
//                           : IR_IF_wire;
        /////EX
            PC_subs_2_EX_reg <= PC_subs_1_DOF_reg;
            //register write + dest addr
            RW_EX_reg <= RW_DOF_wire & branch_NOT_taken_wire;
//           RW_EX_reg <= branch_NOT_taken_wire?
//                           RW_DOF_wire & branch_NOT_taken_wire
//                           : RW_DOF_wire;

            DA_EX_reg <= DA_DOF_wire;
            //mux D
            MD_EX_reg <= MD_DOF_wire;
            //mux C
            BS_EX_reg <= BS_DOF_wire & {2{branch_NOT_taken_wire}};
//           BS_EX_reg <= branch_NOT_taken_wire?
//                           BS_DOF_wire & {2{branch_NOT_taken_wire}}
//                           : BS_DOF_wire;


            PS_EX_reg <= PS_DOF_wire;
            //memory write
            MW_EX_reg <= MW_DOF_wire & branch_NOT_taken_wire;
//           MW_EX_reg <= branch_NOT_taken_wire?
//                           MW_DOF_wire & branch_NOT_taken_wire
//                           : MW_DOF_wire;
            //function unit
            FS_EX_reg <= FS_DOF_wire;
            SH_EX_reg <= IR_DOF_reg[4:0];//SH_DOF_wire;
            //mux A, B outputs (bus A & b)
            RAA_EX_reg <= muxA_bus_A_DOF_wire;
            B_EX_reg <=  muxB_bus_B_DOF_wire;
            //carry initial begin
            //C_in_IF_reg <=C_in_WB_reg;
            //C_in_DOF_reg <= C_in_WB_reg;
            //C_in_EX_reg <= C_in_DOF_reg;
            C_in_EX_reg <= C_EX_wire;
            //C_in_WB_reg;
            // C_in_EX_reg <= C_in_DOF_reg;
        /////WB
            //from data memory
            data_OUT_memory_WB_reg <= data_OUT_memory_EX_wire;
            //regiter write
            RW_WB_reg <= RW_EX_reg;
            DA_WB_reg <= DA_EX_reg;
            //mux D
            MD_WB_reg <= MD_EX_reg; //MD_DOF_wire;
            V_xor_N_WB_reg <= V_EX_wire ^ N_EX_wire;
            F_WB_reg <= F_EX_wire;
            //carry in
            //C_in_WB_reg <= C_EX_wire;
        end
    end
///////////////  ENDF of always@  ///////////////
// mux C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mux_C muxC(
        .reset(reset),
        // .sel( { BS_EX_reg[1] ,
        // ( (PS_EX_reg ^ Z_EX_wire) | BS_EX_reg[1]  )
        // & BS_EX_reg[0] } ),//end of sel
        .sel( mux_c_sel_wire),//end of sel
        .RAA(RAA_EX_reg),
        .BrA(BrA_EX_wire),
        .PC_IN(PC_IF_reg ),
        .PC_OUT(PC_muxC_result_wire)
    );
// program space >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    memProg programSpace(
        .PC(PC_IF_reg),
        .IR(IR_IF_wire)
    );

// IR >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    instr_dec instr_dec1(
        .reset(reset),
        .IR(IR_DOF_reg),
        .FS(FS_DOF_wire),
        .MD(MD_DOF_wire),
        .BS(BS_DOF_wire),
        .PS(PS_DOF_wire),
        .MW(MW_DOF_wire),
        .RW(RW_DOF_wire),
        .MA(MA_DOF_wire),
        .MB(MB_DOF_wire),
        .CS(CS_DOF_wire),
        .SA(AAddr_DOF_wire),
        .SB(BAddr_DOF_wire),
        .DR(DA_DOF_wire)
    );
// CU - fills zero or sign extension    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    constant_unit CU(
        .CS(CS_DOF_wire),
        .IM(IR_DOF_reg[14:0]),
        .IM_filled(IM_filled_DOF_wire)
    );
// mux A, B >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mux_A_B muxAB(
        .reset(reset),
        .data_A(regFile_Aout_DOF_wire),
        .data_B(regFile_Bout_DOF_wire),
        .data_D_prime(bus_D_prime_wire),
        .PC_1(PC_subs_1_DOF_reg),
        .const_unit(IM_filled_DOF_wire), //constant unit
        .MA_MB({MA_DOF_wire, MB_DOF_wire}),
        .HA_HB({HA_wire, HB_wire}),
        .bus_A(muxA_bus_A_DOF_wire),
        .bus_B( muxB_bus_B_DOF_wire)
    );
// adder    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    adder Adder(
        .reset(reset),
        .PC_2(PC_subs_2_EX_reg),
        .bus_B(B_EX_reg),
        .BrA(BrA_EX_wire)
    );
// memory_data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    memory_data memData(
        .clock(clock),
        .reset(reset),
        .RAA_addr(RAA_EX_reg[6:0]),
        .MW(MW_EX_reg),
        .data_IN(B_EX_reg),
        .data_OUT(data_OUT_memory_EX_wire)
    );

// ALU >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ALU alu1(
            //RAA_EX_reg, B_EX_reg;
        .reset(reset),
        .carry_in(C_in_EX_reg),
        .select_FS(FS_EX_reg),
        .A(RAA_EX_reg),
        .B(B_EX_reg),
        .SH(SH_EX_reg),
        .result(F_EX_wire),
        .V(V_EX_wire),
        .C(C_EX_wire),
        .N(N_EX_wire),
        .Z(Z_EX_wire)//,.V_test(V_test_wire)
        // V == overflow
        // C == carry out
        // N == negative
        // Z == zero
        );
// mux D >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mux_D muxD(
        .MD(MD_WB_reg),
        .mem_data_IN(data_OUT_memory_WB_reg),/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        .F(F_WB_reg),//F is the result from FU
        .V_xor_N(V_xor_N_WB_reg),
        .bus_D(bus_D_WB_wire)
    );
// mux_D_prime   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mux_D_prime mxDpr(
        .reset(reset),
        .select_in_MD_EX_REG(MD_EX_reg),
        //.select_in_MD_EX_REG(MD_DOF_wire),
        .in2_V_xor_N_WB_reg({31'd0, V_EX_wire ^ N_EX_wire}),
        .in1_F_EX_wire(F_EX_wire),
        .in0_data_OUT_memory_EX_wire(data_OUT_memory_EX_wire),
        .bus_D_prime(bus_D_prime_wire)
    );
// register file    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    register_file regfile(
        .clock(clock),
        .reset(reset),
        .write_now(RW_WB_reg),
        .SA(AAddr_DOF_wire),
        .SB(BAddr_DOF_wire),
        .DR(DA_WB_reg), //DA
//        .data_IN( (HA_wire | HB_wire)?
//                     bus_D_prime_wire
//                     : bus_D_WB_wire),
        .data_IN(bus_D_WB_wire),
        .data_A_OUT(regFile_Aout_DOF_wire),
        .data_B_OUT(regFile_Bout_DOF_wire),
        .data_DR_OUT(regFile_DAout_WB_wire)
    );

    assign reg_DR_just_written_out = regFile_DAout_WB_wire;
    assign PC_muxC_result_output = PC_muxC_result_wire;
    assign IR_IF_output = IR_IF_wire;
    assign CS_DOF_output = CS_DOF_wire;
    assign PS_EX_output = PS_EX_reg;
    assign MW_EX_output = MW_EX_reg;

    assign BS_EX_output = BS_EX_reg;
    assign IM_filled_DOF_output = IM_filled_DOF_wire;
    assign AAddr_DOF_output = AAddr_DOF_wire;
    assign BAddr_DOF_output = BAddr_DOF_wire;
    assign SH_EX_output = SH_EX_reg;
    assign FS_EX_output = FS_EX_reg;
    //WB
    assign RW_WB_output = RW_WB_reg;
    assign DA_WB_output =DA_WB_reg;
    assign MD_WB_output = MD_WB_reg;

    assign regFile_Aout_DOF_output = regFile_Aout_DOF_wire;
    assign regFile_Bout_DOF_output = regFile_Bout_DOF_wire;
    // assign muxA_bus_A_DOF_output = muxA_bus_A_DOF_wire;
    // assign  muxB_bus_B_DOF_output =  muxB_bus_B_DOF_wire;
    assign V_EX_output = V_EX_wire;
    assign N_EX_output = N_EX_wire;
    assign C_EX_output = C_EX_wire;
    assign Z_EX_output =Z_EX_wire;
    assign data_OUT_memory_EX_output = data_OUT_memory_EX_wire;
    assign F_EX_output = F_EX_wire;
    assign BrA_EX_output = BrA_EX_wire;
    assign bus_D_WB_output = bus_D_WB_wire;
    assign RAA_EX_reg_output = RAA_EX_reg;
    assign B_EX_reg_output = B_EX_reg;
    assign PC_2_out = PC_subs_2_EX_reg;
    assign mux_D_prime_output = bus_D_prime_wire;
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/12/2018 04:58:54 PM
// Design Name:
// Module Name: top_v2
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

module top_v2(
    input reset, clock,
    //PC, IR
    output [9:0] PC_muxC_result_output,
    output [9:0] PC_2_out,
    output [31:0] IR_IF_output,
    //CU
    output CS_DOF_output,
    output [31:0] IM_filled_DOF_output,
    //register read
    //register read, addr input
    output [4:0] AAddr_DOF_output,
    output [31:0] regFile_Aout_DOF_output,
    output [4:0] BAddr_DOF_output,
    output [31:0] regFile_Bout_DOF_output,
    //mux A, B
    output [31:0] RAA_EX_reg_output,//mux A out stored
    output [31:0] B_EX_reg_output,//mux B out stored out stored
    //storing instruction decoded
    output PS_EX_output,
    output MW_EX_output,
    output [1:0] BS_EX_output,
    output [4:0] SH_EX_output,
    //function unit
    output [4:0] FS_EX_output,
    output V_EX_output,
    output N_EX_output,
    output C_EX_output,
    output Z_EX_output,
    output [31:0] F_EX_output,
    //memory read
    output [31:0] data_OUT_memory_EX_output,
    output [9:0] BrA_EX_output,
    //MUX D
    output [1:0] MD_WB_output,
    output [31:0] bus_D_WB_output,
    //register write
    output RW_WB_output,
    output [4:0] DA_WB_output,
    output [31:0] reg_DR_just_written_out
    , output [31:0] mux_D_prime_output
);

    wire [31:0] regFile_DAout_WB_wire;
    //wire [9:0] PC_2_out;
////// IF tick //////
    //regs
    reg [9:0] PC_IF_reg;
    //wires
    wire [31:0] IR_IF_wire;
    wire [9:0] PC_muxC_result_wire;
////// DOF tick //////
    //regs
    reg [9:0] PC_subs_1_DOF_reg;
    reg [31:0] IR_DOF_reg;
    //wire [1:0] MD_DOF_wire
    //wire [1:0] MD_EX_reg;
    //wires
    wire CS_DOF_wire, MA_DOF_wire, MB_DOF_wire,
        RW_DOF_wire, PS_DOF_wire, MW_DOF_wire,
        HA_wire, HB_wire;
    wire [1:0] MD_DOF_wire, BS_DOF_wire;
    wire [31:0] IM_filled_DOF_wire;
    wire [4:0] AAddr_DOF_wire, BAddr_DOF_wire, SH_DOF_wire, FS_DOF_wire, DA_DOF_wire;
    wire [31:0] regFile_Aout_DOF_wire, regFile_Bout_DOF_wire,
        muxA_bus_A_DOF_wire,  muxB_bus_B_DOF_wire;
////// EX tick //////
    //regs
    reg [9:0] PC_subs_2_EX_reg;
    reg [4:0] DA_EX_reg;
    reg [1:0] MD_EX_reg, BS_EX_reg;
    reg RW_EX_reg, PS_EX_reg, MW_EX_reg;
    reg C_in_WB_reg, C_in_IF_reg, C_in_DOF_reg, C_in_EX_reg;

    reg [4:0] FS_EX_reg, SH_EX_reg;
    reg [31:0] RAA_EX_reg, B_EX_reg;
    //wires
    wire V_EX_wire, N_EX_wire, C_EX_wire, Z_EX_wire;
    wire [31:0] data_OUT_memory_EX_wire, F_EX_wire;
    wire [9:0] BrA_EX_wire;
    wire [31:0] bus_D_prime_wire;
////// WB tick //////
    //regs
    reg [31:0] data_OUT_memory_WB_reg;
    reg [4:0] DA_WB_reg;
    reg [1:0] MD_WB_reg;
    reg RW_WB_reg, V_xor_N_WB_reg;
    reg [31:0] F_WB_reg;
    //wires
    wire [31:0] bus_D_WB_wire;
    wire [1:0] mux_c_sel_wire;
    wire branch_NOT_taken_wire;


//// counter for clock tick delay
    reg [1:0] counter_reg;
    assign mux_c_sel_wire = { BS_EX_reg[1] ,
                            (
                                (PS_EX_reg ^ Z_EX_wire)
                                | BS_EX_reg[1]
                            ) & BS_EX_reg[0] } ;
    assign branch_NOT_taken_wire = ~(| mux_c_sel_wire );
    //assign DA_(DA_EX_reg == AAddr_DOF_wire);
    //assign
    assign HA_wire = (DA_EX_reg == AAddr_DOF_wire)&(~MA_DOF_wire)
                 & (MW_EX_reg | RW_EX_reg) & ( | DA_EX_reg );

    assign HB_wire =  (DA_EX_reg == BAddr_DOF_wire) & (~MB_DOF_wire)
                  & (MW_EX_reg | RW_EX_reg) & ( | DA_EX_reg );
    //all regs to 0
    initial begin
        {PC_IF_reg, PC_subs_1_DOF_reg, IR_DOF_reg, PC_subs_2_EX_reg, DA_EX_reg,
            MD_EX_reg, BS_EX_reg, RW_EX_reg, PS_EX_reg, MW_EX_reg, FS_EX_reg,
            SH_EX_reg, RAA_EX_reg, B_EX_reg, data_OUT_memory_WB_reg, DA_WB_reg,
            MD_WB_reg, RW_WB_reg, V_xor_N_WB_reg, F_WB_reg, counter_reg,
            C_in_WB_reg, C_in_IF_reg, C_in_DOF_reg, C_in_EX_reg} = 0;
    end

///////////////  /IR / PC else sotring happens below  ///////////////
    always@(negedge clock) begin
        if (reset) begin
            {PC_IF_reg, PC_subs_1_DOF_reg, IR_DOF_reg,
                PC_subs_2_EX_reg, DA_EX_reg, MD_EX_reg,
                BS_EX_reg, RW_EX_reg, PS_EX_reg, MW_EX_reg,
                FS_EX_reg, SH_EX_reg, RAA_EX_reg, B_EX_reg,
                data_OUT_memory_WB_reg, DA_WB_reg, MD_WB_reg,
                RW_WB_reg, V_xor_N_WB_reg, F_WB_reg, counter_reg,
                C_in_WB_reg, C_in_IF_reg, C_in_DOF_reg, C_in_EX_reg} = 0;
        end
        else begin
        /////instruction fectch
            PC_IF_reg <= PC_muxC_result_wire;

        /////DOF
            PC_subs_1_DOF_reg <= PC_IF_reg + 1;
            IR_DOF_reg <= IR_IF_wire & {32{branch_NOT_taken_wire}};
        /////EX
            PC_subs_2_EX_reg <= PC_subs_1_DOF_reg;
            //register write + dest addr
            RW_EX_reg <= RW_DOF_wire & branch_NOT_taken_wire;
            DA_EX_reg <= DA_DOF_wire;
            //mux D
            MD_EX_reg <= MD_DOF_wire;
            //mux C
            BS_EX_reg <= BS_DOF_wire & {2{branch_NOT_taken_wire}};
            PS_EX_reg <= PS_DOF_wire;
            //memory write
            MW_EX_reg <= MW_DOF_wire & branch_NOT_taken_wire;
            //function unit
            FS_EX_reg <= FS_DOF_wire;
            SH_EX_reg <= IR_DOF_reg[4:0];//SH_DOF_wire;
            //mux A, B outputs (bus A & b)
            RAA_EX_reg <= muxA_bus_A_DOF_wire;
            B_EX_reg <=  muxB_bus_B_DOF_wire;
            //carry initial begin
            //C_in_IF_reg <=C_in_WB_reg;
            //C_in_DOF_reg <= C_in_WB_reg;
            //C_in_EX_reg <= C_in_DOF_reg;
            C_in_EX_reg <= C_EX_wire;
            //C_in_WB_reg;
            // C_in_EX_reg <= C_in_DOF_reg;
        /////WB
            //from data memory
            data_OUT_memory_WB_reg <= data_OUT_memory_EX_wire;
            //regiter write
            RW_WB_reg <= RW_EX_reg;
            DA_WB_reg <= DA_EX_reg;
            //mux D
            MD_WB_reg <= MD_EX_reg; //MD_DOF_wire;
            V_xor_N_WB_reg <= V_EX_wire ^ N_EX_wire;
            F_WB_reg <= F_EX_wire;
            //carry in
            //C_in_WB_reg <= C_EX_wire;
        end
    end
///////////////  ENDF of always@  ///////////////
// mux C >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mux_C muxC(
        .reset(reset),
        // .sel( { BS_EX_reg[1] ,
        // ( (PS_EX_reg ^ Z_EX_wire) | BS_EX_reg[1]  )
        // & BS_EX_reg[0] } ),//end of sel
        .sel( mux_c_sel_wire),//end of sel
        .RAA(RAA_EX_reg),
        .BrA(BrA_EX_wire),
        .PC_IN(PC_IF_reg ),
        .PC_OUT(PC_muxC_result_wire)
    );
// program space >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    memProg programSpace(
        .PC(PC_IF_reg),
        .IR(IR_IF_wire)
    );

// IR >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    instr_dec instr_dec1(
        .reset(reset),
        .IR(IR_DOF_reg),
        .FS(FS_DOF_wire),
        .MD(MD_DOF_wire),
        .BS(BS_DOF_wire),
        .PS(PS_DOF_wire),
        .MW(MW_DOF_wire),
        .RW(RW_DOF_wire),
        .MA(MA_DOF_wire),
        .MB(MB_DOF_wire),
        .CS(CS_DOF_wire),
        .SA(AAddr_DOF_wire),
        .SB(BAddr_DOF_wire),
        .DR(DA_DOF_wire)
    );
// CU - fills zero or sign extension    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    constant_unit CU(
        .CS(CS_DOF_wire),
        .IM(IR_DOF_reg[14:0]),
        .IM_filled(IM_filled_DOF_wire)
    );
// mux A, B >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mux_A_B muxAB(
        .reset(reset),
        .data_A(regFile_Aout_DOF_wire),
        .data_B(regFile_Bout_DOF_wire),
        .data_D_prime(bus_D_prime_wire),
        .PC_1(PC_subs_1_DOF_reg),
        .const_unit(IM_filled_DOF_wire), //constant unit
        .MA_MB({MA_DOF_wire, MB_DOF_wire}),
        .HA_HB({HA_wire, HB_wire}),
        .bus_A(muxA_bus_A_DOF_wire),
        .bus_B( muxB_bus_B_DOF_wire)
    );
// adder    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    adder Adder(
        .reset(reset),
        .PC_2(PC_subs_2_EX_reg),
        .bus_B(B_EX_reg),
        .BrA(BrA_EX_wire)
    );
// memory_data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    memory_data memData(
        .clock(clock),
        .reset(reset),
        .RAA_addr(RAA_EX_reg[6:0]),
        .MW(MW_EX_reg),
        .data_IN(B_EX_reg),
        .data_OUT(data_OUT_memory_EX_wire)
    );

// ALU >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    ALU alu1(
            //RAA_EX_reg, B_EX_reg;
        .reset(reset),
        .carry_in(C_in_EX_reg),
        .select_FS(FS_EX_reg),
        .A(RAA_EX_reg),
        .B(B_EX_reg),
        .SH(SH_EX_reg),
        .result(F_EX_wire),
        .V(V_EX_wire),
        .C(C_EX_wire),
        .N(N_EX_wire),
        .Z(Z_EX_wire)//,.V_test(V_test_wire)
        // V == overflow
        // C == carry out
        // N == negative
        // Z == zero
        );
// mux D >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mux_D muxD(
        .MD(MD_WB_reg),
        .mem_data_IN(data_OUT_memory_WB_reg),/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        .F(F_WB_reg),//F is the result from FU
        .V_xor_N(V_xor_N_WB_reg),
        .bus_D(bus_D_WB_wire)
    );
// mux_D_prime   >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    mux_D_prime mxDpr(
        .reset(reset),
        .select_in_MD_EX_REG(MD_EX_reg),
        //.select_in_MD_EX_REG(MD_DOF_wire),
        .in2_V_xor_N_WB_reg({31'd0, V_EX_wire ^ N_EX_wire}),
        .in1_F_EX_wire(F_EX_wire),
        .in0_data_OUT_memory_EX_wire(data_OUT_memory_EX_wire),
        .bus_D_prime(bus_D_prime_wire)
    );
// register file    >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    register_file regfile(
        .clock(clock),
        .reset(reset),
        .write_now(RW_WB_reg),
        .SA(AAddr_DOF_wire),
        .SB(BAddr_DOF_wire),
        .DR(DA_WB_reg), //DA
//        .data_IN( (HA_wire | HB_wire)?
//                     bus_D_prime_wire
//                     : bus_D_WB_wire),
        .data_IN(bus_D_WB_wire),
        .data_A_OUT(regFile_Aout_DOF_wire),
        .data_B_OUT(regFile_Bout_DOF_wire),
        .data_DR_OUT(regFile_DAout_WB_wire)
    );

    assign reg_DR_just_written_out = regFile_DAout_WB_wire;
    assign PC_muxC_result_output = PC_muxC_result_wire;
    assign IR_IF_output = IR_IF_wire;
    assign CS_DOF_output = CS_DOF_wire;
    assign PS_EX_output = PS_EX_reg;
    assign MW_EX_output = MW_EX_reg;

    assign BS_EX_output = BS_EX_reg;
    assign IM_filled_DOF_output = IM_filled_DOF_wire;
    assign AAddr_DOF_output = AAddr_DOF_wire;
    assign BAddr_DOF_output = BAddr_DOF_wire;
    assign SH_EX_output = SH_EX_reg;
    assign FS_EX_output = FS_EX_reg;
    //WB
    assign RW_WB_output = RW_WB_reg;
    assign DA_WB_output =DA_WB_reg;
    assign MD_WB_output = MD_WB_reg;

    assign regFile_Aout_DOF_output = regFile_Aout_DOF_wire;
    assign regFile_Bout_DOF_output = regFile_Bout_DOF_wire;
    // assign muxA_bus_A_DOF_output = muxA_bus_A_DOF_wire;
    // assign  muxB_bus_B_DOF_output =  muxB_bus_B_DOF_wire;
    assign V_EX_output = V_EX_wire;
    assign N_EX_output = N_EX_wire;
    assign C_EX_output = C_EX_wire;
    assign Z_EX_output =Z_EX_wire;
    assign data_OUT_memory_EX_output = data_OUT_memory_EX_wire;
    assign F_EX_output = F_EX_wire;
    assign BrA_EX_output = BrA_EX_wire;
    assign bus_D_WB_output = bus_D_WB_wire;
    assign RAA_EX_reg_output = RAA_EX_reg;
    assign B_EX_reg_output = B_EX_reg;
    assign PC_2_out = PC_subs_2_EX_reg;
    assign mux_D_prime_output = bus_D_prime_wire;
endmodule
