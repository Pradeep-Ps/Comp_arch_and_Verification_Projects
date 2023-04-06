
VLOG =  /tools/mentor/questasim_10.1c/questasim/bin/vlog

VSIM = /tools/mentor/questasim_10.1c/questasim/bin/vsim

all: comp_rtl comp run

comp_rtl:
	$(VLOG) +cover=bcstfex ../rtl/*.v  
	

comp: 
	$(VLOG) +incdir+/export/home/vishnu_b21/UVM/uvm-1.1d/src /export/home/vishnu_b21/UVM/uvm-1.1d/src/uvm_pkg.sv +define+UVM_NO_DPI ../rtl/fifo_if.sv ../test/fifo_pkg.sv   ../test/top.sv

	

run: 
	##$(VSIM)   -coverage  -do "run -all" top +UVM_TESTNAME=test_fifo -l vsim.log -c 
	$(VSIM)   -coverage  -novopt top -l vsim.log  -c
       ##add wave -r
