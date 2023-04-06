`ifndef ENV_CONFIG_SV
`define ENV_CONFIG_SV
class env_config extends uvm_object;

int has_coverage;
int has_scoreboard;


`uvm_object_utils_begin(env_config)
	`uvm_field_int (has_coverage, UVM_ALL_ON)
	`uvm_field_int (has_scoreboard, UVM_ALL_ON)
 `uvm_object_utils_end

function new(string name = "env_config");
  super.new(name);
endfunction




endclass: env_config

`endif
