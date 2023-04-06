`ifndef INPUT_SEQUENCE_SV
`define INPUT_SEQUENCE_SV

class input_sequence extends uvm_sequence #(input_trans);
  `uvm_object_utils(input_sequence)

input_trans mydata1;

function new (string name ="input_sequence");
    super.new(name);
  endfunction


 virtual task body();
    `uvm_info("input_sequence","EXECUTING Sequence ....",UVM_MEDIUM);
    //req = input_trans::type_id::create("req");
    for(int i=0;i<no_of_transactions;i++)
     begin
	mydata1=input_trans::type_id::create("mydata1");
       start_item(mydata1);

	if(!mydata1.randomize)
         `uvm_error("RANDFAL","Randomization Failed");
    	//`uvm_info("sequence_info",$sformat("Randomization passed with  =%0d",req.data),"");
       finish_item(mydata1);
     end
  endtask
endclass

`endif
