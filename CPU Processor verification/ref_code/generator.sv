// generator.sv - FILE name
//
// Collaborator : PRADEEP GOVINDAN (pradeep3@pdx.edu)
//
// DESCRIPTION:
// Generator class used to generate and pass stimulus to the BFM in
// order to stimulate the design.
//******************************************************************
//
// `include "scoreboard.sv"
// `include "transactor.sv"
// `include "gen_methods.sv"
import def::*; //importing package definitions

class generator;
  gen_methods ip;  transactor tran_h; //Transactor class handle
  // scoreboard score_h;

  virtual EPW22_if bfm;

  function new (virtual EPW22_if bus);
    bfm = bus;
  endfunction : new

  task execute();
    bfm.Pin_reset();
    case (parserfilename())
         Deterministic_input1: ip.input_0();
     		 Complete_random:      forever ip.input_2();
         Complete_random_c:    forever begin:dynamic_stimulus_2
                                       tran_h = new();
        			                         // score_h = new(top.bus, top.model);
                                       assert(tran_h.randomize());
                                               bfm.data <= tran_h.data1_set;
                                               bfm.tag  <= tran_h.tag_set;
                                               bfm.op   <= tran_h.op_set;
                            @(posedge bfm.clk) bfm.data <= tran_h.data2_set;
                                        end:dynamic_stimulus_2
         Constrain_random:     forever ip.input_3();
         Constrain_random_c:   forever begin:dynamic_stimulus_3 //***create a var to enable and disable dynamic_stimulus_3
                                       tran_h = new();
                                       // score_h = new(top.bus, top.model);
                                       assert(tran_h.randomize() with { data2_set < 8;});
                            @(posedge bfm.clk) bfm.data <= tran_h.data1_set;
                                               bfm.tag  <= tran_h.tag_set;
                                               bfm.op   <= tran_h.op_set;
                            @(posedge bfm.clk) bfm.data <= tran_h.data2_set;
                                        end:dynamic_stimulus_3
      default: $error($time,,,"************************** INVALID INPUT *****************************************");
    endcase
  endtask

  function int parserfilename();  //task to change input file during run time
    int IP = -1;
    if(!$value$plusargs("INPUT=%d", IP)) begin//get the input file name
      $error("************************** NO INPUT CHOSEN **************************"); // display intf.error if there is no input file found
      $stop;
    end
    else
      $display($time,,,"************************** Sucessfully generated stimulus for %0d ****************", IP);
    return IP;
  endfunction

endclass
