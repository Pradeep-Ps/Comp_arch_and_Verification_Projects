module mc_tb;
logic [32:0]address;
int time_tick, opcode;
int timer=0;
//logic [15:0]R, [7:0]HC, [1:0]B,[1:0]BG, [2:0]LC;
initial begin
address=$urandom;
/*R=$urandom_range(18,32);
HC=$urandom_range(10,17);
B=$urandom_range(8,9);
BG=$urandom_range(6,7);
LC=$urandom_range(3,5);
time_tick=$urandom();*/
opcode=$urandom(0,2);
time_tick=$urandom;
$display("%d %0d 0x%h", time_tick, opcode, address);
timer =timer+time_tick;                    
end
endmodule:mc_tb

/*50 0 0x01FF97000 
52 0 0x01FF87000 
55 1 0x01FF06009 
60 0 0x01FF06000 
75 0 0x100FAF800 
76 1 0x01FFB7080  
80 0 0x01FFC7000  
82 1 0x01FFD7080 
84 2 0x010FFAF00 
88 1 0x01FFFBF80 
90 2 0x01FFA5F70
103 0 0x01FFEE080
107 0 0x010FBDF00
109 1 0x01FFABF80
110 1 0x01FF6F800
112 0 0x01FFA4F80
125 0 0x010FBDF000
1300 2 0x01FFA4F80
20000 0 0x01FFA4F80
20000 2 0x01FFA4F80
20000 0 0x01FFA4F80*/
