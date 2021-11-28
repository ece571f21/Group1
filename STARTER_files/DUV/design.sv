///////////////////////////////////////////////////////////////////////
// axi4lite_DUV.sv - top module to instantiate the master, slave and BFM
///////////////////////////////////////////////////////////////////////
//`include"axi4lite_pkg.sv"
//`include"axi4lite_master.sv"
//`include"axi4lite_slave.sv"
//`include"axi4lite_bfm.sv"
//Packages 
import axi4lite_pkg::*;

module DUV(
 			input logic clk, 
			input logic rst_N,
			input logic rd_en,
 			input logic wr_en,                                 // read and write enable
 			input logic [ADDRWIDTH-1:0] Read_Address, Write_Address,   // read and write address variables
           input logic [DATAWIDTH-1:0] Write_Data 
           );                                                         // write data variable

//Instantiate the BFM:
axi4lite_bfm bfm(.ACLK(clk), .ARESETN(rst_N));

  // instantiate the master module
  axi4lite_master MP(
  		.rd_en(rd_en),
  		.wr_en(wr_en),
  		.Read_Address(Read_Address),
  		.Write_Address(Write_Address),
  		.Write_Data(Write_Data),
  		.Minf(bfm.master_if)
  );


  // instantiate the slave module
  axi4lite_slave SP(
          .Sinf(bfm.slave_if)
          );

endmodule : DUV
