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
//
//////////////////////////////////////////////////////////////////////
//
timeunit 1ns; timeprecision 100ps;
// `timescale 1ns/100ps
module try();
  bit clk;
  longint unsigned counter;//counter to count cpu ticks 3.2GHz frequency processor - 312.5ps
    always #1 clk = ~clk; //time period 2
    file_read f1(.clk(clk));
endmodule

module file_read(input bit clk );
  int fd, readfile, dq1[1], dq2[1], dq3[1], t, o, a, c, i;
  int t_q[$], op_q[$], intime_q[$], dq1[$], dq2[$], flag,request_flag, start_operation, j;
  bit [32:0]add_map, add_q[$], dq3[$];
  longint unsigned counter, pop_counter, gcounter=0;;
  string file_name;

  task openFile();
    fd = $fopen(file_name, "r");
    if(fd)         $display("reading successful");
    else           $display("reading failed");
  endtask

  function int get_input();
    repeat(4)
    begin:repeat_loop_4_times
        if($fscanf(fd, "%0d %0d %H", t, o, a)==3)
        begin//reading the input from file and checking whether all 3 inputs are there
          dq1.push_back(t); dq2.push_back(o); dq3.push_back(a);
          return 1;
        end
        else  return 0;
    end:repeat_loop_4_times
  endfunction

  task parserfilename();                                //task to change input file during run time
    if(!$value$plusargs("Trace=%s", file_name) )
    begin     //get the input file name
      $error("********************** NO input file ***********************");                                  // display error if there is no input file found
      $stop;
    end
  endtask

task print_addq();
  $write("add_q = {");
  foreach(add_q[j]) $write("%0h,", add_q[j]);
  $write("}\n");
endtask

task pushback(int c);
  i = 4;
  case(c)
    1 : foreach(dq1[i])
        begin
          intime_q.push_back(counter); t_q.push_back(dq1[i]); op_q.push_back(dq2[i]); add_q.push_back(dq3[i]);
        end
    2 : begin
        i -= 1;
          foreach(dq1[i])
          begin
            intime_q.push_back(counter); t_q.push_back(dq1[i]); op_q.push_back(dq2[i]); add_q.push_back(dq3[i]);
          end
        end
    3 : begin
        i -= 1;
          foreach(dq1[i])
          begin
            intime_q.push_back(counter); t_q.push_back(dq1[i]); op_q.push_back(dq2[i]); add_q.push_back(dq3[i]);
          end
        end
    4 : begin
        i -= 1;
        display(i);
          foreach(dq1[i])
          begin
            intime_q.push_back(counter); t_q.push_back(dq1[i]); op_q.push_back(dq2[i]); add_q.push_back(dq3[i]);
          end
        end
  endcase
endtask

function display (int d);
  $display("%0d", d);
endfunction

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
              begin:req_flag
            				if( t_q.size()==0 && counter < dq1[1])		counter = dq1[1];
                    if(counter >= dq1[1])
                    begin:push

                       if(dq1[0] == dq1[2] == dq1[3] == dq1[4]) c = 1;
                       else if(dq1[0] == dq1[2] == dq1[3])      c = 2;
                       else if(dq1[0] == dq1[2])                c = 3;
                       else if(dq1[0] != dq1[2])                c = 4;
                       pushback(c);

                       request_flag = 0;
                       `ifdef DEBUG
                        $display("G clock %0d", gcounter);
                        $display("in time %p", intime_q);
                        $display("\npush %0d %0d %0h @ counter=%0d, size=%0d\nt_q   =%p,\nop_q  =%p",dq1[1], dq2[1], dq3[1], counter, t_q.size(),  t_q,    op_q);
                        print_addq();
                        add_map = '0;
                        add_map = 32'(add_map ^ dq3[1]);
                        $display("Row=%0d, Hcolumn=%0d, Bank=%0d, Bank group=%0d, L column=%0d\n", add_map[32:18],add_map[17:10],add_map[9:8],add_map[7:6],add_map[5:3]);
                        `endif
                     end:push

                end:req_flag
                start_operation =1;

          end:size

    			if(start_operation)
          begin:start__operation

      			   if((counter==100+intime_q[0]) && (t_q.size() != 0))
               begin:pop_display
                 `ifdef DEBUG
                  $display("G clock %0d", gcounter);
                  $display("\npop %0d %0d %0h @ counter=%0d, size=%0d, time=%0d, op=%0d, add=%h,\nt_q=%p,\nop_q  =%p",
                  t_q.pop_front(), op_q.pop_front(), add_q.pop_front(), counter ,t_q.size(),dq1[1], dq2[1], add_map, t_q, op_q, add_q);
                  `endif
                  pop_counter = 0;
                  print_addq();
                  intime_q.pop_front();
                end:pop_display
              else
                  pop_counter = pop_counter+1;

          end:start__operation
         gcounter    = gcounter+1;
         end:loop
	   $fclose(fd);
     $stop;
end:initial_begin
endmodule
// create a list to keep track of items into queue and pop at that time mentioned in queue
