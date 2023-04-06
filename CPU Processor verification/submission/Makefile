E:
	@echo "build:clean compile, sim"
help:
	@echo "build sim clean compile"

build: clean compile

clean:
	vlib work
	vmap work work
	clear
	a=$(pwd)
	@echo $a
	@echo ${a}

compile:
	vlog -cover bcsx ./tb/def.sv
	vlog -cover bcsx ./tb/generator_parent.sv
	vlog -cover bcsx ./tb/generator_child.sv
	vlog -cover bcsx ./tb/coverage.sv
	vlog -cover bcsx ./tb/EPW22_if.sv
	vlog -cover bcsx ./tb/refmodel.sv
	vlog -cover bcsx ./tb/top.sv
	vlog -cover bcsx ./tb/transactor.sv
	vlog -cover bcsx ./dut/EPW22_design.sv +DEFINE+BUG

coverage:
	coverage report -output "output/code_coverage_18.txt" -srcfile=* -assert -directive -cvg -codeAll

sim:
	vsim -c -coverage -do "run -all" top +INPUT=0 +P_F="output/PF_0.txt" +REF="output/REF_0.txt" +DUT="output/DUT_0.txt" +TIME=300 
	vsim -c -coverage -do "run -all" top +INPUT=1 +P_F="output/PF_1.txt" +REF="output/REF_1.txt" +DUT="output/DUT_1.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=2 +P_F="output/PF_2.txt" +REF="output/REF_2.txt" +DUT="output/DUT_2.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=3 +P_F="output/PF_3.txt" +REF="output/REF_3.txt" +DUT="output/DUT_3.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=4 +P_F="output/PF_4.txt" +REF="output/REF_4.txt" +DUT="output/DUT_4.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=5 +P_F="output/PF_5.txt" +REF="output/REF_5.txt" +DUT="output/DUT_5.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=6 +P_F="output/PF_6.txt" +REF="output/REF_6.txt" +DUT="output/DUT_6.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=7 +P_F="output/PF_7.txt" +REF="output/REF_7.txt" +DUT="output/DUT_7.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=8 +P_F="output/PF_8.txt" +REF="output/REF_8.txt" +DUT="output/DUT_8.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=9 +P_F="output/PF_9.txt" +REF="output/REF_9.txt" +DUT="output/DUT_9.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=10 +P_F="output/PF_10.txt" +REF="output/REF_10.txt" +DUT="output/DUT_10.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=11 +P_F="output/PF_11.txt" +REF="output/REF_11.txt" +DUT="output/DUT_11.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=12 +P_F="output/PF_12.txt" +REF="output/REF_12.txt" +DUT="output/DUT_12.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=13 +P_F="output/PF_13.txt" +REF="output/REF_13.txt" +DUT="output/DUT_13.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=14 +P_F="output/PF_14.txt" +REF="output/REF_14.txt" +DUT="output/DUT_14.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=15 +P_F="output/PF_15.txt" +REF="output/REF_15.txt" +DUT="output/DUT_15.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=16 +P_F="output/PF_16.txt" +REF="output/REF_16.txt" +DUT="output/DUT_16.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=17 +P_F="output/PF_17.txt" +REF="output/REF_17.txt" +DUT="output/DUT_17.txt" +TIME=300
	vsim -c -coverage -do "run -all" top +INPUT=18 +P_F="output/PF_18.txt" +REF="output/REF_18.txt" +DUT="output/DUT_18.txt" +TIME=30000
