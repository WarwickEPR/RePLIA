`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2016 17:43:20
// Design Name: 
// Module Name: IO control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Various IO control
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//Make it show up in the sources
module IO_control();
endmodule

//Split the output of the DDS into separate sine and cosine
module split_AXI # (
    parameter integer OUT_DATA_WIDTH = 14,
    parameter integer IN_DATA_WIDTH = 32
    )(
    output wire [OUT_DATA_WIDTH-1:0] ch_a_out,
    output wire [OUT_DATA_WIDTH-1:0] ch_b_out,
    
    input wire [IN_DATA_WIDTH-1:0] in_data
    );
          
    localparam half_bits = IN_DATA_WIDTH/2;
    localparam out_bits = OUT_DATA_WIDTH;
    
    assign ch_a_out = in_data[out_bits-1:0];
    assign ch_b_out = in_data[half_bits+out_bits-1:half_bits];
endmodule

module comb_AXI # (
    parameter integer OUT_DATA_WIDTH = 48,
    parameter integer IN_DATA_WIDTH = 24,
    
    parameter integer fract = 0     //Special case for making fractional number (-1 to 1)
    )(
    input wire [IN_DATA_WIDTH-1:0] ch_a_in,
    input wire [IN_DATA_WIDTH-1:0] ch_b_in,
    
    output wire [OUT_DATA_WIDTH-1:0] out_data
    );
          
    localparam half_bits = OUT_DATA_WIDTH/2;
    localparam in_bits = IN_DATA_WIDTH;
    
    if(fract) begin
        assign out_data[in_bits-1:0] = {{(2){ch_a_in[in_bits-1]}},ch_a_in[in_bits-2:1]};
        assign out_data[half_bits+in_bits-1:half_bits] = {{(2){ch_b_in[in_bits-1]}},ch_b_in[in_bits-2:1]};
    end
    else begin
        assign out_data[in_bits-1:0] = ch_a_in;
        assign out_data[half_bits+in_bits-1:half_bits] = ch_b_in;
    end
endmodule

module dac_switch # (
    parameter integer twos_comp = 1
    )(
    input wire [13:0] dac_data_a,
    input wire [13:0] dac_data_b,
    output wire [13:0] dac_data_o,
    
    input wire select_i,
    input wire ddr_clk_i,
        
    output wire select_o,
    output wire ddr_clk_o1,
    output wire ddr_clk_o2
    );
    
    reg [13:0] data_a_reg;
    reg [13:0] data_b_reg;
    
    genvar i;
    
    always @(posedge select_i) begin
        if(twos_comp) begin
            //Correct for 2s complement format
            //Note that reg = 0 outputs to 1V, reg = max outputs to -1V
            data_a_reg <= {dac_data_a[13],~dac_data_a[12:0]};
            data_b_reg <= {dac_data_b[13],~dac_data_b[12:0]};
        end
        else begin
            data_a_reg <= dac_data_a;
            data_b_reg <= dac_data_b;
        end
    end
    
    
    ODDR ODDR_ddr(.Q(ddr_clk_o1), .D1(1'b0), .D2(1'b1), .C(ddr_clk_i), .CE(1'b1), .R(1'b0), .S(1'b0));
    ODDR ODDR_ddr2(.Q(ddr_clk_o2), .D1(1'b0), .D2(1'b1), .C(ddr_clk_i), .CE(1'b1), .R(1'b0), .S(1'b0));
    ODDR ODDR_sel(.Q(select_o), .D1(1'b0), .D2(1'b1), .C(select_i), .CE(1'b1), .R(1'b0), .S(1'b0));
    
   
    generate
      for(i = 0; i < 14; i = i + 1)
      begin : DAC_DAT
        ODDR ODDR_dat(
          .Q(dac_data_o[i]),
          .D1(data_a_reg[i]),
          .D2(data_b_reg[i]),
          .C(select_i),
          .CE(1'b1),
          .R(1'b0),
          .S(1'b0)
        );
      end
    endgenerate
endmodule

//Convert adc inputs into 2s complement format. Note that min input = 1V, max input = -1V, hence the negation is opposite expected
module adc_2comp # (
    parameter integer bits = 14
    )(
    input wire [bits-1:0] adc_a_i,
    input wire [bits-1:0] adc_b_i,
    
    input wire clk,
    
    output wire [bits-1:0] adc_a_o,
    output wire [bits-1:0] adc_b_o
    );
    
    reg [bits-1:0] adc_a_t;
    reg [bits-1:0] adc_b_t;
    
    always @(posedge clk) begin
        adc_a_t <= {adc_a_i[bits-1],~adc_a_i[bits-2:0]};
        adc_b_t <= {adc_b_i[bits-1],~adc_b_i[bits-2:0]};
    end
    
    assign adc_a_o = adc_a_t;
    assign adc_b_o = adc_b_t;
endmodule

//Dealing with different bus sizes.
/*
module bit_manip # (
    parameter integer in_bits = 14,
    parameter integer out_bits = 14
    )(
    input wire [in_bits-1:0] bus_in,
    output wire [out_bits-1:0] bus_out
    );
        
    localparam integer diff = out_bits-in_bits;
    
    if(diff > 0) begin
        //Set higher bits to 0 - note this is for unsigned ints only, 2s comp need different treatment
        reg [diff-1:0] blank;
        assign bus_out = {blank[diff-1:0], bus_in[in_bits-1:0]};
    end
    else if(diff < 0) begin
        //Lose the lowest bits
        assign bus_out = bus_in[in_bits-1:-diff];
    end
    else begin
        //just transfer, should not be needed
        assign bus_out = bus_in[in_bits-1:0];
    end    
endmodule
*/

//Connect the correct digital I/O pins
module digital_IO_connect # (
    //parameter integer DDS_bits = 16,
    parameter integer cnt_bits = 4 
    )(
    //input wire [DDS_bits-1:0] DDS_in,
    input wire clk,
    input wire io_slave,
    input wire [cnt_bits-1:0] cnt_in,
    input wire loop_in,
    
    output wire [cnt_bits-1:0] cnt_o,
    output wire loop_out,
    
    inout wire [7:0] io_p,
    inout wire [7:0] io_n
    );
    
    //Square wave at DDS freq on the io output line
    //assign io_p[7] = ~DDS_in[DDS_bits-1];
    //assign io_p[6] = clk;
    
    //Switch between digital io and internal numbers
    IOBUF(.T(io_slave),.I(loop_in),.O(loop_out),.IO(io_p[7]));//,.IOB(io_n[7]));
    //IOBUFDS for differential, need to change port type in ports.xdc, though (not sure what to?)
    
    genvar i;
    generate
      for(i = 0; i < cnt_bits; i = i + 1)
      begin : COUNTER_IO
        IOBUF(  //IOBUFDS for differential, need to change port type in ports.xdc, though (not sure what to?)
            .T(io_slave),
            .I(cnt_in[i]),
            .O(cnt_o[i]),
            .IO(io_p[i])//,
            //.IOB(io_n[i])
        );
      end
    endgenerate
    
    //Should possibly be using IOBUF?
endmodule

module out_val # (
    parameter integer num_bits = 1,
    parameter integer value = 1
    )(
    output wire [num_bits-1:0] out_bus
    );
    
    assign out_bus = value;
endmodule

module default_val # (
    parameter integer num_bits = 1,
    parameter integer value = 1
    )(
    input wire clk,
    input wire [num_bits-1:0] in_bus,
    output wire [num_bits-1:0] out_bus
    );
    reg [num_bits-1:0] inout_reg;
    
    always @(posedge clk) begin
        if(in_bus == 32'b0) begin
            inout_reg <= value;
        end
        else begin
            inout_reg <= in_bus;
        end
    end
    
    assign out_bus = inout_reg;
endmodule

/*
module clk_buf (
    input wire clk_p_i,
    input wire clk_n_i,
    
    output wire clk_o
    );
    
    IBUFGDS clk_buf(
        .I(clk_p_i),
        .IB(clk_n_i),
        .O(clk_o)
        );
endmodule
*/

module clk_switch (
    input wire clk_i0,
    input wire clk_i1,
    
    input wire cl_select,
    
    output wire clk_o
    );
    
    BUFGMUX clk_select(
        .I0(clk_i0),
        .I1(clk_i1),
        .S(cl_select),
        .O(clk_o)
        );
endmodule

module data_padder # (
    parameter integer in_bits = 24,
    parameter integer out_bits = 32
    )(
    input wire [in_bits-1:0] data_in,
    output wire [out_bits-1:0] data_out
    );
    
    assign data_out = {data_in,{(out_bits-in_bits){1'b0}}};
endmodule

module highest_bit # (
    parameter integer in_bits = 32
    )(
    input wire [in_bits-1:0] bus_in,
    output wire bit_out
    );
    
    assign bit_out = bus_in[in_bits-1];
endmodule