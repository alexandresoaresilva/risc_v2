module mux_C(
    input reset,
    input [1:0] sel,
    input [31:0] RAA,
    input [9:0] BrA, [9:0] PC_IN,
    output reg [9:0] PC_OUT
);
//  EN ==  { BS[1] ,((PS ^ Z) | BS[1]  )  & BS[0])}
	always @(*) begin
	   if (reset)
	       PC_OUT <= 0;
	   else begin
            case(sel)
                2'b00:  PC_OUT <= PC_IN + 1;
                2'b01:  PC_OUT <= BrA;
                2'b10:  PC_OUT <= RAA[9:0];
                2'b11:  PC_OUT <= BrA;
                default: PC_OUT <= 0;
            endcase
        end
	end//of always @
endmodule
