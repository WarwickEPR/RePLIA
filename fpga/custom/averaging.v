`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.11.2016 13:42:43
// Design Name: 
// Module Name: averaging
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


module averaging(

    );
endmodule

//Adds until counter highest bit resets to zero, then outputs sum and resets
module simple_summation # (
    parameter integer dat_in_bits = 16,
    parameter integer cnt_in_bits = 16
    )(
    input wire [dat_in_bits-1:0] in_data,
    input wire [cnt_in_bits-1:0] counter,
    input wire clk,
    
    output wire [dat_in_bits+cnt_in_bits-1:0] sum_out,
    output wire cnt_timer
    );
    
    reg [dat_in_bits+cnt_in_bits-1:0] sum;
    reg [dat_in_bits+cnt_in_bits-1:0] out;
    reg [dat_in_bits+cnt_in_bits-1:0] in_data2;
    reg reset;
    
    always @(posedge clk) begin
        //Sign extension on incoming data
        in_data2 <= {{(cnt_in_bits+1){in_data[dat_in_bits-1]}}, in_data[dat_in_bits-2:0]};
        //Check for reset info
        if(reset & ~counter[cnt_in_bits-1]) begin
            //Do reset
            out <= sum;
            sum <= in_data2;
        end
        else begin
            sum <= sum+in_data2;
        end
        reset <= counter[cnt_in_bits-1];
    end
       
    assign sum_out = out;
    assign cnt_timer = ~counter[cnt_in_bits-1];
endmodule

//Adds most recent sample, subtracts oldest
/*module moving_average # (
    parameter integer in_bits = 16,
    parameter integer out_bits = 16,
    parameter integer log2_samples = 8
    )(
    input wire [in_bits-1:0] in_data,
    input wire clk,
    
    output wire [out_bits-1:0] out_data
    );
    
    localparam integer samples = 2**log2_samples;
    localparam integer reg_bits = in_bits+log2_samples;
    
    reg [reg_bits-1:0] in_data2;
    reg [reg_bits-1:0] buffer [samples-1:0];
    reg [reg_bits-1:0] out_data2;
    
    genvar i;
    
    //Deal with buffer chain
    generate
    for(i = 0; i < samples-1; i = i+1) begin : gen_buffer
        always @(posedge clk) begin
            buffer[i][reg_bits-1:0] <= buffer[i+1][reg_bits-1:0];
        end
    end
    endgenerate
    
    //Deal with in and out data
    always @(posedge clk) begin
        in_data2 <= {{(log2_samples+1){in_data[in_bits-1]}}, in_data[in_bits-2:0]};
        buffer[samples-1][reg_bits-1:0] <= in_data2;
        //Update sum
        out_data2 <= out_data2 + in_data2 - buffer[0][reg_bits-1:0];
    end
    
    //Assign to out, drop highest (non signing) bit - will always be 0 due to the nature of the numbers
    assign out_data = {out_data2[reg_bits-1],out_data2[reg_bits-3:reg_bits-out_bits-1]};
endmodule*/

//Actually an IIR filter - log2_samples is the IIR bits
module moving_average # (
    parameter integer in_bits = 16,
    parameter integer out_bits = 16,
    parameter integer log2_samples = 8
    )(
    input wire [in_bits-1:0] in_data,
    input wire clk,
    
    output wire [out_bits-1:0] out_data
    );
    
    localparam integer reg_bits = in_bits+log2_samples;
    
    reg [reg_bits-1:0] out_data2 = 0;
    reg [reg_bits-1:0] in_data2 = 0;
    
    genvar i;
    
    //Deal with in and out data
    always @(posedge clk) begin
        in_data2 <= {{(log2_samples+1){in_data[in_bits-1]}}, in_data[in_bits-2:0]};
        out_data2 <= out_data2 + in_data2 - {{(log2_samples+1){out_data2[reg_bits-1]}}, out_data2[reg_bits-2:log2_samples]};
    end
    
    //Assign to out, drop highest (non signing) bit - will always be 0 due to the nature of the numbers
    assign out_data = out_data2[reg_bits-1:reg_bits-out_bits];
endmodule

module two_clk_accum # (
    parameter integer inc_bits = 32,
    parameter integer count_bits = 32,
    parameter integer out_bits = 32,
    parameter integer out_bus_size = 32 //For AXI interfaces where bus size is a multiple of 8 regardless of number of bits
    )(
    input wire count_clk,
    input wire out_clk,
    input wire sync_i,
    
    input wire [inc_bits-1:0] inc_in,
    
    output wire [out_bus_size-1:0] count_out
    );
    
    reg [count_bits-1:0] count_reg;
    reg [inc_bits-1:0] inc_reg;
    reg [inc_bits-1:0] inc_reg2;
    reg [out_bus_size-1:0] out_reg;
    reg [out_bus_size-1:0] out_reg2;
    
    //In buffer and count
    always @(posedge count_clk) begin
        inc_reg <= inc_in;
        inc_reg2 <= inc_reg;
        
        if(sync_i) begin //Reset to match phases
            count_reg <= 0;
        end
        else begin
            count_reg <= count_reg + inc_reg2;
        end
    end
    
    //Out buffer
    always @(posedge out_clk) begin
        out_reg[out_bits-1:0] <= count_reg[count_bits-1:count_bits-out_bits];
        out_reg2 <= out_reg;
    end
    
    assign count_out = out_reg2;
endmodule