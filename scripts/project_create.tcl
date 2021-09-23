###############################################################################
#
# project_implement.tcl: Tcl script for creating the VIVADO project
# Usage:
# Open Vivado IDE 20xx.x
# Menu Tools->Run Tcl Script-> (this file)
################################################################################

set top_file system_top
# Set the reference directory to where the script is
set origin_dir [file dirname [info script]]

cd $origin_dir
#
################################################################################
# define paths
################################################################################

set path_rtl ../src/hdl
set path_ip  ../src/ip
set path_xdc ../src/constraints

################################################################################
# setup the project
################################################################################

#set part xc7k325tfbg676-2
# set part xc7k325tfbg676-2
set device "xc7k325tffg900-2"
set board [lindex [lsearch -all -inline [get_board_parts] *kc705*] end]

# Create project
create_project vivado_project "$origin_dir/../vivado_project" -force -part $device

set_property board_part xilinx.com:kc705:part0:1.5 [current_project]
#set_property board_part $board [current_project]
################################################################################
# read files:
# 1. RTL design sources
# 2. IP database files
# 3. constraints
################################################################################

add_files                             $path_rtl

#set_property top top [current_fileset]
set_property top_file {$path_rtl/$top_file.sv} [current_fileset]

# read_ip    $path_ip/xdma_id0032/xdma_id0032.xci
set values {xdma_id7024 axis_data_fifo_0  blk_mem_gen_0}	;# Odd numbers first, for fun!
foreach x $values {	;# Now loop and print...
    read_ip    $path_ip/${x}/${x}.xci
}


#generate_target  all [get_ips] -force
#https://www.xilinx.com/support/answers/58526.html
# set_property generate_synth_checkpoint false [get_files $path_ip/xdma_id7024/xdma_id7024.xci]
generate_target  {all} [get_ips]
#
add_files              $path_xdc
# read_xdc   $path_xdc/atca_mimo_v2_adc_x4g2.xdc

# Optional: to implement put on Tcl Console
# update_compile_order -fileset sources_1
# launch_runs impl_1 -to_step write_bitstream -jobs 4
#
puts "INFO: Project created: vivado_project"
