//collaborator :	PRADEEP GOVINDAN
// Date:	24-NOV-2021
//
// Description:
// ------------
//COMMANDS
// vlog inorder_scheduling.sv +define+DEBUG
// vsim work.try +Trace=trace.txt
// run-all
// quit -sim
//
//////////////////////////////////////////////////////////////////////
//tried and failed to implement bank parallelism and open page policy unable to compute pop time

package mc_defs;
//values expressed in CPU clock ticks
      parameter	tRP      = 24; //time between Pre and Act , time to precharge
      parameter	tRCD     = 24; //time between Act and Read
      parameter	tCAS     = 24; //time between read and data burst CL
      //
      parameter	tRAS     = 52; //time for next precharge
      parameter	tRC      = 76; //time for entire read cycle
      //
      parameter	tCWD     = 20; //Write burst operation CAS latency CWL - after write command data in
      parameter	tRTP     = 12; // WR (WRITE recovery)/RTP (READ-to-PRECHARGE
      //Bank to bank delays
      parameter	tRRD_L   = 6; //row 2 row delay inside the same bank group
      parameter	tRRD_S   = 4; //row 2 row delay between 2 different bank groups
      parameter	tCCD_L   = 8; //column 2 column delay inside the same bank group
      parameter	tCCD_S   = 4; //column 2 column delay between 2 different bank groups
      parameter tWR      = 20; // read to next precharge - write recovery
      // covry time time before which precharge can be given
      parameter	tWTR_L   = 12;//write-2-read same bank
      parameter	tWTR_S   = 4; //write-2-read different bank
      parameter	tBURST   = 4; //burst size
      //values experssed in seconds
      parameter	tRFC     =  350000; //expressed in pico seconds - CAS after RAS for refresh - ACT then PRE
      parameter	REFI     = 7800000; //expressed in pico 7.8micro seconds

endpackage: mc_defs

import mc_defs::*; //importing package  definitions
timeunit 1ns; timeprecision 100ps;// `timescale 1ns/100ps
module MC();
  bit clk;
  longint unsigned counter;//counter to count cpu ticks 3.2GHz frequency processor
    always #1 clk = ~clk; //time period 2
    file_read f1(.clk(clk));
endmodule

module file_read(input bit clk );
  int fd, readfile, t_n, op, address, process_time, temp, t_q[$], op_q[$], intime_q[$], outime_q[$], request_flag, start_operation, j, n_mem_ref, cycle, m, delay, prev_req_time = 0;
  bit [31:0]add_map, add_q[$];

  longint unsigned counter, gcounter=1;
  string file_name;

  task openFile();
    fd = $fopen(file_name, "r");
    if(fd)
    begin
      `ifdef DEBUG
       $display("reading successful");
       `endif
     end
    else
    begin
      `ifdef DEBUG
      $display("reading failed");
      `endif
    end
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
    `ifdef DEBUG
      $error("NO ip file");                                  // display error if there is no input file found
    `endif
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
    		//$display("counter=%d",counter);
          if(t_q.size()<16)
          begin:size
              if(!request_flag)
              begin
                  if(get_input())       request_flag=1;
              end

            	if(request_flag)
              begin:push
            				if( t_q.size()==0 && counter < t_n)
              					counter = t_n; //if queue is empty then advance simulation time
                    if(counter >= t_n)
                    begin:push_operation
                       intime_q.push_back(counter);  t_q.push_back(t_n); op_q.push_back(op); add_q.push_back(add_map);
                       temp = outime_q[(intime_q.size()-2)];
                       if(outime_q.size() == 0) outime_q.push_back(intime_q[intime_q.size()-1] + cycle_time(op));
                       else                     outime_q.push_back(temp                        + cycle_time(op));
                       // $display("temp %0d %0d", temp, cycle_time(op));
                       request_flag = 0;
                       `ifdef DEBUG
                        $display("in     %p\nout    %p", intime_q, outime_q);
                        $display("push %0d %0d %0h @ counter=%0d, size=%0d, time=%0d,  op=%0d,  add=%h,\nop_q  =%p\nt_q   =%p\n",t_n, op, add_map, counter, t_q.size(), t_n,     op,    add_map,   op_q,  t_q);
                        print_addq();
                        `endif
                     end:push_operation
                end:push

          end:size

               output_format();

      			   if((counter == outime_q[0]) && (t_q.size() != 0))
               begin:pop_operation
                 t_q.pop_front(); op_q.pop_front(); add_q.pop_front(); intime_q.pop_front();
                 `ifdef DEBUG
                  $display("\nin     %p\nout    %p", intime_q, outime_q);
                  $display("pop  @ counter=%0d, size=%0d, time=%0d, op=%0d, add=%h,\nt_q   =%p,\nop_q  =%p\n", counter ,t_q.size(),t_n, op, add_map, t_q, op_q);
                  print_b_bg_r_c();
                  print_addq();
                  `endif
                  outime_q.pop_front();
                end:pop_operation

                counter += 1;
                gcounter += 1;
         end:loop
	   $fclose(fd);
     $stop;
end:initial_begin

  task print_b_bg_r_c();
    $display("Row=%0d, Hcolumn=%0d, Bank=%0d, Bank group=%0d, L column=%0d\n", add_map[31:18],add_map[17:10],add_map[9:8],add_map[7:6],add_map[5:3]);
  endtask

task output_format();

  if(op_q [0] == 1 && intime_q.size() != 0)
  begin:data_write
    if     (counter == (outime_q[0] - tWR))                               $display("%0d WR %0d %0d %0h",  gcounter, add_map[9:8], add_map[7:6], {add_map[17:10],add_map[5:3]});
  end:data_write

  else
  begin:data_read_instruction_fetch
    if     (counter == (outime_q[0] - tRC+1))                             $display("%0d PRE %0d %0d",     (gcounter-1), add_map[9:8], add_map[7:6]); //76
    // else                                                                  $display("counter %0d %0d",     gcounter,  (outime_q[0] - tBURST - tCAS - tRCD - tRP));
    if     (counter == (outime_q[0] - tRAS))                              $display("%0d ACT %0d %0d %0h", gcounter, add_map[9:8], add_map[7:6], add_map[31:18]);//52
    if     (counter == (outime_q[0] - tCAS - tBURST))                              $display("%0d RD %0d %0d %0h",  gcounter, add_map[9:8], add_map[7:6], {add_map[17:10],add_map[5:3]});//28
  end:data_read_instruction_fetch

endtask

  function int cycle_time(int op);
    case(op)
      0 : process_time = tRC; //76
      1 : process_time = tWR;            //24
      2 : process_time = tRC; //76
    endcase
    return process_time;
  endfunction

endmodule
