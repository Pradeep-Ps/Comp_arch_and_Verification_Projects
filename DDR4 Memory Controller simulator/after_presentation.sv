//collaborator :	PRADEEP GOVINDAN
// Date:	24-NOV-2021
//
// Description:
// ----------------------------------------------------
//
//
//compile in debug module
// vlog open_page_policy.sv +define+DEBUG
// compile without debug module
// vlog open_page_policy.sv
//simulate
// vsim work.MC +Trace=trace.txt
// run in questa sim
// run-all
// quit -sim
//
//////////////////////////////////////////////////////////////////////
//
// timing_parameter.sv - Global definitions to specify timing parameters used in project(memory controller)
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
      //Bank to ban
      parameter	tRRD_L   = 6; //row 2 roinside the same bank group
      parameter	tRRD_S   = 4; //row 2 robetween 2 different bank groups
      parameter	tCCD_L   = 8; //column 2 columinside the same bank group
      parameter	tCCD_S   = 4; //column 2 columbetween 2 different bank groups
      parameter tWR      = 20; // read to next precharge - write recovery
      // covry time time before which precharge can be given
      parameter	tWTR_L   = 12;//write-2-read same bank
      parameter	tWTR_S   = 4; //write-2-read different bank
      parameter	tBURST   = 4; //burst size
      //values experssed in seconds
      parameter	tRFC     =  350000; //expressed in pico seconds - CAS after RAS for refresh - ACT then PRE
      parameter	REFI     = 7800000; //expressed in pico 7.8micro seconds

endpackage: mc_defs
///////////////////////////////////////////////////////////////////////////////////////////////////////////
import mc_defs::*; //importing package  definitions

timeunit 100ps; timeprecision 100fs;
module MC();
  bit clk;
  longint unsigned counter, gcounter;//counter to count cpu ticks 3.2GHz frequency processor

    always #31.2 clk = ~clk; // generating clock

    initial begin
      @(posedge clk)
      counter += 1;
      gcounter +=1;
    end

  file_read f1(.clk(clk));
endmodule

module file_read(input bit clk );
    int fd,  t_n, op, address, process_time, temp, t_q[$], op_q[$], intime_q[$], o_q[$],request_flag, pop_flag, j, op_pop;
    int fd_w; //file descriptor for write file
    bit [32:0]add_map, add_q[$], add_pop, autoprecharge = 0;
    int array[16]= {-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10,-10};
    longint unsigned counter=0, gcounter=1; //global counter and normal counter - used while advacnce simulation time
    string file_name, output_filename; //temp variable to store file name from transcript

    task openFile();
    fd = $fopen(file_name, "r"); //opening input file in read mode
    if(fd) //if file descrioptor is true then read is success
        begin
          `ifdef DEBUG //display only in debug mode
           $display("reading successful");
           `endif
         end
        else
        begin
          `ifdef DEBUG //display only in debug mode
          $display("reading failed");
          `endif
        end
      endtask

function int get_input();  //getting input function
      if($fscanf(fd, "%0d %0d %H", t_n, op, address)==3)     //read form input file if all three inputs time, op and address are present
      begin//reading the input from file and checking whether all 3 inputs are there
      add_map = '0; // initialize to 0
      add_map = 32'(add_map^address); //copying contents of address to add_map for slicing and displaying Bank group, bank, column and address
      return 1; //return 1 if input is present in input file
 end
      else  return 0;
  endfunction

  task parserfilename();                                //task to change input file during run time
    if(!$value$plusargs("INPUT=%s", file_name) )  //copy input file name to file_name
    begin     //get the input file name
    `ifdef DEBUG
      $error("NO ip file");                                  // display error if there is no input file found
    `endif
      $stop;
    end
  endtask

task print_addq();  //printing each element in address queue in hexadecimal format
  $write("add_q = {");
  foreach(add_q[j]) $write("%0h,", add_q[j]); //j represents index in address queue
  $write("}\n");
endtask

