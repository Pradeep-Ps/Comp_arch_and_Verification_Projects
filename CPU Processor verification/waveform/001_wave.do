onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {BUS Input}
add wave -noupdate /top/bus/clk
add wave -noupdate /top/bus/data
add wave -noupdate /top/bus/op
add wave -noupdate /top/bus/tag
add wave -noupdate /top/bus/reset
add wave -noupdate -divider {Model Output}
add wave -noupdate /top/bus/result
add wave -noupdate /top/bus/rtag
add wave -noupdate /top/bus/valid
add wave -noupdate /top/bus/ready
add wave -noupdate /top/bus/error
add wave -noupdate -divider {DUT Output}
add wave -noupdate /top/bus/duv_result
add wave -noupdate /top/bus/duv_rtag
add wave -noupdate /top/bus/duv_ready
add wave -noupdate /top/bus/duv_valid
add wave -noupdate /top/bus/duv_error
add wave -noupdate -divider {Model Internals}
add wave -noupdate /top/model/data_A
add wave -noupdate /top/model/b_flag
add wave -noupdate /top/model/delay_sched
add wave -noupdate /top/model/keys
add wave -noupdate /top/model/xlat_table
add wave -noupdate /top/model/xlat_pointer
add wave -noupdate /top/model/assert_error
add wave -noupdate -divider {DUT Internals}
add wave -noupdate /top/duv/data_A
add wave -noupdate /top/duv/b_flag
add wave -noupdate /top/duv/delay_sched
add wave -noupdate /top/duv/keys
add wave -noupdate /top/duv/xlat_table
add wave -noupdate /top/duv/xlat_pointer
add wave -noupdate /top/duv/assert_error
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 188
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {824 ns} {904 ns}
