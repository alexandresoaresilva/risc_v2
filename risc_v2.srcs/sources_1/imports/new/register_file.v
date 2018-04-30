module register_file(
    input clock,
    input reset,
    input write_now,
    input [4:0] SA,
    input [4:0] SB,
    input [4:0] DR,
    input [31:0] data_IN, //comes from MUX
//special_regFile_update[9:0] == PC_IF_reg
//special_regFile_update[15:10] == RAA_EX_reg - last mem addr written to
//special_regFile_update[19:16] ==V_EX_wire, N_EX_wire, C_EX_wire,
         //Z_EX_wire
//special_regFile_update[31:20] == 12'd0
    input [31:0] special_regFile_update,
    output [31:0] data_A_OUT,
    output [31:0] data_B_OUT,
    output [31:0] data_DR_OUT //FOR debugging
    );

reg [31:0] data [31:0];

integer counter;

initial begin
for(counter = 1; counter < 32; counter = counter + 1)
begin
data [counter] = counter; // for easier initial debugging
end
data[0]=0;
data[1]=0;
data[2]=0;
data[3]=0;   //Neg Flag 1
data[4]=0;   //Neg flag 2
data[5]=0;  // Neg flag
data[6]=0;  // set less than Flag
        data[7]=0;
        data[8]=0;  //LSB
        data[9]=0;  //MSB
        data[10]=0;
        data[11]=15'd9;  //JMR constant
        data[12]=15'd6;  //JMR constant
        data[16]=32'h8000_0000; // Neg check
        data[15]=32'h5; // Y value
        data[14]=32'h4; // X value
        data[13]=32'd1; // S:T Check value
end

always @(posedge clock)
begin
if(reset) begin
            data  [0] <= 0;  data [1] <= 0; data  [2] <= 0; data  [3] <= 0;
            data  [4] <= 0;  data [5] <= 0; data  [6] <= 0; data  [7] <= 0;
            data  [8] <= 0;  data [9] <= 0; data [10] <= 0; data [11] <= 0;
            data [12] <= 0; data [13] <= 0; data [14] <= 0; data [15] <= 0;
            data [16] <= 0; data [17] <= 0; data [18] <= 0; data [19] <= 0;
            data [20] <= 0; data [21] <= 0; data [22] <= 0; data [23] <= 0;
            data [24] <= 0; data [25] <= 0; data [26] <= 0; data [27] <= 0;
            data [28] <= 0; data [29] <= 0; data [30] <= 0; data [31] <= 0;
        end // clear all regs on reset
else if(write_now && (DR != 0 &&  DR != 31) ) begin//DR can't be R[0]
     data[DR] <= data_IN;
     data[31] <= 32'd0 | special_regFile_update;
        end
end

    assign data_A_OUT = data [SA];
    assign data_B_OUT = data [SB];
    assign data_DR_OUT = write_now? data[DR] : 0;
endmodule
