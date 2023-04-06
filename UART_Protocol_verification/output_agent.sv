

`ifndef OUTPUT_AGENT_SV
`define OUTPUT_AGENT_SV
class output_agent extends uvm_agent;

	`uvm_component_utils(output_agent)

         //-----Data members-----------//
          output_agent_config output_config;


	//------------------------------------------
	// Component Members
	//------------------------------------------
	//uvm_active_passive_enum fifo_active;


	input_driver odrv;
	input_sequencer oseqr;
	output_monitor omon;




	function new(string name = "ouput_agent", uvm_component parent= null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);

		super.build_phase(phase);


                if(!uvm_config_db #(output_agent_config)::get(this,"","output_agent_config",output_config))
      		`uvm_error(get_full_name(),"NO FIFO CONFIG CLASS FOUND")
		omon = output_monitor::type_id::create("omon",this);
                //fifo_cfg = fifo_agent_config::type_id::create("fifo_cfg");
		// Monitor is always present
               // mon = input_monitor::type_id::create("mon",this);

		//if(!uvm_config_db#(uvm_active_passive_enum)::get(this,"","fifo_active",fifo_active))
		//`uvm_fatal(get_full_name(),"cant find fifo_active in fifo agent");

		// Only build the driver and sequencer if active
                //if(fifo_cfg.is_active == UVM_ACTIVE)
		if(output_config.is_active == UVM_ACTIVE)
		begin
		odrv = input_driver::type_id::create("odrv",this);
		oseqr = input_sequencer::type_id::create("oseqr",this);
		end
		//mon = mymonitor::type_id::create("mon",this);
	endfunction

	function void connect_phase (uvm_phase phase);
		//super.connect_phase(phase);
		//if(fifo_cfg.is_active == UVM_ACTIVE)
		if(output_config.is_active == UVM_ACTIVE)

		  odrv.seq_item_port.connect(oseqr.seq_item_export);


	endfunction

endclass

`endif
