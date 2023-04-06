// DESCRIPTION:
// This is the parent class of the generator and has all the task
// and functions used by the generator class
//
//
import def::*; //importing package definitions
virtual class generator_parent;

transactor tran_h; //Transactor class handle

   virtual EPW22_if bfm; //creating the BFM as virtual

   function new (virtual EPW22_if bus); //bfm gets bus
     bfm = bus;
   endfunction : new

  task  input_0();//Deterministic_input1
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
  endtask

  task Individual_ops(operation_t change);//Task to generate individual operations from generator
    tran_h = new();
    assert(tran_h.randomize());
    bfm.op  = change;
      @(posedge bfm.clk)
        bfm.data <= tran_h.data1_set;
        bfm.tag = $urandom();
      @(posedge bfm.clk)
        bfm.data <= tran_h.data2_set;
  endtask

endclass
