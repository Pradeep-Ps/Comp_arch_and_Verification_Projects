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

    always #(PERIOD/2) clk = ~clk; //generating clock for a period of 5 with time period 10

    EPW22_if     bus (.clk(clk)); // BFM interface
    refmodel   model (.intf(bus.secondary));//reference module
    EPW22_design duv (.intf(bus.tertiary));//design

    scoreboard score_h;	coverage cover_h; generator_child gen_h;//handles

  initial begin:main
        cover_h = new(bus);
        gen_h = new(bus);
        score_h = new(bus);
        fork//running coverage, scoreboard, generator_child, BFM.mode, and stop as seperate threads
           cover_h.execute();
           score_h.execute();
             forever bus.BFM_mode();
             gen_h.execute();
           begin
             #(get_time()) score_h.close_file();
//             $stop;
		$finish;
           end
        join_any
     end:main

   function int get_time();//getting stop time from command line
     int T;
     if($value$plusargs("TIME=%0d", T)) $display($time,,,"******************************* Got stop time %d *******************************", T);
     else                                $error($time,,,"************************** Invalid stop time value %d ***************************", T);
     return T;
   endfunction

endmodule : top
