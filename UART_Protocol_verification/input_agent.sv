

`ifndef INPUT_AGENT_SV
`define INPUT_AGENT_SV
class input_agent extends uvm_agent;

	`uvm_component_utils(input_agent)

         //-----Data members-----------//
          //input_agent_config input_config1;
	  input_agent_config input_config;

	//------------------------------------------
	// Component Members
	//------------------------------------------
	//uvm_active_passive_enum fifo_active;


	input_driver idrv;
	input_sequencer iseqr;
	input_monitor imon;




	function new(string name = "input_agent", uvm_component parent= null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);

		super.build_phase(phase);
		//input_config= input_agent_config::type_id::create("input_config");
                if(!uvm_config_db #(input_agent_config)::get(this," ","input_agent_config",input_config))
      		`uvm_error(get_full_name(),"NO INPUT AGENT CONFIG CLASS FOUND")

		imon = input_monitor::type_id::create("imon",this);
		//fifo_cfg = fifo_agent_config::type_id::create("fifo_cfg");
		// Monitor is always present
               // mon = input_monitor::type_id::create("mon",this);

		//if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"","fifo_active",fifo_active))
		//`uvm_fatal(get_full_name(),"cant find fifo_active in fifo agent");

		// Only build the driver and sequencer if active
                //if(fifo_cfg.is_active == UVM_ACTIVE)
		if(input_config.is_active == UVM_ACTIVE)
		begin
		idrv = input_driver::type_id::create("idrv",this);
		iseqr = input_sequencer::type_id::create("iseqr",this);
		end
		//mon = mymonitor::type_id::create("mon",this);
	endfunction

	function void connect_phase (uvm_phase phase);
		//super.connect_phase(phase);
		//if(fifo_cfg.is_active == UVM_ACTIVE)
		if(input_config.is_active == UVM_ACTIVE)

		  idrv.seq_item_port.connect(iseqr.seq_item_export);


	endfunction

endclass

`endif
