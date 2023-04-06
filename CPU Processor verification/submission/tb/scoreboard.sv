//
// DESCRIPTION:
// Self-checking scorebard will compare the reference model to the
// DUV. Both are instantiated in the top level module and connect
// to the BFM.
//******************************************************************
//
import def::*;
class scoreboard;
   virtual EPW22_if bfm;
   int fd0, fd1, fd2;//all the fd's are file desriptor to P_f.txt, REF.txt and DUT.txt

   function new (virtual EPW22_if bfm);
     this.bfm = bfm;
   endfunction : new

  task open_file();//opening all the files in write mode, previous content in files will be overwritten
     fd0   = $fopen(filename0(), "w");
     fd1  = $fopen(filename1(), "w");
     fd2  = $fopen(filename2(), "w");
   endtask

  task close_file();//closing all the files after writing
    $fclose(fd0);
    $fclose(fd1);
    $fclose(fd2);
  endtask

   task execute();
          open_file();
          forever begin//checking the dut and refmodel output at each clock pulse
         @(posedge bfm.clk)
		     if (bfm.result != bfm.duv_result)begin
  			   $error($time, "FAILED RESULT! Design: %h, Model: %h", bfm.duv_result, bfm.result);
           $fdisplay(fd0, "%t FAILED RESULT! Design: %h, Model: %h", $time, bfm.duv_result, bfm.result);
         end
		     if (bfm.valid != bfm.duv_valid)begin
  			   $error($time, "FAILED VALID! Design: %h, Model: %h", bfm.duv_valid, bfm.valid);
           $fdisplay(fd0, "%t FAILED VALID! Design: %h, Model: %h", $time, bfm.duv_valid, bfm.valid);
         end
		     if (bfm.ready != bfm.duv_ready)begin
  			   $error($time, "FAILED READY! Design: %h, Model: %h", bfm.duv_ready, bfm.ready);
           $fdisplay(fd0,"%t FAILED READY! Design: %h, Model: %h", $time, bfm.duv_ready, bfm.ready);
         end
		     if (bfm.error != bfm.duv_error)begin
           $error($time, "FAILED ERROR! Design: %h, Model: %h", bfm.duv_error, bfm.error);
           $fdisplay(fd0, "%t FAILED ERROR! Design: %h, Model: %h", $time, bfm.duv_error, bfm.error);
         end
		     if (bfm.rtag != bfm.duv_rtag)begin
  			   $error($time, "FAILED RTAG! Design: %h, Model: %h", bfm.duv_rtag, bfm.rtag);
           $fdisplay(fd0, "%t FAILED RTAG! Design: %h, Model: %h", $time, bfm.duv_rtag, bfm.rtag);
         end
        $fdisplay(fd1,"%b %t %h %h %h %b %h %b %b %b %h", bfm.clk, $time, bfm.data, bfm.op, bfm.tag, bfm.reset, bfm.result, bfm.valid, bfm.ready, bfm.error, bfm.rtag);
        $fdisplay(fd2,"%b %t %h %h %h %b %h %b %b %b %h", bfm.clk, $time, bfm.data, bfm.op, bfm.tag, bfm.reset, bfm.duv_result, bfm.duv_valid, bfm.duv_ready, bfm.duv_error, bfm.duv_rtag);
      end
   endtask : execute

   function string filename0();  //task to change input file during run time
     string fd_name = "Pass_fail.txt";//default name if no name is received
     if(!$value$plusargs("P_F=%s", fd_name)) begin//get the input file name
       $error("NO File name CHOSEN\nstop1 ");
       $stop;
     end
     return fd_name;
   endfunction

   function string filename1();  //task to change input file during run time
     string fd_name = "Ref_module_output.txt";//default name if no name is received
     if(!$value$plusargs("REF=%s", fd_name)) begin//get the input file name
       $error("NO File name CHOSEN for reference module\nstop2 ");
       $stop;
     end
     return fd_name;
   endfunction

   function string filename2();  //task to change input file during run time
     string fd_name = "DUV_output.txt";//default name if no name is received
     if(!$value$plusargs("DUT=%s", fd_name)) begin//get the input file name
       $error("NO File name CHOSEN for DUT\nstop3 ");
       $stop;
     end
     return fd_name;
   endfunction

endclass : scoreboard
