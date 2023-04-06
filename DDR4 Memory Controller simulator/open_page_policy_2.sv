import controller_defs::*; //importing package  definitions
module open_page_policy(
  input int t_q[$], op_q[$], intime_q[$],
  input bit [31:0] add_q[$],
  input longint counter,
  input bit clk
  );
  bit [31:0] add_map, [11:0] r_c, [9:8]b_g_r, [9:8]b_g_c;
  longint refresh_cycle;
  enum{PRE, ACT, READ, WRITE, BURST, REF, WAIT} st, ns;
  always@(counter)
  begin:always_ends
    $display("open page policy: %0d\n time q = %p", counter, t_q);
    add_map = '0;
    add_map = 32'(add_map^add_q[1]);
    case(op_q[1])
    0 : data_read();
    1 : data_write();
    2 : i_fetch();
    default: $display("no operations");
    endcase
    $stop;
  end:always_ends
display(s, counter, bank, bank_group, row_column);
    $display("%s counter: %0d <%0d> <%0d> <%0d>", s, counter, bank, bank_group, row_column);
function data_read();
  if(b_g_r == add_map[9:8]) 
  wait_nxt_inst = tRRD_L;
  else                  
  wait_nxt_inst = tRRD_S;

        if(r_c == add_map[31:18])
        begin
    display("READ", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
        ns <= BURST;
		st <= ns;
      case(st)
        PRE: begin
                display("PRE", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
                ns <= ACT;
              end
        ACT: begin
              wait(counter == tRP + intime_q[1]) ns <= READ;
                display("ACT", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
              end       
        READ: begin
                wait(counter == tRCD + intime_q[1]) ns <= BURST;
                display("READ", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
              end
        BURST: begin
                wait(counter == 4 + intime_q[1]) ns <= PRE;
                display("BURST", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
               end
          endcase
          r_c = add_map[31:18];
endfunction:data_read

function data_write();
  if(b_g_c == add_map[9:8]) 
  wait_nxt_inst = tCCD_L;
  else           
  wait_nxt_inst = tCCD_S;
        if(r_c == add_map[31:18])
        begin
          display("WRITE", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
          ns <= BURST; 
        end
     st <= ns;
        case(st)
        PRE : begin
                display("PRE", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
                ns <= ACT;
              end
        ACT: begin
                wait(counter == tRP + intime_q[1])
				ns <= WRITE;
                display("ACT", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
              end           
        WRITE: begin
                wait(counter == tRCD + intime_q[1]) ns <= BURST;
                display("WRITE", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
               end
        BURST: begin
                wait(counter == 4 + intime_q[1]) ns <= PRE;
              end
          endcase
          r_c = add_map[31:18];
endfunction:data_write

function i_fetch();
  if(r_c == add_map[31:18])
  begin
    display("READ", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
    ns <= BURST;
  end
 st <= ns;
   case(st)
  PRE : begin
          display("PRE", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
          ns <= ACT;
        end
  ACT : begin
          wait(counter == tRP + intime_q[1]) 
		  ns <= READ;
          display("ACT", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
        end           
  READ : begin
          wait(counter == tRCD + intime_q[1]) 
		  ns <= BURST;
          display("READ", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
         end
  BURST : begin
          wait(counter == 4 + intime_q[1]) 
		  ns <= PRE;
          display("BURST", counter, add_map[7:6], add_map[9:8], add_map[31:18]);
          end
    endcase
		r_c = add_map[31:18];
endfunction:i_fetch
 /*if(PRECHARGE)
 t=tRP;
 else if (activate)
 t=tRP+ tRCD;*/
endmodule:open_page_policy