task write();
  $value$plusargs("OUTPUT=%s", output_filename);
 fd_w = $fopen(output_filename, "w"); //opening output file in write mode
 if(fd_w) //if file descriptor is true then write is success
     begin
       `ifdef DEBUG
        $display("writing successful");
        `endif
      end
     else
     begin
       `ifdef DEBUG
       $display("writing failed");
       `endif
     end
endtask

initial
begin: initial_begin
      parserfilename(); //gets only input file name from transcript
  	  openFile();   //open input file and read first line
      write(); //write opens output file in write mode
      `ifdef DEBUG
      $display("Reading %s file successfully", file_name);
      `endif
      // while(  !$feof(fd)  || request_flag || pop_flag)
      while( t_q.size() != 0 || !$feof(fd)  || request_flag) //main loop which will run until all push and pop operations are over
                                                            //!feof(fd)      -  for push operation until end of file all inputs are read
                                                            //t_q.size() !=0 - until queue is empty for pop operations
                                                            //request flag - when queue size is 16 and pending request is present
      begin:loop
          if(t_q.size()<16)          //push only when size is less than 16
          begin:size
              if(!request_flag)     //no pending request
              begin
                  if(get_input())       request_flag=1; // indicates pending request to queue - a line is waiting to be pushed into the queue
              end

            	if(request_flag) //a line has to be pushed inside queue
              begin:push
            				if( t_q.size()==0 && counter < t_n)
              					counter = t_n; //if queue is empty then advance simulation time
                    if(counter >= t_n*2)
                    begin:push_operation

                       intime_q.push_back(counter);
                       t_q.push_back(t_n);
                       op_q.push_back(op);
                       add_q.push_back(add_map); //push all the elements into queue

                       request_flag = 0; //after pushing set flag to 0
                       pop_flag = 1;

                       temp = o_q[(intime_q.size()-2)]; //get the out time of previous elements
                       if(o_q.size() == 0) o_q.push_back(intime_q[intime_q.size()-1] + cycle_time(op));//add intime + cycle time for 1st element
                       else                     o_q.push_back(temp                        + cycle_time(op)); //previous element out time + cycle time

                       `ifdef DEBUG
                          $display("in     %p\nout    %p", intime_q, o_q);
                          $display("push %0d %0d %0h @ counter=%0d, size=%0d, time=%0d,  op=%0d,  add=%h,\nop_q  =%p\nt_q   =%p\n",t_n, op, add_map, counter, t_q.size(), t_n,     op,    add_map,   op_q,  t_q);
                          print_addq();
                        `endif
                    end:push_operation
              end:push
            end:size

              if((counter == o_q[0])) //when counter matches outime pop
                  begin:pop_operation

                    t_q.pop_front();
                    intime_q.pop_front();
                    o_q.pop_front();
                    op_pop  = op_q.pop_front();
                    add_pop = add_q.pop_front();
                    pop_flag = 0; //after poping set pop flag 0

                      `ifdef DEBUG
                        $display("\nin     %p\nout    %p", intime_q, o_q);
                        $display("pop  @ counter=%0d, size=%0d, time=%0d, op=%0d, add=%h,\nt_q   =%p,\nop_q  =%p\n", counter ,t_q.size(),t_n, op, add_map, t_q, op_q);
                        print_addq();
                        print_b_bg_r_c(add_q[0]);
                      `endif
                  end:pop_operation

            print_output(add_q[0],op_pop, o_q[0]);
            @(posedge clk) counter += 1; //incrementing the counter
            @(posedge clk) gcounter += 1;
      end:loop
      $display("counter %0d gcounter %0d", counter, gcounter); //end time of counter
      $fclose(fd); //close input file
      $fclose(fd_w); //close ouput file
      $stop;
end:initial_begin

  function print_b_bg_r_c(bit [32:0] add_map);
    $display(">>>>>>>>>>>>>>>>>>>>> Row=%0d, Hcolumn=%0d, Bank=%0d, Bank group=%0d, L column=%0d\n", add_map[31:18],add_map[17:10],add_map[9:8],add_map[7:6],add_map[5:3]);
    return 0; //slice the address and display it as row bank group bank column
  endfunction

