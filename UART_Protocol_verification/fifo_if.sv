
`include "/export/home/vishnu_b21/UVM/FIFO_uvm_VISHNU/rtl/defines.v"
interface fifo_if(input bit clock,rst_n);

logic [`DATA_WIDTH-1:0]  data_in;
logic write;
logic read;
logic reset;
logic [`DATA_WIDTH-1:0] data_out;
logic full;
logic empty;


clocking cb_drv @(posedge clock);
default input#0 output#0;
output data_in;
output write;
output read;
endclocking

clocking cb_imon @(posedge clock);
default input#0 output#0;
input data_in;
input write;
input read;

endclocking

clocking cb_omon @(posedge clock);
default input#0 output#0;
input  data_out;
input full;
input empty;

endclocking

modport MDRV (input cb_drv,rst_n);

modport IMON (input cb_imon,rst_n);

modport OMON (input cb_omon,rst_n);

endinterface
