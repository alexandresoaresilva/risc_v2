# risc_v2
Simple 32-bit RISC CPU coded in Verilog, based on Mano and Kime's schematics/diagrams. It follows the 4-stage RISC CPU with stages IF, DOF, EX, and WB, separated by their respective clock ticks.The project was created with Vivado 2017.

-Data forwarding and branch prediciton have been implemented, so when writing assembly for the cpu, it's not necessary to put no-ops between instructions.  The textbook's diagram for the RISC CPU, however, brings a wrong implementation of mux D prime, fundamental for data forwarding. Mux D prime's inputs here, thus, have been made to match the ones on mux D, so now mux D prime outputs register content forwarded instead of memory content (wich is what it did before the correction, when following strictly the textbook's implementation).

Verilog source files:
        
        https://github.com/alexandresoaresilva/risc_v2/tree/master/risc_v2.srcs

-The assembly code in 
        https://github.com/alexandresoaresilva/risc_v2/blob/master/risc_v2.srcs/sources_1/new/memProg.v
        
demonstrates a 32 bit x 32 bit multiplication, which yields a result in two registers, R13  adn R12. R13 is the high 32 bits (MSB's) and R12 holds the low 32-bits (LSB's) of the result. The multiplication was implemented as signed multiplication.

To change the registers that hold the values being multiplied, change the values of R3 and R4 in
        https://github.com/alexandresoaresilva/risc_v2/blob/master/risc_v2.srcs/sources_1/imports/new/register_file.v
        
		data[3]=32'hFFFF_FFFF;
		data[4]=32'hFFFF_FFFF;
            
  Then, for a simulated 100 MHz clock, run the test bench for about 45 microseconds, depending on the size of your input. Large positive values will take more simulated time to calculate than negative values in my experience. this is the test bench used to run the top module (whole pipeline):
  
  	https://github.com/alexandresoaresilva/risc_v2/blob/master/risc_v2.srcs/sources_1/new/top_v2_tb.v
  
 I still hope to make the documentation of the registers on the cpu better, while describing how it works. Hope it is useful for somebody out there.
Have fun!
