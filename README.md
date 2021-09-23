# vivado-template

## Getting started

1.  Prerequisites
 * The Master branch in currently using [Vivado Design Suite](https://www.xilinx.com/support/download.html),
 version 2019.2, which needs a valid license to compile projects using Xilinx Kintex-7 XC7K325T FPGA

2.  Clone repository and `cd vivado-template` to the folder:  
` git clone --recurse-submodules https://github.com/bernardocarvalho/vivado-template `

3. Create and build the project in Vivado **Project Mode** (with GUI)

Open Vivado IDE and do:
```
 Menu Tools->Run Tcl Script-> "scripts/project_create.tcl"
 You will need to (re-)generate IP cores in used in the Project, at least 
 PCIe XDMA endpoint/DMA engine.

```
Project files will be generated in `vivado_project` folder

4. (optional) Build the project in Vivado **non-Project Mode** (CLI in Linux)

* Open a Linux console and Run:
```
 [~]source [...]/Xilinx/Vivado/2019.2/settings64.sh
 [~]time vivado -mode batch -source project_implement_kc705.tcl

```

 Generated files will be in `output` folder.

 The Project should compile in ~ 15 minutes on a Intel i7 4-core Machine.

5. Program the FPGA (Kintex 7) in **non-Project Mode**, for temporary testing.
```
 [~]vivado -mode batch -source scripts/program_fpga_kc705.tcl
```
* You may need to change the reference ID to your JTAG programmer. 
* This may be well connected a remote machine running the Xilinx Hardware [Server](https://www.xilinx.com/member/forms/download/xef-vivado.html?filename=Xilinx_HW_Server_Lin_2019.2_1106_2127.tar.gz). 
(You MUST use the same Vivado version!)

6. Program the FPGA configuration Memory and reboot FPGA.
* Note: Trenz Module has a SPI Memory type `s25fl256sxxxxxx0-spi-x1_x2_x4`
* (optional) In **non-Project Mode**:

```
 [~] vivado -mode batch -source scripts/program_spi.tcl
```
    

