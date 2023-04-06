<<<<<<< HEAD
// try.sv - file for checkpoint 4
//
//collaborator :	PRADEEP GOVINDAN
// Date:	24-NOV-2021
//
// Description:
// ------------
//COMMANDS
// vlog +define+DEBUG try.sv - compile
// vsim -gui work.try +Trace=trace.txt - simulate
// run-all - run
// quit -sim - quit simulatoin
//
//////////////////////////////////////////////////////////////////////
//tried and failed to implement bank parallelism and open page policy unable to compute pop time
import mc_defs::*; //importing package  definitions
timeunit 1ns; timeprecision 100ps;// `timescale 1ns/100ps
module try();
  bit clk;
  longint unsigned counter;//counter to count cpu ticks 3.2GHz frequency processor
    always #1 clk = ~clk; //time period 2
    file_read f1(.clk(clk));
endmodule

module file_read(input bit clk );
  int fd, readfile, t_n, op, address, process_time, t_q[$], op_q[$], intime_q[$], outime_q[$], request_flag, start_operation, j, n_mem_ref, cycle, m, delay, prev_req_time = 0;
  bit [31:0]add_map, add_q[$];

  longint unsigned counter;
  string file_name;

  task openFile();
    fd = $fopen(file_name, "r");
    if(fd)         $display("reading successful");
    else           $display("reading failed");
  endtask

  function int get_input();
    if($fscanf(fd, "%0d %0d %H", t_n, op, address)==3)
    begin//reading the input from file and checking whether all 3 inputs are there
      add_map = '0;
      add_map = 32'(add_map ^ address);
      return 1;
    end
    else  return 0;
  endfunction

  task parserfilename();                                //task to change input file during run time
    if(!$value$plusargs("Trace=%s", file_name) )
    begin     //get the input file name
      $error("NO ip file");                                  // display error if there is no input file found
      $stop;
    end
  endtask

task print_addq();
  $write("add_q = {");
  foreach(add_q[j]) $write("%0h,", add_q[j]);
  $write("}\n");
endtask

initial
begin: initial_begin
      parserfilename(); //get input file name
  	  openFile();   //check able to open file or not
      $display("Reading %s file successfully", file_name);
      while( t_q.size() != 0 || !$feof(fd)  || request_flag)
      begin:loop
        counter += 1;
    		//$display("counter=%d",counter);
          if(t_q.size()<16)
          begin:size
              if(!request_flag)
              begin
                  if(get_input())
                  begin
                      request_flag=1;
                  end
              end

            	if(request_flag)
              begin:push
            				if( t_q.size()==0 && counter < t_n)
              					counter = t_n;
                    if(counter >= t_n)
                    begin:push_operation
                       intime_q.push_back(counter); t_q.push_back(t_n); op_q.push_back(op); add_q.push_back(add_map);
                       request_flag = 0;
                       op_mode(); //cal outtime
                       `ifdef DEBUG
                        // $display("in     %p\nout    %p", intime_q, outime_q);
                        // $display("push %0d %0d %0h @ counter=%0d, size=%0d, time=%0d,  op=%0d,  add=%h,\nt_q   =%p,\nop_q  =%p\n",t_n, op, add_map, counter, t_q.size(), t_n,     op,    add_map,   t_q,    op_q);
                        // print_addq();
                        `endif
                     end:push_operation
                end:push

          end:size

               // op_mode();
      			   if((counter == ) && (t_q.size() != 0))
               begin:pop_operation
                 `ifdef DEBUG
                  $display("\nin     %p\nout    %p", intime_q, outime_q);
                  // $display("pop  @ counter=%0d, size=%0d, time=%0d, op=%0d, add=%h,\nt_q   =%p,\nop_q  =%p\n", counter ,t_q.size(),t_n, op, add_map, t_q, op_q);
                  t_q.pop_front(); op_q.pop_front(); add_q.pop_front(); intime_q.pop_front(); outime_q.pop_front();
                  // print_addq();
                  print_b_bg_r_c();
                  `endif
                end:pop_operation
                // else wait_counter += 1;

         end:loop
	   $fclose(fd);
     $stop;
