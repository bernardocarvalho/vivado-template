#On TCL Console run
#open_hw
#connect_hw_server -url 10.136.253.55:3121
#	source 4/fpga-kc705-pcie/program_bpi.tcl

# Vivado (TM) v2018.3 (64-bit)
#
# program_bpi.tcl: Tcl script
#
# Set the reference directory to where the script is
#set hw_dev 2

set fpga_device xc7k325t_0

open_hw

connect_hw_server -url localhost:3121
#refresh_hw_server
# Change to the programmer reference here
#current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210203341302A]
#current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/000012681f5c01]
current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/000012929e2a01]
open_hw_target

current_hw_device [get_hw_devices ${fpga_device}]
refresh_hw_device -update_hw_probes false [current_hw_device]
#[lindex [get_hw_devices ${fpga_device}] 0]
create_hw_bitstream -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM_BITFILE [current_hw_device]]
program_hw_devices [current_hw_device]
refresh_hw_device [current_hw_device]

#    create_hw_cfgmem -hw_device [lindex [get_hw_devices] 0] -mem_dev [lindex [get_cfgmem_parts {s25fl256sxxxxxx0-spi-x1_x2_x4}] 0]
#set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${fpga_device}] 0]]
#set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${fpga_device}] 0]]
#set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices ${fpga_device}] 0]]
#endgroup
