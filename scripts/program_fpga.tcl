###############################################################################
#
# program_fpga.tcl: Tcl script for programming bit file
# Usage:
# source /home/Xilinx/Vivado/201x.x/settings64.sh
# vivado -mode tcl vivado -mode tcl -nojournal -nolog -source program_fpga.tcl
#
#https://www.xilinx.com/support/documentation/sw_manuals/xilinx2014_4/ug908-vivado-programming-debugging.pdf
#http://eng.umb.edu/~cuckov/classes/engin341/Labs/Debug%20Tutorial/Vivado%20Debugging%20Tutorial.pdf
#
################################################################################
#set DEBUG_CORE true
set DEBUG_CORE false

set top_file system_top
set bit_file "../output/${top-file}.bit"
set fpga_device xc7k325t_0

# Set the reference directory to where the script is
set origin_dir [file dirname [info script]]
cd $origin_dir

# open_hw
open_hw_manager

# Connect to the Cable on localhost:3121
connect_hw_server -url 193.136.136.88:3121
# refresh_hw_server
# current_hw_target [get_hw_targets */xilinx_tcf/Digilent/2102033*]
# current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/000012681f5c01]
current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/000012*]
open_hw_target

# Program and Refresh the XC7K325T Device

current_hw_device [get_hw_devices ${fpga_device}]
refresh_hw_device -update_hw_probes false [current_hw_device]
#[lindex [get_hw_devices xc7k325t_0] 0]
set_property PROGRAM.FILE "${bit_file}.bit" [current_hw_device]
#[lindex [get_hw_devices $hw_device] 0]

if {$DEBUG_CORE == true} {
    set_property PROBES.FILE "${bit_file}.ltx" [current_hw_device]
    #[lindex [get_hw_devices $hw_device] 0]
} else {
    set_property PROBES.FILE  {} [current_hw_device]
    #[lindex [get_hw_devices $hw_device] 0]
}

program_hw_devices [current_hw_device]
refresh_hw_device [current_hw_device]
#program_hw_devices [get_hw_devices $hw_device]
#refresh_hw_device [lindex [get_hw_devices $hw_device] 0]

exit
