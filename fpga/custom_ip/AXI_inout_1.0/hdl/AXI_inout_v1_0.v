
`timescale 1 ns / 1 ps

	module AXI_inout_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 8
	)
	(
		// Users to add ports here
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out0,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out1,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out2,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out3,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out4,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out5,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out6,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out7,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out8,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out9,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out10,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out11,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out12,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out13,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out14,
        output wire [C_S00_AXI_DATA_WIDTH-1:0] out15,
        
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in32,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in33,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in34,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in35,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in36,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in37,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in38,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in39,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in40,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in41,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in42,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in43,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in44,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in45,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in46,
        input wire [C_S00_AXI_DATA_WIDTH-1:0] in47,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI

	AXI_inout_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) AXI_inout_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3),
        .out4(out4),
        .out5(out5),
        .out6(out6),
        .out7(out7),
        .out8(out8),
        .out9(out9),
        .out10(out10),
        .out11(out11),
        .out12(out12),
        .out13(out13),
        .out14(out14),
        .out15(out15),
        .in32(in32),
        .in33(in33),
        .in34(in34),
        .in35(in35),
        .in36(in36),
        .in37(in37),
        .in38(in38),
        .in39(in39),
        .in40(in40),
        .in41(in41),
        .in42(in42),
        .in43(in43),
        .in44(in44),
        .in45(in45),
        .in46(in46),
        .in47(in47)
	);

	// Add user logic here

	// User logic ends

	endmodule
