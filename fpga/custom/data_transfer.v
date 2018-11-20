`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2016 16:22:46
// Design Name: 
// Module Name: data_transfer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module data_transfer(

    );
endmodule

module simp_counter # (
    parameter CNT_BITS = 8
    )(
    input wire clk,
    input wire inc_clk,
    input wire sync_i,
    
    output wire [CNT_BITS-1:0] count
    );
    
    reg [CNT_BITS-1:0] count_reg;
    reg inc_last;
    
    always @(posedge clk) begin
        if(sync_i) begin    //Syncronise RPs
            count_reg <= {(CNT_BITS){1'b1}};
        end
        else if(~inc_clk & inc_last) begin   //Count after loop signal goes to 0, to avoid mismatch over synced devices)
            count_reg <= count_reg + 1'b1;
        end
        inc_last <= inc_clk;
    end
    
    assign count = count_reg;
endmodule

module mem_manager # (
    parameter MEM_WIDTH = 32'h00800000,
    parameter integer ADDR_WIDTH = 32,
    parameter integer DATA_WIDTH = 32,
    parameter integer COUNTER_WIDTH = 8,
    parameter integer SAVE_WIDTH = 32
    )(
    input wire clk,
    input wire sample,
    input wire loop_flag,
    input wire [COUNTER_WIDTH-1:0] counter,
    output wire [ADDR_WIDTH-1:0] offset,
    output wire [SAVE_WIDTH-1:0] start_addr,
    output wire [SAVE_WIDTH-1:0] end_addr,
    output wire [SAVE_WIDTH-1:0] counter_full,
    output wire [COUNTER_WIDTH-1:0] counter_min
    );
    
    localparam integer data_size = DATA_WIDTH/8;
    
    reg sample_last;
    reg loop_last;
    reg [ADDR_WIDTH-1:0] offset_reg;
    reg [SAVE_WIDTH-1:0] next_reg;
    reg [SAVE_WIDTH-1:0] start_reg;
    reg [SAVE_WIDTH-1:0] end_reg;
    reg [SAVE_WIDTH-1:0] counter_reg;
    
    always @(posedge clk) begin
        sample_last <= sample;
        loop_last <= loop_flag;
        if(sample & ~sample_last) begin
            if(offset_reg + data_size >= MEM_WIDTH) begin
                offset_reg <= {(ADDR_WIDTH){1'b0}};
            end
            else begin
                offset_reg <= offset_reg + data_size;
            end
        end
        if(loop_flag & ~loop_last) begin
            start_reg <= next_reg;
            end_reg <= offset_reg;
            counter_reg[COUNTER_WIDTH-1:0] <= counter;
            if(offset_reg + data_size >= MEM_WIDTH) begin
                next_reg <= {(ADDR_WIDTH){1'b0}};
            end
            else begin
                next_reg <= offset_reg + data_size;
            end
        end
    end
    
    assign offset = offset_reg;
    assign start_addr = start_reg;
    assign end_addr = end_reg;
    assign counter_full = counter_reg;
    assign counter_min = counter_reg[COUNTER_WIDTH-1:0];
endmodule

module data_writer # (
    // Users to add parameters here
    parameter USER_ID = 4'b0000,
    // User parameters ends
    // Do not modify the parameters beyond this line

    // Base address of targeted slave
    parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
    // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
    parameter integer C_M_AXI_BURST_LEN	= 1,
    // Thread ID Width
    parameter integer C_M_AXI_ID_WIDTH	= 4,
    // Width of Address Bus
    parameter integer C_M_AXI_ADDR_WIDTH	= 32,
    // Width of Data Bus
    parameter integer C_M_AXI_DATA_WIDTH	= 32,
    // Width of User Write Address Bus
    parameter integer C_M_AXI_AWUSER_WIDTH	= 0,
    // Width of User Write Data Bus
    parameter integer C_M_AXI_WUSER_WIDTH	= 0,
    // Width of User Response Bus
    parameter integer C_M_AXI_BUSER_WIDTH	= 0
	)(
    // Users to add ports here
    input wire [C_M_AXI_ADDR_WIDTH-1:0] offset,
    input wire [C_M_AXI_DATA_WIDTH-1:0] data_in,
    input wire do_output,
    output wire done,
    // User ports ends
    // Do not modify the ports beyond this line

    // Global Clock Signal.
    input wire CLK,
    // Global Reset Singal. This Signal is Active Low
    input wire  M_AXI_ARESETN,
    // Master Interface Write Address ID
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
    // Master Interface Write Address
    output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
    // Burst length. The burst length gives the exact number of transfers in a burst
    output wire [7 : 0] M_AXI_AWLEN,
    // Burst size. This signal indicates the size of each transfer in the burst
    output wire [2 : 0] M_AXI_AWSIZE,
    // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
    output wire [1 : 0] M_AXI_AWBURST,
    // Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
    output wire  M_AXI_AWLOCK,
    // Memory type. This signal indicates how transactions
    // are required to progress through a system.
    output wire [3 : 0] M_AXI_AWCACHE,
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    output wire [2 : 0] M_AXI_AWPROT,
    // Quality of Service, QoS identifier sent for each write transaction.
    output wire [3 : 0] M_AXI_AWQOS,
    // Optional User-defined signal in the write address channel.
    output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
    // Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
    output wire  M_AXI_AWVALID,
    // Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
    input wire  M_AXI_AWREADY,
    // Master Interface Write ID
    output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_WID,
    // Master Interface Write Data.
    output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
    // Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
    output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
    // Write last. This signal indicates the last transfer in a write burst.
    output wire  M_AXI_WLAST,
    // Optional User-defined signal in the write data channel.
    output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
    // Write valid. This signal indicates that valid write
    // data and strobes are available
    output wire  M_AXI_WVALID,
    // Write ready. This signal indicates that the slave
    // can accept the write data.
    input wire  M_AXI_WREADY,
    // Master Interface Write Response.
    input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
    // Write response. This signal indicates the status of the write transaction.
    input wire [1 : 0] M_AXI_BRESP,
    // Optional User-defined signal in the write response channel
    input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
    // Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
    input wire  M_AXI_BVALID,
    // Response ready. This signal indicates that the master
    // can accept a write response.
    output wire  M_AXI_BREADY
	);

    // function called clogb2 that returns an integer which has the 
    // value of the ceiling of the log base 2.                      
    function integer clogb2 (input integer bit_depth);              
    begin                                                           
    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
      bit_depth = bit_depth >> 1;                                 
    end                                                           
    endfunction 

	// AXI4LITE signals
	//AXI4 internal temp signals
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg axi_awvalid;
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	axi_wdata;
	reg axi_wlast;
	reg axi_wvalid;
	reg axi_bready;
    
    reg working;

	// I/O Connections assignments

	//I/O Connections. Write Address (AW)
	assign M_AXI_AWID	= USER_ID;
	//The AXI address is a concatenation of the target base address + active offset range
	assign M_AXI_AWADDR	= C_M_TARGET_SLAVE_BASE_ADDR + axi_awaddr;
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_AWLEN	= C_M_AXI_BURST_LEN - 1;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
	assign M_AXI_AWSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_AWBURST	= 2'b01;
	assign M_AXI_AWLOCK	= 1'b0;
	//Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
	assign M_AXI_AWCACHE	= 4'b0010;
	assign M_AXI_AWPROT	= 3'h0;
	assign M_AXI_AWQOS	= 4'h0;
	assign M_AXI_AWUSER	= 'b1;
	assign M_AXI_AWVALID	= axi_awvalid;
	//Write Data(W)
	assign M_AXI_WID	= USER_ID;
	assign M_AXI_WDATA	= axi_wdata;
	//All bursts are complete and aligned in this example
	assign M_AXI_WSTRB	= {(C_M_AXI_DATA_WIDTH/8){1'b1}};
	assign M_AXI_WLAST	= axi_wlast;
	assign M_AXI_WUSER	= 'b0;
	assign M_AXI_WVALID	= axi_wvalid;
	//Write Response (B)
	assign M_AXI_BREADY	= axi_bready;
	
	assign done = ~working;

    always @(posedge CLK) begin
        if(do_output & ~working) begin
            working <= 1'b1;
            axi_awaddr <= offset;
            axi_wdata <= data_in;
            axi_awvalid <= 1'b1;
        end
        else if(working) begin
            if(axi_awvalid & M_AXI_AWREADY) begin
                axi_awvalid <= 1'b0;
                axi_wvalid <= 1'b1;
                axi_wlast <= 1'b1;
                axi_bready <= 1'b1;
            end
            else if(axi_wvalid & M_AXI_WREADY) begin
                axi_wvalid <= 1'b0;
                axi_wlast <= 1'b0;
            end
            else if(axi_bready & M_AXI_BVALID) begin
                axi_bready <= 1'b0;
                working <= 1'b0;
            end
        end
    end
endmodule