end:initial_begin

  task print_b_bg_r_c();
    $display("Row=%0d, Hcolumn=%0d, Bank=%0d, Bank group=%0d, L column=%0d\n", add_map[31:18],add_map[17:10],add_map[9:8],add_map[7:6],add_map[5:3]);
  endtask

function int delay_function(int y);
  case(y)
    0 : delay = tRP; //read after read
    1 : delay = (address[9:8] == op_q[op_q.size()-2])? tWTR_L : tWTR_S;
    2 : delay = tRP;
  endcase
  return delay;
endfunction

function int process_function(int x);
  case(x)
    0 : cycle = tRP  + tRCD + tCAS + tBURST + delay_function(op);
    1 : cycle = tCWD + tBURST;
    2 : cycle = tRP  + tRCD + tCAS + tBURST + delay_function(op);
  endcase
  return cycle;
endfunction

  task op_mode();
    int valid_bit[16], op_bit[16], processtime_bit[16], pending_bit[16];    //valid, op, process time, delay time, row, column
    bit row_bit[16], column_bit[16];
        foreach(valid_bit[m])
        begin:array_loop

            if(m == add_map[9:6] && valid_bit[m] == 0)
                begin:bank_select
                valid_bit[m]       = 1;
                op_bit[m]          = op;
                processtime_bit[m] = process_function(op);
                row_bit[m]         = add_map[31:18];
                column_bit[m]      = {add_map[17:10],add_map[5:3]};
                $display("op_bit       %0d, BG %0d, B %0d", op_bit[m], add_map[9:8], add_map[7:6]);
              end:bank_select
            else
            begin
                valid_bit[m]       = 0;
                if(op_q[m-1] == add_map[9:6]) pending_bit[m]     = 1;
            end

                     // $display("valid_bit    %0d", valid_bit[m]);
                     // $display("process_time %0d", processtime_bit[m]);
                     // $display("pending_bit  %0d", pending_bit[m]);
                     // $display("row_bit      %0b", row_bit[m]);
                     // $display("column_bit   %0b", column_bit[m]);
        end:array_loop


   // case(op)//op code queue first element is checked to find it is data read-0, data write-1, or instruction fetch 2
   //   0 : begin
   //         process_time = intime_q[op_q.size()-1] + delay + cycle; //76
   //         $display("Data read total: %0d start: %0d prev_req: %0d", process_time, intime_q[op_q.size()-1], outime_q[op_q.size()-2]);
   //       end
   //   1 : begin
   //         process_time = intime_q[op_q.size()-1] + delay + cycle + outime_q[op_q.size()-2]; //20
   //         $display("Data write %0d start: %0d prev_req: %0d", process_time, intime_q[op_q.size()-1], outime_q[op_q.size()-2]);
   //       end
   //   2 : begin
   //         process_time = intime_q[op_q.size()-1] + delay + cycle + outime_q[op_q.size()-2]; //76
   //         $display("Instruction fetch %0d start: %0d prev_req: %0d", process_time, intime_q[op_q.size()-1], outime_q[op_q.size()-2]);
   //       end
   //   default $display("idle");
   // endcase
   // n_mem_ref += 1;
   // outime_q.push_back(process_time);
   print_b_bg_r_c();
   foreach(op_bit[m]) $write("%0d,", op_bit[m]);
endtask
endmodule
//open page policy - start time   - in time + delay after prev ref + tRRD_L/tRRD_S + increment if !first element in queue
//                   process time - data read / write / instruction fetch
//bank parallelism - start time   - in time + delay after prev ref + tRRD_L/tRRD_S + start if no request at current clk
//                   process time - data read / write / instruction fetch
// How to tell which instructin should go first choose least intime

