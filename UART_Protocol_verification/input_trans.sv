


class input_trans extends uvm_sequence_item;

  rand bit [7:0] data_in;
  rand bit write;
  rand bit read;
  //bit [7:0] data_out;
  //bit empty;
 // bit full;

  `uvm_object_utils_begin (input_trans)
       `uvm_field_int (data_in, UVM_ALL_ON)
       `uvm_field_int (write, UVM_ALL_ON)
       `uvm_field_int (read, UVM_ALL_ON)
      // `uvm_field_int (data_out, UVM_ALL_ON)
      // `uvm_field_int (empty, UVM_ALL_ON)
      //`uvm_field_int (full, UVM_ALL_ON)

  `uvm_object_utils_end
  constraint w1 {write==1; read==1;}

  constraint c1 {data_in>0;}

function new(string name = "input_trans");
	super.new(name);
endfunction

endclass
