// Collaborator : PRADEEP GOVINDAN 
//
// DESCRIPTION:
// Each input_# tasks defines a testing methodology.
// The remaining tasks execute the conditions needed
// actually stimulate the design

// module case_input(EPW22_if.primary bfm);
import def::*;
class gen_methods;

   virtual EPW22_if bfm;

   function new (virtual EPW22_if bus);
     bfm = bus;
   endfunction : new

  task input_0();
        #(PERIOD/2)bfm.data = 16'h1111; bfm.op = reset_op; bfm.tag = 3; bfm.reset = 0; // RESET OPERATION
        #(PERIOD) bfm.data = 16'h1111; bfm.op = reset_op; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h1111; bfm.op = reset_op; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h1111; bfm.op = reset_op; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h2222; bfm.op = store_dly; bfm.tag = 3; bfm.reset = 0; //STORE A IN SCHEDULE register
        #(PERIOD) bfm.data = 16'h1234; bfm.op = rot_left_out; bfm.tag = 3; bfm.reset = 0; //RESULT = ROTATE LEFT A, B
        #(PERIOD) bfm.data = 16'h0004; bfm.op = rot_left_out; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'hBBCC; bfm.op = rot_rght_out; bfm.tag = 3; bfm.reset = 0; //RESULT = ROTATE RIGHT A, B
        #(PERIOD) bfm.data = 16'h0008; bfm.op = rot_rght_out; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h1357; bfm.op = store_dly; bfm.tag = 3; bfm.reset = 0; //STORE A IN SCHEDULE REGISTER
        #(PERIOD) bfm.data = 16'h0003; bfm.op = xor_out; bfm.tag = 3; bfm.reset = 0; //RESULT = XOR REG[A], B
        #(PERIOD) bfm.data = 16'h000A; bfm.op = xor_out; bfm.tag = 1; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'hAAAA; bfm.op = no_op; bfm.tag = 2; bfm.reset = 0; //NO OPERATIONS
        #(PERIOD) bfm.data = 16'hBBBB; bfm.op = no_op; bfm.tag = 2; bfm.reset = 0; //NO OPERATIONS
        #(PERIOD) bfm.data = 16'hCCCC; bfm.op = no_op; bfm.tag = 2; bfm.reset = 0; //NO OPERATIONS
        #(PERIOD) bfm.data = 16'h0B0B; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0; //STORE A IN REG[B]
        #(PERIOD) bfm.data = 16'h0002; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'hA2B2; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0; //STORE A IN REG[B]
        #(PERIOD) bfm.data = 16'h0003; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'hB3C4; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0; //STORE A IN REG[B]
        #(PERIOD) bfm.data = 16'h0004; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h0203; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0; //STORE A IN REG[B]
        #(PERIOD) bfm.data = 16'h0005; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'hD6E7; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0; //STORE A IN REG[B]
        #(PERIOD) bfm.data = 16'h0006; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h000B; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0; //STORE A IN REG[B]
        #(PERIOD) bfm.data = 16'h0007; bfm.op = key_store; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h0002; bfm.op = key_store_rot_left; bfm.tag = 3; bfm.reset = 0; //reg[A]= RotateLeftreg[A], B
        #(PERIOD) bfm.data = 16'h0008; bfm.op = key_store_rot_left; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h0003; bfm.op = key_store_rot_rght; bfm.tag = 3; bfm.reset = 0; //reg[A]= RotateRIGHTreg[A], B
        #(PERIOD) bfm.data = 16'h000C; bfm.op = key_store_rot_rght; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h0004; bfm.op = key_store_xor; bfm.tag = 3; bfm.reset = 0; //reg[A] = XOR reg[A], B
        #(PERIOD) bfm.data = 16'h1010; bfm.op = key_store_xor; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h0005; bfm.op = store_tbl; bfm.tag = 3; bfm.reset = 0; //Store A and B into next tablelocations
        #(PERIOD) bfm.data = 16'hEFFE; bfm.op = store_tbl; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h0006; bfm.op = store_tbl; bfm.tag = 3; bfm.reset = 0; //Store A and B into next tablelocations
        #(PERIOD) bfm.data = 16'hCDAB; bfm.op = store_tbl; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'hB8C9; bfm.op = store_tbl; bfm.tag = 3; bfm.reset = 0; //Store A and B into next tablelocations
        #(PERIOD) bfm.data = 16'hC0D1; bfm.op = store_tbl; bfm.tag = 3; bfm.reset = 0;
        #(PERIOD) bfm.data = 16'h0005; bfm.op = tbl_out; bfm.tag = 3; bfm.reset = 0; //Result = table[ reg[A].high ], table[ reg[A].low ]
        #(PERIOD) bfm.data = 16'h0007; bfm.op = key_store_tbl; bfm.tag = 3; bfm.reset = 0; //reg[A] = table[ reg[A].high ], table[ reg[A].low ]
        #(PERIOD) bfm.data = 16'h0003; bfm.op = tbl_out; bfm.tag = 3; bfm.reset = 0; // Result = table[ reg[A].high ], table[ reg[A].low ]
        #(PERIOD) bfm.data = 16'h0002; bfm.op = no_op; bfm.tag = 3; bfm.reset = 0; //NO OPERATIONS
        #(PERIOD) bfm.data = 16'hFFFF; bfm.op = store_dly; bfm.tag = 1; bfm.reset = 0; //STORE A IN SCHEDULE register
        #(PERIOD) bfm.data = 16'hFFAA; bfm.op = no_op; bfm.tag = 1; bfm.reset = 0; //NO OPERATIONS
        // add more inputs to get coverage 100% and print op in txt document
  endtask

  task input_2();
        #(PERIOD*($urandom_range(0,7))) bfm.data = $urandom();
        #(PERIOD*($urandom_range(0,7))) bfm.tag  = $urandom();
        #(PERIOD*($urandom_range(0,7))) bfm.op   = $urandom();
  endtask

  task input_3();
			 bfm.tag = $urandom();
       bfm.op  = get_op();

       if(bfm.op == 4) repeat($urandom_range(100, 200))     #PERIOD bfm.data = $urandom(); //range 100
       else if(bfm.op > 7 && bfm.op < 15 || bfm.op == 3) op3_8_15();
       else                                                 #PERIOD bfm.data = $urandom();
     endtask

   task input_4();
       #PERIOD bfm.data = 16'h2030; bfm.op = store_dly; bfm.tag = 2; bfm.reset = 0;
       #PERIOD bfm.data = 16'hFEDA; bfm.op = xor_out;
       #PERIOD bfm.data = 16'h0004; bfm.op = rot_rght_out;
       #PERIOD bfm.data = 16'hAABB; bfm.op = reserved_7;
       #(PERIOD*7) bfm.data = 16'hD00D;
       #PERIOD bfm.op = key_store_tbl;
       #(PERIOD*4) bfm.op = key_store_tbl;
       #(PERIOD) bfm.data = 16'h5BB5;
       bfm.tag = 0;
       #(PERIOD*5) bfm.op = 1;
       #PERIOD bfm.data = 16'h4040;
       #PERIOD bfm.data = 16'h5000;
       #(PERIOD*3) bfm.reset = 1;
       #(PERIOD*2) bfm.reset = 0;
       #(PERIOD*10) bfm.data = 16'hFFF0; bfm.op = key_store_tbl;
       #(PERIOD*3) bfm.data = 16'h7800;
       #PERIOD bfm.data = 16'hAAAA; bfm.op = rot_rght_out;
       #PERIOD bfm.data = 16'h0001; bfm.op = reserved_6;
       #(PERIOD*4) bfm.data = 16'h0000; bfm.op = key_store_rot_left;
       #(PERIOD*3) bfm.data = 16'hAAAA; bfm.op = key_store_rot_rght;
       bfm.reset = 1;
   endtask

   task op3_8_15();
     bfm.data = $urandom_range(0,10);
     #PERIOD bfm.data = $urandom();

     if(bfm.op == 3)  begin:op
               bfm.data = $urandom(); //op =3
       #PERIOD bfm.data = $urandom_range(0,10);
     end:op
   endtask

  function operation_t get_op();
      bit [op_width:0] op_choice;
      op_choice = $urandom_range(0,32);
          case(op_choice)
          0: return no_op;
          1: return reset_op;
          2: return store_dly;
          3: return key_store;
          4: return store_tbl;
          5: return reserved_5;
          6: return reserved_6;
          7: return reserved_7;
          8: return rot_left_out;
          9: return rot_rght_out;
          10: return xor_out;
          11: return tbl_out;
          12: return key_store_rot_left;
          13: return key_store_rot_rght;
          14: return key_store_xor;
          15: return key_store_tbl;
          16: return key_store;
          17: return rot_left_out;
          18: return rot_rght_out;
          19: return tbl_out;
          20: return xor_out;
          21: return key_store;
          22: return rot_left_out;
          23: return rot_rght_out;
          24: return tbl_out;
          25: return xor_out;
          26: return key_store_xor;
          27: return key_store_tbl;
          28: return key_store_xor;
          29: return key_store_tbl;
          30: return rot_rght_out;
          31: return tbl_out;
          32: return rot_left_out;
          default: return no_op;
        endcase
  endfunction

  task no_op_ip();
      #(PERIOD) bfm.data = 16'h1111; bfm.op = no_op; bfm.tag = 3; bfm.reset = 0;
  endtask

  task reset_op_ip();
      #(PERIOD) bfm.data = 16'hFAFA; bfm.op = reset_op; bfm.tag = 1; bfm.reset = 0;
  endtask

  task store_dly_op_ip();
      #(PERIOD) bfm.data = 16'hFFFF; bfm.op = store_dly; bfm.tag = 2; bfm.reset = 0;
  endtask

  task store_tbl_op_ip();
      #(PERIOD) bfm.data = 16'hABCD; bfm.op = store_tbl; bfm.tag = 0; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h1234; bfm.op = store_tbl; bfm.tag = 0; bfm.reset = 0;
  endtask

  task rot_left_out_op_ip();
      #(PERIOD) bfm.data = 16'hFFFF; bfm.op = rot_left_out; bfm.tag = 3; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h000C; bfm.op = rot_left_out; bfm.tag = 3; bfm.reset = 0;
  endtask
  task rot_rght_out_op_ip();
      #(PERIOD) bfm.data = 16'hFFFF; bfm.op = rot_rght_out; bfm.tag = 2; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h000C; bfm.op = rot_rght_out; bfm.tag = 3; bfm.reset = 0;
  endtask
  task xor_out_op_ip();
      #(PERIOD) bfm.data = 16'h0011; bfm.op = xor_out; bfm.tag = 1; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h0AA1; bfm.op = xor_out; bfm.tag = 3; bfm.reset = 0;
  endtask

  task tbl_out_op_ip();
      #(PERIOD) bfm.data = 16'hFF11; bfm.op = tbl_out; bfm.tag = 1; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h0AA1; bfm.op = tbl_out; bfm.tag = 3; bfm.reset = 0;
  endtask

  task key_store_rot_left_op_ip();
      #(PERIOD) bfm.data = 16'hFF11; bfm.op = key_store_rot_left; bfm.tag = 1; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h0AA1; bfm.op = key_store_rot_left; bfm.tag = 3; bfm.reset = 0;
  endtask

  task key_store_rot_rght_op_ip();
      #(PERIOD) bfm.data = 16'hFF11; bfm.op = key_store_rot_rght; bfm.tag = 1; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h0AA1; bfm.op = key_store_rot_rght; bfm.tag = 3; bfm.reset = 0;
  endtask

  task key_store_xor_op_ip();
      #(PERIOD) bfm.data = 16'hFF11; bfm.op = key_store_xor; bfm.tag = 1; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h0AA1; bfm.op = key_store_xor; bfm.tag = 3; bfm.reset = 0;
  endtask

  task 	key_store_tbl_op_ip();
      #(PERIOD) bfm.data = 16'hFF11; bfm.op = 	key_store_tbl; bfm.tag = 1; bfm.reset = 0;
      #(PERIOD) bfm.data = 16'h0AA1; bfm.op = 	key_store_tbl; bfm.tag = 3; bfm.reset = 0;
  endtask
endclass
