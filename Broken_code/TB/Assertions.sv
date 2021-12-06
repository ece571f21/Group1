///////////////////////////////////////////////////////////////////////
// Assertions.sv: Contains assertions for AXI4-lite channels
//
// Author:	Pradeep Reddy, Naveen Manivannan, Narendra Srinivas
// Date:	12/01/2021
//
// Description:- Contains assertions for AXI4-lite channels
//
///////////////////////////////////////////////////////////////////////


import axi4lite_pkg::*;

module Assertions(
	input logic clk, 
	input logic rst_N,
	input logic rd_en,
 	input logic wr_en,                                 		// read and write enable
 	input logic [ADDRWIDTH-1:0] Read_Address, Write_Address,   // read and write address variables
    input logic [DATAWIDTH-1:0] Write_Data 
); 

// Write Address Channel

		// AWADDR_STABLE_a: When AWVALID is asserted and AWREADY is LOW,AWADDR should remain stable
		property AWADDR_STABLE_p;
		@(posedge clk) disable iff (!rst_N) 
		$rose((duv.bfm.AWVALID) && !duv.bfm.AWREADY) |=> $stable (duv.bfm.AWADDR);
		endproperty
		AWADDR_STABLE_a: assert property(AWADDR_STABLE_p);
		
		// AWVALID_STABLE_a: When AWVALID is asserted, then it should remain asserted until AWREADY is HIGH
		property AWVALID_STABLE_p;
		@(posedge clk) disable iff (!rst_N) 
		($rose(duv.bfm.AWVALID) |-> ((duv.bfm.AWVALID) throughout (duv.bfm.AWREADY[->1])));
		endproperty
		AWVALID_STABLE_a: assert property(AWVALID_STABLE_p);
		
		// AWADDR_xcheck_a : A value of X on AWADDR is not allowed when AWVALID is HIGH
		property AWADDR_xcheck_p;
		@(posedge clk) disable iff (!rst_N) 
		duv.bfm.AWVALID |-> ($isunknown(duv.bfm.AWADDR)==0);
		endproperty
		AWADDR_xcheck_a: assert property(AWADDR_xcheck_p);

// Write Data Channel

		// WDATA_stable_a: When WVALID is asserted and WREADY is LOW, WDATA should remain stable.
		property WDATA_stable_p;
		@(posedge clk) disable iff (!rst_N)
		$rose(duv.bfm.WVALID && !duv.bfm.WREADY) |=> $stable (duv.bfm.WDATA);
		endproperty
		WDATA_stable_a: assert property(WDATA_stable_p);
		
		// WVALID_stable_a: When WVALID is asserted, then it should remain asserted until WREADY is HIGH.
		property WVALID_stable_p;
		@(posedge clk) disable iff (!rst_N)
		$rose(duv.bfm.WVALID) |-> (duv.bfm.WVALID) throughout (duv.bfm.WREADY[->1]);
		endproperty
		WVALID_stable_a: assert property (WVALID_stable_p);
	
		// WDATA_xcheck_a : A value of X on WDATA is not allowed when WVALID is HIGH.
		property WDATA_xcheck_p;
		@(posedge clk) disable iff (!rst_N)
		duv.bfm.WVALID |-> ($isunknown(duv.bfm.WDATA)==0);
		endproperty
		WDATA_xcheck_a: assert property(WDATA_xcheck_p);

// Write Response Channel

		// BVALID_stable_a : When BVALID is asserted, then it should remain asserted until BREADY is HIGH.
		property BVALID_stable_p;
		@(posedge clk) disable iff (!rst_N)
		duv.bfm.BVALID |-> duv.bfm.BVALID throughout duv.bfm.BREADY;
		endproperty
		BVALID_stable_a: assert property(BVALID_stable_p);
	
// Read Address Channel

		// ARADDR_stable_a : When ARVALID is asserted and ARREADY is LOW, ARADDR should remain stable
		property ARADDR_stable_p;
		@(posedge clk) disable iff (!rst_N)
		(duv.bfm.ARVALID and (!duv.bfm.ARREADY)) |=> $stable(duv.bfm.ARADDR);
		endproperty
		ARADDR_stable_a: assert property(ARADDR_stable_p);
	
		// ARVALID_stable_a : When ARVALID is asserted, then it should remain asserted until ARREADY is HIGH
		property ARVALID_stable_p;
		@(posedge clk) disable iff (!rst_N)
		duv.bfm.ARVALID |-> (duv.bfm.ARVALID throughout (duv.bfm.ARREADY[->1]));
		endproperty
		ARVALID_stable_a: assert property(ARVALID_stable_p);
	
		// ARADDR_xcheck_a: A value of X on ARADDR is not allowed when ARVALID is HIGH
		property ARADDR_xcheck_p;
		@(posedge clk) disable iff (!rst_N)
		(duv.bfm.ARVALID) |-> ($isunknown(duv.bfm.ARADDR)==0);
		endproperty
		ARADDR_xcheck_a: assert property(ARADDR_xcheck_p);	

// Read Data Channel

		// RDATA_stable_a : When RVALID is asserted, and RREADY is LOW, RDATA should remain stable
		property RDATA_stable_p;
		@(posedge clk) disable iff (!rst_N)
		(duv.bfm.RVALID and (!duv.bfm.RREADY)) |-> $stable(duv.bfm.RDATA);
		endproperty
		RDATA_stable_a: assert property(RDATA_stable_p);
	
		// RVALID_stable_a : When RVALID is asserted, then it must remain asserted until RREADY is HIGH
		property RVALID_stable_p;
		@(posedge clk) disable iff (!rst_N)
		duv.bfm.RVALID |-> (duv.bfm.RVALID throughout (duv.bfm.RREADY));
		endproperty
		RVALID_stable_a: assert property(RVALID_stable_p);
	
		// RDATA_xcheck_a : A value of X on RDATA is not allowed when RVALID is HIGH
		property RDATA_xcheck_p;
		@(posedge clk) disable iff (!rst_N)
		(duv.bfm.RVALID) |-> $isunknown(duv.bfm.RDATA)==0;
		endproperty
		RDATA_xcheck_a: assert property(RDATA_xcheck_p);

endmodule: Assertions