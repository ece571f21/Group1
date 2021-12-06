all: clean setup compile run
setup:
	vlib work
	vmap work work

compile:
	vlog DUV/axi4lite_pkg.sv
	vlog TB/axi4lite_bfm.sv
	vlog DUV/axi4lite_master.svp
	vlog DUV/axi4lite_slave.svp
	vlog DUV/design.sv
	vlog TB/testbench.sv
	vopt +acc DUV -o dut_optimized

run:
	vsim dut_optimized

clean:
