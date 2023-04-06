## Verifying the Design
### By Pradeep Govindan
#### email id :  pradeep3@pdx.edu

---
We were tasked with taking some HDL code for the EPW22 processor and
verifying the functionality is consistent with the design spec using an OOP
testbench implementing the factory model.

# File Overviews
* def.sv : definitions package for consistent implementation in design and testbench
* top.sv : top level module for establishing DUV connections to the testbench
* EPW22_if.sv : BFM defining bus bits and modports for our connections
* Ref_model.sv : reference model to verify design functionality
* generator.sv : class to pass stimulus to the BFM and stimulate design, selects desired test pattern from gen_methods
* gen_methods.sv : class with a list of tasks containing various test case structures
* transactor.sv : class to pass random input data to the DUV and reference model simultaneously
* coverage.sv : class defining collected functional coverage
* scoreboard.sv : class to compare output from reference model with DUV
* golden_vector.txt : file containing golden vectors for comparison
* block_diagram.png : diagram of testbench structure to aid in understanding how classes connect

---

# Detailed File Descriptions

## def.sv
* definitions file for parameters defined in EPW22 docs

### Parameter Descriptions:
* PERIOD : clk period for simulation
* data_width : the width of the data line supplied in the design spec
* num_keys : the number of keys register supplied in the design spec
* key_width : the width of the keys registers supplied in the design spec
* xlat_size : the byte size of the translation table supplied in the design spec
* xlat_data_width : the width of the translation table registers supplied in the design spec
* result_width : the width of the result line supplied in the design spec
* op_width : the width of the opcode supplied in the design spec
* tag_width : the width of the tag supplied in the design spec

### Typedef Descriptions:
* operation_t : give naming convention to map the opcodes for better readability
* test_case : give each of our test cases a name for better readability
* states : defines states for FSM used in design code
---

## top.sv
* top level module instantiates the design and connects each part of the testbench to the BFM.

### Code Walkthrough:
* generates clock for design and testbench
* creates an output file to display the collected testing data used to compare to golden vectors
* get_time function gets total time stimulus should be generated
---

## EPW22_if.sv
* interface created as the BFM controlling operational flow of the testbench

### Variable Descriptions:
* result : result output line of the EPW22
* data : input data line of the EPW22
* tag : input tag used to index into the delay scheduler of the EPW22
* op : input opcode to select EPW22 ALU operation
* rtag : output result tag of the EPW22 (currently unused)
* reset : EPW22 device pin reset signal
* valid : EPW22 output bit indicating valid data on result line
* ready : EPW22 output signal indicating device is ready for input
* error : EPW22 output bit indicating operational error

### Modports:
* primary : used to drive input stimulus to the EPW22
* secondary : used to drive and display output from the reference model
* tertiary : connects to DUV and used to compare with reference model to ensure proper functionality
---

## Ref_model.sv
* reference model to compare with output of the DUV

### Operational Overview (WIP, detail signals, function, and structure of the model)
---

## generator.sv
* stimulus generator creates and sends tests to the DUV and Ref_model

### Case Statement Conditions (c suffix is class based stimulus):
* Deterministic_input1 :
* Complete_random :
* Complete_random_c :
* Constrain_random :
* Constrain_random_c :
---

## gen_methods.sv
* contains tasks used to generate the design stimulus
* specific task passed to generator at runtime

### Task Descriptions (WIP):
* no_op_ip :
* reset_op_ip :
* store_dly_op_ip :
* store_tbl_op_ip :
* rot_left_out_op_ip :
* rot_right_out_op_ip :
* xor_out_op_ip :
* tbl_out_op_ip :
* key_store_rot_left_op_ip :
* key_store_rot_right_op_ip :
* key_store_xor_op_ip :
* key_store_tbl_op_ip :
---

## transactor.sv
* class to pass random input data to the DUV and reference model simultaneously
### Operational Overview (easy way to pass and modify randomized inputs to both designs)
---

## coverage.sv
* class containing all coverage information
### Operational Overview (detail on covergroups, coverpoints)
---

## scoreboard.sv (WIP, had Questa issues loading design when trying to compare the design with reference model)
* eventual scoreboard which compares the DUV against the reference model to ensure proper functionality.
### Operational Overview (details about the comparison and techniques used to compare)
---

## golden_vector.txt
* file containing golden vectors for comparison
* used to check against top.sv output file when deterministic testing

### Column Headers:
CLK		TIME	DATA	OP	TAG		RESET	RESULT	VALID	READY	ERROR	RTAG
