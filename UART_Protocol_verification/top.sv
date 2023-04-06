
`include "uvm_macros.svh"


module top;

//virtual interface io_if vif;

 import uvm_pkg::*;
 import fifo_pkg::*;

  bit clock;
  bit reset;



initial
	clock = 1'b1;

initial
	begin
	 #10;
	reset = 1'b1;
	 #10;
	reset = 1'b0;
	end

always #10 clock = ~clock;
bit rst_n;

  fifo_if if1(.clock(clock), .rst_n(reset));

  fifo dut(.clock(if1.clock),.reset(if1.rst_n),.read(if1.read),
            .write_enb(if1.write),.data_in(if1.data_in),.data_out(if1.data_out),
             .empty(if1.empty),.full(if1.full));

initial
	begin
	uvm_config_db#(virtual fifo_if)::set(null,"*","fifo_if",if1);

	run_test("test_fifo");
        end


endmodule
