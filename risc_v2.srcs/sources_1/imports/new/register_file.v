module register_file(
    input clock,
    input reset,
input write_now,
    input [4:0] SA,
    input [4:0] SB,
    input [4:0] DR,
    input [31:0] data_IN, //comes from MUX
    output [31:0] data_A_OUT,
    output [31:0] data_B_OUT,
    output [31:0] data_DR_OUT //FOR debugging
    );

reg [31:0] data [31:0];

integer counter;

    initial begin
        for(counter = 0; counter < 32; counter = counter + 1) begin
            data [counter] = 0; // for easier initial debugging
        end
         data[1]=32'd1;
         // data[3]=32'hF0F0_F0F0;
         // data[4]=32'hF0F0_F0F0;         
		 // data[3]=32'h4;
         // data[4]=32'h4000_0000;         

		data[3]=32'hFFFF_FFFF;
		data[4]=32'hFFFF_FFFF;         

    end

    always @(posedge clock) begin
        if(reset) begin
            //data  [0] <= 0;  //data [1] <= 0; data  [2] <= 0; data  [3] <= 0;
            // data  [4] <= 0;  data [5] <= 0; data  [6] <= 0; data  [7] <= 0;
            // data  [8] <= 0;  data [9] <= 0; data [10] <= 0; data [11] <= 0;
            // data [12] <= 0; data [13] <= 0; data [14] <= 0; data [15] <= 0;
            // data [16] <= 0; data [17] <= 0; data [18] <= 0; data [19] <= 0;
            // data [20] <= 0; data [21] <= 0; data [22] <= 0; data [23] <= 0;
            // data [24] <= 0; data [25] <= 0; data [26] <= 0; data [27] <= 0;
            // data [28] <= 0; data [29] <= 0; data [30] <= 0; data [31] <= 0;
            // for(counter = 0; counter < 32; counter = counter + 1) begin
            //     data [counter] = counter; // for easier initial debugging
            // end
            for(counter = 0; counter < 32; counter = counter + 1) begin
                data [counter] = 0; // for easier initial debugging
            end
        end // clear all regs on reset
        else if(write_now && (DR != 0 ) ) begin//DR can't be R[0]
             data[DR] <= data_IN;
        end
    end

    assign data_A_OUT = data [SA];
    assign data_B_OUT = data [SB];
    assign data_DR_OUT = write_now? data[DR] : 0;
endmodule