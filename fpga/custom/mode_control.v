`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.11.2016 18:48:38
// Design Name: 
// Module Name: mode_control_file
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


module mode_control_file(
    );
endmodule

module mode_control # (
    parameter integer in_bits_XY = 24,
    parameter integer in_bits_amp = 24,
    parameter integer in_bits_phase = 24,
    parameter integer in_bits_sweep = 16,
    parameter integer in_bits_sweep_mod = 16,
    parameter integer in_bits_sweep_mod_raw = 16,
    parameter integer in_bits_sweep_amp = 32,
    
    parameter integer phase_correct_bits = 1, //Bit shift correction to make phase use full scale (as -180 to 180)
    
    parameter integer out_bits_dac = 14
    )(
    input wire clk,
    //input wire clk2, //Secondary clock for driving clock select, from
    
    input wire [31:0] mode_flags,
    
    output wire [out_bits_dac-1:0] dac_a,
    output wire [out_bits_dac-1:0] dac_b,
    
    input wire [in_bits_XY-1:0] ch_a_X_in,
    input wire [in_bits_XY-1:0] ch_a_Y_in,
    input wire [in_bits_XY-1:0] ch_b_X_in,
    input wire [in_bits_XY-1:0] ch_b_Y_in,
    
    input wire [in_bits_amp-1:0] ch_a_amp_in,
    input wire [in_bits_amp-1:0] ch_b_amp_in,
    
    input wire [in_bits_phase-1:0] ch_a_phase_in,
    input wire [in_bits_phase-1:0] ch_b_phase_in,
    
    input wire [in_bits_sweep-1:0] sweep_in,
    input wire [in_bits_sweep_mod-1:0] sweep_mod_in,
    input wire [in_bits_sweep_mod_raw-1:0] sweep_mod_raw_in,
    input wire [in_bits_sweep_amp-1:0] sweep_amp_in,
    
    input wire sweep_loop,
    
    input wire sync_i,
    
    output wire cl_select,
    //output wire cl_reset_n,
    output wire sync_o,
    output wire ttl_o,
    output wire freq_double,
    output wire sweep_const,
    output wire io_slave
    );
    
    localparam integer phase_end = in_bits_amp-out_bits_dac-phase_correct_bits < 0 ? 0 : in_bits_amp-out_bits_dac-phase_correct_bits;
    localparam integer phase_extra_bits = in_bits_amp-out_bits_dac-phase_correct_bits < 0 ? -(in_bits_amp-out_bits_dac-phase_correct_bits) : 0;
        
    reg cl_sel_reg;
    //reg cl_res_reg;
    reg sync_out_reg;
    reg sync_flag_reg;
    reg [2:0] sync_counter;                          
    //reg [2:0] cl_sel_counter;
    
    reg [out_bits_dac-1:0] dac_a_reg;
    reg [out_bits_dac-1:0] dac_b_reg;
    
    reg [4:0] hold;
    reg ttl_o_reg;
    
    always @(posedge clk) begin
        /*
        if(cl_sel_reg != mode_flags[0]) begin //1st bit - slave mode, 1 = slave
            if(cl_sel_counter == 2'b11) begin
                cl_sel_reg <= mode_flags[0];
                cl_sel_counter <= 2'b00;
                cl_res_reg <= 1'b0;
            end
            else begin
                cl_sel_counter <= cl_sel_counter + 2'b11;
                cl_res_reg <= 1'b1;
            end
        end */
        
        cl_sel_reg <= mode_flags[0];
        
        if(mode_flags[2]) begin //3rd bit - amp or X out, 1 = amp
            if(mode_flags[7] & (mode_flags[4] | mode_flags[1])) begin   //8th bit - output Y/phase instead of X/amp, only if sweep (5th bit) or dual input (2nd bit) enabled
                dac_a_reg <= {ch_a_phase_in[in_bits_phase-1-phase_correct_bits:phase_end],{(phase_extra_bits){1'b0}}};
            end
            else begin
                dac_a_reg <= ch_a_amp_in[in_bits_amp-1:in_bits_amp-out_bits_dac];
            end
        end
        else begin
            if(mode_flags[7] & (mode_flags[4] | mode_flags[1])) begin
                dac_a_reg <= ch_a_Y_in[in_bits_amp-1:in_bits_amp-out_bits_dac];
            end
            else begin
                dac_a_reg <= ch_a_X_in[in_bits_XY-1:in_bits_amp-out_bits_dac];
            end
        end
        
        if(mode_flags[4]) begin //5th bit - output a sweep on dac 2
            if(mode_flags[5]) begin //6th bit - include modulation
                if(mode_flags[8]) begin //8th bit - modulation is square wave
                    if(sweep_mod_raw_in[in_bits_sweep_mod_raw-1]) begin
                        //Have to bit shift the sweep amplitude to get the right pk-pk height
                        dac_b_reg <= sweep_in[in_bits_sweep-1:in_bits_sweep-out_bits_dac]-{{1'b0},sweep_amp_in[in_bits_sweep_amp-1:in_bits_sweep_amp-out_bits_dac+1]};
                    end
                    else begin
                        dac_b_reg <= sweep_in[in_bits_sweep-1:in_bits_sweep-out_bits_dac]+{{1'b0},sweep_amp_in[in_bits_sweep_amp-1:in_bits_sweep_amp-out_bits_dac+1]};
                    end
                end
                else begin
                    dac_b_reg <= sweep_in[in_bits_sweep-1:in_bits_sweep-out_bits_dac]+sweep_mod_in[in_bits_sweep-1:in_bits_sweep-out_bits_dac];
                end
            end
            else begin
                dac_b_reg <= sweep_in[in_bits_sweep-1:in_bits_sweep-out_bits_dac];
            end
            if(hold > 4'b0) begin //7th bit - ttl pulse on
                //dac_a_reg <= {{1'b1},{13'b0}};
                hold <= hold + 4'b1;
            end
            else if(mode_flags[6] & sweep_loop) begin
                //dac_a_reg <= {{1'b1},{13'b0}};
                hold <= 4'b1;
                ttl_o_reg <= 1'b1;
            end
            else begin
                ttl_o_reg <= 1'b0;
            end
        end
        else begin
            ttl_o_reg <= 1'b0;
            if(mode_flags[1]) begin //2nd bit - number of inputs, 1 = dual input
                if(mode_flags[2]) begin //3rd bit - amp or X out, 1 = amp
                    if(mode_flags[7]) begin   //8th bit - output Y/phase instead of X/amp
                        dac_b_reg <= {ch_b_phase_in[in_bits_phase-1-phase_correct_bits:phase_end],{(phase_extra_bits){1'b0}}};
                    end
                    else begin
                        dac_b_reg <= ch_b_amp_in[in_bits_amp-1:in_bits_amp-out_bits_dac];
                    end
                end
                else begin
                    if(mode_flags[7]) begin   //8th bit - output Y/phase instead of X/amp
                        dac_b_reg <= ch_b_Y_in[in_bits_amp-1:in_bits_amp-out_bits_dac];
                    end
                    else begin
                        dac_b_reg <= ch_b_X_in[in_bits_XY-1:in_bits_amp-out_bits_dac];
                     end
                end
            end
            else begin
                if(mode_flags[2]) begin //3rd bit - amp/phase or X/y out, 1 = amp
                    dac_b_reg <= {ch_a_phase_in[in_bits_phase-1-phase_correct_bits:phase_end],{(phase_extra_bits){1'b0}}};
                end
                else begin
                    dac_b_reg <= ch_a_Y_in[in_bits_XY-1:in_bits_amp-out_bits_dac];
                end
            end
        end
        
        if(mode_flags[0]) begin //Pass through sync signal when slave
            sync_out_reg <= sync_i;
        end
        else if(sync_flag_reg != mode_flags[3]) begin //4th bit, sync flag (master only)
            if(sync_counter[0] && sync_counter[1]) begin
                //Turn sysnc signal off
                sync_counter <= 2'b00;
                sync_out_reg <= 1'b0;
                sync_flag_reg <= mode_flags[3];
            end
            else begin //Send sync signal
                sync_counter <= sync_counter + 2'b01;
                sync_out_reg <= 1'b1;
            end
        end
        else begin
            sync_counter <= 2'b00;
        end
    end
    
    assign dac_a = dac_a_reg;
    assign dac_b = dac_b_reg;
    
    assign cl_select = cl_sel_reg;
    //assign cl_reset_n = cl_res_reg;
    assign sync_o = sync_out_reg;
    assign ttl_o = ttl_o_reg;
    
    assign sweep_const = mode_flags[9]; //10th bit - sweep is a constant
    assign freq_double = mode_flags[10]; //11th bit - frequency doubling
    assign io_slave = (mode_flags[0] & mode_flags[11]); //12th bit - use IO for counting, not internal generated, slave only
endmodule

module accumulator_limited # (
    parameter integer in_bits = 32,
    parameter integer accum_bits = 32,
    parameter integer out_bits = 16
    )(
    input wire [in_bits-1:0] min,
    input wire [in_bits-1:0] max,
    input wire [in_bits-1:0] add,
    input wire const_flag,
    
    output wire [out_bits-1:0] sweep_out,
    
    input wire clk,
    input wire sync,
    
    output wire loop_o
    );
    
    reg [accum_bits:0] stored; //Extra bit to enable looping at max range
    reg loop_reg;
    reg [5:0] loop_cnt;
    
    always @(posedge clk) begin
        if(sync) begin
            stored[accum_bits] = 0;
            stored[accum_bits-1:accum_bits-in_bits] <= min;
            loop_reg <= 1'b1;
        end
        else if(stored[accum_bits:accum_bits-in_bits] >= {1'b0,max}) begin
            stored[accum_bits] = 0;
            stored[accum_bits-1:accum_bits-in_bits] <= min;
            loop_reg <= 1'b1;
        end
        else begin
            stored <= stored+add;
        end
        //Keep loop register on for a period - 512 ns hold - to improve data over IO pins
        if(loop_reg & ~loop_cnt[5]) begin
            loop_cnt <= loop_cnt + 6'b1;
        end
        else if(loop_reg) begin
            loop_cnt <= 6'b0;
            loop_reg <= 1'b0;
        end
    end
    
    //Output can be chosen to be a constant value
    //Converting from linear to 2s comp
    assign sweep_out = const_flag ? {~min[in_bits-1],min[in_bits-2:in_bits-out_bits]} : {~stored[accum_bits-1],stored[accum_bits-2:accum_bits-out_bits]};
    assign loop_o = loop_reg;
endmodule

module ttl_insert # (
    parameter integer num_bits = 14
    )(
    input wire [num_bits-1:0] dat_in,
    output wire [num_bits-1:0] dat_out,
    
    input wire ttl_in,
    input wire clk
    );
    
    reg [num_bits-1:0] out_reg;
    
    always @(posedge clk) begin
        if(ttl_in) begin
            out_reg <= {{1'b1},{(num_bits-1){1'b0}}};
        end
        else begin
            out_reg <= dat_in;
        end
    end
    
    assign dat_out = out_reg;
endmodule

module freq_doubler # (
    parameter integer num_bits = 16
    )(
    input wire [num_bits-1:0] phase_in,
    output wire [num_bits-1:0] phase_out,
    
    input wire freq_double,
    input wire clk
    );
    
    reg [num_bits-1:0] phase_reg;
    
    always @(posedge clk) begin
        if(freq_double) begin
            phase_reg <= {phase_in[num_bits-2:0],{1'b0}};
        end
        else begin
            phase_reg <= phase_in;
        end
    end
    
    assign phase_out = phase_reg;
endmodule