# Usage:
# source /home/Xilinx/Vivado/20xx.x/settings64.sh
# vivado -mode batch -source program_spi_flash_mem.tcl
#
#
# Set the reference directory to where the script is
set prog_file atcav2xdma
set mcs_file "../output/${prog_file}.mcs"

set fpga_device xc7k325t_0
set cfgParts "s25fl256sxxxxxx0-spi-x1_x2_x4"

open_hw

# connect_hw_server -url localhost:3121
connect_hw_server -url 193.136.136.88:3121
#refresh_hw_server
# Change to the programmer reference here
# current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210203341302A]
# current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/000012681f5c01]
# current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/000012929e2a01]
current_hw_target [get_hw_targets */xilinx_tcf/Xilinx/000012*]
open_hw_target

current_hw_device [get_hw_devices ${fpga_device}]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices ${fpga_device}] 0]
create_hw_cfgmem -hw_device [current_hw_device] [lindex $cfgParts 0 ]
set cfgMem [current_hw_cfgmem]
set_property PROGRAM.FILES $mcs_file $cfgMem
set_property PROGRAM.ADDRESS_RANGE  {use_file} $cfgMem
set_property PROGRAM.BLANK_CHECK  1 $cfgMem
set_property PROGRAM.ERASE  1 $cfgMem
set_property PROGRAM.CFG_PROGRAM  1 $cfgMem
set_property PROGRAM.VERIFY  1 $cfgMem
set_property PROGRAM.BPI_RS_PINS {none} $cfgMem
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} $cfgMem
create_hw_bitstream -hw_device [current_hw_device] [get_property PROGRAM.HW_CFGMEM_BITFILE [current_hw_device]]
program_hw_devices [current_hw_device]
refresh_hw_device [current_hw_device]
program_hw_cfgmem $cfgMem
boot_hw_device [current_hw_device]

