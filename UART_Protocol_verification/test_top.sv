

`ifndef TEST_TOP_SV
`define TEST_TOP_SV

class test_top extends uvm_test;


	`uvm_component_utils(test_top)



	env e;
//	virtual io_if vif;

	function new(string name ="test_top", uvm_component parent = null);
		super.new(name,parent);
	endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	e = env::type_id::create("e",this);
	 endfunction

endclass

/*class test_fifo extends test_top;

	`uvm_component_utils(test_fifo)

	//my_sequence seq;
	input_sequence seq;
	env_config  e_config;
	function new(string name ="test_fifo", uvm_component parent = null);
		super.new(name,parent);
	endfunction


function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	seq = input_sequence::type_id::create("seq");
	//e = env::type_id::create("e",this);
	e_config = env_config::type_id::create("e_config",this);

		e_config.has_scoreboard = 1;
		uvm_config_db#(env_config)::set(this," ","env_config",e_config);
                e_config.has_coverage=1;
		uvm_config_db#(env_config)::set(this," ","env_config",e_config);
        //uvm_config_db#(uvm_active_passive_enum)::set(this,"e.fifo_agent1","fifo_active",UVM_ACTIVE);
       // uvm_config_db#(uvm_active_passive_enum)::set(this,"e.fifo_agent2","fifo_active",UVM_PASSIVE);
endfunction


task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	seq.start(e.active_agent.iseqr);
	phase.drop_objection(this);
endtask

endclass*/

`endif
