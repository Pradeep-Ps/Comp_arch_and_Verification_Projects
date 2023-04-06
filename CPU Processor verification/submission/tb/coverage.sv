// DESCRIPTION:
// Collection of covergoups to collect functional coverage on the design.
// and the reference module. The coverage is broken into different scenarios
// where each covergroup is used to collect coverage for them. Coverpoints in
// each covergroup cover each input,output or internal signals during simulation
// and its values are collected in its respective bins.
//******************************************************************
//

import def::*; //importing package definitions
class coverage;
covergroup nreset_r;//covergrouop during not reset for reference module
  data_ip: coverpoint intf.data//input data
  {
  bins data1 = {[                     0:(2**data_width-1)/4       ]};
  bins data2 = {[     (2**data_width)/4:((2**data_width)/2)-1     ]};
  bins data3 = {[     (2**data_width)/2:(((2**data_width)*3)/4)-1 ]};
  bins data4 = {[ ((2**data_width)*3)/4:(2**data_width)-1         ]};
  wildcard bins odd_data  = {16'h ???1};
  wildcard bins even_data = {16'h ???0};
  ignore_bins datax = {'bx};
  bins others = default;
  }
  OP_all:coverpoint intf.op //input operation
  {
  bins op_bin[] = {[0:(2**op_width)-1]};   //covers intf.op values from 0 to 15
  bins op0_1 = (4'b0 => 4'b1);
  bins others = default; //everything else not covered in previous bin
  wildcard bins odd_op  = {4'b ???1};
  wildcard bins even_op = {4'b ???0};
  ignore_bins  opx = {'bx};
  }
  tag:coverpoint intf.tag//input tag
  {
  bins tag_bin_nr[] = {[0:tag_width-1]};
  bins tag_other_nr = default;
  ignore_bins tagx = {'bx};
  }
  key0:coverpoint top.model.keys[0] //all the keys in EPW22 processor
  {
  bins key0_bin = {0};
  ignore_bins key0_other = {[1:2**key_width-1]};
  bins key_others = default;
  }
  key1:coverpoint top.model.keys[1]
  {
  bins key1_ones = {2**key_width-1};
  ignore_bins key1_zero = {0};
  ignore_bins key1_other = {[2:2**key_width-1]};
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

  c_op_key0: cross OP_all, key0; //cross coverage between all operations and keys
  c_op_key1: cross OP_all, key1;
  c_op_key2: cross OP_all, key2;
  c_op_key3: cross OP_all, key3;
  c_op_key4: cross OP_all, key4;
  c_op_key5: cross OP_all, key5;
  c_op_key6: cross OP_all, key6;
  c_op_key7: cross OP_all, key7;

  t_op_start: cross OP_all, xlat_64; //cross coverage between all operations and xlat_table
  t_op_xlat_64: cross OP_all, xlat_128;
  t_op_xlat128: cross OP_all, xlat_full;

  q_size_not_reset:coverpoint top.model.data_stream.size()//checking queue size if it is varying
  {
  bins data_stream = {[0:data_width-1]};
  bins q_empty = {0};
  bins q_full = {1};
  bins data_stream_others = default;
  }
  q_not_reset:coverpoint top.model.data_stream[0]//checking values inside queue
  {
  bins data_stream = {[0:(2**20)-1]};
  ignore_bins opx = {4'b????};
  bins data_stream_others = default;
  }
  delay_schedule:coverpoint top.model.delay_sched //checking the delay scheduler
  {
  bins ds_bin0_1 = {0, 2**data_width-1};
  bins ds_bin5 = {[0:2**data_width-1]};
  bins ds_others = default;
  }
  xlat_start:coverpoint top.model.xlat_table[0] //First entry in the xlat table
  {
  bins xlat_full_bin = {[0:2**xlat_data_width-1]};
  bins xlat_full_others = default;
  }
  xlat_64:coverpoint top.model.xlat_table[63]//64th Entry in the xlat table
  {
  bins xlat_full_bin = {[0:2**xlat_data_width-1]};
  bins xlat_full_others = default;
  }
  xlat_128:coverpoint top.model.xlat_table[127]//128th entry in the xlat_table
  {
  bins xlat_full_bin = {[0:2**xlat_data_width-1]};
  bins xlat_full_others = default;
  }
  xlat_full:coverpoint top.model.xlat_table[xlat_size-1]//last entry in the xlat_table
  {
  bins xlat_full_bin = {[0:2**xlat_data_width-1]};
  bins xlat_full_others = default;
  }
  c_xlat_s64: cross xlat_start, xlat_64;//cross coverage between different ranges of xlat_table
  c_xlat_s128: cross xlat_start, xlat_128;
  c_xlat_sfull: cross xlat_start, xlat_full;
  c_xlat_all: cross xlat_start, xlat_64, xlat_128, xlat_full;

  result_r:coverpoint intf.result //Covering result during not reset
  {
  bins result1 = {[                     0:(2**data_width-1)/4       ]};
  bins result2 = {[     (2**data_width)/4:((2**data_width)/2)-1     ]};
  bins result3 = {[     (2**data_width)/2:(((2**data_width)*3)/4)-1 ]};
  bins result4 = {[ ((2**data_width)*3)/4:(2**data_width)-1         ]};
  wildcard bins odd_data  = {16'h ???1};
  wildcard bins even_data = {16'h ???0};
  ignore_bins datax = {'bx};
  bins others = default;
  }
endgroup

covergroup reset_r;//covergroup for reference module when resetting the reference module
  key1_reset:coverpoint top.model.keys[1]
  {
  bins key1_bin = {(2**data_width)-1};
  bins key_others = default;
  }
  keys0_2_7_reset:coverpoint {top.model.keys[0], top.model.keys[7:2]}//keys during reset
  {
  bins key0_2_7_bin = {0};
  bins key_others = default;
  }
  xlat_reset:coverpoint top.model.xlat_table//xlat_table
  {
  bins xlat_bin = {0};
  bins xlat_others = default;
  }
  xlat_pointer_reset:coverpoint top.model.xlat_pointer//xlat_table pointer
  {
  bins xlat_pointer_bin = {0};
  bins xlat_pointer_others = default;
  }
  q_reset:coverpoint top.model.data_stream.size()
  {
  bins data_stream_bin = {0};
  bins data_stream_others = default;
  }
  data_r: coverpoint intf.data//checking data stimulus during reset
  {
  bins data1 = {[                     0:(2**data_width-1)/4       ]};
  bins data2 = {[     (2**data_width)/4:((2**data_width)/2)-1     ]};
  bins data3 = {[     (2**data_width)/2:(((2**data_width)*3)/4)-1 ]};
  bins data4 = {[ ((2**data_width)*3)/4:(2**data_width)-1         ]};
  ignore_bins datax = {'bx};
  bins others = default;
  }
  op_r:coverpoint intf.op //input op
  {
  bins op = {0};
  ignore_bins op_x = {1'hx};

  }
  tag_r:coverpoint intf.tag//input tag
  {
  bins tag = {0};
  ignore_bins tag_x = {'bx};
  }
  xlat_table_r:coverpoint top.model.xlat_table
  {
  bins xlat_table = {0};
  }
  result_r:coverpoint intf.result
  {
  bins result = {0};
  }
  valid_r:coverpoint intf.valid
  {
  bins valid = {0};
  }
  endgroup

covergroup internal_r;
  data_A:coverpoint top.model.data_A//internal variables of reference module
  {
  bins data_A_bin = {[0:2**data_width-1]};
  bins data_A_others = default;
  }
  temp_tag:coverpoint top.model.temp_tag
  {
  bins temp_tag_bin[] = {[0:2**tag_width-1]};
  bins data_A_others = default;
  }
endgroup

covergroup xtable;//xlat_table
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

covergroup reset_d;//checking duv during reset
  result_d:coverpoint intf.duv_result
  {
  bins result = {0};
  }
  valid_r:coverpoint intf.duv_valid
  {
  bins valid = {0};
  }
  ready_r:coverpoint intf.duv_ready
  {
  bins ready = {1};
  }
  xlat_table_r:coverpoint top.duv.xlat_table
  {
  bins xlat_table = {0};
  }
  key1_reset:coverpoint top.duv.keys[1]
  {
  bins key1_bin = {(2**data_width)-1};
  bins key_others = default;
  }
  keys0_2_7_reset:coverpoint {top.duv.keys[0], top.duv.keys[7:2]}//keys during reset
  {
  bins key0_2_7_bin = {0};
  bins key_others = default;
  }
endgroup

covergroup nreset_d; //checking duv while not reset
  result_d:coverpoint intf.duv_result
  {
  bins result1 = {[                     0:(2**data_width-1)/4       ]};
  bins result2 = {[     (2**data_width)/4:((2**data_width)/2)-1     ]};
  bins result3 = {[     (2**data_width)/2:(((2**data_width)*3)/4)-1 ]};
  bins result4 = {[ ((2**data_width)*3)/4:(2**data_width)-1         ]};
  wildcard bins odd_data  = {16'h ???1};
  wildcard bins even_data = {16'h ???0};
  ignore_bins datax = {'bx};
  bins others = default;
  }
  valid_d:coverpoint intf.duv_valid
  {
  bins valid = {0,1};
  }
  ready_d:coverpoint intf.duv_ready
  {
  bins ready = {0,1};
  }
//xlat_table of design
    xlat_table0:coverpoint top.duv.xlat_table[0]
    {
    bins xlat_table0 = {[0:2**xlat_data_width-1]};
    bins xlat_tableothers = default;
    }
    xlat_table_64:coverpoint top.duv.xlat_table[xlat_size/4]
    {
    bins xlat_table64 = {[0:2**xlat_data_width-1]};
    bins xlat_tableothers = default;
    }
    xlat_table_128:coverpoint top.duv.xlat_table[xlat_size/2]
    {
    bins xlat_table128 = {[0:2**xlat_data_width-1]};
    bins xlat_tableothers = default;
    }
    xlat_table_255:coverpoint top.duv.xlat_table[xlat_size-1]
    {
    bins xlat_table255 = {[0:2**xlat_data_width-1]};
    bins xlat_tableothers = default;
    }
    pointer:coverpoint top.duv.xlat_pointer
    {
    bins xlat_pointer1 = {[               0:(xlat_size/4)-1   ]};
    bins xlat_pointer2 = {[     xlat_size/4:(xlat_size/2)-1   ]};
    bins xlat_pointer3 = {[     xlat_size/2:(3*xlat_size/4)-1 ]};
    bins xlat_pointer4 = {[ (3*xlat_size/4):xlat_size-1       ]};
    bins xlat_pointer_others = default;
    }
    key0:coverpoint top.duv.keys[0] //all the keys in EPW22 processor
    {
    bins key0_bin = {0};
    ignore_bins key0_other = {[1:2**key_width-1]};
    bins key_others = default;
    }
    key1:coverpoint top.duv.keys[1]
    {
    bins key1_ones = {2**key_width-1};
    ignore_bins key1_zero = {0};
    ignore_bins key1_other = {[2:2**key_width-1]};
    bins key_others = default;
    }
    key2:coverpoint top.duv.keys[2]
    {
    bins key2_bin = {[0:2**key_width-1]};
    bins key_others = default;
    }
    key3:coverpoint top.duv.keys[3]
    {
    bins key3_bin = {[0:2**key_width-1]};
    bins key_others = default;
    }
    key4:coverpoint top.duv.keys[4]
    {
    bins key4_bin = {[0:2**key_width-1]};
    bins key_others = default;
    }
    key5:coverpoint top.duv.keys[5]
    {
    bins key5_bin = {[0:2**key_width-1]};
    bins key_others = default;
    }
    key6:coverpoint top.duv.keys[6]
    {
    bins key6_bin = {[0:2**key_width-1]};
    bins key_others = default;
    }
    key7:coverpoint top.duv.keys[7]
    {
    bins key7_bin = {[0:2**key_width-1]};
    bins key_others = default;
    }
    OP_all:coverpoint intf.op //input operation
    {
    bins op_bin[] = {[0:(2**op_width)-1]};   //covers intf.op values from 0 to 15
    bins op0_1 = (4'b0 => 4'b1);
    bins others = default; //everything else not covered in previous bin
    wildcard bins odd_op  = {4'b ???1};
    wildcard bins even_op = {4'b ???0};
    ignore_bins  opx = {'bx};
    }
    c_op_key0: cross OP_all, key0; //cross coverage between all operations and keys
    c_op_key1: cross OP_all, key1;
    c_op_key2: cross OP_all, key2;
    c_op_key3: cross OP_all, key3;
    c_op_key4: cross OP_all, key4;
    c_op_key5: cross OP_all, key5;
    c_op_key6: cross OP_all, key6;
    c_op_key7: cross OP_all, key7;

    t_op_start: cross OP_all, xlat_table_64; //cross coverage between all operations and xlat_table
    t_op_xlat_64: cross OP_all, xlat_table_128;
    t_op_xlat128: cross OP_all, xlat_table_255;

endgroup

virtual EPW22_if intf;

  function new( virtual EPW22_if  bus);//creating new object and passing the BFM
      internal_r      = new();
      xtable    = new();
      reset_r   = new();
      reset_d   = new();
      nreset_r  = new();
      nreset_d  = new();
      intf      = bus;
  endfunction:new

  task execute();//sampling covergroups during negedge of clock
      forever begin:sampling
          @(negedge intf.clk);
            if(intf.reset)begin
              reset_r.sample();
              reset_d.sample();
            end
            internal_r.sample();
            xtable.sample();
            nreset_r.sample();
            nreset_d.sample();
      end:sampling
  endtask
endclass
