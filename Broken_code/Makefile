all: clean setup compile run
setup:
	vlib work
	vmap work work

compile:
	vlog axi4lite_pkg.sv
	vlog axi4lite_master.svp
	vlog axi4lite_slave.svp
	vlog axi4lite_bfm.sv
	vlog design.sv
	vlog testbench.sv
	vopt +acc DUV -o dut_optimized

run:
	vsim dut_optimized

clean:
