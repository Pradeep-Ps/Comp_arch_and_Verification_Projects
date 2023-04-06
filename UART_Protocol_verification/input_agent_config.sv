
`ifndef INPUT_AGENT_CONFIG_SV
`define INPUT_AGENT_CONFIG_SV
class input_agent_config extends uvm_object;

//bit has_coverage = 1;
//`uvm_object_utils(fifo_agent_config)

uvm_active_passive_enum is_active;

`uvm_object_utils_begin(input_agent_config)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_object_utils_end

function new(string name = "input_agent_config");
  super.new(name);
endfunction




endclass: input_agent_config

`endif
