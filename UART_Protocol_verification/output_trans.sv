

class output_trans extends uvm_sequence_item;

 // rand bit [7:0] data_in;
 // rand bit write;
 // rand bit read;
  bit [7:0] data_out;
  bit empty;
  bit full;

  `uvm_object_utils_begin (output_trans)
      // `uvm_field_int (data_in, UVM_ALL_ON)
      // `uvm_field_int (write, UVM_ALL_ON)
      // `uvm_field_int (read, UVM_ALL_ON)
       `uvm_field_int (data_out, UVM_ALL_ON)
       `uvm_field_int (empty, UVM_ALL_ON)
       `uvm_field_int (full, UVM_ALL_ON)

  `uvm_object_utils_end

  //constraint c1 {data_in>=0; data_in<=255;}

function new(string name = "output_trans");
	super.new(name);
endfunction

endclass
