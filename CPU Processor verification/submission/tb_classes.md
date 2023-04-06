## Testbench Classes
### Pradeep Govindan

---
File describing each of the classes created for the testbench factory
Converting our testbench to a class hierarchy allowed for an easier to maintain codebase
by passing each of the transactions as packets. It also greatly reduced the number of lines
of code we were required to maintain. Splitting the generator code into parent and child classes
made it easy to override methods and pass new arguments for various tests we decided to run. The
transactor class made it easy to constrain the randomization either during runtime or on-the-fly.

## transactor.sv
* declaration of random logic used to pass variables to other classes
---

## generator_parent.sv
* contains tasks used to generate the testbench stimulus
* stimulus generator creates and sends tests to the EPW22_design.sv and refmodel.sv

### Task/Function Descriptions:
* input_0 : task used to pass the deterministic input stimulus to the EPW22_if.sv
* Individual_ops : task used to run back to back operations for each opcode

### golden_vector.txt
* file containing golden vectors for comparison to output from input_0 task
* used to check against EPW22_design.sv output file when deterministic testing
#### Column Headers:
CLK		TIME	DATA	OP	TAG		RESET	RESULT	VALID	READY	ERROR	RTAG

---

## generator_child.sv
* class extended from generator_parent class used to execute stimulus types for testing
* specific task passed to generator at runtime

### Function Descriptions:
* execute() : called in top.sv and runs case statement forever
* parserfilename() : selects the desired test at runtime using INPUT argument

### Case Statement Conditions:
* no_op : stimulus to run consecutive no operations (opcode=0)
* reset_op : stimulus to run consecutive reset operations (opcode=1)
* store_dly : stimulus to run consecutive stores to the delay scheduler (opcode=2)
* key_store : stimulus to run consecutive stores to any of the 8 keys registers (opcode=3)
* store_tbl : stimulus to run consecutive stores to the translation table (opcode=4)
* reserved_5 : stimulus to run consecutive reserved_5 operations (not currently implemented) (opcode=5)
* reserved_6 : stimulus to run consecutive reserved_6 operations (not currently implemented) (opcode=6)
* reserved_7 : stimulus to run consecutive reserved_7 operations (not currently implemented) (opcode=7)
* rot_left_out : stimulus to run consecutive left rotations and sent the output to the result line (opcode=8)
* rot_right_out : stimulus to run consecutive right rotations and sent the output to the result line (opcode=9)
* xor_out : stimulus to run consecutive xor operations and sent the output to the result line (opcode=A)
* tbl_out : stimulus to run consecutive outputs of data from the translation table to the result line (opcode=B)
* key_store_rot_left : stimulus to run consecutive key stores with a left rotation (opcode=C)
* key_store_rot_right : stimulus to run consecutive key stores with a right rotation (opcode=D)
* key_store_xor : stimulus to run consecutive key stores with an xor operation (opcode=E)
* key_store_tbl : stimulus to store a value from a key register into the translation table (opcode=F)
* Deterministic_input1 : stimulus to run deterministic input using our golden vectors
* Complete_random_c : pass completely random stimulus to the EPW22_if.sv through the transactor handle
* Constrain_random_c : pass constrained random stimulus to the EPW22_if.sv through the transactor handle
---

## scoreboard.sv
* class used to track and compare outputs in the refmodel.sv against the EPW22_design.sv at each posedge of clk
* prints an error to a file declared at runtime using the P_F plusarg
* prints output from refmodel.sv and EPW22_design.sv to files declared at runtime using REF and DUT plusargs respectively

### Task Descriptions:
* open_file : creates three files to write information to
* close_file : closes the files opened with open_file when done with them
* execute : creates files for checking whether the design passes, and compares the output of EPW22_design.sv to the output of refmodel.sv
	* Column Headers: CLK		TIME	DATA	OP	TAG		RESET	RESULT	VALID	READY	ERROR	RTAG
* filename0 : declares the name the output file at runtime containing pass/fail information
* filename1 : declares the name the output file at runtime containing refmodel.sv input and output
* filename2 : declares the name the output file at runtime containing EPW22_design.sv input and output
---

## coverage.sv
* class containing all coverage information
### Covergroup: nreset_r
* coverage for all functionality when the pin reset is not asserted in the refmodel.sv

### Covergroup: reset_r
* coverage to ensure the state of the refmodel.sv remains in reset during the pin reset

### Covergoup: internal_r
* coverage of internal signals in the refmodel.sv

### Covergroup: xtable
* coverage of the xlat table registers and pointer in the refmodel.sv ensuring the table fills completely

### Covergroup: reset_d
* coverage on the input and output signals for when the pin reset is asserted in the EPW22_design.sv

### Covergroup: nreset_d
* coverage on the input and output signals for when the pin reset is asserted in the EPW22_design.sv

### Task/Function Descriptions:
* new() : creates instances for each defined covergroup
* execute() : samples each covergroup forever at negedge of clk
	* only samples reset_r and reset_d during pin reset
---
