//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
"Verification of AMBA AXI4 lite protocol" for ECE 571 fall 2021		
							
Author: Pradeep Reddy,Naveen Manivannan,Narendra Srinivas				
Date: Dec 01, 2021						
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/DUV/axi4lite_master.svp : The encrypted working master model for AXI4 Lite protocol
/DUV/axi4lite_slave.svp: The encrypted working slave model for AXI4 Lite protocol
/DUV/axi4lite_pkg.sv: The package that contains shared parameters of the DUV
/DUV/design.sv: The design is top module to instantiate the master, slave and BFM
/TB/axi4lite_bfm.sv: The Bus Functional Model is an interface that encapsulates all the 
		signals of master and slave
/TB/testbench.sv: The tesbench contains the verification environment
/TB/Assertions.sv: Contains assertions for AXI4-lite channels
