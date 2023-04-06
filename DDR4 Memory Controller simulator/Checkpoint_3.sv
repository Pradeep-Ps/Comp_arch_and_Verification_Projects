timeunit 1ns; timeprecision 100ps;
`timescale 1ns/100ps
module try();
  bit clk;
  longint unsigned counter;
  
    always #1 clk = ~clk; //time period 2

  initial begin 
    #2000   $stop;
  end 
  file_read f1(.clk(clk));
endmodule

module file_read(
  input bit clk );
  int fd, readfile, time_n, op, address, time_q[$], op_q[$], add_q[$];
  bit [31:0]address_map;
  longint unsigned counter, pop_counter;
  int flag,request_flag, start_operation ;
  
  
  function int get_input();
    if($fscanf(fd, "%0d %0d %H", time_n, op, address)==3)
	begin
	 address_map = '0;
	  address_map = 32'(address_map ^ address);
      return 1;
	  end
    else 
      return 0;
  endfunction
  
  task openFile();
  fd = $fopen("trace.txt","r");
  if(fd)
   $display("reading successful");
   else
    $display("reading failed");
  endtask
  
  always_ff@(posedge clk) begin
    //counter <= counter +1;
	//$strobe("%d",counter);
	
  end
  
  initial
    begin
      openFile();                            
      $display("Reading trace1 file successfully"); 
      while( time_q.size() != 0 || !$feof(fd)  || request_flag)
        begin
		//$display("counter=%d",counter);
          if(time_q.size()<16)
            begin
              if(!request_flag)
                begin
                  if(get_input())
                    begin
                      //$display("request is high");
                      request_flag=1;
                    end
                end
              
              	if(request_flag)
              	begin
				if( time_q.size()==0 && counter < time_n)
				begin
					counter = time_n;
				end
                if(counter >= time_n)
                  begin
				  
				 time_q.push_back(time_n);
				 op_q.push_back(op);
				 add_q.push_back(address_map);
				 
                 request_flag = 0;
				 $display("\npush %0d %0d %0h @ counter=%0d, time=%0d,  op=%0d,  add=%h,\ntime_q=%p,\n op_q  =%p,\n add_q =%p, size=%0d", 
				             time_n, op, address_map, counter,         time_n,     op,    address_map,   time_q,    op_q,        add_q,     time_q.size());
				 $display("Row=%0d, Hcolumn=%0d, Bank=%0d, Bank group=%0d, L column=%0d\n", 
                 address_map[32:18], address_map[17:10],
                 address_map[9:8], address_map[7:6],
                 address_map[5:3]);

				 end
              	end
              
             start_operation =1;
             
            end 
			
			if(start_operation)
			begin
			
			   if((pop_counter==101+time_q[0]) && (time_q.size() != 0))
			   begin
			     
				 $display("\npop %0d %0d %0h @ counter=%0d,  time=%0d, op=%0d, add=%h,\ntime_q=%p,\nop_q  =%p,\nadd_q =%p, size=%0d", 
				 time_q.pop_front(), op_q.pop_front(), add_q.pop_front(), pop_counter ,  time_n, op, address_map, time_q, op_q, add_q, time_q.size());	  
				 
				 //pop_counter = ; 
				 end
			end
			
         counter = counter+1;		 
		 pop_counter=pop_counter+1;
          		  
	  end
	   $fclose(fd);
    end
      
      
     /* always@(counter) 
        begin
          while(time_q.size() >= 1) 
            begin
              wait(100)
              begin
                wait(counter == 101 + time_q[0]) 
                begin 
                  $display(" pop %0d counter=%0d, time=%0d, op=%0d, add=%h, q=%p, size=%0d", time_q.pop_front(), counter, time_n, op, address, time_q, time_q.size());	  
                  flag = 0;
                end
              end		  
            end
          $display($time,,,"stop2");
          $stop;
        end*/
      endmodule
      
      /*
      have 2 states where u have to count and push normally into the queue when n+16 element have time greater than n enter+100 clock cycles
and when n+16 element is less than n enter+100 clock cycles
pop when 100 clock cycles are over

always@(counter) begin
if(time_n< time_q[0] +100) begin //problem
count_q = count_q+1;

end
end

always@(counter) begin
if(time_n > time_q[0] +100) begin
end
end
*/
