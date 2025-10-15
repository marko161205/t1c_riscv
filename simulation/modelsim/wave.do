onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /tb/clk
add wave -noupdate -radix hexadecimal /tb/reset
add wave -noupdate -radix hexadecimal /tb/Ext_MemWrite
add wave -noupdate -radix hexadecimal /tb/Ext_WriteData
add wave -noupdate -radix hexadecimal /tb/Ext_DataAdr
add wave -noupdate -radix hexadecimal /tb/WriteData
add wave -noupdate -radix hexadecimal /tb/DataAdr
add wave -noupdate -radix hexadecimal /tb/ReadData
add wave -noupdate -radix hexadecimal /tb/MemWrite
add wave -noupdate -radix hexadecimal /tb/PC
add wave -noupdate -radix hexadecimal /tb/Result
add wave -noupdate -radix hexadecimal /tb/fault_instrs
add wave -noupdate -radix hexadecimal /tb/i
add wave -noupdate -radix hexadecimal /tb/fw
add wave -noupdate -radix hexadecimal /tb/flag
add wave -noupdate -radix hexadecimal /tb/uut/rvcpu/dp/alu/a
add wave -noupdate -radix hexadecimal /tb/uut/rvcpu/dp/alu/b
add wave -noupdate -radix binary /tb/uut/rvcpu/dp/alu/alu_ctrl
add wave -noupdate -radix hexadecimal /tb/uut/rvcpu/dp/alu/alu_out
add wave -noupdate -radix hexadecimal /tb/uut/rvcpu/dp/rf/reg_file_arr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {94769 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
configure wave -valuecolwidth 125
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {88080 ps} {198188 ps}
