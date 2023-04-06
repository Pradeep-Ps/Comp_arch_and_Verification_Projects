

`ifndef SCB_SV
`define SCB_SV


`uvm_analysis_imp_decl(_fifo1)
`uvm_analysis_imp_decl(_fifo2)

class scoreboard extends uvm_scoreboard;//uvm_scoreboard;

`uvm_component_utils(scoreboard)

  uvm_analysis_imp_fifo1 #(input_trans,scoreboard) fifo_aport1;
  uvm_analysis_imp_fifo2 #(output_trans,scoreboard) fifo_aport2;

  int m_matches, m_mismatches;
  bit [7:0] compare_data;



 function new( string name , uvm_component parent) ;
  super.new( name , parent );
  m_matches = 0;
  m_mismatches = 0;
 // cg=new;
 endfunction

 function void build_phase( uvm_phase phase );
   fifo_aport1 = new("fifo_aport1", this);
   fifo_aport2 = new("fifo_aport2", this);
 endfunction

 virtual function void write_fifo1(input_trans fifo_data1);
        compare_data = fifo_data1.data_in;
 endfunction

 virtual function void write_fifo2(output_trans fifo_data2);
	if (compare_data == fifo_data2.data_out)
       begin
       `uvm_info(get_full_name(),"Comparator match",UVM_MEDIUM);
        m_matches++;
       `uvm_info("Inorder Comparator", $sformatf("Matches:    %0d", m_matches),UVM_MEDIUM);
        end
       else
       begin
       `uvm_error(get_full_name(),"Comparator Mismatch");
        m_mismatches++;
       `uvm_info("Inorder Comparator", $sformatf("Mismatches: %0d", m_mismatches),UVM_MEDIUM);
       end
 endfunction


 function void report_phase( uvm_phase phase );
  `uvm_info("Inorder Comparator", $sformatf("Matches:    %0d", m_matches),UVM_MEDIUM);
  `uvm_info("Inorder Comparator", $sformatf("Mismatches: %0d", m_mismatches),UVM_MEDIUM);
 endfunction



endclass : scoreboard

`endif
