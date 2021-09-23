`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2021 11:01:13 AM
// Design Name: 
// Module Name: xdma_pckt_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:  // Block ram for the AXI Lite interface
// 
//////////////////////////////////////////////////////////////////////////////////


module xdma_pckt_gen #(
    parameter C_DATA_WIDTH    = 64,         // RX/TX interface data width, only 64 is implemented
//    parameter MAX_PAYLOAD  = 10'd128,      // 32 or 64 or 128 DW. Check your PCIe hardware, e.g  lspci -vv -d :30

    // Do not override parameters below this line
    parameter KEEP_WIDTH = C_DATA_WIDTH / 8,              // TSTRB width
    parameter TCQ        = 1
)(
    input user_clk,
    input user_resetn,
    
    input data_clk,
/*    
    input  s_axis_tvalid,
    output s_axis_tready,
    input [(C_DATA_WIDTH-1):0] s_axis_tdata,
    input [(KEEP_WIDTH-1):0]   s_axis_tkeep,
    input s_axis_tlast,
*/
    output m_axis_tvalid,xdma_pckt_gen,
    input  m_axis_tready,
    output [(C_DATA_WIDTH-1):0] m_axis_tdata,
    output [(KEEP_WIDTH-1):0]   m_axis_tkeep,
    output m_axis_tlast,
    
    input  wire         USER_CLOCK_156
   
);

    reg [5:0] data_clk_cnt=0;
    //wire data_clk_i = data_clk;

    reg [30:0] data_cnt=0;
    //wire data_clk_i = data_clk;

    always @ (posedge USER_CLOCK_156)
            data_clk_cnt  <= #TCQ data_clk_cnt + 1;

//    wire data_clk_i = data_clk_cnt[4]; 
//    wire data_clk_i = data_clk_cnt[1]; // 
    wire data_clk_i = data_clk_cnt[2]; // 156*8/8
    
    always @ (posedge data_clk_i)
        if (!user_resetn) begin
            data_cnt  <= #TCQ 0;
        end
        else
            if(s_axis_tready)
                data_cnt  <= #TCQ data_cnt + 1;
            
    wire s_axis_tlast_i = (data_cnt[8:0]==9'h1FF)? 1:0; // 32kB packet
    
    wire [(C_DATA_WIDTH-1):0] data_i = {data_cnt, 1'b1, data_cnt, 1'b0};
        
    axis_data_fifo_0 axis_data_fifo_i (
        .s_axis_aresetn(user_resetn),  // input wire s_axis_aresetn
        
        .s_axis_aclk(data_clk_i),        // input wire s_axis_aclk
       
        .s_axis_tvalid(s_axis_tready),    // input wire s_axis_tvalid
        .s_axis_tready(s_axis_tready),    // output wire s_axis_tready
        .s_axis_tdata(data_i),      // input wire [63 : 0] s_axis_tdata
        .s_axis_tkeep(8'hFF),      // input wire [7 : 0] s_axis_tkeep
        .s_axis_tlast(s_axis_tlast_i),      // input wire s_axis_tlast
     
        .m_axis_aclk(user_clk),        // input wire m_axis_aclk
        .m_axis_tvalid(m_axis_tvalid),    // output wire m_axis_tvalid
        .m_axis_tready(m_axis_tready),    // input wire m_axis_tready
        .m_axis_tdata(m_axis_tdata),      // output wire [63 : 0] m_axis_tdata
        .m_axis_tkeep(m_axis_tkeep),      // output wire [7 : 0] m_axis_tkeep
        .m_axis_tlast(m_axis_tlast)      // output wire m_axis_tlast
    );
            
    endmodule
        
        