// case(add_map[9:6])
//   0  :  begin
//           arbiter[0][0] = 1; //valid bit
//           arbiter[0][1] = op;//bank group A bank 0
//           arbiter[0][2] = process_function(op); //process time
//           arbiter[0][3] = delay_function(op); //previous valud delay added
//           arbiter[0][4] = address[31:18]; //row
//           arbiter[0][5] = {address[17:10], address[5:3]}; //column
//         end
//   1  :  begin
//           arbiter[0][0] = 1; //valid bit
//           arbiter[0][1] = op;//bank group A bank 0
//           arbiter[0][2] = process_function(op); //process time
//           arbiter[0][3] = delay_function(op); //previous valud delay added
//           arbiter[0][4] = address[31:18]; //row
//           arbiter[0][5] = {address[17:10], address[5:3]}; //column
//         end
//   2  :  begin
//           arbiter[0][0] = 1; //valid bit
//           arbiter[0][1] = op;//bank group A bank 0
//           arbiter[0][2] = process_function(op); //process time
//           arbiter[0][3] = delay_function(op); //previous valud delay added
//           arbiter[0][4] = address[31:18]; //row
//           arbiter[0][5] = {address[17:10], address[5:3]}; //column
//         end
//   3  :  begin
//           arbiter[3][1] = op;//bank group A bank 3
//           arbiter[3][0] = 1; //valid bit
//         end
//   4  : begin
//           arbiter[4][1] = op;//bank group B bank 0
//           arbiter[4][0] = 1; //valid bit
//        end
//   5  : begin
//           arbiter[5][1] = op;//bank group B bank 1
//           arbiter[5][0] = 1; //valid bit
//        end
//   6  : begin
//           arbiter[6][1] = op;//bank group B bank 2
//           arbiter[6][0] = 1; //valid bit
//         end
//   7  : begin
//           arbiter[7][1] = op;//bank group B bank 3
//           arbiter[7][0] = 1; //valid bit
//         end
//   8  : begin
//          arbiter[8][1] = op;//bank group C bank 0
//          arbiter[8][0] = 1; //valid bit
//        end
//   9  : begin
  //          arbiter[9][1] = op;//bank group C bank 1
  //          arbiter[9][0] = 1; //valid bit
//        end
//   10 : begin
  //          arbiter[10][1] = op;//bank group C bank 2
  //          arbiter[10][0] = 1; //valid bit
//        end
//   11 : begin
  //          arbiter[11][1] = op;//bank group C bank 3
  //          arbiter[11][0] = 1; //valid bit
//        end
//   12 : begin
  //          arbiter[12][1] = op;//bank group D bank 0
  //          arbiter[12][0] = 1; //valid bit
//        end
//   13 : begin
  //          arbiter[13][1] = op;//bank group D bank 1
  //          arbiter[13][0] = 1; //valid bit
//        end
//   14 : begin
  //          arbiter[14][1] = op;//bank group D bank 2
  //          arbiter[14][0] = 1; //valid bit
//        end
//   15 : begin
  //          arbiter[15][1] = op;//bank group D bank 3
  //          arbiter[15][0] = 1; //valid bit
//        end
// endcase
// foreach(arbiter[m]) $display("arbiter %0d: %0d", m, arbiter[m][0]);
//     if(address[7:6]   == add_map[7:6])
//     begin:same_bankgroup
  //          $display("same bankgroup");//find same or diff     bank group
  //          if(op == (op_q.size()-2) == 0) cycle = tRRD_L;//read after read
//     end:same_bankgroup
//     else
//     begin:diff_bankgroup
  //          $display("diff bankgroup");
  //          if(op == (op_q.size()-2) == 0) cycle = tRRD_S;//read after read
//     end:diff_bankgroup
//
//     if(address[9:8]   == add_map[9:8])
//     begin
  //          $display("same bank");     //find same or diff     bank
  //          if(address[31:18] == add_map[31:18])
  //          begin
    //            $display("same row");      //find same or diff row - PAGE HIT
    //            cycle += tCAS + tBURST;              //give only read command
  //          end
  //          else
  //          begin
    //            $display("diff row");    //PAGE MISS
    //            cycle += tRP + tRCD + tCAS + tBURST; //
  //          end
