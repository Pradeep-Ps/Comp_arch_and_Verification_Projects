

`ifndef OUTPUT_MONITOR_SV
`define OUTPUT_MONITOR_SV

class output_monitor extends uvm_monitor;
virtual  fifo_if om_vif;

`uvm_component_utils(output_monitor)

int num_col=0;
output_trans mydata;

event transaction_ended;

// This TLM port is used to connect the monitor to the scoreboard
  uvm_analysis_port #(output_trans) oitem_collected_port;

 //fifo_slave_config fifo_config;

//covergroup fifo_cg;
//option.per_instance =1;
//FIFO_IN:coverpoint mydata.fifo_in
  // {
   //  bins random_data ={[8'h00:8'hff]};
  // }

//endgroup:fifo_cg


 function new (string name, uvm_component parent);
    super.new(name, parent);
  //  fifo_cg=new();
    oitem_collected_port=new("oitem_collected_port",this);
endfunction : new

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
        mydata = output_trans::type_id::create("mydata");
          if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",om_vif))
	   `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),"om_vif"})
        //  if( !uvm_config_db#(fifo_slave_config)::get(this,"","fifo_slave_config",fifo_config))
        // `uvm_error("fifo_config","HAVE YOU SET IT")
 endfunction



  extern virtual task run_phase(uvm_phase phase);
    extern virtual task collect_transfer();
  //extern virtual function void perform_coverage();
  extern virtual function void report();

endclass : output_monitor

   // UVM run() phase
  task output_monitor::run_phase(uvm_phase phase);
     `uvm_info(get_type_name(), "monitor  is started", UVM_MEDIUM)
      collect_transfer();
 `uvm_info(get_type_name(), "monitor  is completed", UVM_MEDIUM)
  endtask : run_phase

  /***************************************************************************
   IVB-NOTE : REQUIRED : master Monitor : Monitors
   -------------------------------------------------------------------------
   Modify the collect_transfers() method to match your protocol.
   Note that if you change/add signals to the physical interface, you must
   also change this method.
   ***************************************************************************/

  task output_monitor::collect_transfer();
    // This monitor re-uses its data items for ALL transfers
    mydata = output_trans::type_id::create("mydata", this);

`uvm_info(get_type_name(), "monitor  sequence is started", UVM_MEDIUM)
    for(int i=0;i<no_of_transactions;i++)
     begin
//repeat(1)
      @(om_vif.cb_omon);
      // mydata.read = om_vif.read;
      // mydata.write = om_vif.write;
       //mydata.data_in = om_vif.data_in;
       mydata.data_out = om_vif.cb_omon.data_out;
       mydata.empty = om_vif.cb_omon.empty;
       mydata.full = om_vif.cb_omon.full;
       num_col++;
     //@(posedge vif.clock)
      `uvm_info(get_type_name(),
        $psprintf("master transfer collected :\n%s",
        mydata.sprint()), UVM_MEDIUM)

        oitem_collected_port.write(mydata);
      //  -> transaction_ended;
         // if(fifo_config.has_coverage)
	//	    fifo_cg.sample();
            //      end

//-> transaction_ended;

     // transfer.print();
       end
  endtask : collect_transfer

 function void output_monitor::report();
    `uvm_info(get_type_name(),$psprintf("\nReport: FIFO monitor collected %0d transfers", num_col),UVM_MEDIUM);
  endfunction : report

`endif
