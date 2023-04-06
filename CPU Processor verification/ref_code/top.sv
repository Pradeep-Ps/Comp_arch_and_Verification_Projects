// top.sv - FILE name
//
// Collaborator : PRADEEP GOVINDAN 
//
// DESCRIPTION:
// Creating top module to instantiate my_testbench module, my_refmodel
// module and interface EPW22_if. Handles input to define what funtionality
// to test at runtime.
//
//******************************************************************
//
import def::*;
`include "scoreboard.sv"
`include "coverage.sv"

module top;
    bit clk;
    int fd;

    always #(PERIOD/2) clk = ~clk; //generating clock for a period of 5 with time period 10

    EPW22_if     bus (.clk(clk)); //interface
    refmodel   model (.intf(bus.secondary));
    EPW22_design dut (.intf(bus.tertiary));

scoreboard score_h;
coverage cover_h; generator gen_h;  gen_methods gmet_h; //handles

  initial begin:main
        cover_h = new(bus); gen_h = new(bus); gmet_h = new(bus); score_h = new(bus); //score_h = new1(dut);
        fork
           cover_h.execute(); gen_h.execute(); score_h.execute();
           begin
               fd   = $fopen("Pass_fail.txt", "w");
             #(get_time()) $fclose(fd);
             $stop;
           end
        join
     end:main

     always@(posedge clk) $fdisplay (fd," %0b       %0t       %0h       %0h       %0h       %0b       %0h       %0b       %0b       %0b       %0h",  bus.clk, $time, bus.data, bus.op, bus.tag, bus.reset, bus.result, bus.valid, bus.ready, bus.error, bus.rtag);

   function int get_time();
     int T;
     if($value$plusargs("TIME=%0d", T)) $display($time,,,"************************** Got stop time %0d ************************************", T);
     else                                $error($time,,,"************************** Invalid stop time value %0d **************************", T);
     return T;
   endfunction

endmodule : top
