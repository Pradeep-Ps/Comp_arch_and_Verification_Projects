//timing_parameter.sv - Global definitions to specify timing parameters used in project(memory controller)
//
//
// gobal defs for memoery controller
// timing paramter to perform the operation for the certain time
//
//
///////////////////////////////////////////////////////////////////////////////////
package controller_defs;
parameter tRP 	= 24;
parameter tRCD = 24;
parameter tCAS = 24;
parameter tRAS = 52;
parameter tRC = 76;
parameter tCWD = 20;
parameter tRTP = 12;
// delays for the banks
parameter tRRD_L = 4;
parameter tRRD_S = 6;
parameter tCCD_L = 8;
parameter tCCD_S = 4;
// transaction time for internal read and write 
parameter tWR = 20;
parameter tWTR_S = 4;
parameter tWTR_L = 12;
parameter tBURST = 4;
parameter tRFC = 350;
parameter REFI = 7800;
endpackage: controller_defs
