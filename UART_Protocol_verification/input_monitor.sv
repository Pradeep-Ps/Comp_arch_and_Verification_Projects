

`ifndef INPUT_MONITOR_SV
`define INPUT_MONITOR_SV

class input_monitor extends uvm_monitor;
virtual  fifo_if im_vif;

`uvm_component_utils(input_monitor)

int num_col=0;
input_trans mydata;

//event transaction_ended;

// This TLM port is used to connect the monitor to the scoreboard
  uvm_analysis_port #(input_trans) item_collected_port;

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
    item_collected_port=new("item_collected_port",this);
endfunction : new

 function void build_phase(uvm_phase phase);
	super.build_phase(phase);
       // mydata = input_trans::type_id::create("mydata");
          if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",im_vif))
	    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),"im_vif"})

 endfunction



  extern virtual task run_phase(uvm_phase phase);
    extern virtual task collect_transfer();
  //extern virtual function void perform_coverage();
  extern virtual function void report();

endclass : input_monitor

   // UVM run() phase
  task input_monitor::run_phase(uvm_phase phase);
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

  task input_monitor::collect_transfer();
    // This monitor re-uses its data items for ALL transfers
    mydata = input_trans::type_id::create("mydata", this);

`uvm_info(get_type_name(), "monitor  sequence is started", UVM_MEDIUM)
    for(int i=0;i<no_of_transactions;i++)
     begin
//repeat(1)
      @(im_vif.cb_imon);
       mydata.read = im_vif.cb_imon.read;
       mydata.write = im_vif.cb_imon.write;
       mydata.data_in = im_vif.cb_imon.data_in;
       //mydata.fifo_out = vif.fifo_out;
       //mydata.fifo_empty = vif.fifo_empty;
       //mydata.fifo_full = vif.fifo_full;
       num_col++;
     //@(posedge vif.clock)
      `uvm_info(get_type_name(),
        $psprintf("master transfer collected :\n%s",
        mydata.sprint()), UVM_MEDIUM)

        item_collected_port.write(mydata);
      //  -> transaction_ended;
         // if(fifo_config.has_coverage)
	//	    fifo_cg.sample();
            //      end

//-> transaction_ended;

     // transfer.print();
       end
  endtask : collect_transfer

 function void input_monitor::report();
    `uvm_info(get_type_name(),$psprintf("\nReport: FIFO monitor collected %0d transfers", num_col),UVM_MEDIUM);
  endfunction : report

`endif
