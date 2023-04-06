vlog -cover bcsx tb/def.sv
vlog -cover bcsx tb/generator_parent.sv
vlog -cover bcsx tb/generator_child.sv
vlog -cover bcsx tb/coverage.sv
vlog -cover bcsx tb/EPW22_if.sv
vlog -cover bcsx tb/refmodel.sv
vlog -cover bcsx tb/top.sv
vlog -cover bcsx tb/transactor.sv
vlog -cover bcsx dut/EPW22_design.sv +DEFINE+BUG

vsim -coverage -voptargs=+acc work.top +INPUT=18 +P_F=output/P_F18.txt +REF=output/REF18.txt +DUT=output/DUT18.txt +TIME=300000;
do waveform/001_wave.do;
restart -f;
run -all;
coverage report -output output/code_coverage18.txt -srcfile=* -assert -directive -cvg -codeAll;