//     end
//     else
//     begin
  //       $display("diff bank");
//     end
//
//     if(address[17:10] == add_map[17:10]) $display("same Hcolumn");  //find same or diff Hcolumn
//     else $display("diff Hcolumn");
//     if(address[5:3]   == add_map[5:3])   $display("same Lcolumn");  //find same or diff     Lcolumn
//     else $display("diff Lcolumn");
//case()
// endcase
=======
// try.sv - file for checkpoint 4
//
//collaborator :	PRADEEP GOVINDAN
//collaborator :  SAKET
//collaborator :  AVANTI
//collaborator :  DIVYA
// Date:	24-NOV-2021
//
// Description:
// ------------
//COMMANDS
// vlog +define+DEBUG try.sv - compile
// vsim -gui work.try +Trace=trace.txt - simulate
// run-all - run
// quit -sim - quit simulatoin
//
//////////////////////////////////////////////////////////////////////
//
import mc_defs::*; //importing package  definitions
timeunit 1ns; timeprecision 100ps;// `timescale 1ns/100ps
module try();
  bit clk;
  longint unsigned counter;//counter to count cpu ticks 3.2GHz frequency processor
    always #1 clk = ~clk; //time period 2
    file_read f1(.clk(clk));
endmodule

module file_read(input bit clk );
  int fd, readfile, t_n, op, address, process_time, t_q[$], op_q[$], intime_q[$], outime_q[$], request_flag, start_operation, j, n_mem_ref, cycle, m, delay, prev_req_time = 0;
  bit [31:0]add_map, add_q[$];
  longint unsigned counter;
  string file_name;

  task openFile();
    fd = $fopen(file_name, "r");
    if(fd)         $display("reading successful");
    else           $display("reading failed");
  endtask

  function int get_input();
    if($fscanf(fd, "%0d %0d %H", t_n, op, address)==3)
    begin//reading the input from file and checking whether all 3 inputs are there
      add_map = '0;
      add_map = 32'(add_map ^ address);
      return 1;
    end
    else  return 0;
  endfunction

  task parserfilename();                                //task to change input file during run time
    if(!$value$plusargs("Trace=%s", file_name) )
    begin     //get the input file name
      $error("NO ip file");                                  // display error if there is no input file found
      $stop;
    end
  endtask

task print_addq();
  $write("add_q = {");
  foreach(add_q[j]) $write("%0h,", add_q[j]);
  $write("}\n");
endtask

initial
begin: initial_begin
      parserfilename(); //get input file name
  	  openFile();   //check able to open file or not
      $display("Reading %s file successfully", file_name);
      while( t_q.size() != 0 || !$feof(fd)  || request_flag)
      begin:loop
        counter += 1;
    		//$display("counter=%d",counter);
          if(t_q.size()<16)
          begin:size
              if(!request_flag)
              begin
                  if(get_input())
                  begin
                      request_flag=1;
                  end
              end

            	if(request_flag)
              begin:push
            				if( t_q.size()==0 && counter < t_n)
              					counter = t_n;
                    if(counter >= t_n)
                    begin:push_operation
                       intime_q.push_back(counter); t_q.push_back(t_n); op_q.push_back(op); add_q.push_back(add_map);
                       request_flag = 0;
                       op_mode(); //cal outtime
                       `ifdef DEBUG
                        $display("in     %p\nout    %p", intime_q, outime_q);
                        $display("push %0d %0d %0h @ counter=%0d, size=%0d, time=%0d,  op=%0d,  add=%h,\nt_q   =%p,\nop_q  =%p\n",t_n, op, add_map, counter, t_q.size(), t_n,     op,    add_map,   t_q,    op_q);
                        print_addq();
                        `endif
                     end:push_operation
                end:push

          end:size

               // op_mode();
      			   if((counter == outime_q[0]) && (t_q.size() != 0))
               begin:pop_operation
                 `ifdef DEBUG
                  $display("\nin     %p\nout    %p", intime_q, outime_q);
                  $display("pop %0d %0d %0h @ counter=%0d, size=%0d, time=%0d, op=%0d, add=%h,\nt_q   =%p,\nop_q  =%p\n",
                  t_q.pop_front(), op_q.pop_front(), add_q.pop_front(), counter ,t_q.size(),t_n, op, add_map, t_q, op_q);
                  print_addq();
                  print_b_bg_r_c();
                  `endif
                  intime_q.pop_front();
                  outime_q.pop_front();

                end:pop_operation
                // else wait_counter += 1;

         end:loop
	   $fclose(fd);
     $stop;
