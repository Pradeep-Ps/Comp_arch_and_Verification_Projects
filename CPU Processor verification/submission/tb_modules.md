## Testbench Modules
### By  Pradeep Govindan

---
File describing each of the modules created in the testbench.

# File Overviews
* def.sv : definitions package for consistent implementation in design and testbench
* top.sv : top level module for establishing EPW22_design.sv connections to the testbench
* EPW22_if.sv : BFM defining bus bits and modports for our connections
* Ref_model.sv : refmodel.sv to verify design functionality
* generator.sv : class to pass stimulus to the BFM and stimulate design, selects desired test pattern from gen_methods
* gen_methods.sv : class with a list of tasks containing various test case structures
* transactor.sv : class to pass random input data to the EPW22_design.sv and refmodel.sv simultaneously
* coverage.sv : class defining collected functional coverage
* scoreboard.sv : class to compare output from refmodel.sv with EPW22_design.sv
* golden_vector.txt : file containing golden vectors for comparison
* block_diagram.png : diagram of testbench structure to aid in understanding how classes connect
---

# Runtime Arguments:

## Detailed File Descriptions

### def.sv
* definitions file for parameters defined in EPW22 docs
* defined the timeunit equal to 1ns
* includes the transactor.sv, generator.sv, gen_methods.sv for use in every other file

#### Parameter Descriptions:
* PERIOD : clk period for simulation (2ns)
* data_width : the width of the data line supplied in the design spec
* num_keys : the number of keys register supplied in the design spec
* key_width : the width of the keys registers supplied in the design spec
* xlat_size : the byte size of the translation table supplied in the design spec
* xlat_data_width : the width of the translation table registers supplied in the design spec
* result_width : the width of the result line supplied in the design spec
* op_width : the width of the opcode supplied in the design spec
* tag_width : the width of the tag supplied in the design spec

#### Typedef Descriptions:
* operation_t : give naming convention to map the opcodes for better readability
* test_case : give each of our test cases a name for better readability
* states : defines states for FSM used in design code
---

### top.sv
* top level module instantiates the EPW22_design.sv, refmodel.sv, and connects each part of the testbench to the EPW22_intf.sv
* contains includes for scoreboard.sv, coverage.sv

#### Code Walkthrough:
* generates clock for for all submodules with a defined period of 2ns
* instantiates the EPW22_design.sv as duv, refmodel.sv as model, and EPW22_intf.sv as bus
* initial block:
	* creates new objects for coverage, generator, and scoreboard
	* forks execution for coverage, scoreboard, generator, and random reset
* get_time function receives stop time from TIME runtime argument and displays it
---

### EPW22_if.sv
* interface created as the BFM controlling operational flow of the testbench
* all input and output signals for the EPW22_design.sv and refmodel.sv explicitly defined

#### Variable Descriptions:
* data : input data line sent to the EPW22_design.sv and refmodel.sv
* tag : input tag used to index into the delay scheduler of the EPW22_design.sv and refmodel.sv
* op : input opcode to select EPW22_design.sv and refmodel.sv ALU operation
* reset : reset device pin signal sent to EPW22_design.sv and refmodel.sv
* result : result output line of the EPW22_design.sv
* rtag : output result tag of the EPW22_design.sv (currently unused)
* valid : EPW22_design.sv output bit indicating valid data on result line
* ready : EPW22_design.sv output signal indicating device is ready for input
* error : EPW22_design.sv output bit indicating operational error
* duv_result : result output line of the refmodel.sv
* duv_rtag : output result tag of the refmodel.sv (currently unused)
* duv_valid : refmodel.sv output bit indicating valid data on result line
* duv_ready : refmodel.sv output signal indicating device is ready for input
* duv_error : refmodel.sv output bit indicating operational error


#### Modports:
* primary : used to drive input stimulus to both the EPW22_design.sv and refmodel.sv
* secondary : used to drive and display output from the refmodel.sv
* tertiary : used to drive and display output from the EPW22_design

#### Task Descriptions:
* Pin_reset : assert reset signal from PERIOD*6 to PERIOD*10 delay
* BFM_mode : asserts reset signal at the start and then some time randomly between a delay of PERIOD*100 and PERIOD*200
---

### refmodel.sv
* model of the EPW22_design.sv used to compare and determine proper functionality

#### Internal Declarations:
* data_stream : scheduler queue for handling the output and delay on the result line
* delay_sched : register to hold the delay values
* xlat_table : 256 byte table with byte sized registers for holding information
* keys : 8 16-bit general purpose registers used for operations (keys[0] = 0000h, keys[1] = FFFFh)
* data_A : temporary storage for the first set of data since many operations take two clock cycles
* temp_tag : temporary storage location for the tag since it's received on the first clock cycle
* xlat_pointer : pointer to the next available location in the xlat_table
* qpop_flag : flag indicating of data was popped from the queue to the result line
* b_flag : flag indicating if the data line contains the A or B data
* assert_error : flag used to indicate if we should assert an error on the error line

#### Internal Tasks/Functions:
* clear_state() : function used for the reset instruction (soft reset of the system)
* init_chip() : task used when the reset pin is asserted on the chip (hard reset of the system)
* toggle_error() : task used to bring the error line down the clock cycle after it has been asserted
* display_table() : displays the table values if the PRINT macro is defined

#### Always Block Descriptions:
* always_ff device_reset : logic for checking if the reset pin is asserted to reset the system
* always_ff alu_ops : block with the opcode functionality integrating the design
* always_ff display_result : block for managing the data_stream queue and passing data to the result line at the correct delays
* always assert_error : used to assert or de-assert the error output
