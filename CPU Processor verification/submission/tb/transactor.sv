//
//DESCRIPTION:
// All the inputs are declared as randomized type
//  which can be used to randomize and send to other classes easily
//******************************************************************
//
import def::*; //importing package definitions
class transactor;
//Declaring all the input signals  as randomized type
  randc logic [data_width-1:0] data1_set, data2_set;
  randc logic [tag_width-1:0]  tag_set;
  randc logic [op_width-1:0]   op_set;

endclass
