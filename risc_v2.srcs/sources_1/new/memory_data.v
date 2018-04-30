// RAM
//
module memory_data(
    input clock, reset,
    input [6:0] RAA_addr,
    input MW,
    input [31:0] data_IN,
    output [31:0] data_OUT
);

    reg [31:0] memword [127:0];
    integer i;

    initial begin
        for(i=0; i<128; i=i+1)
            memword[i] <= i;
    end

    always @ (posedge clock) begin
        if (reset) begin
            for(i=0; i<128; i=i+1)
                memword[i] <= i;
        end
        else begin
            if(MW) begin
               memword[RAA_addr] <= data_IN;
            end
        end
    end
assign data_OUT = memword[RAA_addr];

endmodule
