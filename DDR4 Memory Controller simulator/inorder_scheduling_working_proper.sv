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
  int fd, readfile, t_n, op, address, process_time, temp, t_q[$], op_q[$], intime_q[$], outime_q[$], request_flag, start_operation, j, n_mem_ref, cycle, m, delay, prev_req_time = 0;
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
                  if(get_input())       request_flag=1;
              end

            	if(request_flag)
              begin:push
            				if( t_q.size()==0 && counter < t_n)
              					counter = t_n;
                    if(counter >= t_n)
                    begin:push_operation
                       intime_q.push_back(counter);  t_q.push_back(t_n); op_q.push_back(op); add_q.push_back(add_map);
                       temp = outime_q[(intime_q.size()-2)];
                       if(outime_q.size() == 0) outime_q.push_back((intime_q[intime_q.size()-1]) + 100);
                       else                     outime_q.push_back(temp + 100);
                       request_flag = 0;
                       `ifdef DEBUG
                        $display("in     %p\nout    %p", intime_q, outime_q);
                        $display("push %0d %0d %0h @ counter=%0d, size=%0d, time=%0d,  op=%0d,  add=%h,\nt_q   =%p,\nop_q  =%p\n",t_n, op, add_map, counter, t_q.size(), t_n,     op,    add_map,   t_q,    op_q);
                        print_addq();
                        `endif
                     end:push_operation
                end:push

          end:size

      			   if((counter == outime_q[0]) && (t_q.size() != 0))
               begin:pop_operation
                 `ifdef DEBUG
                  $display("\nin     %p\nout    %p", intime_q, outime_q);
                  $display("pop  @ counter=%0d, size=%0d, time=%0d, op=%0d, add=%h,\nt_q   =%p,\nop_q  =%p\n", counter ,t_q.size(),t_n, op, add_map, t_q, op_q);
                  t_q.pop_front(); op_q.pop_front(); add_q.pop_front(); intime_q.pop_front();
                  outime_q.pop_front();
                  print_addq();
                  print_b_bg_r_c();
                  `endif
                end:pop_operation

         end:loop
	   $fclose(fd);
     $stop;
end:initial_begin

  task print_b_bg_r_c();
    $display("Row=%0d, Hcolumn=%0d, Bank=%0d, Bank group=%0d, L column=%0d\n", add_map[31:18],add_map[17:10],add_map[9:8],add_map[7:6],add_map[5:3]);
  endtask
endmodule
