//
//collaborator :	PRADEEP GOVINDAN
//
//-----------------------------
// Contains the global defs,  etc. for the memory controller
// controller assignment
//------------------------------
//////////////////////////////////////////////////////////////
// timing_parameter.sv - Global definitions to specify timing parameters used in project(memory controller)
package mc_defs;
//values expressed in CPU clock ticks
parameter	tRP      = 24; //time between Pre and Act , time to precharge
parameter	tRCD     = 24; //time between Act and Read
parameter	tCAS     = 24; //time between read and data burst CL
//
parameter	tRAS     = 52; //time for next precharge
parameter	tRC      = 76; //time for entire read cycle
//
parameter	tCWD     = 20; //Write burst operation CAS latency CWL - after write command data in
parameter	tRTP     = 12; // WR (WRITE recovery)/RTP (READ-to-PRECHARGE
//Bank to bank delays
parameter	tRRD_L   = 6; //row 2 row delay inside the same bank group
parameter	tRRD_S   = 4; //row 2 row delay between 2 different bank groups
parameter	tCCD_L   = 8; //column 2 column delay inside the same bank group
parameter	tCCD_S   = 4; //column 2 column delay between 2 different bank groups
parameter tWR      = 20; // read to next precharge - write recovery
// covry time time before which precharge can be given
parameter	tWTR_L   = 12;//prewrite-2-read same bank
parameter	tWTR_S   = 4; //write-2-read different bank
parameter	tBURST   = 4; //burst size
//values experssed in seconds
parameter	tRFC     =  350000; //expressed in pico seconds - CAS after RAS for refresh - ACT then PRE
parameter	REFI     = 7800000; //expressed in pico 7.8micro seconds

endpackage: mc_defs

/*
('R1', 'R1') reads to same group
('R1', 'R2') read to different group
('R1', 'W1')
('R1', 'W2')
('R1', 'W2')
('R1', 'Inst1')
('R1', 'Inst2')
('R1', 'R2')
('R1', 'W1')
('R1', 'W2')
('R1', 'Inst1')
('R1', 'Inst2')
('R2', 'R2')
('R2', 'W1')
('R2', 'W2')
('R2', 'Inst1')
('R2', 'Inst2')
('R2', 'W1')
('R2', 'W2')
('R2', 'Inst1')
('R2', 'Inst2')
('W1', 'W1')
('W1', 'W2')
('W1', 'Inst1')
('W1', 'Inst2')
('W1', 'W2')
('W1', 'Inst1')
('W1', 'Inst2')
('W2', 'W2')
('W2', 'Inst1')
('W2', 'Inst2')
('W2', 'Inst1')
('W2', 'Inst2')
('Inst1', 'Inst1')
('Inst1', 'Inst2')
('Inst2', 'Inst1')
('Inst2', 'Inst2')
*/
