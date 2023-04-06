// DESCRIPTION:
// Creating interface betweeen refmodel and generator and design modules using
// modports. Signals used inside the modules are declared here modports define input
// and output to the modules.
//
//******************************************************************
//
import def::*; //importing package definitions
 interface EPW22_if (input bit clk);

	logic [result_width-1:0] result;// operation result
	logic [data_width-1:0] data;	// data: can be immediate or reference
	logic [tag_width-1:0] tag;	// used to index the delay register
	logic [op_width-1:0] op;	// opcode for ALU operation (comes on first clk cycle)
	logic [tag_width-1:0] rtag;		// result tag used for delay (CURRENLY UNUSED)
	bit reset;			// device pin reset
	bit valid;			// valid output received
	bit ready;			// are we ready for input?
	bit error;			// have we received an error somewhere?


	// output signals for the DUT
	logic [result_width-1:0] duv_result;// operation result
	logic [tag_width-1:0] duv_rtag;		// result tag used for delay (CURRENLY UNUSED)
	bit duv_valid;			// valid output received
	bit duv_ready;			// are we ready for input?
	bit duv_error;			// have we received an error somewhere?

// ---------------------------------------------------------------------------------
//  PRIMARY MODPORT CONNECTED TO CLASS STIMULUS
//  --------------------------------------------------------------------------------
	modport primary (//input stimulus //EPW22_if.primary intf
	input ready,
	input clk,

	output data,
	output tag,
	output op,
	output reset
	);
// ---------------------------------------------------------------------------------
//  SECONDARY MODPORT CONNECTED TO REFERENCE MODULE
//  --------------------------------------------------------------------------------
	modport secondary(//ouput reference model //EPW22_if.secondary intf
	input reset,
	input clk,
	input data,
	input tag,
	input op,

	output result,
	output rtag,
	output valid,
	output ready,
	output error
	);
// ---------------------------------------------------------------------------------
//  TERTIARY MODPORT CONNECTED TO DUV MODULE
//  --------------------------------------------------------------------------------
	modport tertiary(
		input reset,
		input clk,
		input data,
		input tag,
		input op,

		output duv_result,
		output duv_rtag,
		output duv_valid,
		output duv_ready,
		output duv_error
		);

	task Pin_reset();//task to reset processor within a time frame of 1 to 6
                                        reset = 1'b1;
      #(PERIOD*($urandom_range(6, 10))) reset = 1'b0;
  endtask

  task BFM_mode();//randomly generate reset while running other test cases
    Pin_reset();
    #(PERIOD*$urandom_range(100, 200));
  endtask

endinterface: EPW22_if
