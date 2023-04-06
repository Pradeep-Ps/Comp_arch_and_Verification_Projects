

`ifndef INPUT_SEQUENCER_SV
`define INPUT_SEQUENCER_SV

class input_sequencer extends uvm_sequencer #(input_trans);
  `uvm_component_utils(input_sequencer)

  function new(string name = "input_sequencer",uvm_component parent );
    super.new(name,parent);
  endfunction

endclass :input_sequencer

`endif
