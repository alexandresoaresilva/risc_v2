module mux_A_B(
    input reset,
	input [31:0]  data_A, data_B, data_D_prime,
	input [9:0] PC_1, //PC - 1
	input [31:0] const_unit, //constant unit
	//input [1:0] MA_MB,
	input [1:0] MA_MB, HA_HB,
	output reg[31:0] bus_A, bus_B
//	output reg [31:0]
);

    wire [1:0] mux_A_sel, mux_B_sel;
    assign mux_A_sel = HA_HB[1]? 2'b10 : {1'b0, MA_MB[1] }; 
    assign mux_B_sel = HA_HB[0]? 2'b10 : {1'b0, MA_MB[0] };
//    assign mux_A_sel = HA_HB[1]? 2'b01 : {MA_MB[1], 1'b0 }; 
//    assign mux_B_sel = HA_HB[0]? 2'b01 : {MA_MB[0], 1'b0};


always @(*) begin //  bus_B
    if (reset) begin
        {bus_A, bus_B} <= 0;
    end
    else begin
        //mux A
        //case({HA_HB[1], MA_MB[1]})
        case(mux_A_sel)
            2'b00: bus_A <= data_A;
            2'b01: bus_A <= {22'd0, PC_1};
            2'b10: bus_A <= data_D_prime;
            default: bus_A <= 0;
        endcase
        //mux B
        //case({HA_HB[0], MA_MB[0]})
        case(mux_B_sel)
            2'b00: bus_B <= data_B;
            2'b01: bus_B <= const_unit;
            2'b10: bus_B <= data_D_prime;
            default: bus_B <= 0;
        endcase
    end //of if else
end //always@
//always @(*) begin //  bus_B
//    if (reset) begin
//        {bus_A, bus_B} <= 0;
//    end
//    else begin
//        //mux A
//        case(MA_MB[1])
//            1'b0: bus_A <= data_A;
//            1'b1: bus_A <= {22'd0, PC_1};
//            default: bus_A <= 0;
//        endcase
//        //mux B
//        case(MA_MB[0])
//            1'b0: bus_B <= data_B;
//            1'b1: bus_B <= const_unit;
//            default: bus_B <= 0;
//        endcase
//    end //of if else
//end //always@

endmodule
