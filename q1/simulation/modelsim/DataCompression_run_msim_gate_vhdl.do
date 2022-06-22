transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vcom -93 -work work {DataCompression.vho}

vcom -93 -work work {/home/chetan/Desktop/Semester4/CS232DLDCALab/lab6/q1/Testbench.vhd}

vsim -t 1ps -L maxv -L gate_work -L work -voptargs="+acc"  Testbench

add wave *
view structure
view signals
run -all
