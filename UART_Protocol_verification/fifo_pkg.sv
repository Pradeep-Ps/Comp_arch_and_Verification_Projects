
package fifo_pkg;
 `include"uvm_macros.svh"
	import uvm_pkg::*;

	int no_of_transactions = 200;

  //typedef uvm_config_db#(virtual io_if) vif_config;
  // typedef virtual fiof_if d_vif;
   //typedef virtual fiof_if im_vif;
  // typedef virtual fiof_if om_vif;
   
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/rtl/defines.v"	
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/input_agent/input_agent_config.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/input_agent/input_trans.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/input_agent/input_sequence.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/input_agent/input_sequencer.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/input_agent/input_driver.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/input_agent/input_monitor.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/input_agent/input_agent.sv"
  
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/output_agent/output_agent_config.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/output_agent/output_trans.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/output_agent/output_monitor.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/agents/output_agent/output_agent.sv"
   
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/tb/scoreboard.sv"
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/tb/env_config.sv"  
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/tb/env.sv"
  
  `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/test/test_top.sv"
   `include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/test/test_fifo.sv"
   

endpackage : fifo_pkg
