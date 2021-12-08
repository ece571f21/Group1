///////////////////////////////////////////////////////////////////////
// testbench.sv: Basic structure of the testbench which you can build on
//
// Author:	Pradeep Reddy, Naveen Manivannan, Narendra Srinivas
// Date:	12/01/2021
//
// Description:- Contains task for read and write and has stimulus for design
/////////////////////////////////////////////////////////////////////////
import axi4lite_pkg::*;

class Transaction;

	rand logic [DATAWIDTH-1:0] write_data_rand;
	constraint data_range {write_data_rand inside {[32'h00000000:32'hFFFFFFFF]};}
	
endclass: Transaction

module top;
	bit clk=0;
	bit resetn=0;
	logic rd_en, wr_en;                                   // read and write enable
	logic [ADDRWIDTH-1:0] Read_Address, Write_Address;   // read and write address variables
	logic [DATAWIDTH-1:0] Write_Data  ;					// Write data
	
	// declare internal variables
	bit [DATAWIDTH-1:0]      TBMem[MEMSIZE];     // testbench memory array	
	int						total_errors;		// total errors (can only be updated on reads)
	bit rand_flag;
  
// make use of the SystemVerilog C programming interface
// https://stackoverflow.com/questions/33394999/how-can-i-know-my-current-path-in-system-verilog
import "DPI-C" function string getenv(input string env_name);

 // instantiation of Design module  
  DUV duv(.clk(clk), .rst_N(resetn), .rd_en(rd_en), .wr_en(wr_en), .Read_Address(Read_Address), .Write_Address(Write_Address), .Write_Data(Write_Data));
    
  always #10 clk= ~clk;
  
  Transaction trans;

// Bind Assertions to DUV
bind DUV Assertions asser(.*); 
  
//---------- Read request --------------
//- reads data from memory and stores it in 
//- TBMEM[Rd_Addr]
//------------------------------------------
	task rdReq(input logic [ADDRWIDTH-1:0] Rd_Addr);
	
    logic	[DATAWIDTH-1:0] dbuffer;		// memory data buffer
    int				errCnt;			// error count

    @(posedge clk);
	rd_en = 1'b1;
    wr_en = 1'b0;
    Read_Address = Rd_Addr; //put Rd_Addr in read address channel
	//duv.bfm.ARVALID=1'b1;
	//duv.bfm.RREADY=1'b1;
	//
	//if (duv.bfm.ARREADY && duv.bfm.RVALID) begin
			repeat(5) @(posedge clk);
			dbuffer=duv.bfm.RDATA;
	//		duv.bfm.ARREADY=1'b0;
	//		duv.bfm.RVALID=1'b0;
	//		duv.bfm.ARVALID=1'b0;
	//		duv.bfm.RREADY=1'b0;
	//end
	
    $display($time,, "Memory Read from Address %4h", Rd_Addr);
    $display("\t\t\tMem data = %4h\tExpected = %4h", dbuffer, TBMem[Rd_Addr]);
    if (dbuffer != TBMem[Rd_Addr]) begin
      errCnt++;
    end

    if (errCnt != 0)
      $display("Memory data does not match...better find out why");
    else
      $display("Memory data matches...so far, so good");
    
    total_errors += errCnt;
    @(posedge clk);
  endtask : rdReq

//------------- write request --------------------
//- writes data to memory array.  Also stores it in 
//- TBMEM[Wr_Addr]
//---------------------------------------------------
  task wrReq(input logic [ADDRWIDTH-1:0] Wr_Addr, [DATAWIDTH-1:0] Wr_Data);

    $display($time,, "Memory Write to address %4h", Wr_Addr);
    $display("\t\t\tdata: %4h", Wr_Data);

    @(posedge clk);
    rd_en = 1'b0;
    wr_en = 1'b1;
    Write_Address = Wr_Addr;
    Write_Data = Wr_Data; //put Wr_Data into Write data channel

	//duv.bfm.AWVALID=1'b1;
	//duv.bfm.WVALID=1'b1;
	//duv.bfm.BREADY=1'b1;
	//
	//if (duv.bfm.AWREADY && duv.bfm.WREADY) begin
			TBMem[Wr_Addr] = Wr_Data;
	//		duv.bfm.AWVALID=1'b0;
	//		duv.bfm.WVALID=1'b0;
	//		duv.bfm.BREADY=1'b0;
	//		duv.bfm.AWREADY=1'b0;
	//		duv.bfm.WREADY=1'b0;
	//end

  endtask: wrReq
  
  
  initial begin: setup
  	// initialize memory array
	foreach (TBMem[i]) begin
		TBMem[i] = 0;
	end
	
    $dumpfile("dump.vcd"); $dumpvars;
    repeat (1) @(posedge clk)
    resetn= 1'b0;
     repeat (1) @(posedge clk)
	 resetn = 1'b1;

  end: setup
  
  // apply test cases to the model
initial begin: stimulus
    $display("ECE 571 Fall 2021: Final Project AXI4 Lite Testbench implementation - Pradeep Reddy (pmanthu@pdx.edu) Naveen Manivannan(nav9@pdx.edu) Narendra Srinivas(nraghav2@pdx.edu)");
    $display("Sources: %s\n", getenv("PWD"));
	
	  #10 trans = new();
	
	//writing to a given location  Test_WR_Location
	wrReq(32'h00000001,32'h00000001);
    repeat (10) @(posedge clk);
	
	//reading from a given location Test_RD_Location
	rdReq(32'h00000001);
	
	//writing to the last location Test_WR_Last
	wrReq(32'h00000FFF,32'h00000002);
    repeat (10) @(posedge clk);
	
	//reading from the last location Test_RD_Last
	rdReq(32'h00000FFF);
	
	//writing to location that is not in memory array Test_WR_Outofrange
	wrReq(32'h00001000,32'h00000003);
    repeat (10) @(posedge clk);
	
	//reading from a location that is not in memory array Test_RD_Outofrange
	rdReq(32'h00001000);
	
	//Write and read previously written location Test_WR_RD
	wrReq(32'h00000001,32'h00000004);
    repeat (10) @(posedge clk);
	rdReq(32'h00000001);
	
	//Read a location and write it Test_RD_WR
	repeat (10) @(posedge clk);
	rdReq(32'h00000005);
	wrReq(32'h00000005,32'h00000008);
	
    //Writing to successive locations Test_WR_Successive
    for(int i = 1; i<= 5; i++) begin
	rand_flag=trans.randomize();
	if(!rand_flag)
		$error("Randomization has Failed");
	wrReq(i,trans.write_data_rand);
	repeat (10) @(posedge clk);	
    end

    //Reading from successive locations Test_RD_Successive
    for(int i = 1; i<=5; i++) begin
	rdReq(i);
	repeat (10) @(posedge clk);
    end
	
	if(total_errors!=0)
	$display("Test complete - %d errors detected, Try debugging the errors\n",total_errors);
	else
	$display("Test complete - no errors detected, take the rest of the day off\n");
	
    $display("End simulation of ECE 571 Fall 2021:  Final Project AXI4 Lite Testbench implementation - Pradeep Reddy (pmanthu@pdx.edu) Naveen Manivannan(nav9@pdx.edu) Narendra Srinivas(nraghav2@pdx.edu)\n");	
	$stop;
end: stimulus
   
  
endmodule: top