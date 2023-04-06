// transactor.sv - FILE name
//
// Collaborator : PRADEEP GOVINDAN
//
//DESCRIPTION:
//
//******************************************************************
//
import def::*; //importing package definitions
class transactor;

  randc logic [data_width-1:0] data1_set, data2_set;
  randc logic [tag_width-1:0]  tag_set;
  randc logic [op_width-1:0]   op_set;

endclass
