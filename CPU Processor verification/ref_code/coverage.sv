// coverage.sv - FILE name
//
// Collaborator : PRADEEP GOVINDAN 
//
// DESCRIPTION:
// Collection of covergoups to collect code coverage on the design.
// The covergroups are broken up into sections where the reset pin
// is asserted high, reset pin is asserted low, and looking at each
// of the xlat_table and keys registers in more detail.
//******************************************************************
//

import def::*; //importing package definitions
class coverage;
covergroup not_reset;
  data_ip: coverpoint intf.data
  {
  bins data1 = {[                     0:(2**data_width-1)/4       ]};
  bins data2 = {[     (2**data_width)/4:((2**data_width)/2)-1     ]};
  bins data3 = {[     (2**data_width)/2:(((2**data_width)*3)/4)-1 ]};
  bins data4 = {[ ((2**data_width)*3)/4:(2**data_width)-1         ]};
  bins others = default;
  }
  OP_all:coverpoint intf.op
  {
  bins op_bin[] = {[0:(2**op_width)-1]};   //covers intf.op values from 0 to 15
  bins others = default; //everything else not covered in previous bin
  }
  tag:coverpoint intf.tag
  {
  bins tag_bin_nr[] = {[0:tag_width-1]};
  bins tag_other_nr = default;
  }
  key0:coverpoint top.model.keys[0]
  {
  bins key0_bin = {0};
  bins key_others = default;
  }
  key1:coverpoint top.model.keys[1]
  {
  bins key1_bin = {2**key_width-1};
  bins key_others = default;
  }
  key2:coverpoint top.model.keys[2]
  {
  bins key2_bin = {[0:2**key_width-1]};
  bins key_others = default;
  }
  key3:coverpoint top.model.keys[3]
  {
  bins key3_bin = {[0:2**key_width-1]};
  bins key_others = default;
  }
  key4:coverpoint top.model.keys[4]
  {
  bins key4_bin = {[0:2**key_width-1]};
  bins key_others = default;
  }
  key5:coverpoint top.model.keys[5]
  {
  bins key5_bin = {[0:2**key_width-1]};
  bins key_others = default;
  }
  key6:coverpoint top.model.keys[6]
  {
  bins key6_bin = {[0:2**key_width-1]};
  bins key_others = default;
  }
  key7:coverpoint top.model.keys[7]
  {
  bins key7_bin = {[0:2**key_width-1]};
  bins key_others = default;
  }
  q_not_reset:coverpoint top.model.data_stream.size()
  {
  bins data_stream = {[0:key_width-1]};
  bins data_stream_others = default;
  }
  delay_schedule:coverpoint top.model.delay_sched
  {
  bins ds_bin0_1 = {0, 2**data_width-1};
  bins ds_bin5 = {[0:2**data_width-1]};
  bins ds_others = default;
  }
  xlat_start:coverpoint top.model.xlat_table[0]
  {
  bins xlat_full_bin = {[0:2**xlat_data_width-1]};
  bins xlat_full_others = default;
  }
  xlat_64:coverpoint top.model.xlat_table[63]
  {
  bins xlat_full_bin = {[0:2**xlat_data_width-1]};
  bins xlat_full_others = default;
  }
  xlat_128:coverpoint top.model.xlat_table[127]
  {
  bins xlat_full_bin = {[0:2**xlat_data_width-1]};
  bins xlat_full_others = default;
  }

  xlat_full:coverpoint top.model.xlat_table[xlat_size-1]
  {
  bins xlat_full_bin = {[0:2**xlat_data_width-1]};
  bins xlat_full_others = default;
  }
endgroup

covergroup reset_1;
  key1_reset:coverpoint top.model.keys[1]
  {
  bins key1_bin = {2**data_width-1};
  bins key_others = default;
  }
  keys0_2_7_reset:coverpoint {top.model.keys[0], top.model.keys[7:2]}
  {
  bins key0_2_7_bin = {0};
  bins key_others = default;
  }
  xlat_reset:coverpoint top.model.xlat_table
  {
  bins xlat_bin = {0};
  bins xlat_others = default;
  }
  xlat_pointer_reset:coverpoint top.model.xlat_pointer
  {
  bins xlat_pointer_bin = {0};
  bins xlat_pointer_others = default;
  }
  q_reset:coverpoint top.model.data_stream.size()
  {
  bins data_stream_bin = {0};
  bins data_stream_others = default;
  }
  endgroup

covergroup vars;
  data_A:coverpoint top.model.data_A
  {
  bins data_A_bin = {[0:2**data_width-1]};
  bins data_A_others = default;
  }
  temp_op:coverpoint top.model.temp_tag
  {
  bins temp_tag_bin[] = {[0:2**tag_width-1]};
  bins data_A_others = default;
  }
endgroup

covergroup xtable;
  xlat_table0:coverpoint top.model.xlat_table[0]
  {
  bins xlat_table0 = {[0:2**xlat_data_width-1]};
  bins xlat_tableothers = default;
  }
  xlat_table_64:coverpoint top.model.xlat_table[xlat_size/4]
  {
  bins xlat_table64 = {[0:2**xlat_data_width-1]};
  bins xlat_tableothers = default;
  }
  xlat_table_128:coverpoint top.model.xlat_table[xlat_size/2]
  {
  bins xlat_table128 = {[0:2**xlat_data_width-1]};
  bins xlat_tableothers = default;
  }
  xlat_table_255:coverpoint top.model.xlat_table[xlat_size-1]
  {
  bins xlat_table255 = {[0:2**xlat_data_width-1]};
  bins xlat_tableothers = default;
  }
  pointer:coverpoint top.model.xlat_pointer
  {
  bins xlat_pointer1 = {[               0:(xlat_size/4)-1   ]};
  bins xlat_pointer2 = {[     xlat_size/4:(xlat_size/2)-1   ]};
  bins xlat_pointer3 = {[     xlat_size/2:(3*xlat_size/4)-1 ]};
  bins xlat_pointer4 = {[ (3*xlat_size/4):xlat_size-1       ]};
  bins xlat_pointer_others = default;
  }
endgroup

virtual EPW22_if intf;

  function new( virtual EPW22_if  bus);
      vars      = new();
      xtable    = new();
      reset_1   = new();
      not_reset = new();
      intf      = bus;
  endfunction:new

  task execute();
      forever begin:sampling
          @(negedge intf.clk);
            if(intf.reset)
              reset_1.sample();
            vars.sample();
            xtable.sample();
            not_reset.sample();
      end:sampling
  endtask
endclass
