// DESCRIPTION:
// generator_child class used to generate and pass stimulus to the BFM in
// order to stimulate the design for varoius test cases.
//******************************************************************
//
import def::*; //importing package definitions
class generator_child extends generator_parent;

   transactor tran_h; //Transactor class handle

  function new (virtual EPW22_if bus);
    super.new(bus);
  endfunction : new

  task execute();
    fork
     forever case (parserfilename())//runs forever until it reaches the stop time
         no_op:                   Individual_ops(no_op);
         reset_op:                Individual_ops(reset_op);
         store_dly:               Individual_ops(store_dly);
         key_store:               Individual_ops(key_store);
         store_tbl:               Individual_ops(store_tbl);
         reserved_5:              Individual_ops(reserved_5);
         reserved_6:              Individual_ops(reserved_6);
         reserved_7:              Individual_ops(reserved_7);
         rot_left_out:            Individual_ops(rot_left_out);
         rot_rght_out:            Individual_ops(rot_rght_out);
         xor_out:                 Individual_ops(xor_out);
         tbl_out:                 Individual_ops(tbl_out);
         key_store_rot_left:      Individual_ops(key_store_rot_left);
         key_store_rot_rght:      Individual_ops(key_store_rot_rght);
         key_store_xor:           Individual_ops(key_store_xor);
         key_store_tbl:           Individual_ops(key_store_tbl);
         Deterministic_input1:    input_0();
         Complete_random_c:     begin:dynamic_stimulus_2//completly random stimulus generation
                                       tran_h = new();
                                       assert(tran_h.randomize());
                                               bfm.data <= tran_h.data1_set;
                                               bfm.tag  <= tran_h.tag_set;
                                               bfm.op   <= tran_h.op_set;
                                               @(posedge bfm.clk)
                                                bfm.data <= tran_h.data2_set;
                                        end:dynamic_stimulus_2
          Constrain_random_c:    begin:dynamic_stimulus_4 //***create a var to enable and disable dynamic_stimulus_3
                                       tran_h = new();
                                       assert(tran_h.randomize() with { data2_set < 8;});
                                       bfm.op   <= tran_h.op_set;
                                       if(tran_h.op_set == 4)
                                               repeat($urandom_range(0, xlat_size*2))//trying to fill the table twice the size
                                        @(posedge bfm.clk) bfm.data <= tran_h.data1_set;
                                        bfm.tag  <= tran_h.tag_set;
                                        @(posedge bfm.clk)
                                        bfm.data <= tran_h.data2_set;
                                        end:dynamic_stimulus_4
      default: $error($time,,,"************************** INVALID INPUT *****************************************");
    endcase
    $display($time,,,"************************** Sucessfully generated stimulus for %0d ****************", parserfilename());
  join_none
  endtask
  function int parserfilename();  //task to change input file during run time
    int IP = -1;
    if(!$value$plusargs("INPUT=%d", IP)) begin//get the input file name
      $error("************************** NO INPUT CHOSEN **************************"); // display intf.error if there is no input file found
      $stop;
    end
    return IP;
  endfunction

endclass