end:initial_begin

function int process_function(int x);
  case(x)
    0 : cycle = tRP  + tRCD + tCAS + tBURST + delay_function(op);
    1 : cycle = tCWD + tBURST;
    2 : cycle = tRP  + tRCD + tCAS + tBURST + delay_function(op);
  endcase
  return cycle;
endfunction

function int delay_function(int y);
    case(y)
      0 : delay = tRP; //read after read
      1 : delay = (address[9:8] == op_q[op_q.size()-1])? tWTR_L : tWTR_S;
      2 : delay = tRP;
    endcase
    return delay;
endfunction

  task op_mode();
    int arbiter[16][6] ;    //valid, op, process time, delay time, row, column
        //
        // case(add_map[9:6])
        //   0  :  begin
        //           arbiter[0][0] = 1; //valid bit
        //           arbiter[0][1] = op;//bank group A bank 0
        //           arbiter[0][2] = process_function(op); //process time
        //           arbiter[0][3] = delay_function(op); //previous valud delay added
        //           arbiter[0][4] = address[31:18]; //row
        //           arbiter[0][5] = {address[17:10], address[5:3]}; //column
        //         end
        //   1  :  begin
        //           arbiter[0][0] = 1; //valid bit
        //           arbiter[0][1] = op;//bank group A bank 0
        //           arbiter[0][2] = process_function(op); //process time
        //           arbiter[0][3] = delay_function(op); //previous valud delay added
        //           arbiter[0][4] = address[31:18]; //row
        //           arbiter[0][5] = {address[17:10], address[5:3]}; //column
        //         end
        //   2  :  begin
        //           arbiter[0][0] = 1; //valid bit
        //           arbiter[0][1] = op;//bank group A bank 0
        //           arbiter[0][2] = process_function(op); //process time
        //           arbiter[0][3] = delay_function(op); //previous valud delay added
        //           arbiter[0][4] = address[31:18]; //row
        //           arbiter[0][5] = {address[17:10], address[5:3]}; //column
        //         end
        //   3  :  begin
        //           arbiter[3][1] = op;//bank group A bank 3
        //           arbiter[3][0] = 1; //valid bit
        //         end
        //   4  : begin
        //           arbiter[4][1] = op;//bank group B bank 0
        //           arbiter[4][0] = 1; //valid bit
        //        end
        //   5  : begin
        //           arbiter[5][1] = op;//bank group B bank 1
        //           arbiter[5][0] = 1; //valid bit
        //        end
        //   6  : begin
        //           arbiter[6][1] = op;//bank group B bank 2
        //           arbiter[6][0] = 1; //valid bit
        //         end
        //   7  : begin
        //           arbiter[7][1] = op;//bank group B bank 3
        //           arbiter[7][0] = 1; //valid bit
        //         end
        //   8  : begin
        //          arbiter[8][1] = op;//bank group C bank 0
        //          arbiter[8][0] = 1; //valid bit
        //        end
        //   9  : begin
        //          arbiter[9][1] = op;//bank group C bank 1
        //          arbiter[9][0] = 1; //valid bit
        //        end
        //   10 : begin
        //          arbiter[10][1] = op;//bank group C bank 2
        //          arbiter[10][0] = 1; //valid bit
        //        end
        //   11 : begin
        //          arbiter[11][1] = op;//bank group C bank 3
        //          arbiter[11][0] = 1; //valid bit
        //        end
        //   12 : begin
        //          arbiter[12][1] = op;//bank group D bank 0
        //          arbiter[12][0] = 1; //valid bit
        //        end
        //   13 : begin
        //          arbiter[13][1] = op;//bank group D bank 1
        //          arbiter[13][0] = 1; //valid bit
        //        end
        //   14 : begin
        //          arbiter[14][1] = op;//bank group D bank 2
        //          arbiter[14][0] = 1; //valid bit
        //        end
        //   15 : begin
        //          arbiter[15][1] = op;//bank group D bank 3
        //          arbiter[15][0] = 1; //valid bit
        //        end
        // endcase
        // foreach(arbiter[m]) $display("arbiter %0d: %0d", m, arbiter[m][0]);
    //     if(address[7:6]   == add_map[7:6])
    //     begin:same_bankgroup
    //          $display("same bankgroup");//find same or diff     bank group
    //          if(op == (op_q.size()-2) == 0) cycle = tRRD_L;//read after read
    //     end:same_bankgroup
    //     else
    //     begin:diff_bankgroup
    //          $display("diff bankgroup");
    //          if(op == (op_q.size()-2) == 0) cycle = tRRD_S;//read after read
    //     end:diff_bankgroup
    //
    //     if(address[9:8]   == add_map[9:8])
    //     begin
    //          $display("same bank");     //find same or diff     bank
    //          if(address[31:18] == add_map[31:18])
    //          begin
    //            $display("same row");      //find same or diff row - PAGE HIT
    //            cycle += tCAS + tBURST;              //give only read command
    //          end
    //          else
    //          begin
    //            $display("diff row");    //PAGE MISS
    //            cycle += tRP + tRCD + tCAS + tBURST; //
    //          end
    //     end
    //     else
    //     begin
    //       $display("diff bank");
    //     end
    //
    //     if(address[17:10] == add_map[17:10]) $display("same Hcolumn");  //find same or diff Hcolumn
    //     else $display("diff Hcolumn");
    //     if(address[5:3]   == add_map[5:3])   $display("same Lcolumn");  //find same or diff     Lcolumn
    //     else $display("diff Lcolumn");
    //case()
    // endcase
   case(op)//op code queue first element is checked to find it is data read-0, data write-1, or instruction fetch 2
     0 : begin
           process_time = intime_q[op_q.size()-1] + delay + cycle + outime_q[op_q.size()-2]; //76
           $display("Data read total: %0d start: %0d prev_req: %0d", process_time, intime_q[op_q.size()-1], outime_q[op_q.size()-2]);
         end
     1 : begin
           process_time = intime_q[op_q.size()-1] + delay + cycle + outime_q[op_q.size()-2]; //20
           $display("Data write %0d start: %0d prev_req: %0d", process_time, intime_q[op_q.size()-1], outime_q[op_q.size()-2]);
         end
     2 : begin
           process_time = intime_q[op_q.size()-1] + delay + cycle + outime_q[op_q.size()-2]; //76
           $display("Instruction fetch %0d start: %0d prev_req: %0d", process_time, intime_q[op_q.size()-1], outime_q[op_q.size()-2]);
         end
     default $display("idle");
   endcase
   n_mem_ref += 1;
   outime_q.push_back(process_time);
   print_b_bg_r_c();
 endtask

  task print_b_bg_r_c();
    $display("Row=%0d, Hcolumn=%0d, Bank=%0d, Bank group=%0d, L column=%0d\n", add_map[31:18],add_map[17:10],add_map[9:8],add_map[7:6],add_map[5:3]);
  endtask
endmodule
//open page policy - start time   - in time + delay after prev ref + tRRD_L/tRRD_S + increment if !first element in queue
//                   process time - data read / write / instruction fetch
//bank parallelism - start time   - in time + delay after prev ref + tRRD_L/tRRD_S + start if no request at current clk
//                   process time - data read / write / instruction fetch
// How to tell which instructin should go first choose least intime
>>>>>>> ff1a98ff3280ca2d796851a79a75594add5fa4c8
