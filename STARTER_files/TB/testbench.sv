///////////////////////////////////////////////////////////////////////
// testbench.sv: Basic structure of the testbench which you can build on
///////////////////////////////////////////////////////////////////////

import axi4lite_pkg::*;
module top;
	bit clk;
	bit resetn;
	logic rd_en, wr_en;                                   // read and write enable
	logic [ADDRWIDTH-1:0] Read_Address, Write_Address;   // read and write address variables
	logic [DATAWIDTH-1:0] Write_Data  ;					// Write data
  
  
 // instantiation of Design module  
  DUV duv(.clk(clk), .rst_N(resetn), .rd_en(rd_en), .wr_en(wr_en), .Read_Address(Read_Address), .Write_Address(Write_Address), .Write_Data(Write_Data));
  
  
  always #10 clk= ~clk;
  
  initial 
  begin
    $dumpfile("dump.vcd"); $dumpvars;
    repeat (1) @(posedge clk)
    resetn= 1'b0;
     repeat (1) @(posedge clk)
	 resetn = 1'b1;

  end
  
endmodule: top