function page1(bit [32:0] add_q);
        bit HIT;
  if( array[{add_q[9:8],add_q[7:6]}] == add_q[32:18])
  begin
        HIT = 1;
        // $display("page hit @ counter %3d", counter);
      end
  else
  begin
      array[{add_q[9:8],add_q[7:6]}] = add_q[32:18];
      // $display("page miss @counter 3d", counter);
      HIT = 0;
  end
  return HIT;
endfunction

function bit print_output(bit [32:0]add_q,  int op_pop, o_q);
      case(op_q[0])
      0 : begin:data_read

                    if((counter == (o_q - tRC+1))   && autoprecharge)
                    begin
                             $display("%3d PRE %0d %0d",     counter-1, add_q[7:6], add_q[9:8]                         ); //76
                                    $fdisplay(fd_w,"%3d PRE %0d %0d",     counter-1, add_q[7:6], add_q[9:8]                         ); //76

                    end
                    else if(counter == (o_q - tRAS        ))
                    begin
                         $display("%3d ACT %0d %0d %4h", counter, add_q[7:6], add_q[9:8], add_q[31:18]             );//52
                            $fdisplay(fd_w,"%3d ACT %0d %0d %4h", counter, add_q[7:6], add_q[9:8], add_q[31:18]             );//52
                            autoprecharge = 1;
                    end
                    else if(counter == (o_q - (page1(add_q)? tCCD_L : tCAS -tBURST)))
                    begin
                         $display("%3d RD  %0d %0d %4h", counter, add_q[7:6], add_q[9:8], {add_q[17:10],add_q[5:3]});//28
                            $fdisplay(fd_w,"%3d RD  %0d %0d %4h", counter, add_q[7:6], add_q[9:8], {add_q[17:10],add_q[5:3]});//28
                    end

          end:data_read

      1 : begin:data_write
              if(counter == (o_q - tWR+1)) $display("%3d WR  %0d %0d %4h", counter-1, add_q[7:6], add_q[9:8], {add_q[17:10],add_q[5:3]});
              // else                  // print_b_bg_r_c(add_q);                  // $display("out failed %0d counter %0d", o_q[0] - tWR, counter);
          end:data_write

      2 : begin:inst_fetch
          // $display("counter %3d %3d", counter, (o_q -tCAS-tBURST));
            if((counter == (o_q - tRC+1))   && autoprecharge )
            begin
                     $display("%3d PRE %0d %0d",     counter-1, add_q[7:6], add_q[9:8]                         ); //76
                            $fdisplay(fd_w,"%3d PRE %0d %0d",     counter-1, add_q[7:6], add_q[9:8]                         ); //76

            end
            else if(counter == (o_q - tRAS        ))
            begin
                 $display("%3d ACT %0d %0d %4h", counter, add_q[7:6], add_q[9:8], add_q[31:18]             );//52
                    $fdisplay(fd_w,"%3d ACT %0d %0d %4h", counter, add_q[7:6], add_q[9:8], add_q[31:18]             );//52
                    autoprecharge = 1;
            end
            else if(counter == (o_q - (page1(add_q)? tCCD_L : tCAS -tBURST)))
            begin
                 $display("%3d RD  %0d %0d %4h", counter, add_q[7:6], add_q[9:8], {add_q[17:10],add_q[5:3]});//28
                    $fdisplay(fd_w,"%3d RD  %0d %0d %4h", counter, add_q[7:6], add_q[9:8], {add_q[17:10],add_q[5:3]});//28
            end

       end:inst_fetch
   endcase

endfunction

  function int cycle_time(int op);
    case(op)
      0 : process_time = page()?tCCD_L : tRC; //76
      1 : process_time = tWR;                 //24
      2 : process_time = page()?tCCD_L : tRC; //76
    endcase
    return process_time;
  endfunction

  function int page();
        bit [32:0] prev;
        prev = add_q[(intime_q.size()-2)];
        page = ((prev[32:18]==add_map[32:18])? 1 : 0);
        return page;
  endfunction

endmodule
