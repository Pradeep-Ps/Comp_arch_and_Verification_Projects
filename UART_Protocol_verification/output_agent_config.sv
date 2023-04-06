
`ifndef OUTPUT_AGENT_CONFIG_SV
`define OUTPUT_AGENT_CONFIG_SV
class output_agent_config extends uvm_object;

//bit has_coverage = 1;
//`uvm_object_utils(fifo_agent_config)

uvm_active_passive_enum is_active;

`uvm_object_utils_begin(output_agent_config)
    `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
   `uvm_object_utils_end

function new(string name = "output_agent_config");
  super.new(name);
endfunction




endclass: output_agent_config

`endif
