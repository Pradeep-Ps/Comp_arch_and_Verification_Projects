// Ref_model.sv - FILE name
//
// Collaborator : PRADEEP GOVINDAN 
//
// DESCRIPTION:
// top module instantiated  my_testbench, ref_module and EPW22_if.
// Also, top module provides clock pulse to sub modules.
//
//******************************************************************
//
import def::*; //importing package definitions
module refmodel(EPW22_if.secondary intf);
	// internal declarations
	logic [xlat_size-1:0] [xlat_data_width-1:0] xlat_table; // packed array for xlat table registers **Should we initialize this to 'b0?**
	byte unsigned xlat_pointer = 8'b0; //pointer to store the last accessed location in xlat table

	logic [num_keys-1:0] [key_width-1:0] keys; // packed array for keys registers
	logic [0:tag_width**2-1] [(data_width/tag_width**2)-1:0] delay_sched; // register with delay values ***look over packed arrays

	logic [20:0] data_stream[$]; // queue for output stream with elements {result, delay}
	logic [data_width-1:0] data_A; // temporary store data_A
	logic [tag_width-1:0] temp_tag;
	logic b_flag, qpop_flag = 1'b0; // flag for if B is on data line
	logic assert_error = 1'b0;

	function void clear_states(); // clear states, soft reset (reset instruction)
		delay_sched = 'b0; // clear delay scheduler
		xlat_table = 'x; // clear xlat_table
		keys = 'b0;  // clear keys registers (set to 0)
		keys[1] = ~0; // fill register 1 with 1's
	endfunction

	task init_chip(); // initialize the chip (pin reset)
		clear_states();
		xlat_pointer = 8'h00;  // reset xlat table pointer
		temp_tag = 'b0; // clear the temp tag
		data_stream.delete(); // clear the queue
		intf.ready = 1'b1; // ready to receive input
		intf.error = 1'b0; // no output error, might need to comment this out***
		intf.valid = 1'b0; // no result provided
	endtask

	task display_table();
	`ifdef BUG
		$display($time,,,"0 xlat[%0d] = %0h", xlat_pointer, xlat_table[xlat_pointer]);
	`endif
	endtask

	always_ff @(posedge intf.clk)
	begin : device_reset
		if (intf.reset)	init_chip(); //calling task
		else
		begin
			intf.ready = 1'b1;
			assert_error = 1'b0;
		end
	end : device_reset

	always_ff @(posedge intf.clk) begin : alu_ops
		unique case (intf.op)
			// NO OPERATION
			'h0 : ;

			// Soft Reset
			'h1 : clear_states();

			// Store A in (reorder/scheduler) register (DONE IN ONE CLK)
			'h2 : delay_sched = intf.data;

			// Store A in key register B
			'h3 : begin: op_3
							if (b_flag)
							begin: reset_bflag
								if (intf.data < 2 || intf.data > 7) assert_error = 1'b1;
								else                                keys[intf.data] = data_A;
								b_flag = 1'b0;
							end: reset_bflag
							else
								{data_A, b_flag} = {intf.data, 1'b1};
						end: op_3

			// Store A,B in next table locations
			'h4 : begin: op_4
							if (b_flag)
								begin: reset_bflag
									if (xlat_pointer > 251) assert_error = 1'b1; //size of xlat table is 256(0-255) and 4 entries are made for one operation
									else
									begin: store_table
										xlat_table[xlat_pointer] = data_A[15:8]; // xlat is 8 bits, data is 16bits, storing operand A MSB 8bits in xlat table
										display_table();
										xlat_pointer++;
										xlat_table[xlat_pointer] = data_A[7:0]; // xlat is 8 bits, data is 16bits storing operand A LSB 8bits in xlat table
										display_table();
										xlat_pointer++;
										xlat_table[xlat_pointer] = intf.data[15:8]; // xlat is 8 bits, data is 16bits storing operand B MSB 8bits in xlat table from data line
										display_table();
										xlat_pointer++;
										xlat_table[xlat_pointer] = intf.data[7:0]; // xlat is 8 bits, data is 16bits storing operand B LSB 8bits in xlat table from data line
										display_table();
										xlat_pointer++;
									end: store_table
									b_flag = 1'b0;
								end: reset_bflag
								else {data_A, b_flag} = {intf.data, 1'b1};
						end: op_4

			'h5 : ; // Reserved
			'h6 : ; // Reserved
			'h7 : ; // Reserved

			// Result = RotateLeft A,B
			'h8 : begin: op_8
							if (b_flag)
							begin: reset_bflag
								data_stream.push_front({data_A << intf.data, delay_sched[temp_tag]+2'b10}); //store the data and delay in queue
								b_flag = 1'b0;
							end: reset_bflag
							else {temp_tag, data_A, b_flag} = {intf.tag, intf.data, 1'b1}; //store tag in temporary tag, store data in dataA and set B flag 1
					end: op_8

			// Result = RotateRight A,B
			'h9 : begin: op_9
						if (b_flag)
						begin: reset_bflag
							data_stream.push_front({data_A >> intf.data, delay_sched[temp_tag]+2'b10}); //store the data and delay in queue
							b_flag = 1'b0;
						end: reset_bflag
						else {temp_tag, data_A, b_flag} = {intf.tag, intf.data, 1'b1}; //store tag in temporary tag, store data in dataA and set B flag 1
						end: op_9

			// Result = XOR Reg[A],B
			'hA : begin: op_A
						if (b_flag)
						begin: reset_bflag
							if (data_A > 7 || data_A < 2) assert_error = 1'b1;
							else data_stream.push_front({keys[data_A] ^ intf.data, delay_sched[temp_tag]+2'b10}); //store the data and delay in queue
							b_flag = 1'b0;
						end: reset_bflag
						else {temp_tag, data_A, b_flag} = {intf.tag, intf.data, 1'b1}; //store tag in temporary tag, store data in dataA and set B flag 1
					end: op_A

			// Result = Table[ Reg-hi[A] ],Table[ Reg-low[A] ] (DONE IN ONE CLK)
			'hB : begin: op_B
						if (keys[intf.data][data_width-1:data_width/2] < xlat_pointer && keys[intf.data][data_width/2-1:0] < xlat_pointer) // Keys should point to table location less than pointer address location
							data_stream.push_front({xlat_table[keys[intf.data][data_width-1:data_width/2]], xlat_table[keys[intf.data][data_width/2-1:0]], delay_sched[intf.tag]+2'b10}); //concatenating the xlat table values and delay to store the data and delay in queue
						else assert_error = 1'b1;
						end: op_B

			//Reg[A] = RotateLeft Reg[A], B
			'hC : begin: op_C
						if (b_flag)
							begin: reset_bflag
								if (data_A > 7 || data_A < 2) assert_error = 1'b1; //Key value should be within 0-7 and key[0] and key[1] are reserved
								else keys[data_A] = keys[data_A] << intf.data; //rotate left the data in key[A] data times and store in key[A]
								b_flag = 1'b0;
							end: reset_bflag
							else {data_A, b_flag} = {intf.data, 1'b1};
					end: op_C

			// Reg[A] = RotateRight Reg[A], B
			'hD : begin: op_D
						if (b_flag)
						begin: reset_bflag
							if (data_A > 7 || data_A < 2) assert_error= 1'b1; //Key value should be within 0-7 and key[0] and key[1] are reserved
							else keys[data_A] = keys[data_A] >> intf.data; //rotate right the data in key[A] data times and store in key[A]
							b_flag = 1'b0;
						end:reset_bflag
						else {data_A, b_flag} = {intf.data, 1'b1};
					end: op_D

			// Reg[A] = XOR Reg[A], B
			'hE : begin: op_E
						if (b_flag)
						begin: reset_bflag
							if (data_A > 7 || data_A < 2) assert_error = 1'b1; //Key value should be within 0-7 and key[0] and key[1] are reserved
							else keys[data_A] = keys[data_A] ^ intf.data; //Xor key[A] with data
							b_flag = 1'b0;
						end: reset_bflag
						else	{data_A, b_flag} = {intf.data, 1'b1};
					end: op_E

			// Reg[A] = Table[ Reg-hi[A] ], Table[ Reg-low[A] ] (DONE IN ONE CLK)
			'hF : begin: op_F
						if (intf.data > 7 || intf.data < 2)
							if (~(keys[intf.data][data_width-1:data_width/2] < xlat_pointer && keys[intf.data][data_width/2-1:0] < xlat_pointer)) // Keys should point to table location less than pointer address location ***Ps
								assert_error = 1'b1;
						else keys[intf.data] = {xlat_table[keys[intf.data][data_width-1:data_width/2]], xlat_table[keys[intf.data][(data_width/2)-1:0]]};
						end: op_F
		endcase
	end: alu_ops

	always @(posedge intf.clk)
	begin : display_result
		foreach(data_stream[i])
		fork
		begin: foreach_block
				`ifdef BUG
					$display($time, " %0h, %0h", data_stream[i][(data_width + (tag_width**2)) -1:tag_width**2], data_stream[i][(tag_width**2)-1:0]);
		    `endif
				if (data_stream[i][(tag_width**2)-1:0]) // counter for results output delay***
				begin
					`ifdef BUG
						$display("decrement");
			    `endif
					data_stream[i] -= 1;
				end

				else if (intf.valid) // check if already result on the line
				begin
					`ifdef BUG
						$display("duplicate");
					`endif
					intf.error = 1'b1; // deassert valid?
				end

				if (data_stream[i][(tag_width**2)-1:0] == 0)
				begin
					`ifdef BUG
						$display("pop from queue to result");
					`endif
					intf.result = data_stream[i][(data_width + (tag_width**2)) -1:tag_width**2]; //***
					qpop_flag = 1'b1;
					`ifdef BUG
						$display("d[%d]: %p", i, data_stream);
					`endif
				end

				`ifdef BUG
					$display($time, " %p, d[%d]: %0h, %0h", data_stream, i, data_stream[i][(data_width + (tag_width**2)) -1:tag_width**2], data_stream[i][(tag_width**2)-1:0]);
				`endif
		end: foreach_block

			begin: set_valid
			 @(intf.result)		   intf.valid = 1'b1; //when resutl changes valid is asserted
			 @(posedge intf.clk) intf.valid = 1'b0; //deassert after one clock pulse
			end: set_valid
		join_any

		if (qpop_flag)
		begin
			data_stream = data_stream.find with (item[(data_width/tag_width**2)-1:0] != 'b0); // remove pushed results from the queue***
			qpop_flag = 1'b0;
		end
	end : display_result

	always @(assert_error)
	begin: assert_error_signal
		if (assert_error)
		begin
			intf.error = 1'b1;
		 	@(posedge intf.clk)	intf.error = 1'b0;
		end
		else intf.error = 1'b0;
	end:  assert_error_signal

endmodule : refmodel
