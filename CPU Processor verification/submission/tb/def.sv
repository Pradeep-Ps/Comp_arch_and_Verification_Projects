//
//DESCRIPTION: The package contains all the parameters and definitions
// used in project
//
//******************************************************************
//
timeunit 1ns;
package def;
  parameter PERIOD = 2;	// clock period
  parameter data_width = 16;	// width of input data

  parameter num_keys = 8;	// number of key registers
  parameter key_width = 16;	// width of key registers
  parameter xlat_size = 256;	// size of xlat table
  parameter xlat_data_width = 8;// width of xlat registers

  parameter result_width = 16;	// width of result output
  parameter op_width = 4;	// width of opcode
  parameter tag_width = 2;	// width of input tag

typedef enum  bit[op_width-1:0] {//All operations of the EPW22 processor
          no_op              = 4'h0,
					reset_op           = 4'h1,
					store_dly          = 4'h2,
					key_store          = 4'h3,
					store_tbl          = 4'h4,
					reserved_5         = 4'h5,
					reserved_6         = 4'h6,
					reserved_7         = 4'h7,
					rot_left_out       = 4'h8,
					rot_rght_out       = 4'h9,
					xor_out            = 4'hA,
					tbl_out            = 4'hB,
					key_store_rot_left = 4'hC,
					key_store_rot_rght = 4'hD,
					key_store_xor      = 4'hE,
					key_store_tbl      = 4'hF } operation_t;

typedef enum int {//Different test cases of EPW22 processor
          Deterministic_input1 = 16,
          Complete_random_c = 17,
          Constrain_random_c = 18,
          Table_ops=19,
          Result_ops=20,
          Rotateleft_ops=21,
          Rotateright_ops=22,
          walking_zeros=23,
          walking_ones=24,
          no_op_ip=25,
          reset_op_ip=26,
          store_dly_op_ip=27,
          key_store_op_ip=28}test_case;

//including the common tb class files.
  `include "transactor.sv"
  `include "generator_parent.sv"
  `include "generator_child.sv"
endpackage: def
