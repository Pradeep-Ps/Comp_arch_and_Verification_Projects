
`ifndef ENV_SV
`define ENV_SV


class env extends uvm_env;

	`uvm_component_utils(env)
	//virtual interface io_if vif;
	input_agent active_agent;
	output_agent passive_agent;
	input_agent_config input_config;
	output_agent_config output_config;
 	//fifo_slave_config fifo_slave_cfg;
        scoreboard fifo_sb;
	env_config e_config;




	function new(string name = "env", uvm_component parent );
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		active_agent = input_agent::type_id::create("active_agent",this);
                passive_agent = output_agent::type_id::create("passive_agent",this);
                input_config = input_agent_config::type_id::create("input_config");
		output_config = output_agent_config::type_id::create("output_config");

		 input_config.is_active = UVM_ACTIVE;
		uvm_config_db#(input_agent_config)::set(this,"*","input_agent_config",input_config);
                output_config.is_active = UVM_PASSIVE;
		uvm_config_db#(output_agent_config)::set(this,"*","output_agent_config",output_config);

		 if(!uvm_config_db #(env_config)::get(this," ","env_config",e_config))
      		`uvm_error(get_full_name(),"NO FIFO CONFIG CLASS FOUND")

		if(e_config.has_scoreboard==1)
 		fifo_sb = scoreboard::type_id::create("fifo_sb",this);
		//uvm_config_db#(fifo_slave_config)::set(null,"*","fifo_slave_config",fifo_slave_cfg);

	endfunction

       function void connect_phase(uvm_phase phase);
	active_agent.imon.item_collected_port.connect(fifo_sb.fifo_aport1);
        passive_agent.omon.oitem_collected_port.connect(fifo_sb.fifo_aport2);

       endfunction

       function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
        endfunction
endclass
`endif
