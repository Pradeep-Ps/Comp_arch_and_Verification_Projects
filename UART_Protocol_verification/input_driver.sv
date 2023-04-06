

`ifndef INPUT_DRIVER_SV
`define INPUT_DRIVER_SV

class input_driver extends uvm_driver #(input_trans);

virtual fifo_if d_vif;

//mytransaction mydata;
  `uvm_component_utils(input_driver)
   input_trans mydata1;

	int num_sent;
	function new (string name = "input_driver", uvm_component parent = null);
		super.new(name,parent);
	endfunction

  //uvm_get_port #(mytransaction) get_port;

       function void build_phase(uvm_phase phase);
	super.build_phase(phase);
          if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",d_vif))
	    `uvm_error("NOVIF",{"virtual interface must be set for: ",get_full_name(),"d_vif"})
       endfunction

 extern virtual task run_phase(uvm_phase phase);
 extern virtual task get_and_drive();
// extern virtual task reset();
 extern virtual task drive_transfer(input_trans mydata);
 extern function void report();
endclass


task input_driver::run_phase(uvm_phase phase);
    //fork
        get_and_drive();
      // reset();

  //  join
  endtask : run_phase

/*function void mydriver::report_phase(uvm_phase phase);
    		`uvm_info(get_type_name(), "Report: FIFO DRIVER sent transactions", UVM_LOW);
endfunction */


//task input_driver::reset();
 //forever
//begin
    // @(posedge d_vif.rst_n);
     //`uvm_info(get_type_name(), "Reset observed", UVM_MEDIUM);
      //`uvm_info(get_full_name(),"DUT starting reset operation", UVM_LOW);
         //vif.data_out<=8'd0;
        //end
//endtask

//task mydriver::get_and_drive(input_trans transfer);
task input_driver::get_and_drive();
   @(negedge d_vif.rst_n);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
   for(int i=0;i<no_of_transactions;i++)
    begin
      @( d_vif.cb_drv);
	mydata1=input_trans::type_id::create("mydata1");
      // Get new item from the sequencer
      seq_item_port.get_next_item(mydata1);
      // Drive the item
      drive_transfer(mydata1);
      // Communicate item done to the sequencer
      seq_item_port.item_done();

    end
`uvm_info(get_type_name(), "transaction is done", UVM_MEDIUM)
endtask : get_and_drive

task input_driver::drive_transfer(input_trans mydata);
      @(d_vif.cb_drv);
	begin
	d_vif.cb_drv.read <= mydata.read;
        d_vif.cb_drv.write <= mydata.write;
        d_vif.cb_drv.data_in <= mydata.data_in;

        `uvm_info(get_type_name(),
        $psprintf("master sending data :\n%s",
        mydata.sprint()), UVM_MEDIUM)
         num_sent++;
	end
	`uvm_info(get_type_name(), "transaction is completed", UVM_MEDIUM)
endtask : drive_transfer

function void input_driver::report();
    `uvm_info(get_type_name(),
      $psprintf("\nReport: fifo driver sent %0d transfers",
      num_sent), UVM_LOW)
  endfunction : report





 `endif
