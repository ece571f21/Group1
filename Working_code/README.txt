//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Some general notes on the Design model of AXI4 lite under the release 	
"Verification of AMBA AXI4 lite protocol" for ECE 571 fall 2021		
							
Author: Apoorva Shenoy					
Date: Nov 08, 2021						
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
The complete code is not released on purpose since you are verifying the code. 
The i/o ports and required signals to complete verfication of the protocol is made visible. 
/DUV/axi4lite_master.svp : The encrypted working master model for AXI4 Lite protocol
/DUV/axi4lite_slave.svp: The encrypted working slave model for AXI4 Lite protocol
/DUV/axi4lite_pkg.sv: The package that contains shared parameters of the DUV
/DUV/design.sv: The design is top module to instantiate the master, slave and BFM
/TB/axi4lite_bfm.sv: The Bus Functional Model is an interface that encapsulates all the 
		signals of master and slave
/TB/testbench.sv: The tesbench is just an declaration and definition of DUV, which 
		has to be developed by your team to complete the verification environment

Note:
You are expected to complete a black box verfication of the given design. Your team has access to only 
the non encrypted region of the code and you learn documents provided, inorder to build testcase
to check if the DUV provided to you is satisfying the requirement or not. 
In further weeks you will recieve bug injected encrypted code to verify.