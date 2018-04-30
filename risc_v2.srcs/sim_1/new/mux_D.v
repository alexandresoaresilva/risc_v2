module mux_D(
	input  reset, [1:0] MD,
    input [31:0]mem_data_IN, F,//F is the result from FU
	input V_xor_N,
	output reg [31:0] bus_D
);

initial begin
	bus_D <= 0;
end

	always @(*) begin
		if (reset)
			bus_D <= 0;
		else begin
			case(MD)
				2'b00: bus_D <= F;
				2'b01: bus_D <= mem_data_IN;
				2'b10: bus_D <= {31'b0, V_xor_N} ;
				default: bus_D <= 0;
			endcase
		end //of else
	end //always@
endmodule
