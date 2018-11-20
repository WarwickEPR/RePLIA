//Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2016.3 (win64) Build 1682563 Mon Oct 10 19:07:27 MDT 2016
//Date        : Sun Apr 29 21:04:50 2018
//Host        : Mark-i5 running 64-bit Service Pack 1  (build 7601)
//Command     : generate_target system.bd
//Design      : system
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module DDS_imp_75IOFP
   (cos_out,
    cos_shift_out,
    count_clk,
    freq_double,
    inc_in,
    out_clk,
    phase_lead,
    sin_out,
    sync_i);
  output [15:0]cos_out;
  output [15:0]cos_shift_out;
  input count_clk;
  input freq_double;
  input [31:0]inc_in;
  input out_clk;
  input [15:0]phase_lead;
  output [15:0]sin_out;
  input sync_i;

  wire [15:0]c_addsub_0_S;
  wire count_clk_1;
  wire [31:0]dds_compiler_0_m_axis_data_tdata;
  wire [31:0]dds_compiler_1_m_axis_data_tdata;
  wire freq_double_1;
  wire [15:0]freq_doubler_0_phase_out;
  wire [31:0]inc_in_1;
  wire out_clk_1;
  wire [0:0]out_val_0_out_bus;
  wire [15:0]phase_gen_count_out;
  wire [15:0]phase_lead_1;
  wire [15:0]split_AXI_0_ch_a_out;
  wire [15:0]split_AXI_0_ch_b_out;
  wire [15:0]split_AXI_1_ch_a_out;
  wire sync_i_1;

  assign cos_out[15:0] = split_AXI_0_ch_a_out;
  assign cos_shift_out[15:0] = split_AXI_1_ch_a_out;
  assign count_clk_1 = count_clk;
  assign freq_double_1 = freq_double;
  assign inc_in_1 = inc_in[31:0];
  assign out_clk_1 = out_clk;
  assign phase_lead_1 = phase_lead[15:0];
  assign sin_out[15:0] = split_AXI_0_ch_b_out;
  assign sync_i_1 = sync_i;
  system_c_addsub_0_2 c_addsub_0
       (.A(phase_gen_count_out),
        .B(phase_lead_1),
        .CLK(out_clk_1),
        .S(c_addsub_0_S));
  system_dds_compiler_0_0 dds_compiler_0
       (.aclk(out_clk_1),
        .m_axis_data_tdata(dds_compiler_0_m_axis_data_tdata),
        .s_axis_phase_tdata(freq_doubler_0_phase_out),
        .s_axis_phase_tvalid(out_val_0_out_bus));
  system_dds_compiler_0_1 dds_compiler_1
       (.aclk(out_clk_1),
        .m_axis_data_tdata(dds_compiler_1_m_axis_data_tdata),
        .s_axis_phase_tdata(c_addsub_0_S),
        .s_axis_phase_tvalid(out_val_0_out_bus));
  system_freq_doubler_0_0 freq_doubler_0
       (.clk(out_clk_1),
        .freq_double(freq_double_1),
        .phase_in(phase_gen_count_out),
        .phase_out(freq_doubler_0_phase_out));
  system_out_val_0_0 out_val_0
       (.out_bus(out_val_0_out_bus));
  system_two_clk_accum_1_0 phase_gen
       (.count_clk(count_clk_1),
        .count_out(phase_gen_count_out),
        .inc_in(inc_in_1),
        .out_clk(out_clk_1),
        .sync_i(sync_i_1));
  system_split_AXI_0_0 split_AXI_0
       (.ch_a_out(split_AXI_0_ch_a_out),
        .ch_b_out(split_AXI_0_ch_b_out),
        .in_data(dds_compiler_0_m_axis_data_tdata));
  system_split_AXI_0_2 split_AXI_1
       (.ch_a_out(split_AXI_1_ch_a_out),
        .in_data(dds_compiler_1_m_axis_data_tdata));
endmodule

module Lock_in_X_imp_QSDFYO
   (CLK,
    cnt_inc,
    counter,
    out_data,
    ref_in,
    signal_in);
  input CLK;
  input [31:0]cnt_inc;
  input [31:0]counter;
  output [23:0]out_data;
  input [15:0]ref_in;
  input [13:0]signal_in;

  wire [13:0]adc_2comp_0_adc_a_o;
  wire [31:0]cnt_inc_1;
  wire [31:0]counter_1;
  wire [23:0]moving_average_0_out_data;
  wire [23:0]mult_gen_0_P;
  wire [23:0]mult_gen_1_P;
  wire ps_0_FCLK_CLK0;
  wire [15:0]ref_in_1;
  wire simple_summation_0_cnt_timer;
  wire [55:0]simple_summation_0_sum_out;

  assign adc_2comp_0_adc_a_o = signal_in[13:0];
  assign cnt_inc_1 = cnt_inc[31:0];
  assign counter_1 = counter[31:0];
  assign out_data[23:0] = moving_average_0_out_data;
  assign ps_0_FCLK_CLK0 = CLK;
  assign ref_in_1 = ref_in[15:0];
  system_moving_average_0_4 moving_average_0
       (.clk(simple_summation_0_cnt_timer),
        .in_data(mult_gen_1_P),
        .out_data(moving_average_0_out_data));
  system_mult_gen_0_7 mult_gen_0
       (.A(adc_2comp_0_adc_a_o),
        .B(ref_in_1),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_0_P));
  system_mult_gen_1_5 mult_gen_1
       (.A(simple_summation_0_sum_out),
        .B(cnt_inc_1),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_1_P));
  system_simple_summation_0_4 simple_summation_0
       (.clk(ps_0_FCLK_CLK0),
        .cnt_timer(simple_summation_0_cnt_timer),
        .counter(counter_1),
        .in_data(mult_gen_0_P),
        .sum_out(simple_summation_0_sum_out));
endmodule

module Lock_in_X_imp_RA8R3R
   (CLK,
    cnt_inc,
    counter,
    out_data,
    ref_in,
    signal_in);
  input CLK;
  input [31:0]cnt_inc;
  input [31:0]counter;
  output [23:0]out_data;
  input [15:0]ref_in;
  input [13:0]signal_in;

  wire [13:0]adc_2comp_0_adc_a_o;
  wire [31:0]cnt_inc_1;
  wire [31:0]counter_1;
  wire [23:0]moving_average_0_out_data;
  wire [23:0]mult_gen_0_P;
  wire [23:0]mult_gen_1_P;
  wire ps_0_FCLK_CLK0;
  wire [15:0]ref_in_1;
  wire simple_summation_0_cnt_timer;
  wire [55:0]simple_summation_0_sum_out;

  assign adc_2comp_0_adc_a_o = signal_in[13:0];
  assign cnt_inc_1 = cnt_inc[31:0];
  assign counter_1 = counter[31:0];
  assign out_data[23:0] = moving_average_0_out_data;
  assign ps_0_FCLK_CLK0 = CLK;
  assign ref_in_1 = ref_in[15:0];
  system_moving_average_0_1 moving_average_0
       (.clk(simple_summation_0_cnt_timer),
        .in_data(mult_gen_1_P),
        .out_data(moving_average_0_out_data));
  system_mult_gen_0_0 mult_gen_0
       (.A(adc_2comp_0_adc_a_o),
        .B(ref_in_1),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_0_P));
  system_mult_gen_1_0 mult_gen_1
       (.A(simple_summation_0_sum_out),
        .B(cnt_inc_1),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_1_P));
  system_simple_summation_0_0 simple_summation_0
       (.clk(ps_0_FCLK_CLK0),
        .cnt_timer(simple_summation_0_cnt_timer),
        .counter(counter_1),
        .in_data(mult_gen_0_P),
        .sum_out(simple_summation_0_sum_out));
endmodule

module Lock_in_Y_imp_1IF5DHF
   (CLK,
    cnt_inc,
    counter,
    out_data,
    ref_in,
    signal_in);
  input CLK;
  input [31:0]cnt_inc;
  input [31:0]counter;
  output [23:0]out_data;
  input [15:0]ref_in;
  input [13:0]signal_in;

  wire [13:0]adc_2comp_0_adc_a_o;
  wire [31:0]cnt_inc_1;
  wire [31:0]counter_1;
  wire [23:0]moving_average_0_out_data;
  wire [23:0]mult_gen_0_P;
  wire [23:0]mult_gen_1_P;
  wire ps_0_FCLK_CLK0;
  wire [15:0]ref_in_1;
  wire simple_summation_0_cnt_timer;
  wire [55:0]simple_summation_0_sum_out;

  assign adc_2comp_0_adc_a_o = signal_in[13:0];
  assign cnt_inc_1 = cnt_inc[31:0];
  assign counter_1 = counter[31:0];
  assign out_data[23:0] = moving_average_0_out_data;
  assign ps_0_FCLK_CLK0 = CLK;
  assign ref_in_1 = ref_in[15:0];
  system_moving_average_0_3 moving_average_0
       (.clk(simple_summation_0_cnt_timer),
        .in_data(mult_gen_1_P),
        .out_data(moving_average_0_out_data));
  system_mult_gen_0_3 mult_gen_0
       (.A(adc_2comp_0_adc_a_o),
        .B(ref_in_1),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_0_P));
  system_mult_gen_1_3 mult_gen_1
       (.A(simple_summation_0_sum_out),
        .B(cnt_inc_1),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_1_P));
  system_simple_summation_0_3 simple_summation_0
       (.clk(ps_0_FCLK_CLK0),
        .cnt_timer(simple_summation_0_cnt_timer),
        .counter(counter_1),
        .in_data(mult_gen_0_P),
        .sum_out(simple_summation_0_sum_out));
endmodule

module Lock_in_Y_imp_1J7MSO4
   (CLK,
    cnt_inc,
    counter,
    out_data,
    ref_in,
    signal_in);
  input CLK;
  input [31:0]cnt_inc;
  input [31:0]counter;
  output [23:0]out_data;
  input [15:0]ref_in;
  input [13:0]signal_in;

  wire [13:0]adc_2comp_0_adc_a_o;
  wire [31:0]cnt_inc_1;
  wire [31:0]counter_1;
  wire [23:0]moving_average_0_out_data;
  wire [23:0]mult_gen_0_P;
  wire [23:0]mult_gen_1_P;
  wire ps_0_FCLK_CLK0;
  wire [15:0]ref_in_1;
  wire simple_summation_0_cnt_timer;
  wire [55:0]simple_summation_0_sum_out;

  assign adc_2comp_0_adc_a_o = signal_in[13:0];
  assign cnt_inc_1 = cnt_inc[31:0];
  assign counter_1 = counter[31:0];
  assign out_data[23:0] = moving_average_0_out_data;
  assign ps_0_FCLK_CLK0 = CLK;
  assign ref_in_1 = ref_in[15:0];
  system_moving_average_0_2 moving_average_0
       (.clk(simple_summation_0_cnt_timer),
        .in_data(mult_gen_1_P),
        .out_data(moving_average_0_out_data));
  system_mult_gen_0_6 mult_gen_0
       (.A(adc_2comp_0_adc_a_o),
        .B(ref_in_1),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_0_P));
  system_mult_gen_1_4 mult_gen_1
       (.A(simple_summation_0_sum_out),
        .B(cnt_inc_1),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_1_P));
  system_simple_summation_0_2 simple_summation_0
       (.clk(ps_0_FCLK_CLK0),
        .cnt_timer(simple_summation_0_cnt_timer),
        .counter(counter_1),
        .in_data(mult_gen_0_P),
        .sum_out(simple_summation_0_sum_out));
endmodule

module ch_a_processing_imp_8HXZQG
   (CLK,
    X_out,
    Y_out,
    amp_out,
    cnt_inc,
    counter,
    phase_out,
    ref_in_cos,
    ref_in_sin,
    signal_in);
  input CLK;
  output [23:0]X_out;
  output [23:0]Y_out;
  output [23:0]amp_out;
  input [31:0]cnt_inc;
  input [31:0]counter;
  output [23:0]phase_out;
  input [15:0]ref_in_cos;
  input [15:0]ref_in_sin;
  input [13:0]signal_in;

  wire [23:0]Lock_in_a_X_out_data;
  wire [23:0]Lock_in_a_Y_out_data;
  wire [13:0]adc_2comp_0_adc_a_o;
  wire [47:0]c_addsub_0_S;
  wire [47:0]comb_AXI_0_out_data;
  wire [23:0]cordic_0_m_axis_dout_tdata;
  wire [23:0]cordic_1_m_axis_dout_tdata;
  wire [31:0]counter_1;
  wire [47:0]mult_gen_0_P;
  wire [47:0]mult_gen_1_P;
  wire [31:0]out_val_0_out_bus;
  wire [0:0]out_val_0_out_bus1;
  wire ps_0_FCLK_CLK0;
  wire [15:0]ref_in_cos_1;
  wire [15:0]ref_in_sin_1;

  assign X_out[23:0] = Lock_in_a_X_out_data;
  assign Y_out[23:0] = Lock_in_a_Y_out_data;
  assign adc_2comp_0_adc_a_o = signal_in[13:0];
  assign amp_out[23:0] = cordic_0_m_axis_dout_tdata;
  assign counter_1 = counter[31:0];
  assign out_val_0_out_bus = cnt_inc[31:0];
  assign phase_out[23:0] = cordic_1_m_axis_dout_tdata;
  assign ps_0_FCLK_CLK0 = CLK;
  assign ref_in_cos_1 = ref_in_cos[15:0];
  assign ref_in_sin_1 = ref_in_sin[15:0];
  Lock_in_X_imp_RA8R3R Lock_in_X
       (.CLK(ps_0_FCLK_CLK0),
        .cnt_inc(out_val_0_out_bus),
        .counter(counter_1),
        .out_data(Lock_in_a_X_out_data),
        .ref_in(ref_in_cos_1),
        .signal_in(adc_2comp_0_adc_a_o));
  Lock_in_Y_imp_1IF5DHF Lock_in_Y
       (.CLK(ps_0_FCLK_CLK0),
        .cnt_inc(out_val_0_out_bus),
        .counter(counter_1),
        .out_data(Lock_in_a_Y_out_data),
        .ref_in(ref_in_sin_1),
        .signal_in(adc_2comp_0_adc_a_o));
  system_cordic_1_0 atan
       (.aclk(ps_0_FCLK_CLK0),
        .m_axis_dout_tdata(cordic_1_m_axis_dout_tdata),
        .s_axis_cartesian_tdata(comb_AXI_0_out_data),
        .s_axis_cartesian_tvalid(out_val_0_out_bus1));
  system_c_addsub_0_0 c_addsub_0
       (.A(mult_gen_0_P),
        .B(mult_gen_1_P),
        .CLK(ps_0_FCLK_CLK0),
        .S(c_addsub_0_S));
  system_comb_AXI_0_0 comb_AXI_0
       (.ch_a_in(Lock_in_a_X_out_data),
        .ch_b_in(Lock_in_a_Y_out_data),
        .out_data(comb_AXI_0_out_data));
  system_mult_gen_0_2 mult_gen_0
       (.A(Lock_in_a_Y_out_data),
        .B(Lock_in_a_Y_out_data),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_0_P));
  system_mult_gen_0_4 mult_gen_1
       (.A(Lock_in_a_X_out_data),
        .B(Lock_in_a_X_out_data),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_1_P));
  system_out_val_0_1 out_val_0
       (.out_bus(out_val_0_out_bus1));
  system_cordic_0_1 sqrt
       (.aclk(ps_0_FCLK_CLK0),
        .m_axis_dout_tdata(cordic_0_m_axis_dout_tdata),
        .s_axis_cartesian_tdata(c_addsub_0_S),
        .s_axis_cartesian_tvalid(out_val_0_out_bus1));
endmodule

module ch_b_processing_imp_1VQSWGA
   (CLK,
    X_out,
    Y_out,
    amp_out,
    cnt_inc,
    counter,
    phase_out,
    ref_in_cos,
    ref_in_sin,
    signal_in);
  input CLK;
  output [23:0]X_out;
  output [23:0]Y_out;
  output [23:0]amp_out;
  input [31:0]cnt_inc;
  input [31:0]counter;
  output [23:0]phase_out;
  input [15:0]ref_in_cos;
  input [15:0]ref_in_sin;
  input [13:0]signal_in;

  wire [23:0]Lock_in_a_X_out_data;
  wire [23:0]Lock_in_a_Y_out_data;
  wire [13:0]adc_2comp_0_adc_a_o;
  wire [47:0]c_addsub_0_S;
  wire [47:0]comb_AXI_0_out_data;
  wire [23:0]cordic_0_m_axis_dout_tdata;
  wire [23:0]cordic_1_m_axis_dout_tdata;
  wire [31:0]counter_1;
  wire [47:0]mult_gen_0_P;
  wire [47:0]mult_gen_1_P;
  wire [31:0]out_val_0_out_bus;
  wire [0:0]out_val_0_out_bus1;
  wire ps_0_FCLK_CLK0;
  wire [15:0]ref_in_cos_1;
  wire [15:0]ref_in_sin_1;

  assign X_out[23:0] = Lock_in_a_X_out_data;
  assign Y_out[23:0] = Lock_in_a_Y_out_data;
  assign adc_2comp_0_adc_a_o = signal_in[13:0];
  assign amp_out[23:0] = cordic_0_m_axis_dout_tdata;
  assign counter_1 = counter[31:0];
  assign out_val_0_out_bus = cnt_inc[31:0];
  assign phase_out[23:0] = cordic_1_m_axis_dout_tdata;
  assign ps_0_FCLK_CLK0 = CLK;
  assign ref_in_cos_1 = ref_in_cos[15:0];
  assign ref_in_sin_1 = ref_in_sin[15:0];
  Lock_in_X_imp_QSDFYO Lock_in_X
       (.CLK(ps_0_FCLK_CLK0),
        .cnt_inc(out_val_0_out_bus),
        .counter(counter_1),
        .out_data(Lock_in_a_X_out_data),
        .ref_in(ref_in_cos_1),
        .signal_in(adc_2comp_0_adc_a_o));
  Lock_in_Y_imp_1J7MSO4 Lock_in_Y
       (.CLK(ps_0_FCLK_CLK0),
        .cnt_inc(out_val_0_out_bus),
        .counter(counter_1),
        .out_data(Lock_in_a_Y_out_data),
        .ref_in(ref_in_sin_1),
        .signal_in(adc_2comp_0_adc_a_o));
  system_cordic_1_1 atan
       (.aclk(ps_0_FCLK_CLK0),
        .m_axis_dout_tdata(cordic_1_m_axis_dout_tdata),
        .s_axis_cartesian_tdata(comb_AXI_0_out_data),
        .s_axis_cartesian_tvalid(out_val_0_out_bus1));
  system_c_addsub_0_1 c_addsub_0
       (.A(mult_gen_0_P),
        .B(mult_gen_1_P),
        .CLK(ps_0_FCLK_CLK0),
        .S(c_addsub_0_S));
  system_comb_AXI_0_1 comb_AXI_0
       (.ch_a_in(Lock_in_a_X_out_data),
        .ch_b_in(Lock_in_a_Y_out_data),
        .out_data(comb_AXI_0_out_data));
  system_mult_gen_0_5 mult_gen_0
       (.A(Lock_in_a_Y_out_data),
        .B(Lock_in_a_Y_out_data),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_0_P));
  system_mult_gen_1_2 mult_gen_1
       (.A(Lock_in_a_X_out_data),
        .B(Lock_in_a_X_out_data),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_1_P));
  system_out_val_0_2 out_val_0
       (.out_bus(out_val_0_out_bus1));
  system_cordic_0_0 sqrt
       (.aclk(ps_0_FCLK_CLK0),
        .m_axis_dout_tdata(cordic_0_m_axis_dout_tdata),
        .s_axis_cartesian_tdata(c_addsub_0_S),
        .s_axis_cartesian_tvalid(out_val_0_out_bus1));
endmodule

module m00_couplers_imp_1H57HJR
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arburst,
    M_AXI_arcache,
    M_AXI_arid,
    M_AXI_arlen,
    M_AXI_arlock,
    M_AXI_arprot,
    M_AXI_arqos,
    M_AXI_arready,
    M_AXI_arsize,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rid,
    M_AXI_rlast,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wid,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arregion,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awregion,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [1:0]M_AXI_arburst;
  output [3:0]M_AXI_arcache;
  output [5:0]M_AXI_arid;
  output [3:0]M_AXI_arlen;
  output [1:0]M_AXI_arlock;
  output [2:0]M_AXI_arprot;
  output [3:0]M_AXI_arqos;
  input M_AXI_arready;
  output [2:0]M_AXI_arsize;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [5:0]M_AXI_awid;
  output [3:0]M_AXI_awlen;
  output [1:0]M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  input [5:0]M_AXI_rid;
  input M_AXI_rlast;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  output [5:0]M_AXI_wid;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [5:0]S_AXI_arid;
  input [7:0]S_AXI_arlen;
  input [0:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [3:0]S_AXI_arregion;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [5:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input [0:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [3:0]S_AXI_awregion;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output [5:0]S_AXI_rid;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [31:0]auto_pc_to_m00_couplers_ARADDR;
  wire [1:0]auto_pc_to_m00_couplers_ARBURST;
  wire [3:0]auto_pc_to_m00_couplers_ARCACHE;
  wire [5:0]auto_pc_to_m00_couplers_ARID;
  wire [3:0]auto_pc_to_m00_couplers_ARLEN;
  wire [1:0]auto_pc_to_m00_couplers_ARLOCK;
  wire [2:0]auto_pc_to_m00_couplers_ARPROT;
  wire [3:0]auto_pc_to_m00_couplers_ARQOS;
  wire auto_pc_to_m00_couplers_ARREADY;
  wire [2:0]auto_pc_to_m00_couplers_ARSIZE;
  wire auto_pc_to_m00_couplers_ARVALID;
  wire [31:0]auto_pc_to_m00_couplers_AWADDR;
  wire [1:0]auto_pc_to_m00_couplers_AWBURST;
  wire [3:0]auto_pc_to_m00_couplers_AWCACHE;
  wire [5:0]auto_pc_to_m00_couplers_AWID;
  wire [3:0]auto_pc_to_m00_couplers_AWLEN;
  wire [1:0]auto_pc_to_m00_couplers_AWLOCK;
  wire [2:0]auto_pc_to_m00_couplers_AWPROT;
  wire [3:0]auto_pc_to_m00_couplers_AWQOS;
  wire auto_pc_to_m00_couplers_AWREADY;
  wire [2:0]auto_pc_to_m00_couplers_AWSIZE;
  wire auto_pc_to_m00_couplers_AWVALID;
  wire [5:0]auto_pc_to_m00_couplers_BID;
  wire auto_pc_to_m00_couplers_BREADY;
  wire [1:0]auto_pc_to_m00_couplers_BRESP;
  wire auto_pc_to_m00_couplers_BVALID;
  wire [31:0]auto_pc_to_m00_couplers_RDATA;
  wire [5:0]auto_pc_to_m00_couplers_RID;
  wire auto_pc_to_m00_couplers_RLAST;
  wire auto_pc_to_m00_couplers_RREADY;
  wire [1:0]auto_pc_to_m00_couplers_RRESP;
  wire auto_pc_to_m00_couplers_RVALID;
  wire [31:0]auto_pc_to_m00_couplers_WDATA;
  wire [5:0]auto_pc_to_m00_couplers_WID;
  wire auto_pc_to_m00_couplers_WLAST;
  wire auto_pc_to_m00_couplers_WREADY;
  wire [3:0]auto_pc_to_m00_couplers_WSTRB;
  wire auto_pc_to_m00_couplers_WVALID;
  wire [31:0]m00_couplers_to_auto_pc_ARADDR;
  wire [1:0]m00_couplers_to_auto_pc_ARBURST;
  wire [3:0]m00_couplers_to_auto_pc_ARCACHE;
  wire [5:0]m00_couplers_to_auto_pc_ARID;
  wire [7:0]m00_couplers_to_auto_pc_ARLEN;
  wire [0:0]m00_couplers_to_auto_pc_ARLOCK;
  wire [2:0]m00_couplers_to_auto_pc_ARPROT;
  wire [3:0]m00_couplers_to_auto_pc_ARQOS;
  wire m00_couplers_to_auto_pc_ARREADY;
  wire [3:0]m00_couplers_to_auto_pc_ARREGION;
  wire [2:0]m00_couplers_to_auto_pc_ARSIZE;
  wire m00_couplers_to_auto_pc_ARVALID;
  wire [31:0]m00_couplers_to_auto_pc_AWADDR;
  wire [1:0]m00_couplers_to_auto_pc_AWBURST;
  wire [3:0]m00_couplers_to_auto_pc_AWCACHE;
  wire [5:0]m00_couplers_to_auto_pc_AWID;
  wire [7:0]m00_couplers_to_auto_pc_AWLEN;
  wire [0:0]m00_couplers_to_auto_pc_AWLOCK;
  wire [2:0]m00_couplers_to_auto_pc_AWPROT;
  wire [3:0]m00_couplers_to_auto_pc_AWQOS;
  wire m00_couplers_to_auto_pc_AWREADY;
  wire [3:0]m00_couplers_to_auto_pc_AWREGION;
  wire [2:0]m00_couplers_to_auto_pc_AWSIZE;
  wire [0:0]m00_couplers_to_auto_pc_AWUSER;
  wire m00_couplers_to_auto_pc_AWVALID;
  wire [5:0]m00_couplers_to_auto_pc_BID;
  wire m00_couplers_to_auto_pc_BREADY;
  wire [1:0]m00_couplers_to_auto_pc_BRESP;
  wire m00_couplers_to_auto_pc_BVALID;
  wire [31:0]m00_couplers_to_auto_pc_RDATA;
  wire [5:0]m00_couplers_to_auto_pc_RID;
  wire m00_couplers_to_auto_pc_RLAST;
  wire m00_couplers_to_auto_pc_RREADY;
  wire [1:0]m00_couplers_to_auto_pc_RRESP;
  wire m00_couplers_to_auto_pc_RVALID;
  wire [31:0]m00_couplers_to_auto_pc_WDATA;
  wire m00_couplers_to_auto_pc_WLAST;
  wire m00_couplers_to_auto_pc_WREADY;
  wire [3:0]m00_couplers_to_auto_pc_WSTRB;
  wire [0:0]m00_couplers_to_auto_pc_WUSER;
  wire m00_couplers_to_auto_pc_WVALID;

  assign M_AXI_araddr[31:0] = auto_pc_to_m00_couplers_ARADDR;
  assign M_AXI_arburst[1:0] = auto_pc_to_m00_couplers_ARBURST;
  assign M_AXI_arcache[3:0] = auto_pc_to_m00_couplers_ARCACHE;
  assign M_AXI_arid[5:0] = auto_pc_to_m00_couplers_ARID;
  assign M_AXI_arlen[3:0] = auto_pc_to_m00_couplers_ARLEN;
  assign M_AXI_arlock[1:0] = auto_pc_to_m00_couplers_ARLOCK;
  assign M_AXI_arprot[2:0] = auto_pc_to_m00_couplers_ARPROT;
  assign M_AXI_arqos[3:0] = auto_pc_to_m00_couplers_ARQOS;
  assign M_AXI_arsize[2:0] = auto_pc_to_m00_couplers_ARSIZE;
  assign M_AXI_arvalid = auto_pc_to_m00_couplers_ARVALID;
  assign M_AXI_awaddr[31:0] = auto_pc_to_m00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = auto_pc_to_m00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = auto_pc_to_m00_couplers_AWCACHE;
  assign M_AXI_awid[5:0] = auto_pc_to_m00_couplers_AWID;
  assign M_AXI_awlen[3:0] = auto_pc_to_m00_couplers_AWLEN;
  assign M_AXI_awlock[1:0] = auto_pc_to_m00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = auto_pc_to_m00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = auto_pc_to_m00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = auto_pc_to_m00_couplers_AWSIZE;
  assign M_AXI_awvalid = auto_pc_to_m00_couplers_AWVALID;
  assign M_AXI_bready = auto_pc_to_m00_couplers_BREADY;
  assign M_AXI_rready = auto_pc_to_m00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = auto_pc_to_m00_couplers_WDATA;
  assign M_AXI_wid[5:0] = auto_pc_to_m00_couplers_WID;
  assign M_AXI_wlast = auto_pc_to_m00_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = auto_pc_to_m00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_pc_to_m00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = m00_couplers_to_auto_pc_ARREADY;
  assign S_AXI_awready = m00_couplers_to_auto_pc_AWREADY;
  assign S_AXI_bid[5:0] = m00_couplers_to_auto_pc_BID;
  assign S_AXI_bresp[1:0] = m00_couplers_to_auto_pc_BRESP;
  assign S_AXI_bvalid = m00_couplers_to_auto_pc_BVALID;
  assign S_AXI_rdata[31:0] = m00_couplers_to_auto_pc_RDATA;
  assign S_AXI_rid[5:0] = m00_couplers_to_auto_pc_RID;
  assign S_AXI_rlast = m00_couplers_to_auto_pc_RLAST;
  assign S_AXI_rresp[1:0] = m00_couplers_to_auto_pc_RRESP;
  assign S_AXI_rvalid = m00_couplers_to_auto_pc_RVALID;
  assign S_AXI_wready = m00_couplers_to_auto_pc_WREADY;
  assign auto_pc_to_m00_couplers_ARREADY = M_AXI_arready;
  assign auto_pc_to_m00_couplers_AWREADY = M_AXI_awready;
  assign auto_pc_to_m00_couplers_BID = M_AXI_bid[5:0];
  assign auto_pc_to_m00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_pc_to_m00_couplers_BVALID = M_AXI_bvalid;
  assign auto_pc_to_m00_couplers_RDATA = M_AXI_rdata[31:0];
  assign auto_pc_to_m00_couplers_RID = M_AXI_rid[5:0];
  assign auto_pc_to_m00_couplers_RLAST = M_AXI_rlast;
  assign auto_pc_to_m00_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_pc_to_m00_couplers_RVALID = M_AXI_rvalid;
  assign auto_pc_to_m00_couplers_WREADY = M_AXI_wready;
  assign m00_couplers_to_auto_pc_ARADDR = S_AXI_araddr[31:0];
  assign m00_couplers_to_auto_pc_ARBURST = S_AXI_arburst[1:0];
  assign m00_couplers_to_auto_pc_ARCACHE = S_AXI_arcache[3:0];
  assign m00_couplers_to_auto_pc_ARID = S_AXI_arid[5:0];
  assign m00_couplers_to_auto_pc_ARLEN = S_AXI_arlen[7:0];
  assign m00_couplers_to_auto_pc_ARLOCK = S_AXI_arlock[0];
  assign m00_couplers_to_auto_pc_ARPROT = S_AXI_arprot[2:0];
  assign m00_couplers_to_auto_pc_ARQOS = S_AXI_arqos[3:0];
  assign m00_couplers_to_auto_pc_ARREGION = S_AXI_arregion[3:0];
  assign m00_couplers_to_auto_pc_ARSIZE = S_AXI_arsize[2:0];
  assign m00_couplers_to_auto_pc_ARVALID = S_AXI_arvalid;
  assign m00_couplers_to_auto_pc_AWADDR = S_AXI_awaddr[31:0];
  assign m00_couplers_to_auto_pc_AWBURST = S_AXI_awburst[1:0];
  assign m00_couplers_to_auto_pc_AWCACHE = S_AXI_awcache[3:0];
  assign m00_couplers_to_auto_pc_AWID = S_AXI_awid[5:0];
  assign m00_couplers_to_auto_pc_AWLEN = S_AXI_awlen[7:0];
  assign m00_couplers_to_auto_pc_AWLOCK = S_AXI_awlock[0];
  assign m00_couplers_to_auto_pc_AWPROT = S_AXI_awprot[2:0];
  assign m00_couplers_to_auto_pc_AWQOS = S_AXI_awqos[3:0];
  assign m00_couplers_to_auto_pc_AWREGION = S_AXI_awregion[3:0];
  assign m00_couplers_to_auto_pc_AWSIZE = S_AXI_awsize[2:0];
  assign m00_couplers_to_auto_pc_AWUSER = S_AXI_awuser[0];
  assign m00_couplers_to_auto_pc_AWVALID = S_AXI_awvalid;
  assign m00_couplers_to_auto_pc_BREADY = S_AXI_bready;
  assign m00_couplers_to_auto_pc_RREADY = S_AXI_rready;
  assign m00_couplers_to_auto_pc_WDATA = S_AXI_wdata[31:0];
  assign m00_couplers_to_auto_pc_WLAST = S_AXI_wlast;
  assign m00_couplers_to_auto_pc_WSTRB = S_AXI_wstrb[3:0];
  assign m00_couplers_to_auto_pc_WUSER = S_AXI_wuser[0];
  assign m00_couplers_to_auto_pc_WVALID = S_AXI_wvalid;
  system_auto_pc_1 auto_pc
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(auto_pc_to_m00_couplers_ARADDR),
        .m_axi_arburst(auto_pc_to_m00_couplers_ARBURST),
        .m_axi_arcache(auto_pc_to_m00_couplers_ARCACHE),
        .m_axi_arid(auto_pc_to_m00_couplers_ARID),
        .m_axi_arlen(auto_pc_to_m00_couplers_ARLEN),
        .m_axi_arlock(auto_pc_to_m00_couplers_ARLOCK),
        .m_axi_arprot(auto_pc_to_m00_couplers_ARPROT),
        .m_axi_arqos(auto_pc_to_m00_couplers_ARQOS),
        .m_axi_arready(auto_pc_to_m00_couplers_ARREADY),
        .m_axi_arsize(auto_pc_to_m00_couplers_ARSIZE),
        .m_axi_arvalid(auto_pc_to_m00_couplers_ARVALID),
        .m_axi_awaddr(auto_pc_to_m00_couplers_AWADDR),
        .m_axi_awburst(auto_pc_to_m00_couplers_AWBURST),
        .m_axi_awcache(auto_pc_to_m00_couplers_AWCACHE),
        .m_axi_awid(auto_pc_to_m00_couplers_AWID),
        .m_axi_awlen(auto_pc_to_m00_couplers_AWLEN),
        .m_axi_awlock(auto_pc_to_m00_couplers_AWLOCK),
        .m_axi_awprot(auto_pc_to_m00_couplers_AWPROT),
        .m_axi_awqos(auto_pc_to_m00_couplers_AWQOS),
        .m_axi_awready(auto_pc_to_m00_couplers_AWREADY),
        .m_axi_awsize(auto_pc_to_m00_couplers_AWSIZE),
        .m_axi_awvalid(auto_pc_to_m00_couplers_AWVALID),
        .m_axi_bid(auto_pc_to_m00_couplers_BID),
        .m_axi_bready(auto_pc_to_m00_couplers_BREADY),
        .m_axi_bresp(auto_pc_to_m00_couplers_BRESP),
        .m_axi_bvalid(auto_pc_to_m00_couplers_BVALID),
        .m_axi_rdata(auto_pc_to_m00_couplers_RDATA),
        .m_axi_rid(auto_pc_to_m00_couplers_RID),
        .m_axi_rlast(auto_pc_to_m00_couplers_RLAST),
        .m_axi_rready(auto_pc_to_m00_couplers_RREADY),
        .m_axi_rresp(auto_pc_to_m00_couplers_RRESP),
        .m_axi_rvalid(auto_pc_to_m00_couplers_RVALID),
        .m_axi_wdata(auto_pc_to_m00_couplers_WDATA),
        .m_axi_wid(auto_pc_to_m00_couplers_WID),
        .m_axi_wlast(auto_pc_to_m00_couplers_WLAST),
        .m_axi_wready(auto_pc_to_m00_couplers_WREADY),
        .m_axi_wstrb(auto_pc_to_m00_couplers_WSTRB),
        .m_axi_wvalid(auto_pc_to_m00_couplers_WVALID),
        .s_axi_araddr(m00_couplers_to_auto_pc_ARADDR),
        .s_axi_arburst(m00_couplers_to_auto_pc_ARBURST),
        .s_axi_arcache(m00_couplers_to_auto_pc_ARCACHE),
        .s_axi_arid(m00_couplers_to_auto_pc_ARID),
        .s_axi_arlen(m00_couplers_to_auto_pc_ARLEN),
        .s_axi_arlock(m00_couplers_to_auto_pc_ARLOCK),
        .s_axi_arprot(m00_couplers_to_auto_pc_ARPROT),
        .s_axi_arqos(m00_couplers_to_auto_pc_ARQOS),
        .s_axi_arready(m00_couplers_to_auto_pc_ARREADY),
        .s_axi_arregion(m00_couplers_to_auto_pc_ARREGION),
        .s_axi_arsize(m00_couplers_to_auto_pc_ARSIZE),
        .s_axi_arvalid(m00_couplers_to_auto_pc_ARVALID),
        .s_axi_awaddr(m00_couplers_to_auto_pc_AWADDR),
        .s_axi_awburst(m00_couplers_to_auto_pc_AWBURST),
        .s_axi_awcache(m00_couplers_to_auto_pc_AWCACHE),
        .s_axi_awid(m00_couplers_to_auto_pc_AWID),
        .s_axi_awlen(m00_couplers_to_auto_pc_AWLEN),
        .s_axi_awlock(m00_couplers_to_auto_pc_AWLOCK),
        .s_axi_awprot(m00_couplers_to_auto_pc_AWPROT),
        .s_axi_awqos(m00_couplers_to_auto_pc_AWQOS),
        .s_axi_awready(m00_couplers_to_auto_pc_AWREADY),
        .s_axi_awregion(m00_couplers_to_auto_pc_AWREGION),
        .s_axi_awsize(m00_couplers_to_auto_pc_AWSIZE),
        .s_axi_awuser(m00_couplers_to_auto_pc_AWUSER),
        .s_axi_awvalid(m00_couplers_to_auto_pc_AWVALID),
        .s_axi_bid(m00_couplers_to_auto_pc_BID),
        .s_axi_bready(m00_couplers_to_auto_pc_BREADY),
        .s_axi_bresp(m00_couplers_to_auto_pc_BRESP),
        .s_axi_bvalid(m00_couplers_to_auto_pc_BVALID),
        .s_axi_rdata(m00_couplers_to_auto_pc_RDATA),
        .s_axi_rid(m00_couplers_to_auto_pc_RID),
        .s_axi_rlast(m00_couplers_to_auto_pc_RLAST),
        .s_axi_rready(m00_couplers_to_auto_pc_RREADY),
        .s_axi_rresp(m00_couplers_to_auto_pc_RRESP),
        .s_axi_rvalid(m00_couplers_to_auto_pc_RVALID),
        .s_axi_wdata(m00_couplers_to_auto_pc_WDATA),
        .s_axi_wlast(m00_couplers_to_auto_pc_WLAST),
        .s_axi_wready(m00_couplers_to_auto_pc_WREADY),
        .s_axi_wstrb(m00_couplers_to_auto_pc_WSTRB),
        .s_axi_wuser(m00_couplers_to_auto_pc_WUSER),
        .s_axi_wvalid(m00_couplers_to_auto_pc_WVALID));
endmodule

module memory_interface_imp_4TOQ3E
   (M00_AXI_araddr,
    M00_AXI_arburst,
    M00_AXI_arcache,
    M00_AXI_arid,
    M00_AXI_arlen,
    M00_AXI_arlock,
    M00_AXI_arprot,
    M00_AXI_arqos,
    M00_AXI_arready,
    M00_AXI_arsize,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awburst,
    M00_AXI_awcache,
    M00_AXI_awid,
    M00_AXI_awlen,
    M00_AXI_awlock,
    M00_AXI_awprot,
    M00_AXI_awqos,
    M00_AXI_awready,
    M00_AXI_awsize,
    M00_AXI_awvalid,
    M00_AXI_bid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rid,
    M00_AXI_rlast,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wid,
    M00_AXI_wlast,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arid,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awid,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rid,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wid,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid,
    amp_mult,
    avg_inc_cnt,
    ch_a_X,
    ch_a_Y,
    ch_a_amp,
    ch_a_phase,
    ch_b_X,
    ch_b_Y,
    ch_b_amp,
    ch_b_phase,
    clk,
    count_clk,
    counter,
    counter_current,
    dac_a_mult,
    dac_b_mult,
    dcm_locked,
    ext_reset_in,
    loop_flag,
    mod_phase_lead,
    mode_flags,
    phase_inc,
    sweep_add,
    sweep_max,
    sweep_min,
    sync_i);
  output [31:0]M00_AXI_araddr;
  output [1:0]M00_AXI_arburst;
  output [3:0]M00_AXI_arcache;
  output [5:0]M00_AXI_arid;
  output [3:0]M00_AXI_arlen;
  output [1:0]M00_AXI_arlock;
  output [2:0]M00_AXI_arprot;
  output [3:0]M00_AXI_arqos;
  input M00_AXI_arready;
  output [2:0]M00_AXI_arsize;
  output M00_AXI_arvalid;
  output [31:0]M00_AXI_awaddr;
  output [1:0]M00_AXI_awburst;
  output [3:0]M00_AXI_awcache;
  output [5:0]M00_AXI_awid;
  output [3:0]M00_AXI_awlen;
  output [1:0]M00_AXI_awlock;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  input M00_AXI_awready;
  output [2:0]M00_AXI_awsize;
  output M00_AXI_awvalid;
  input [5:0]M00_AXI_bid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [31:0]M00_AXI_rdata;
  input [5:0]M00_AXI_rid;
  input M00_AXI_rlast;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [31:0]M00_AXI_wdata;
  output [5:0]M00_AXI_wid;
  output M00_AXI_wlast;
  input M00_AXI_wready;
  output [3:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input [31:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [11:0]S00_AXI_arid;
  input [3:0]S00_AXI_arlen;
  input [1:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input S00_AXI_arvalid;
  input [31:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [11:0]S00_AXI_awid;
  input [3:0]S00_AXI_awlen;
  input [1:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  output [11:0]S00_AXI_bid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  output [11:0]S00_AXI_rid;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  input [11:0]S00_AXI_wid;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;
  output [31:0]amp_mult;
  output [31:0]avg_inc_cnt;
  input [23:0]ch_a_X;
  input [23:0]ch_a_Y;
  input [23:0]ch_a_amp;
  input [23:0]ch_a_phase;
  input [23:0]ch_b_X;
  input [23:0]ch_b_Y;
  input [23:0]ch_b_amp;
  input [23:0]ch_b_phase;
  input clk;
  input count_clk;
  input [6:0]counter;
  output [6:0]counter_current;
  output [15:0]dac_a_mult;
  output [15:0]dac_b_mult;
  input dcm_locked;
  input ext_reset_in;
  input loop_flag;
  output [15:0]mod_phase_lead;
  output [31:0]mode_flags;
  output [31:0]phase_inc;
  output [31:0]sweep_add;
  output [31:0]sweep_max;
  output [31:0]sweep_min;
  input sync_i;

  wire [31:0]Conn1_ARADDR;
  wire [1:0]Conn1_ARBURST;
  wire [3:0]Conn1_ARCACHE;
  wire [11:0]Conn1_ARID;
  wire [3:0]Conn1_ARLEN;
  wire [1:0]Conn1_ARLOCK;
  wire [2:0]Conn1_ARPROT;
  wire [3:0]Conn1_ARQOS;
  wire Conn1_ARREADY;
  wire [2:0]Conn1_ARSIZE;
  wire Conn1_ARVALID;
  wire [31:0]Conn1_AWADDR;
  wire [1:0]Conn1_AWBURST;
  wire [3:0]Conn1_AWCACHE;
  wire [11:0]Conn1_AWID;
  wire [3:0]Conn1_AWLEN;
  wire [1:0]Conn1_AWLOCK;
  wire [2:0]Conn1_AWPROT;
  wire [3:0]Conn1_AWQOS;
  wire Conn1_AWREADY;
  wire [2:0]Conn1_AWSIZE;
  wire Conn1_AWVALID;
  wire [11:0]Conn1_BID;
  wire Conn1_BREADY;
  wire [1:0]Conn1_BRESP;
  wire Conn1_BVALID;
  wire [31:0]Conn1_RDATA;
  wire [11:0]Conn1_RID;
  wire Conn1_RLAST;
  wire Conn1_RREADY;
  wire [1:0]Conn1_RRESP;
  wire Conn1_RVALID;
  wire [31:0]Conn1_WDATA;
  wire [11:0]Conn1_WID;
  wire Conn1_WLAST;
  wire Conn1_WREADY;
  wire [3:0]Conn1_WSTRB;
  wire Conn1_WVALID;
  wire [31:0]Conn2_ARADDR;
  wire [1:0]Conn2_ARBURST;
  wire [3:0]Conn2_ARCACHE;
  wire [5:0]Conn2_ARID;
  wire [3:0]Conn2_ARLEN;
  wire [1:0]Conn2_ARLOCK;
  wire [2:0]Conn2_ARPROT;
  wire [3:0]Conn2_ARQOS;
  wire Conn2_ARREADY;
  wire [2:0]Conn2_ARSIZE;
  wire Conn2_ARVALID;
  wire [31:0]Conn2_AWADDR;
  wire [1:0]Conn2_AWBURST;
  wire [3:0]Conn2_AWCACHE;
  wire [5:0]Conn2_AWID;
  wire [3:0]Conn2_AWLEN;
  wire [1:0]Conn2_AWLOCK;
  wire [2:0]Conn2_AWPROT;
  wire [3:0]Conn2_AWQOS;
  wire Conn2_AWREADY;
  wire [2:0]Conn2_AWSIZE;
  wire Conn2_AWVALID;
  wire [5:0]Conn2_BID;
  wire Conn2_BREADY;
  wire [1:0]Conn2_BRESP;
  wire Conn2_BVALID;
  wire [31:0]Conn2_RDATA;
  wire [5:0]Conn2_RID;
  wire Conn2_RLAST;
  wire Conn2_RREADY;
  wire [1:0]Conn2_RRESP;
  wire Conn2_RVALID;
  wire [31:0]Conn2_WDATA;
  wire [5:0]Conn2_WID;
  wire Conn2_WLAST;
  wire Conn2_WREADY;
  wire [3:0]Conn2_WSTRB;
  wire Conn2_WVALID;
  wire [31:0]Net;
  wire Net1;
  wire [31:0]S00_AXI_1_ARADDR;
  wire [2:0]S00_AXI_1_ARPROT;
  wire S00_AXI_1_ARREADY;
  wire S00_AXI_1_ARVALID;
  wire [31:0]S00_AXI_1_AWADDR;
  wire [2:0]S00_AXI_1_AWPROT;
  wire S00_AXI_1_AWREADY;
  wire S00_AXI_1_AWVALID;
  wire S00_AXI_1_BREADY;
  wire [1:0]S00_AXI_1_BRESP;
  wire S00_AXI_1_BVALID;
  wire [31:0]S00_AXI_1_RDATA;
  wire S00_AXI_1_RREADY;
  wire [1:0]S00_AXI_1_RRESP;
  wire S00_AXI_1_RVALID;
  wire [31:0]S00_AXI_1_WDATA;
  wire S00_AXI_1_WREADY;
  wire [3:0]S00_AXI_1_WSTRB;
  wire S00_AXI_1_WVALID;
  wire [23:0]ch_a_X_1;
  wire [23:0]ch_a_Y_1;
  wire [23:0]ch_a_amp_1;
  wire [23:0]ch_a_phase_1;
  wire [23:0]ch_b_X_1;
  wire [23:0]ch_b_Y_1;
  wire [23:0]ch_b_amp_1;
  wire [23:0]ch_b_phase_1;
  wire count_clk_1;
  wire [6:0]counter_1;
  wire [15:0]dac_a_mult_out_bus;
  wire [15:0]dac_b_mult_out_bus;
  wire [31:0]data_padder_0_data_out;
  wire [31:0]data_padder_0_data_out1;
  wire [31:0]data_padder_1_data_out;
  wire [31:0]data_padder_2_data_out;
  wire [31:0]data_padder_3_data_out;
  wire [31:0]data_padder_4_data_out;
  wire [31:0]data_padder_5_data_out;
  wire [31:0]data_padder_6_data_out;
  wire [31:0]data_writer_0_M_AXI_AWADDR;
  wire [1:0]data_writer_0_M_AXI_AWBURST;
  wire [3:0]data_writer_0_M_AXI_AWCACHE;
  wire [2:0]data_writer_0_M_AXI_AWID;
  wire [7:0]data_writer_0_M_AXI_AWLEN;
  wire data_writer_0_M_AXI_AWLOCK;
  wire [2:0]data_writer_0_M_AXI_AWPROT;
  wire [3:0]data_writer_0_M_AXI_AWQOS;
  wire data_writer_0_M_AXI_AWREADY;
  wire [2:0]data_writer_0_M_AXI_AWSIZE;
  wire [0:0]data_writer_0_M_AXI_AWUSER;
  wire data_writer_0_M_AXI_AWVALID;
  wire [5:0]data_writer_0_M_AXI_BID;
  wire data_writer_0_M_AXI_BREADY;
  wire [1:0]data_writer_0_M_AXI_BRESP;
  wire [0:0]data_writer_0_M_AXI_BUSER;
  wire data_writer_0_M_AXI_BVALID;
  wire [31:0]data_writer_0_M_AXI_WDATA;
  wire data_writer_0_M_AXI_WLAST;
  wire data_writer_0_M_AXI_WREADY;
  wire [3:0]data_writer_0_M_AXI_WSTRB;
  wire [0:0]data_writer_0_M_AXI_WUSER;
  wire data_writer_0_M_AXI_WVALID;
  wire [31:0]data_writer_1_M_AXI_AWADDR;
  wire [1:0]data_writer_1_M_AXI_AWBURST;
  wire [3:0]data_writer_1_M_AXI_AWCACHE;
  wire [2:0]data_writer_1_M_AXI_AWID;
  wire [7:0]data_writer_1_M_AXI_AWLEN;
  wire data_writer_1_M_AXI_AWLOCK;
  wire [2:0]data_writer_1_M_AXI_AWPROT;
  wire [3:0]data_writer_1_M_AXI_AWQOS;
  wire data_writer_1_M_AXI_AWREADY;
  wire [2:0]data_writer_1_M_AXI_AWSIZE;
  wire [0:0]data_writer_1_M_AXI_AWUSER;
  wire data_writer_1_M_AXI_AWVALID;
  wire [5:0]data_writer_1_M_AXI_BID;
  wire data_writer_1_M_AXI_BREADY;
  wire [1:0]data_writer_1_M_AXI_BRESP;
  wire [0:0]data_writer_1_M_AXI_BUSER;
  wire data_writer_1_M_AXI_BVALID;
  wire [31:0]data_writer_1_M_AXI_WDATA;
  wire data_writer_1_M_AXI_WLAST;
  wire data_writer_1_M_AXI_WREADY;
  wire [3:0]data_writer_1_M_AXI_WSTRB;
  wire [0:0]data_writer_1_M_AXI_WUSER;
  wire data_writer_1_M_AXI_WVALID;
  wire [31:0]data_writer_2_M_AXI_AWADDR;
  wire [1:0]data_writer_2_M_AXI_AWBURST;
  wire [3:0]data_writer_2_M_AXI_AWCACHE;
  wire [2:0]data_writer_2_M_AXI_AWID;
  wire [7:0]data_writer_2_M_AXI_AWLEN;
  wire data_writer_2_M_AXI_AWLOCK;
  wire [2:0]data_writer_2_M_AXI_AWPROT;
  wire [3:0]data_writer_2_M_AXI_AWQOS;
  wire data_writer_2_M_AXI_AWREADY;
  wire [2:0]data_writer_2_M_AXI_AWSIZE;
  wire [0:0]data_writer_2_M_AXI_AWUSER;
  wire data_writer_2_M_AXI_AWVALID;
  wire [5:0]data_writer_2_M_AXI_BID;
  wire data_writer_2_M_AXI_BREADY;
  wire [1:0]data_writer_2_M_AXI_BRESP;
  wire [0:0]data_writer_2_M_AXI_BUSER;
  wire data_writer_2_M_AXI_BVALID;
  wire [31:0]data_writer_2_M_AXI_WDATA;
  wire data_writer_2_M_AXI_WLAST;
  wire data_writer_2_M_AXI_WREADY;
  wire [3:0]data_writer_2_M_AXI_WSTRB;
  wire [0:0]data_writer_2_M_AXI_WUSER;
  wire data_writer_2_M_AXI_WVALID;
  wire [31:0]data_writer_3_M_AXI_AWADDR;
  wire [1:0]data_writer_3_M_AXI_AWBURST;
  wire [3:0]data_writer_3_M_AXI_AWCACHE;
  wire [2:0]data_writer_3_M_AXI_AWID;
  wire [7:0]data_writer_3_M_AXI_AWLEN;
  wire data_writer_3_M_AXI_AWLOCK;
  wire [2:0]data_writer_3_M_AXI_AWPROT;
  wire [3:0]data_writer_3_M_AXI_AWQOS;
  wire data_writer_3_M_AXI_AWREADY;
  wire [2:0]data_writer_3_M_AXI_AWSIZE;
  wire [0:0]data_writer_3_M_AXI_AWUSER;
  wire data_writer_3_M_AXI_AWVALID;
  wire [5:0]data_writer_3_M_AXI_BID;
  wire data_writer_3_M_AXI_BREADY;
  wire [1:0]data_writer_3_M_AXI_BRESP;
  wire [0:0]data_writer_3_M_AXI_BUSER;
  wire data_writer_3_M_AXI_BVALID;
  wire [31:0]data_writer_3_M_AXI_WDATA;
  wire data_writer_3_M_AXI_WLAST;
  wire data_writer_3_M_AXI_WREADY;
  wire [3:0]data_writer_3_M_AXI_WSTRB;
  wire [0:0]data_writer_3_M_AXI_WUSER;
  wire data_writer_3_M_AXI_WVALID;
  wire [31:0]data_writer_4_M_AXI_AWADDR;
  wire [1:0]data_writer_4_M_AXI_AWBURST;
  wire [3:0]data_writer_4_M_AXI_AWCACHE;
  wire [2:0]data_writer_4_M_AXI_AWID;
  wire [7:0]data_writer_4_M_AXI_AWLEN;
  wire data_writer_4_M_AXI_AWLOCK;
  wire [2:0]data_writer_4_M_AXI_AWPROT;
  wire [3:0]data_writer_4_M_AXI_AWQOS;
  wire data_writer_4_M_AXI_AWREADY;
  wire [2:0]data_writer_4_M_AXI_AWSIZE;
  wire [0:0]data_writer_4_M_AXI_AWUSER;
  wire data_writer_4_M_AXI_AWVALID;
  wire [5:0]data_writer_4_M_AXI_BID;
  wire data_writer_4_M_AXI_BREADY;
  wire [1:0]data_writer_4_M_AXI_BRESP;
  wire [0:0]data_writer_4_M_AXI_BUSER;
  wire data_writer_4_M_AXI_BVALID;
  wire [31:0]data_writer_4_M_AXI_WDATA;
  wire data_writer_4_M_AXI_WLAST;
  wire data_writer_4_M_AXI_WREADY;
  wire [3:0]data_writer_4_M_AXI_WSTRB;
  wire [0:0]data_writer_4_M_AXI_WUSER;
  wire data_writer_4_M_AXI_WVALID;
  wire [31:0]data_writer_5_M_AXI_AWADDR;
  wire [1:0]data_writer_5_M_AXI_AWBURST;
  wire [3:0]data_writer_5_M_AXI_AWCACHE;
  wire [2:0]data_writer_5_M_AXI_AWID;
  wire [7:0]data_writer_5_M_AXI_AWLEN;
  wire data_writer_5_M_AXI_AWLOCK;
  wire [2:0]data_writer_5_M_AXI_AWPROT;
  wire [3:0]data_writer_5_M_AXI_AWQOS;
  wire data_writer_5_M_AXI_AWREADY;
  wire [2:0]data_writer_5_M_AXI_AWSIZE;
  wire [0:0]data_writer_5_M_AXI_AWUSER;
  wire data_writer_5_M_AXI_AWVALID;
  wire [5:0]data_writer_5_M_AXI_BID;
  wire data_writer_5_M_AXI_BREADY;
  wire [1:0]data_writer_5_M_AXI_BRESP;
  wire [0:0]data_writer_5_M_AXI_BUSER;
  wire data_writer_5_M_AXI_BVALID;
  wire [31:0]data_writer_5_M_AXI_WDATA;
  wire data_writer_5_M_AXI_WLAST;
  wire data_writer_5_M_AXI_WREADY;
  wire [3:0]data_writer_5_M_AXI_WSTRB;
  wire [0:0]data_writer_5_M_AXI_WUSER;
  wire data_writer_5_M_AXI_WVALID;
  wire [31:0]data_writer_6_M_AXI_AWADDR;
  wire [1:0]data_writer_6_M_AXI_AWBURST;
  wire [3:0]data_writer_6_M_AXI_AWCACHE;
  wire [2:0]data_writer_6_M_AXI_AWID;
  wire [7:0]data_writer_6_M_AXI_AWLEN;
  wire data_writer_6_M_AXI_AWLOCK;
  wire [2:0]data_writer_6_M_AXI_AWPROT;
  wire [3:0]data_writer_6_M_AXI_AWQOS;
  wire data_writer_6_M_AXI_AWREADY;
  wire [2:0]data_writer_6_M_AXI_AWSIZE;
  wire [0:0]data_writer_6_M_AXI_AWUSER;
  wire data_writer_6_M_AXI_AWVALID;
  wire [5:0]data_writer_6_M_AXI_BID;
  wire data_writer_6_M_AXI_BREADY;
  wire [1:0]data_writer_6_M_AXI_BRESP;
  wire [0:0]data_writer_6_M_AXI_BUSER;
  wire data_writer_6_M_AXI_BVALID;
  wire [31:0]data_writer_6_M_AXI_WDATA;
  wire data_writer_6_M_AXI_WLAST;
  wire data_writer_6_M_AXI_WREADY;
  wire [3:0]data_writer_6_M_AXI_WSTRB;
  wire [0:0]data_writer_6_M_AXI_WUSER;
  wire data_writer_6_M_AXI_WVALID;
  wire [31:0]data_writer_7_M_AXI_AWADDR;
  wire [1:0]data_writer_7_M_AXI_AWBURST;
  wire [3:0]data_writer_7_M_AXI_AWCACHE;
  wire [2:0]data_writer_7_M_AXI_AWID;
  wire [7:0]data_writer_7_M_AXI_AWLEN;
  wire data_writer_7_M_AXI_AWLOCK;
  wire [2:0]data_writer_7_M_AXI_AWPROT;
  wire [3:0]data_writer_7_M_AXI_AWQOS;
  wire data_writer_7_M_AXI_AWREADY;
  wire [2:0]data_writer_7_M_AXI_AWSIZE;
  wire [0:0]data_writer_7_M_AXI_AWUSER;
  wire data_writer_7_M_AXI_AWVALID;
  wire [5:0]data_writer_7_M_AXI_BID;
  wire data_writer_7_M_AXI_BREADY;
  wire [1:0]data_writer_7_M_AXI_BRESP;
  wire [0:0]data_writer_7_M_AXI_BUSER;
  wire data_writer_7_M_AXI_BVALID;
  wire [31:0]data_writer_7_M_AXI_WDATA;
  wire data_writer_7_M_AXI_WLAST;
  wire data_writer_7_M_AXI_WREADY;
  wire [3:0]data_writer_7_M_AXI_WSTRB;
  wire [0:0]data_writer_7_M_AXI_WUSER;
  wire data_writer_7_M_AXI_WVALID;
  wire dcm_locked_1;
  wire [31:0]default_val_0_out_bus;
  wire [31:0]default_val_0_out_bus1;
  wire [31:0]default_val_0_out_bus2;
  wire [31:0]default_val_0_out_bus3;
  wire [15:0]default_val_0_out_bus4;
  wire ext_reset_in_1;
  wire loop_flag_1;
  wire [6:0]mem_manager_0_counter_min;
  wire [31:0]mem_manager_0_counter_o;
  wire [31:0]mem_manager_0_end_addr;
  wire [31:0]mem_manager_0_start_addr;
  wire [31:0]out_val_0_out_bus;
  wire ps_0_FCLK_CLK0;
  wire [0:0]rst_clk_wiz_0_125M_interconnect_aresetn;
  wire [0:0]s00_axi_aresetn_1;
  wire [31:0]sample_clk_count_out;
  wire [31:0]settings_sample_cnt;
  wire [31:0]sweep_max_out_bus;
  wire [31:0]sweep_min_out_bus;
  wire sync_i_1;

  assign Conn1_ARADDR = S00_AXI_araddr[31:0];
  assign Conn1_ARBURST = S00_AXI_arburst[1:0];
  assign Conn1_ARCACHE = S00_AXI_arcache[3:0];
  assign Conn1_ARID = S00_AXI_arid[11:0];
  assign Conn1_ARLEN = S00_AXI_arlen[3:0];
  assign Conn1_ARLOCK = S00_AXI_arlock[1:0];
  assign Conn1_ARPROT = S00_AXI_arprot[2:0];
  assign Conn1_ARQOS = S00_AXI_arqos[3:0];
  assign Conn1_ARSIZE = S00_AXI_arsize[2:0];
  assign Conn1_ARVALID = S00_AXI_arvalid;
  assign Conn1_AWADDR = S00_AXI_awaddr[31:0];
  assign Conn1_AWBURST = S00_AXI_awburst[1:0];
  assign Conn1_AWCACHE = S00_AXI_awcache[3:0];
  assign Conn1_AWID = S00_AXI_awid[11:0];
  assign Conn1_AWLEN = S00_AXI_awlen[3:0];
  assign Conn1_AWLOCK = S00_AXI_awlock[1:0];
  assign Conn1_AWPROT = S00_AXI_awprot[2:0];
  assign Conn1_AWQOS = S00_AXI_awqos[3:0];
  assign Conn1_AWSIZE = S00_AXI_awsize[2:0];
  assign Conn1_AWVALID = S00_AXI_awvalid;
  assign Conn1_BREADY = S00_AXI_bready;
  assign Conn1_RREADY = S00_AXI_rready;
  assign Conn1_WDATA = S00_AXI_wdata[31:0];
  assign Conn1_WID = S00_AXI_wid[11:0];
  assign Conn1_WLAST = S00_AXI_wlast;
  assign Conn1_WSTRB = S00_AXI_wstrb[3:0];
  assign Conn1_WVALID = S00_AXI_wvalid;
  assign Conn2_ARREADY = M00_AXI_arready;
  assign Conn2_AWREADY = M00_AXI_awready;
  assign Conn2_BID = M00_AXI_bid[5:0];
  assign Conn2_BRESP = M00_AXI_bresp[1:0];
  assign Conn2_BVALID = M00_AXI_bvalid;
  assign Conn2_RDATA = M00_AXI_rdata[31:0];
  assign Conn2_RID = M00_AXI_rid[5:0];
  assign Conn2_RLAST = M00_AXI_rlast;
  assign Conn2_RRESP = M00_AXI_rresp[1:0];
  assign Conn2_RVALID = M00_AXI_rvalid;
  assign Conn2_WREADY = M00_AXI_wready;
  assign M00_AXI_araddr[31:0] = Conn2_ARADDR;
  assign M00_AXI_arburst[1:0] = Conn2_ARBURST;
  assign M00_AXI_arcache[3:0] = Conn2_ARCACHE;
  assign M00_AXI_arid[5:0] = Conn2_ARID;
  assign M00_AXI_arlen[3:0] = Conn2_ARLEN;
  assign M00_AXI_arlock[1:0] = Conn2_ARLOCK;
  assign M00_AXI_arprot[2:0] = Conn2_ARPROT;
  assign M00_AXI_arqos[3:0] = Conn2_ARQOS;
  assign M00_AXI_arsize[2:0] = Conn2_ARSIZE;
  assign M00_AXI_arvalid = Conn2_ARVALID;
  assign M00_AXI_awaddr[31:0] = Conn2_AWADDR;
  assign M00_AXI_awburst[1:0] = Conn2_AWBURST;
  assign M00_AXI_awcache[3:0] = Conn2_AWCACHE;
  assign M00_AXI_awid[5:0] = Conn2_AWID;
  assign M00_AXI_awlen[3:0] = Conn2_AWLEN;
  assign M00_AXI_awlock[1:0] = Conn2_AWLOCK;
  assign M00_AXI_awprot[2:0] = Conn2_AWPROT;
  assign M00_AXI_awqos[3:0] = Conn2_AWQOS;
  assign M00_AXI_awsize[2:0] = Conn2_AWSIZE;
  assign M00_AXI_awvalid = Conn2_AWVALID;
  assign M00_AXI_bready = Conn2_BREADY;
  assign M00_AXI_rready = Conn2_RREADY;
  assign M00_AXI_wdata[31:0] = Conn2_WDATA;
  assign M00_AXI_wid[5:0] = Conn2_WID;
  assign M00_AXI_wlast = Conn2_WLAST;
  assign M00_AXI_wstrb[3:0] = Conn2_WSTRB;
  assign M00_AXI_wvalid = Conn2_WVALID;
  assign S00_AXI_arready = Conn1_ARREADY;
  assign S00_AXI_awready = Conn1_AWREADY;
  assign S00_AXI_bid[11:0] = Conn1_BID;
  assign S00_AXI_bresp[1:0] = Conn1_BRESP;
  assign S00_AXI_bvalid = Conn1_BVALID;
  assign S00_AXI_rdata[31:0] = Conn1_RDATA;
  assign S00_AXI_rid[11:0] = Conn1_RID;
  assign S00_AXI_rlast = Conn1_RLAST;
  assign S00_AXI_rresp[1:0] = Conn1_RRESP;
  assign S00_AXI_rvalid = Conn1_RVALID;
  assign S00_AXI_wready = Conn1_WREADY;
  assign amp_mult[31:0] = default_val_0_out_bus3;
  assign avg_inc_cnt[31:0] = out_val_0_out_bus;
  assign ch_a_X_1 = ch_a_X[23:0];
  assign ch_a_Y_1 = ch_a_Y[23:0];
  assign ch_a_amp_1 = ch_a_amp[23:0];
  assign ch_a_phase_1 = ch_a_phase[23:0];
  assign ch_b_X_1 = ch_b_X[23:0];
  assign ch_b_Y_1 = ch_b_Y[23:0];
  assign ch_b_amp_1 = ch_b_amp[23:0];
  assign ch_b_phase_1 = ch_b_phase[23:0];
  assign count_clk_1 = count_clk;
  assign counter_1 = counter[6:0];
  assign counter_current[6:0] = mem_manager_0_counter_min;
  assign dac_a_mult[15:0] = dac_a_mult_out_bus;
  assign dac_b_mult[15:0] = dac_b_mult_out_bus;
  assign dcm_locked_1 = dcm_locked;
  assign ext_reset_in_1 = ext_reset_in;
  assign loop_flag_1 = loop_flag;
  assign mod_phase_lead[15:0] = default_val_0_out_bus4;
  assign mode_flags[31:0] = default_val_0_out_bus1;
  assign phase_inc[31:0] = default_val_0_out_bus;
  assign ps_0_FCLK_CLK0 = clk;
  assign sweep_add[31:0] = default_val_0_out_bus2;
  assign sweep_max[31:0] = sweep_max_out_bus;
  assign sweep_min[31:0] = sweep_min_out_bus;
  assign sync_i_1 = sync_i;
  system_axi_mem_intercon_0 axi_mem_intercon
       (.ACLK(ps_0_FCLK_CLK0),
        .ARESETN(rst_clk_wiz_0_125M_interconnect_aresetn),
        .M00_ACLK(ps_0_FCLK_CLK0),
        .M00_ARESETN(s00_axi_aresetn_1),
        .M00_AXI_araddr(Conn2_ARADDR),
        .M00_AXI_arburst(Conn2_ARBURST),
        .M00_AXI_arcache(Conn2_ARCACHE),
        .M00_AXI_arid(Conn2_ARID),
        .M00_AXI_arlen(Conn2_ARLEN),
        .M00_AXI_arlock(Conn2_ARLOCK),
        .M00_AXI_arprot(Conn2_ARPROT),
        .M00_AXI_arqos(Conn2_ARQOS),
        .M00_AXI_arready(Conn2_ARREADY),
        .M00_AXI_arsize(Conn2_ARSIZE),
        .M00_AXI_arvalid(Conn2_ARVALID),
        .M00_AXI_awaddr(Conn2_AWADDR),
        .M00_AXI_awburst(Conn2_AWBURST),
        .M00_AXI_awcache(Conn2_AWCACHE),
        .M00_AXI_awid(Conn2_AWID),
        .M00_AXI_awlen(Conn2_AWLEN),
        .M00_AXI_awlock(Conn2_AWLOCK),
        .M00_AXI_awprot(Conn2_AWPROT),
        .M00_AXI_awqos(Conn2_AWQOS),
        .M00_AXI_awready(Conn2_AWREADY),
        .M00_AXI_awsize(Conn2_AWSIZE),
        .M00_AXI_awvalid(Conn2_AWVALID),
        .M00_AXI_bid(Conn2_BID),
        .M00_AXI_bready(Conn2_BREADY),
        .M00_AXI_bresp(Conn2_BRESP),
        .M00_AXI_bvalid(Conn2_BVALID),
        .M00_AXI_rdata(Conn2_RDATA),
        .M00_AXI_rid(Conn2_RID),
        .M00_AXI_rlast(Conn2_RLAST),
        .M00_AXI_rready(Conn2_RREADY),
        .M00_AXI_rresp(Conn2_RRESP),
        .M00_AXI_rvalid(Conn2_RVALID),
        .M00_AXI_wdata(Conn2_WDATA),
        .M00_AXI_wid(Conn2_WID),
        .M00_AXI_wlast(Conn2_WLAST),
        .M00_AXI_wready(Conn2_WREADY),
        .M00_AXI_wstrb(Conn2_WSTRB),
        .M00_AXI_wvalid(Conn2_WVALID),
        .S00_ACLK(ps_0_FCLK_CLK0),
        .S00_ARESETN(s00_axi_aresetn_1),
        .S00_AXI_awaddr(data_writer_0_M_AXI_AWADDR),
        .S00_AXI_awburst(data_writer_0_M_AXI_AWBURST),
        .S00_AXI_awcache(data_writer_0_M_AXI_AWCACHE),
        .S00_AXI_awid(data_writer_0_M_AXI_AWID),
        .S00_AXI_awlen(data_writer_0_M_AXI_AWLEN),
        .S00_AXI_awlock(data_writer_0_M_AXI_AWLOCK),
        .S00_AXI_awprot(data_writer_0_M_AXI_AWPROT),
        .S00_AXI_awqos(data_writer_0_M_AXI_AWQOS),
        .S00_AXI_awready(data_writer_0_M_AXI_AWREADY),
        .S00_AXI_awsize(data_writer_0_M_AXI_AWSIZE),
        .S00_AXI_awuser(data_writer_0_M_AXI_AWUSER),
        .S00_AXI_awvalid(data_writer_0_M_AXI_AWVALID),
        .S00_AXI_bid(data_writer_0_M_AXI_BID),
        .S00_AXI_bready(data_writer_0_M_AXI_BREADY),
        .S00_AXI_bresp(data_writer_0_M_AXI_BRESP),
        .S00_AXI_buser(data_writer_0_M_AXI_BUSER),
        .S00_AXI_bvalid(data_writer_0_M_AXI_BVALID),
        .S00_AXI_wdata(data_writer_0_M_AXI_WDATA),
        .S00_AXI_wlast(data_writer_0_M_AXI_WLAST),
        .S00_AXI_wready(data_writer_0_M_AXI_WREADY),
        .S00_AXI_wstrb(data_writer_0_M_AXI_WSTRB),
        .S00_AXI_wuser(data_writer_0_M_AXI_WUSER),
        .S00_AXI_wvalid(data_writer_0_M_AXI_WVALID),
        .S01_ACLK(ps_0_FCLK_CLK0),
        .S01_ARESETN(s00_axi_aresetn_1),
        .S01_AXI_awaddr(data_writer_1_M_AXI_AWADDR),
        .S01_AXI_awburst(data_writer_1_M_AXI_AWBURST),
        .S01_AXI_awcache(data_writer_1_M_AXI_AWCACHE),
        .S01_AXI_awid(data_writer_1_M_AXI_AWID),
        .S01_AXI_awlen(data_writer_1_M_AXI_AWLEN),
        .S01_AXI_awlock(data_writer_1_M_AXI_AWLOCK),
        .S01_AXI_awprot(data_writer_1_M_AXI_AWPROT),
        .S01_AXI_awqos(data_writer_1_M_AXI_AWQOS),
        .S01_AXI_awready(data_writer_1_M_AXI_AWREADY),
        .S01_AXI_awsize(data_writer_1_M_AXI_AWSIZE),
        .S01_AXI_awuser(data_writer_1_M_AXI_AWUSER),
        .S01_AXI_awvalid(data_writer_1_M_AXI_AWVALID),
        .S01_AXI_bid(data_writer_1_M_AXI_BID),
        .S01_AXI_bready(data_writer_1_M_AXI_BREADY),
        .S01_AXI_bresp(data_writer_1_M_AXI_BRESP),
        .S01_AXI_buser(data_writer_1_M_AXI_BUSER),
        .S01_AXI_bvalid(data_writer_1_M_AXI_BVALID),
        .S01_AXI_wdata(data_writer_1_M_AXI_WDATA),
        .S01_AXI_wlast(data_writer_1_M_AXI_WLAST),
        .S01_AXI_wready(data_writer_1_M_AXI_WREADY),
        .S01_AXI_wstrb(data_writer_1_M_AXI_WSTRB),
        .S01_AXI_wuser(data_writer_1_M_AXI_WUSER),
        .S01_AXI_wvalid(data_writer_1_M_AXI_WVALID),
        .S02_ACLK(ps_0_FCLK_CLK0),
        .S02_ARESETN(s00_axi_aresetn_1),
        .S02_AXI_awaddr(data_writer_2_M_AXI_AWADDR),
        .S02_AXI_awburst(data_writer_2_M_AXI_AWBURST),
        .S02_AXI_awcache(data_writer_2_M_AXI_AWCACHE),
        .S02_AXI_awid(data_writer_2_M_AXI_AWID),
        .S02_AXI_awlen(data_writer_2_M_AXI_AWLEN),
        .S02_AXI_awlock(data_writer_2_M_AXI_AWLOCK),
        .S02_AXI_awprot(data_writer_2_M_AXI_AWPROT),
        .S02_AXI_awqos(data_writer_2_M_AXI_AWQOS),
        .S02_AXI_awready(data_writer_2_M_AXI_AWREADY),
        .S02_AXI_awsize(data_writer_2_M_AXI_AWSIZE),
        .S02_AXI_awuser(data_writer_2_M_AXI_AWUSER),
        .S02_AXI_awvalid(data_writer_2_M_AXI_AWVALID),
        .S02_AXI_bid(data_writer_2_M_AXI_BID),
        .S02_AXI_bready(data_writer_2_M_AXI_BREADY),
        .S02_AXI_bresp(data_writer_2_M_AXI_BRESP),
        .S02_AXI_buser(data_writer_2_M_AXI_BUSER),
        .S02_AXI_bvalid(data_writer_2_M_AXI_BVALID),
        .S02_AXI_wdata(data_writer_2_M_AXI_WDATA),
        .S02_AXI_wlast(data_writer_2_M_AXI_WLAST),
        .S02_AXI_wready(data_writer_2_M_AXI_WREADY),
        .S02_AXI_wstrb(data_writer_2_M_AXI_WSTRB),
        .S02_AXI_wuser(data_writer_2_M_AXI_WUSER),
        .S02_AXI_wvalid(data_writer_2_M_AXI_WVALID),
        .S03_ACLK(ps_0_FCLK_CLK0),
        .S03_ARESETN(s00_axi_aresetn_1),
        .S03_AXI_awaddr(data_writer_3_M_AXI_AWADDR),
        .S03_AXI_awburst(data_writer_3_M_AXI_AWBURST),
        .S03_AXI_awcache(data_writer_3_M_AXI_AWCACHE),
        .S03_AXI_awid(data_writer_3_M_AXI_AWID),
        .S03_AXI_awlen(data_writer_3_M_AXI_AWLEN),
        .S03_AXI_awlock(data_writer_3_M_AXI_AWLOCK),
        .S03_AXI_awprot(data_writer_3_M_AXI_AWPROT),
        .S03_AXI_awqos(data_writer_3_M_AXI_AWQOS),
        .S03_AXI_awready(data_writer_3_M_AXI_AWREADY),
        .S03_AXI_awsize(data_writer_3_M_AXI_AWSIZE),
        .S03_AXI_awuser(data_writer_3_M_AXI_AWUSER),
        .S03_AXI_awvalid(data_writer_3_M_AXI_AWVALID),
        .S03_AXI_bid(data_writer_3_M_AXI_BID),
        .S03_AXI_bready(data_writer_3_M_AXI_BREADY),
        .S03_AXI_bresp(data_writer_3_M_AXI_BRESP),
        .S03_AXI_buser(data_writer_3_M_AXI_BUSER),
        .S03_AXI_bvalid(data_writer_3_M_AXI_BVALID),
        .S03_AXI_wdata(data_writer_3_M_AXI_WDATA),
        .S03_AXI_wlast(data_writer_3_M_AXI_WLAST),
        .S03_AXI_wready(data_writer_3_M_AXI_WREADY),
        .S03_AXI_wstrb(data_writer_3_M_AXI_WSTRB),
        .S03_AXI_wuser(data_writer_3_M_AXI_WUSER),
        .S03_AXI_wvalid(data_writer_3_M_AXI_WVALID),
        .S04_ACLK(ps_0_FCLK_CLK0),
        .S04_ARESETN(s00_axi_aresetn_1),
        .S04_AXI_awaddr(data_writer_4_M_AXI_AWADDR),
        .S04_AXI_awburst(data_writer_4_M_AXI_AWBURST),
        .S04_AXI_awcache(data_writer_4_M_AXI_AWCACHE),
        .S04_AXI_awid(data_writer_4_M_AXI_AWID),
        .S04_AXI_awlen(data_writer_4_M_AXI_AWLEN),
        .S04_AXI_awlock(data_writer_4_M_AXI_AWLOCK),
        .S04_AXI_awprot(data_writer_4_M_AXI_AWPROT),
        .S04_AXI_awqos(data_writer_4_M_AXI_AWQOS),
        .S04_AXI_awready(data_writer_4_M_AXI_AWREADY),
        .S04_AXI_awsize(data_writer_4_M_AXI_AWSIZE),
        .S04_AXI_awuser(data_writer_4_M_AXI_AWUSER),
        .S04_AXI_awvalid(data_writer_4_M_AXI_AWVALID),
        .S04_AXI_bid(data_writer_4_M_AXI_BID),
        .S04_AXI_bready(data_writer_4_M_AXI_BREADY),
        .S04_AXI_bresp(data_writer_4_M_AXI_BRESP),
        .S04_AXI_buser(data_writer_4_M_AXI_BUSER),
        .S04_AXI_bvalid(data_writer_4_M_AXI_BVALID),
        .S04_AXI_wdata(data_writer_4_M_AXI_WDATA),
        .S04_AXI_wlast(data_writer_4_M_AXI_WLAST),
        .S04_AXI_wready(data_writer_4_M_AXI_WREADY),
        .S04_AXI_wstrb(data_writer_4_M_AXI_WSTRB),
        .S04_AXI_wuser(data_writer_4_M_AXI_WUSER),
        .S04_AXI_wvalid(data_writer_4_M_AXI_WVALID),
        .S05_ACLK(ps_0_FCLK_CLK0),
        .S05_ARESETN(s00_axi_aresetn_1),
        .S05_AXI_awaddr(data_writer_5_M_AXI_AWADDR),
        .S05_AXI_awburst(data_writer_5_M_AXI_AWBURST),
        .S05_AXI_awcache(data_writer_5_M_AXI_AWCACHE),
        .S05_AXI_awid(data_writer_5_M_AXI_AWID),
        .S05_AXI_awlen(data_writer_5_M_AXI_AWLEN),
        .S05_AXI_awlock(data_writer_5_M_AXI_AWLOCK),
        .S05_AXI_awprot(data_writer_5_M_AXI_AWPROT),
        .S05_AXI_awqos(data_writer_5_M_AXI_AWQOS),
        .S05_AXI_awready(data_writer_5_M_AXI_AWREADY),
        .S05_AXI_awsize(data_writer_5_M_AXI_AWSIZE),
        .S05_AXI_awuser(data_writer_5_M_AXI_AWUSER),
        .S05_AXI_awvalid(data_writer_5_M_AXI_AWVALID),
        .S05_AXI_bid(data_writer_5_M_AXI_BID),
        .S05_AXI_bready(data_writer_5_M_AXI_BREADY),
        .S05_AXI_bresp(data_writer_5_M_AXI_BRESP),
        .S05_AXI_buser(data_writer_5_M_AXI_BUSER),
        .S05_AXI_bvalid(data_writer_5_M_AXI_BVALID),
        .S05_AXI_wdata(data_writer_5_M_AXI_WDATA),
        .S05_AXI_wlast(data_writer_5_M_AXI_WLAST),
        .S05_AXI_wready(data_writer_5_M_AXI_WREADY),
        .S05_AXI_wstrb(data_writer_5_M_AXI_WSTRB),
        .S05_AXI_wuser(data_writer_5_M_AXI_WUSER),
        .S05_AXI_wvalid(data_writer_5_M_AXI_WVALID),
        .S06_ACLK(ps_0_FCLK_CLK0),
        .S06_ARESETN(s00_axi_aresetn_1),
        .S06_AXI_awaddr(data_writer_6_M_AXI_AWADDR),
        .S06_AXI_awburst(data_writer_6_M_AXI_AWBURST),
        .S06_AXI_awcache(data_writer_6_M_AXI_AWCACHE),
        .S06_AXI_awid(data_writer_6_M_AXI_AWID),
        .S06_AXI_awlen(data_writer_6_M_AXI_AWLEN),
        .S06_AXI_awlock(data_writer_6_M_AXI_AWLOCK),
        .S06_AXI_awprot(data_writer_6_M_AXI_AWPROT),
        .S06_AXI_awqos(data_writer_6_M_AXI_AWQOS),
        .S06_AXI_awready(data_writer_6_M_AXI_AWREADY),
        .S06_AXI_awsize(data_writer_6_M_AXI_AWSIZE),
        .S06_AXI_awuser(data_writer_6_M_AXI_AWUSER),
        .S06_AXI_awvalid(data_writer_6_M_AXI_AWVALID),
        .S06_AXI_bid(data_writer_6_M_AXI_BID),
        .S06_AXI_bready(data_writer_6_M_AXI_BREADY),
        .S06_AXI_bresp(data_writer_6_M_AXI_BRESP),
        .S06_AXI_buser(data_writer_6_M_AXI_BUSER),
        .S06_AXI_bvalid(data_writer_6_M_AXI_BVALID),
        .S06_AXI_wdata(data_writer_6_M_AXI_WDATA),
        .S06_AXI_wlast(data_writer_6_M_AXI_WLAST),
        .S06_AXI_wready(data_writer_6_M_AXI_WREADY),
        .S06_AXI_wstrb(data_writer_6_M_AXI_WSTRB),
        .S06_AXI_wuser(data_writer_6_M_AXI_WUSER),
        .S06_AXI_wvalid(data_writer_6_M_AXI_WVALID),
        .S07_ACLK(ps_0_FCLK_CLK0),
        .S07_ARESETN(s00_axi_aresetn_1),
        .S07_AXI_awaddr(data_writer_7_M_AXI_AWADDR),
        .S07_AXI_awburst(data_writer_7_M_AXI_AWBURST),
        .S07_AXI_awcache(data_writer_7_M_AXI_AWCACHE),
        .S07_AXI_awid(data_writer_7_M_AXI_AWID),
        .S07_AXI_awlen(data_writer_7_M_AXI_AWLEN),
        .S07_AXI_awlock(data_writer_7_M_AXI_AWLOCK),
        .S07_AXI_awprot(data_writer_7_M_AXI_AWPROT),
        .S07_AXI_awqos(data_writer_7_M_AXI_AWQOS),
        .S07_AXI_awready(data_writer_7_M_AXI_AWREADY),
        .S07_AXI_awsize(data_writer_7_M_AXI_AWSIZE),
        .S07_AXI_awuser(data_writer_7_M_AXI_AWUSER),
        .S07_AXI_awvalid(data_writer_7_M_AXI_AWVALID),
        .S07_AXI_bid(data_writer_7_M_AXI_BID),
        .S07_AXI_bready(data_writer_7_M_AXI_BREADY),
        .S07_AXI_bresp(data_writer_7_M_AXI_BRESP),
        .S07_AXI_buser(data_writer_7_M_AXI_BUSER),
        .S07_AXI_bvalid(data_writer_7_M_AXI_BVALID),
        .S07_AXI_wdata(data_writer_7_M_AXI_WDATA),
        .S07_AXI_wlast(data_writer_7_M_AXI_WLAST),
        .S07_AXI_wready(data_writer_7_M_AXI_WREADY),
        .S07_AXI_wstrb(data_writer_7_M_AXI_WSTRB),
        .S07_AXI_wuser(data_writer_7_M_AXI_WUSER),
        .S07_AXI_wvalid(data_writer_7_M_AXI_WVALID));
  system_data_padder_1_0 ch_a_amp_RnM
       (.data_in(ch_a_amp_1),
        .data_out(data_padder_1_data_out));
  system_data_padder_2_0 ch_a_phase_RnM
       (.data_in(ch_a_phase_1),
        .data_out(data_padder_2_data_out));
  system_data_padder_0_0 ch_a_x
       (.data_in(ch_a_X_1),
        .data_out(data_padder_0_data_out));
  system_data_padder_0_1 ch_a_y
       (.data_in(ch_a_Y_1),
        .data_out(data_padder_0_data_out1));
  system_data_padder_3_0 ch_b_X_RnM
       (.data_in(ch_b_X_1),
        .data_out(data_padder_3_data_out));
  system_data_padder_4_0 ch_b_Y_RnM
       (.data_in(ch_b_Y_1),
        .data_out(data_padder_4_data_out));
  system_data_padder_5_0 ch_b_amp_RnM
       (.data_in(ch_b_amp_1),
        .data_out(data_padder_5_data_out));
  system_data_padder_6_0 ch_b_phase_RnM
       (.data_in(ch_b_phase_1),
        .data_out(data_padder_6_data_out));
  system_data_writer_0_3 data_writer_a_amp
       (.CLK(ps_0_FCLK_CLK0),
        .M_AXI_ARESETN(s00_axi_aresetn_1),
        .M_AXI_AWADDR(data_writer_2_M_AXI_AWADDR),
        .M_AXI_AWBURST(data_writer_2_M_AXI_AWBURST),
        .M_AXI_AWCACHE(data_writer_2_M_AXI_AWCACHE),
        .M_AXI_AWID(data_writer_2_M_AXI_AWID),
        .M_AXI_AWLEN(data_writer_2_M_AXI_AWLEN),
        .M_AXI_AWLOCK(data_writer_2_M_AXI_AWLOCK),
        .M_AXI_AWPROT(data_writer_2_M_AXI_AWPROT),
        .M_AXI_AWQOS(data_writer_2_M_AXI_AWQOS),
        .M_AXI_AWREADY(data_writer_2_M_AXI_AWREADY),
        .M_AXI_AWSIZE(data_writer_2_M_AXI_AWSIZE),
        .M_AXI_AWUSER(data_writer_2_M_AXI_AWUSER),
        .M_AXI_AWVALID(data_writer_2_M_AXI_AWVALID),
        .M_AXI_BID(data_writer_2_M_AXI_BID[2:0]),
        .M_AXI_BREADY(data_writer_2_M_AXI_BREADY),
        .M_AXI_BRESP(data_writer_2_M_AXI_BRESP),
        .M_AXI_BUSER(data_writer_2_M_AXI_BUSER),
        .M_AXI_BVALID(data_writer_2_M_AXI_BVALID),
        .M_AXI_WDATA(data_writer_2_M_AXI_WDATA),
        .M_AXI_WLAST(data_writer_2_M_AXI_WLAST),
        .M_AXI_WREADY(data_writer_2_M_AXI_WREADY),
        .M_AXI_WSTRB(data_writer_2_M_AXI_WSTRB),
        .M_AXI_WUSER(data_writer_2_M_AXI_WUSER),
        .M_AXI_WVALID(data_writer_2_M_AXI_WVALID),
        .data_in(data_padder_1_data_out),
        .do_output(Net1),
        .offset(Net));
  system_data_writer_0_4 data_writer_a_phase
       (.CLK(ps_0_FCLK_CLK0),
        .M_AXI_ARESETN(s00_axi_aresetn_1),
        .M_AXI_AWADDR(data_writer_3_M_AXI_AWADDR),
        .M_AXI_AWBURST(data_writer_3_M_AXI_AWBURST),
        .M_AXI_AWCACHE(data_writer_3_M_AXI_AWCACHE),
        .M_AXI_AWID(data_writer_3_M_AXI_AWID),
        .M_AXI_AWLEN(data_writer_3_M_AXI_AWLEN),
        .M_AXI_AWLOCK(data_writer_3_M_AXI_AWLOCK),
        .M_AXI_AWPROT(data_writer_3_M_AXI_AWPROT),
        .M_AXI_AWQOS(data_writer_3_M_AXI_AWQOS),
        .M_AXI_AWREADY(data_writer_3_M_AXI_AWREADY),
        .M_AXI_AWSIZE(data_writer_3_M_AXI_AWSIZE),
        .M_AXI_AWUSER(data_writer_3_M_AXI_AWUSER),
        .M_AXI_AWVALID(data_writer_3_M_AXI_AWVALID),
        .M_AXI_BID(data_writer_3_M_AXI_BID[2:0]),
        .M_AXI_BREADY(data_writer_3_M_AXI_BREADY),
        .M_AXI_BRESP(data_writer_3_M_AXI_BRESP),
        .M_AXI_BUSER(data_writer_3_M_AXI_BUSER),
        .M_AXI_BVALID(data_writer_3_M_AXI_BVALID),
        .M_AXI_WDATA(data_writer_3_M_AXI_WDATA),
        .M_AXI_WLAST(data_writer_3_M_AXI_WLAST),
        .M_AXI_WREADY(data_writer_3_M_AXI_WREADY),
        .M_AXI_WSTRB(data_writer_3_M_AXI_WSTRB),
        .M_AXI_WUSER(data_writer_3_M_AXI_WUSER),
        .M_AXI_WVALID(data_writer_3_M_AXI_WVALID),
        .data_in(data_padder_2_data_out),
        .do_output(Net1),
        .offset(Net));
  system_data_writer_0_0 data_writer_a_x
       (.CLK(ps_0_FCLK_CLK0),
        .M_AXI_ARESETN(s00_axi_aresetn_1),
        .M_AXI_AWADDR(data_writer_0_M_AXI_AWADDR),
        .M_AXI_AWBURST(data_writer_0_M_AXI_AWBURST),
        .M_AXI_AWCACHE(data_writer_0_M_AXI_AWCACHE),
        .M_AXI_AWID(data_writer_0_M_AXI_AWID),
        .M_AXI_AWLEN(data_writer_0_M_AXI_AWLEN),
        .M_AXI_AWLOCK(data_writer_0_M_AXI_AWLOCK),
        .M_AXI_AWPROT(data_writer_0_M_AXI_AWPROT),
        .M_AXI_AWQOS(data_writer_0_M_AXI_AWQOS),
        .M_AXI_AWREADY(data_writer_0_M_AXI_AWREADY),
        .M_AXI_AWSIZE(data_writer_0_M_AXI_AWSIZE),
        .M_AXI_AWUSER(data_writer_0_M_AXI_AWUSER),
        .M_AXI_AWVALID(data_writer_0_M_AXI_AWVALID),
        .M_AXI_BID(data_writer_0_M_AXI_BID[2:0]),
        .M_AXI_BREADY(data_writer_0_M_AXI_BREADY),
        .M_AXI_BRESP(data_writer_0_M_AXI_BRESP),
        .M_AXI_BUSER(data_writer_0_M_AXI_BUSER),
        .M_AXI_BVALID(data_writer_0_M_AXI_BVALID),
        .M_AXI_WDATA(data_writer_0_M_AXI_WDATA),
        .M_AXI_WLAST(data_writer_0_M_AXI_WLAST),
        .M_AXI_WREADY(data_writer_0_M_AXI_WREADY),
        .M_AXI_WSTRB(data_writer_0_M_AXI_WSTRB),
        .M_AXI_WUSER(data_writer_0_M_AXI_WUSER),
        .M_AXI_WVALID(data_writer_0_M_AXI_WVALID),
        .data_in(data_padder_0_data_out),
        .do_output(Net1),
        .offset(Net));
  system_data_writer_0_2 data_writer_a_y
       (.CLK(ps_0_FCLK_CLK0),
        .M_AXI_ARESETN(s00_axi_aresetn_1),
        .M_AXI_AWADDR(data_writer_1_M_AXI_AWADDR),
        .M_AXI_AWBURST(data_writer_1_M_AXI_AWBURST),
        .M_AXI_AWCACHE(data_writer_1_M_AXI_AWCACHE),
        .M_AXI_AWID(data_writer_1_M_AXI_AWID),
        .M_AXI_AWLEN(data_writer_1_M_AXI_AWLEN),
        .M_AXI_AWLOCK(data_writer_1_M_AXI_AWLOCK),
        .M_AXI_AWPROT(data_writer_1_M_AXI_AWPROT),
        .M_AXI_AWQOS(data_writer_1_M_AXI_AWQOS),
        .M_AXI_AWREADY(data_writer_1_M_AXI_AWREADY),
        .M_AXI_AWSIZE(data_writer_1_M_AXI_AWSIZE),
        .M_AXI_AWUSER(data_writer_1_M_AXI_AWUSER),
        .M_AXI_AWVALID(data_writer_1_M_AXI_AWVALID),
        .M_AXI_BID(data_writer_1_M_AXI_BID[2:0]),
        .M_AXI_BREADY(data_writer_1_M_AXI_BREADY),
        .M_AXI_BRESP(data_writer_1_M_AXI_BRESP),
        .M_AXI_BUSER(data_writer_1_M_AXI_BUSER),
        .M_AXI_BVALID(data_writer_1_M_AXI_BVALID),
        .M_AXI_WDATA(data_writer_1_M_AXI_WDATA),
        .M_AXI_WLAST(data_writer_1_M_AXI_WLAST),
        .M_AXI_WREADY(data_writer_1_M_AXI_WREADY),
        .M_AXI_WSTRB(data_writer_1_M_AXI_WSTRB),
        .M_AXI_WUSER(data_writer_1_M_AXI_WUSER),
        .M_AXI_WVALID(data_writer_1_M_AXI_WVALID),
        .data_in(data_padder_0_data_out1),
        .do_output(Net1),
        .offset(Net));
  system_data_writer_0_7 data_writer_b_amp
       (.CLK(ps_0_FCLK_CLK0),
        .M_AXI_ARESETN(s00_axi_aresetn_1),
        .M_AXI_AWADDR(data_writer_6_M_AXI_AWADDR),
        .M_AXI_AWBURST(data_writer_6_M_AXI_AWBURST),
        .M_AXI_AWCACHE(data_writer_6_M_AXI_AWCACHE),
        .M_AXI_AWID(data_writer_6_M_AXI_AWID),
        .M_AXI_AWLEN(data_writer_6_M_AXI_AWLEN),
        .M_AXI_AWLOCK(data_writer_6_M_AXI_AWLOCK),
        .M_AXI_AWPROT(data_writer_6_M_AXI_AWPROT),
        .M_AXI_AWQOS(data_writer_6_M_AXI_AWQOS),
        .M_AXI_AWREADY(data_writer_6_M_AXI_AWREADY),
        .M_AXI_AWSIZE(data_writer_6_M_AXI_AWSIZE),
        .M_AXI_AWUSER(data_writer_6_M_AXI_AWUSER),
        .M_AXI_AWVALID(data_writer_6_M_AXI_AWVALID),
        .M_AXI_BID(data_writer_6_M_AXI_BID[2:0]),
        .M_AXI_BREADY(data_writer_6_M_AXI_BREADY),
        .M_AXI_BRESP(data_writer_6_M_AXI_BRESP),
        .M_AXI_BUSER(data_writer_6_M_AXI_BUSER),
        .M_AXI_BVALID(data_writer_6_M_AXI_BVALID),
        .M_AXI_WDATA(data_writer_6_M_AXI_WDATA),
        .M_AXI_WLAST(data_writer_6_M_AXI_WLAST),
        .M_AXI_WREADY(data_writer_6_M_AXI_WREADY),
        .M_AXI_WSTRB(data_writer_6_M_AXI_WSTRB),
        .M_AXI_WUSER(data_writer_6_M_AXI_WUSER),
        .M_AXI_WVALID(data_writer_6_M_AXI_WVALID),
        .data_in(data_padder_5_data_out),
        .do_output(Net1),
        .offset(Net));
  system_data_writer_0_8 data_writer_b_phase
       (.CLK(ps_0_FCLK_CLK0),
        .M_AXI_ARESETN(s00_axi_aresetn_1),
        .M_AXI_AWADDR(data_writer_7_M_AXI_AWADDR),
        .M_AXI_AWBURST(data_writer_7_M_AXI_AWBURST),
        .M_AXI_AWCACHE(data_writer_7_M_AXI_AWCACHE),
        .M_AXI_AWID(data_writer_7_M_AXI_AWID),
        .M_AXI_AWLEN(data_writer_7_M_AXI_AWLEN),
        .M_AXI_AWLOCK(data_writer_7_M_AXI_AWLOCK),
        .M_AXI_AWPROT(data_writer_7_M_AXI_AWPROT),
        .M_AXI_AWQOS(data_writer_7_M_AXI_AWQOS),
        .M_AXI_AWREADY(data_writer_7_M_AXI_AWREADY),
        .M_AXI_AWSIZE(data_writer_7_M_AXI_AWSIZE),
        .M_AXI_AWUSER(data_writer_7_M_AXI_AWUSER),
        .M_AXI_AWVALID(data_writer_7_M_AXI_AWVALID),
        .M_AXI_BID(data_writer_7_M_AXI_BID[2:0]),
        .M_AXI_BREADY(data_writer_7_M_AXI_BREADY),
        .M_AXI_BRESP(data_writer_7_M_AXI_BRESP),
        .M_AXI_BUSER(data_writer_7_M_AXI_BUSER),
        .M_AXI_BVALID(data_writer_7_M_AXI_BVALID),
        .M_AXI_WDATA(data_writer_7_M_AXI_WDATA),
        .M_AXI_WLAST(data_writer_7_M_AXI_WLAST),
        .M_AXI_WREADY(data_writer_7_M_AXI_WREADY),
        .M_AXI_WSTRB(data_writer_7_M_AXI_WSTRB),
        .M_AXI_WUSER(data_writer_7_M_AXI_WUSER),
        .M_AXI_WVALID(data_writer_7_M_AXI_WVALID),
        .data_in(data_padder_6_data_out),
        .do_output(Net1),
        .offset(Net));
  system_data_writer_0_5 data_writer_b_x
       (.CLK(ps_0_FCLK_CLK0),
        .M_AXI_ARESETN(s00_axi_aresetn_1),
        .M_AXI_AWADDR(data_writer_4_M_AXI_AWADDR),
        .M_AXI_AWBURST(data_writer_4_M_AXI_AWBURST),
        .M_AXI_AWCACHE(data_writer_4_M_AXI_AWCACHE),
        .M_AXI_AWID(data_writer_4_M_AXI_AWID),
        .M_AXI_AWLEN(data_writer_4_M_AXI_AWLEN),
        .M_AXI_AWLOCK(data_writer_4_M_AXI_AWLOCK),
        .M_AXI_AWPROT(data_writer_4_M_AXI_AWPROT),
        .M_AXI_AWQOS(data_writer_4_M_AXI_AWQOS),
        .M_AXI_AWREADY(data_writer_4_M_AXI_AWREADY),
        .M_AXI_AWSIZE(data_writer_4_M_AXI_AWSIZE),
        .M_AXI_AWUSER(data_writer_4_M_AXI_AWUSER),
        .M_AXI_AWVALID(data_writer_4_M_AXI_AWVALID),
        .M_AXI_BID(data_writer_4_M_AXI_BID[2:0]),
        .M_AXI_BREADY(data_writer_4_M_AXI_BREADY),
        .M_AXI_BRESP(data_writer_4_M_AXI_BRESP),
        .M_AXI_BUSER(data_writer_4_M_AXI_BUSER),
        .M_AXI_BVALID(data_writer_4_M_AXI_BVALID),
        .M_AXI_WDATA(data_writer_4_M_AXI_WDATA),
        .M_AXI_WLAST(data_writer_4_M_AXI_WLAST),
        .M_AXI_WREADY(data_writer_4_M_AXI_WREADY),
        .M_AXI_WSTRB(data_writer_4_M_AXI_WSTRB),
        .M_AXI_WUSER(data_writer_4_M_AXI_WUSER),
        .M_AXI_WVALID(data_writer_4_M_AXI_WVALID),
        .data_in(data_padder_3_data_out),
        .do_output(Net1),
        .offset(Net));
  system_data_writer_0_6 data_writer_b_y
       (.CLK(ps_0_FCLK_CLK0),
        .M_AXI_ARESETN(s00_axi_aresetn_1),
        .M_AXI_AWADDR(data_writer_5_M_AXI_AWADDR),
        .M_AXI_AWBURST(data_writer_5_M_AXI_AWBURST),
        .M_AXI_AWCACHE(data_writer_5_M_AXI_AWCACHE),
        .M_AXI_AWID(data_writer_5_M_AXI_AWID),
        .M_AXI_AWLEN(data_writer_5_M_AXI_AWLEN),
        .M_AXI_AWLOCK(data_writer_5_M_AXI_AWLOCK),
        .M_AXI_AWPROT(data_writer_5_M_AXI_AWPROT),
        .M_AXI_AWQOS(data_writer_5_M_AXI_AWQOS),
        .M_AXI_AWREADY(data_writer_5_M_AXI_AWREADY),
        .M_AXI_AWSIZE(data_writer_5_M_AXI_AWSIZE),
        .M_AXI_AWUSER(data_writer_5_M_AXI_AWUSER),
        .M_AXI_AWVALID(data_writer_5_M_AXI_AWVALID),
        .M_AXI_BID(data_writer_5_M_AXI_BID[2:0]),
        .M_AXI_BREADY(data_writer_5_M_AXI_BREADY),
        .M_AXI_BRESP(data_writer_5_M_AXI_BRESP),
        .M_AXI_BUSER(data_writer_5_M_AXI_BUSER),
        .M_AXI_BVALID(data_writer_5_M_AXI_BVALID),
        .M_AXI_WDATA(data_writer_5_M_AXI_WDATA),
        .M_AXI_WLAST(data_writer_5_M_AXI_WLAST),
        .M_AXI_WREADY(data_writer_5_M_AXI_WREADY),
        .M_AXI_WSTRB(data_writer_5_M_AXI_WSTRB),
        .M_AXI_WUSER(data_writer_5_M_AXI_WUSER),
        .M_AXI_WVALID(data_writer_5_M_AXI_WVALID),
        .data_in(data_padder_4_data_out),
        .do_output(Net1),
        .offset(Net));
  system_highest_bit_0_0 highest_bit_0
       (.bit_out(Net1),
        .bus_in(sample_clk_count_out));
  system_mem_manager_0_0 mem_manager_0
       (.clk(ps_0_FCLK_CLK0),
        .counter(counter_1),
        .counter_full(mem_manager_0_counter_o),
        .counter_min(mem_manager_0_counter_min),
        .end_addr(mem_manager_0_end_addr),
        .loop_flag(loop_flag_1),
        .offset(Net),
        .sample(Net1),
        .start_addr(mem_manager_0_start_addr));
  system_ps_0_axi_periph_0 ps_0_axi_periph
       (.ACLK(ps_0_FCLK_CLK0),
        .ARESETN(rst_clk_wiz_0_125M_interconnect_aresetn),
        .M00_ACLK(ps_0_FCLK_CLK0),
        .M00_ARESETN(s00_axi_aresetn_1),
        .M00_AXI_araddr(S00_AXI_1_ARADDR),
        .M00_AXI_arprot(S00_AXI_1_ARPROT),
        .M00_AXI_arready(S00_AXI_1_ARREADY),
        .M00_AXI_arvalid(S00_AXI_1_ARVALID),
        .M00_AXI_awaddr(S00_AXI_1_AWADDR),
        .M00_AXI_awprot(S00_AXI_1_AWPROT),
        .M00_AXI_awready(S00_AXI_1_AWREADY),
        .M00_AXI_awvalid(S00_AXI_1_AWVALID),
        .M00_AXI_bready(S00_AXI_1_BREADY),
        .M00_AXI_bresp(S00_AXI_1_BRESP),
        .M00_AXI_bvalid(S00_AXI_1_BVALID),
        .M00_AXI_rdata(S00_AXI_1_RDATA),
        .M00_AXI_rready(S00_AXI_1_RREADY),
        .M00_AXI_rresp(S00_AXI_1_RRESP),
        .M00_AXI_rvalid(S00_AXI_1_RVALID),
        .M00_AXI_wdata(S00_AXI_1_WDATA),
        .M00_AXI_wready(S00_AXI_1_WREADY),
        .M00_AXI_wstrb(S00_AXI_1_WSTRB),
        .M00_AXI_wvalid(S00_AXI_1_WVALID),
        .S00_ACLK(ps_0_FCLK_CLK0),
        .S00_ARESETN(s00_axi_aresetn_1),
        .S00_AXI_araddr(Conn1_ARADDR),
        .S00_AXI_arburst(Conn1_ARBURST),
        .S00_AXI_arcache(Conn1_ARCACHE),
        .S00_AXI_arid(Conn1_ARID),
        .S00_AXI_arlen(Conn1_ARLEN),
        .S00_AXI_arlock(Conn1_ARLOCK),
        .S00_AXI_arprot(Conn1_ARPROT),
        .S00_AXI_arqos(Conn1_ARQOS),
        .S00_AXI_arready(Conn1_ARREADY),
        .S00_AXI_arsize(Conn1_ARSIZE),
        .S00_AXI_arvalid(Conn1_ARVALID),
        .S00_AXI_awaddr(Conn1_AWADDR),
        .S00_AXI_awburst(Conn1_AWBURST),
        .S00_AXI_awcache(Conn1_AWCACHE),
        .S00_AXI_awid(Conn1_AWID),
        .S00_AXI_awlen(Conn1_AWLEN),
        .S00_AXI_awlock(Conn1_AWLOCK),
        .S00_AXI_awprot(Conn1_AWPROT),
        .S00_AXI_awqos(Conn1_AWQOS),
        .S00_AXI_awready(Conn1_AWREADY),
        .S00_AXI_awsize(Conn1_AWSIZE),
        .S00_AXI_awvalid(Conn1_AWVALID),
        .S00_AXI_bid(Conn1_BID),
        .S00_AXI_bready(Conn1_BREADY),
        .S00_AXI_bresp(Conn1_BRESP),
        .S00_AXI_bvalid(Conn1_BVALID),
        .S00_AXI_rdata(Conn1_RDATA),
        .S00_AXI_rid(Conn1_RID),
        .S00_AXI_rlast(Conn1_RLAST),
        .S00_AXI_rready(Conn1_RREADY),
        .S00_AXI_rresp(Conn1_RRESP),
        .S00_AXI_rvalid(Conn1_RVALID),
        .S00_AXI_wdata(Conn1_WDATA),
        .S00_AXI_wid(Conn1_WID),
        .S00_AXI_wlast(Conn1_WLAST),
        .S00_AXI_wready(Conn1_WREADY),
        .S00_AXI_wstrb(Conn1_WSTRB),
        .S00_AXI_wvalid(Conn1_WVALID));
  system_rst_clk_wiz_0_125M_0 rst_clk_wiz_0_125M
       (.aux_reset_in(1'b1),
        .dcm_locked(dcm_locked_1),
        .ext_reset_in(ext_reset_in_1),
        .interconnect_aresetn(rst_clk_wiz_0_125M_interconnect_aresetn),
        .mb_debug_sys_rst(1'b0),
        .peripheral_aresetn(s00_axi_aresetn_1),
        .slowest_sync_clk(ps_0_FCLK_CLK0));
  system_two_clk_accum_0_1 sample_clk
       (.count_clk(count_clk_1),
        .count_out(sample_clk_count_out),
        .inc_in(settings_sample_cnt),
        .out_clk(ps_0_FCLK_CLK0),
        .sync_i(sync_i_1));
  settings_imp_1WQD0NO settings
       (.S00_AXI_araddr(S00_AXI_1_ARADDR),
        .S00_AXI_arprot(S00_AXI_1_ARPROT),
        .S00_AXI_arready(S00_AXI_1_ARREADY),
        .S00_AXI_arvalid(S00_AXI_1_ARVALID),
        .S00_AXI_awaddr(S00_AXI_1_AWADDR),
        .S00_AXI_awprot(S00_AXI_1_AWPROT),
        .S00_AXI_awready(S00_AXI_1_AWREADY),
        .S00_AXI_awvalid(S00_AXI_1_AWVALID),
        .S00_AXI_bready(S00_AXI_1_BREADY),
        .S00_AXI_bresp(S00_AXI_1_BRESP),
        .S00_AXI_bvalid(S00_AXI_1_BVALID),
        .S00_AXI_rdata(S00_AXI_1_RDATA),
        .S00_AXI_rready(S00_AXI_1_RREADY),
        .S00_AXI_rresp(S00_AXI_1_RRESP),
        .S00_AXI_rvalid(S00_AXI_1_RVALID),
        .S00_AXI_wdata(S00_AXI_1_WDATA),
        .S00_AXI_wready(S00_AXI_1_WREADY),
        .S00_AXI_wstrb(S00_AXI_1_WSTRB),
        .S00_AXI_wvalid(S00_AXI_1_WVALID),
        .amp_mult(default_val_0_out_bus3),
        .avg_inc_cnt(out_val_0_out_bus),
        .ch_a_Y(data_padder_0_data_out1),
        .ch_a_amp(data_padder_1_data_out),
        .ch_a_x(data_padder_0_data_out),
        .ch_b_X(data_padder_3_data_out),
        .ch_b_Y(data_padder_4_data_out),
        .ch_b_amp(data_padder_5_data_out),
        .ch_b_phase(data_padder_6_data_out),
        .cha_a_phase(data_padder_2_data_out),
        .counter(mem_manager_0_counter_o),
        .dac_a_mult(dac_a_mult_out_bus),
        .dac_b_mult(dac_b_mult_out_bus),
        .mod_phase(default_val_0_out_bus4),
        .mode_flags(default_val_0_out_bus1),
        .offset_end(mem_manager_0_end_addr),
        .offset_start(mem_manager_0_start_addr),
        .phase_inc(default_val_0_out_bus),
        .s00_axi_aclk(ps_0_FCLK_CLK0),
        .s00_axi_aresetn(s00_axi_aresetn_1),
        .sample_cnt(settings_sample_cnt),
        .sweep_add(default_val_0_out_bus2),
        .sweep_max(sweep_max_out_bus),
        .sweep_min(sweep_min_out_bus));
endmodule

module s00_couplers_imp_11QQSXY
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_buser,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wuser,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_buser,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [2:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_buser;
  input M_AXI_bvalid;
  output [31:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wuser;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [2:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_buser;
  output S_AXI_bvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire [31:0]s00_couplers_to_s00_couplers_AWADDR;
  wire [1:0]s00_couplers_to_s00_couplers_AWBURST;
  wire [3:0]s00_couplers_to_s00_couplers_AWCACHE;
  wire [2:0]s00_couplers_to_s00_couplers_AWID;
  wire [7:0]s00_couplers_to_s00_couplers_AWLEN;
  wire s00_couplers_to_s00_couplers_AWLOCK;
  wire [2:0]s00_couplers_to_s00_couplers_AWPROT;
  wire [3:0]s00_couplers_to_s00_couplers_AWQOS;
  wire s00_couplers_to_s00_couplers_AWREADY;
  wire [2:0]s00_couplers_to_s00_couplers_AWSIZE;
  wire [0:0]s00_couplers_to_s00_couplers_AWUSER;
  wire s00_couplers_to_s00_couplers_AWVALID;
  wire [5:0]s00_couplers_to_s00_couplers_BID;
  wire s00_couplers_to_s00_couplers_BREADY;
  wire [1:0]s00_couplers_to_s00_couplers_BRESP;
  wire [0:0]s00_couplers_to_s00_couplers_BUSER;
  wire s00_couplers_to_s00_couplers_BVALID;
  wire [31:0]s00_couplers_to_s00_couplers_WDATA;
  wire s00_couplers_to_s00_couplers_WLAST;
  wire s00_couplers_to_s00_couplers_WREADY;
  wire [3:0]s00_couplers_to_s00_couplers_WSTRB;
  wire [0:0]s00_couplers_to_s00_couplers_WUSER;
  wire s00_couplers_to_s00_couplers_WVALID;

  assign M_AXI_awaddr[31:0] = s00_couplers_to_s00_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s00_couplers_to_s00_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s00_couplers_to_s00_couplers_AWCACHE;
  assign M_AXI_awid[2:0] = s00_couplers_to_s00_couplers_AWID;
  assign M_AXI_awlen[7:0] = s00_couplers_to_s00_couplers_AWLEN;
  assign M_AXI_awlock = s00_couplers_to_s00_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s00_couplers_to_s00_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s00_couplers_to_s00_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s00_couplers_to_s00_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s00_couplers_to_s00_couplers_AWUSER;
  assign M_AXI_awvalid = s00_couplers_to_s00_couplers_AWVALID;
  assign M_AXI_bready = s00_couplers_to_s00_couplers_BREADY;
  assign M_AXI_wdata[31:0] = s00_couplers_to_s00_couplers_WDATA;
  assign M_AXI_wlast = s00_couplers_to_s00_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = s00_couplers_to_s00_couplers_WSTRB;
  assign M_AXI_wuser[0] = s00_couplers_to_s00_couplers_WUSER;
  assign M_AXI_wvalid = s00_couplers_to_s00_couplers_WVALID;
  assign S_AXI_awready = s00_couplers_to_s00_couplers_AWREADY;
  assign S_AXI_bid[5:0] = s00_couplers_to_s00_couplers_BID;
  assign S_AXI_bresp[1:0] = s00_couplers_to_s00_couplers_BRESP;
  assign S_AXI_buser[0] = s00_couplers_to_s00_couplers_BUSER;
  assign S_AXI_bvalid = s00_couplers_to_s00_couplers_BVALID;
  assign S_AXI_wready = s00_couplers_to_s00_couplers_WREADY;
  assign s00_couplers_to_s00_couplers_AWADDR = S_AXI_awaddr[31:0];
  assign s00_couplers_to_s00_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_s00_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_s00_couplers_AWID = S_AXI_awid[2:0];
  assign s00_couplers_to_s00_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s00_couplers_to_s00_couplers_AWLOCK = S_AXI_awlock;
  assign s00_couplers_to_s00_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_s00_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_s00_couplers_AWREADY = M_AXI_awready;
  assign s00_couplers_to_s00_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_s00_couplers_AWUSER = S_AXI_awuser[0];
  assign s00_couplers_to_s00_couplers_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_s00_couplers_BID = M_AXI_bid[5:0];
  assign s00_couplers_to_s00_couplers_BREADY = S_AXI_bready;
  assign s00_couplers_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign s00_couplers_to_s00_couplers_BUSER = M_AXI_buser[0];
  assign s00_couplers_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign s00_couplers_to_s00_couplers_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_s00_couplers_WLAST = S_AXI_wlast;
  assign s00_couplers_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_s00_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_s00_couplers_WUSER = S_AXI_wuser[0];
  assign s00_couplers_to_s00_couplers_WVALID = S_AXI_wvalid;
endmodule

module s00_couplers_imp_H3WDR2
   (M_ACLK,
    M_ARESETN,
    M_AXI_araddr,
    M_AXI_arprot,
    M_AXI_arready,
    M_AXI_arvalid,
    M_AXI_awaddr,
    M_AXI_awprot,
    M_AXI_awready,
    M_AXI_awvalid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_bvalid,
    M_AXI_rdata,
    M_AXI_rready,
    M_AXI_rresp,
    M_AXI_rvalid,
    M_AXI_wdata,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_araddr,
    S_AXI_arburst,
    S_AXI_arcache,
    S_AXI_arid,
    S_AXI_arlen,
    S_AXI_arlock,
    S_AXI_arprot,
    S_AXI_arqos,
    S_AXI_arready,
    S_AXI_arsize,
    S_AXI_arvalid,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_bvalid,
    S_AXI_rdata,
    S_AXI_rid,
    S_AXI_rlast,
    S_AXI_rready,
    S_AXI_rresp,
    S_AXI_rvalid,
    S_AXI_wdata,
    S_AXI_wid,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_araddr;
  output [2:0]M_AXI_arprot;
  input M_AXI_arready;
  output M_AXI_arvalid;
  output [31:0]M_AXI_awaddr;
  output [2:0]M_AXI_awprot;
  input M_AXI_awready;
  output M_AXI_awvalid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input M_AXI_bvalid;
  input [31:0]M_AXI_rdata;
  output M_AXI_rready;
  input [1:0]M_AXI_rresp;
  input M_AXI_rvalid;
  output [31:0]M_AXI_wdata;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_araddr;
  input [1:0]S_AXI_arburst;
  input [3:0]S_AXI_arcache;
  input [11:0]S_AXI_arid;
  input [3:0]S_AXI_arlen;
  input [1:0]S_AXI_arlock;
  input [2:0]S_AXI_arprot;
  input [3:0]S_AXI_arqos;
  output S_AXI_arready;
  input [2:0]S_AXI_arsize;
  input S_AXI_arvalid;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [11:0]S_AXI_awid;
  input [3:0]S_AXI_awlen;
  input [1:0]S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input S_AXI_awvalid;
  output [11:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output S_AXI_bvalid;
  output [31:0]S_AXI_rdata;
  output [11:0]S_AXI_rid;
  output S_AXI_rlast;
  input S_AXI_rready;
  output [1:0]S_AXI_rresp;
  output S_AXI_rvalid;
  input [31:0]S_AXI_wdata;
  input [11:0]S_AXI_wid;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input S_AXI_wvalid;

  wire S_ACLK_1;
  wire S_ARESETN_1;
  wire [31:0]auto_pc_to_s00_couplers_ARADDR;
  wire [2:0]auto_pc_to_s00_couplers_ARPROT;
  wire auto_pc_to_s00_couplers_ARREADY;
  wire auto_pc_to_s00_couplers_ARVALID;
  wire [31:0]auto_pc_to_s00_couplers_AWADDR;
  wire [2:0]auto_pc_to_s00_couplers_AWPROT;
  wire auto_pc_to_s00_couplers_AWREADY;
  wire auto_pc_to_s00_couplers_AWVALID;
  wire auto_pc_to_s00_couplers_BREADY;
  wire [1:0]auto_pc_to_s00_couplers_BRESP;
  wire auto_pc_to_s00_couplers_BVALID;
  wire [31:0]auto_pc_to_s00_couplers_RDATA;
  wire auto_pc_to_s00_couplers_RREADY;
  wire [1:0]auto_pc_to_s00_couplers_RRESP;
  wire auto_pc_to_s00_couplers_RVALID;
  wire [31:0]auto_pc_to_s00_couplers_WDATA;
  wire auto_pc_to_s00_couplers_WREADY;
  wire [3:0]auto_pc_to_s00_couplers_WSTRB;
  wire auto_pc_to_s00_couplers_WVALID;
  wire [31:0]s00_couplers_to_auto_pc_ARADDR;
  wire [1:0]s00_couplers_to_auto_pc_ARBURST;
  wire [3:0]s00_couplers_to_auto_pc_ARCACHE;
  wire [11:0]s00_couplers_to_auto_pc_ARID;
  wire [3:0]s00_couplers_to_auto_pc_ARLEN;
  wire [1:0]s00_couplers_to_auto_pc_ARLOCK;
  wire [2:0]s00_couplers_to_auto_pc_ARPROT;
  wire [3:0]s00_couplers_to_auto_pc_ARQOS;
  wire s00_couplers_to_auto_pc_ARREADY;
  wire [2:0]s00_couplers_to_auto_pc_ARSIZE;
  wire s00_couplers_to_auto_pc_ARVALID;
  wire [31:0]s00_couplers_to_auto_pc_AWADDR;
  wire [1:0]s00_couplers_to_auto_pc_AWBURST;
  wire [3:0]s00_couplers_to_auto_pc_AWCACHE;
  wire [11:0]s00_couplers_to_auto_pc_AWID;
  wire [3:0]s00_couplers_to_auto_pc_AWLEN;
  wire [1:0]s00_couplers_to_auto_pc_AWLOCK;
  wire [2:0]s00_couplers_to_auto_pc_AWPROT;
  wire [3:0]s00_couplers_to_auto_pc_AWQOS;
  wire s00_couplers_to_auto_pc_AWREADY;
  wire [2:0]s00_couplers_to_auto_pc_AWSIZE;
  wire s00_couplers_to_auto_pc_AWVALID;
  wire [11:0]s00_couplers_to_auto_pc_BID;
  wire s00_couplers_to_auto_pc_BREADY;
  wire [1:0]s00_couplers_to_auto_pc_BRESP;
  wire s00_couplers_to_auto_pc_BVALID;
  wire [31:0]s00_couplers_to_auto_pc_RDATA;
  wire [11:0]s00_couplers_to_auto_pc_RID;
  wire s00_couplers_to_auto_pc_RLAST;
  wire s00_couplers_to_auto_pc_RREADY;
  wire [1:0]s00_couplers_to_auto_pc_RRESP;
  wire s00_couplers_to_auto_pc_RVALID;
  wire [31:0]s00_couplers_to_auto_pc_WDATA;
  wire [11:0]s00_couplers_to_auto_pc_WID;
  wire s00_couplers_to_auto_pc_WLAST;
  wire s00_couplers_to_auto_pc_WREADY;
  wire [3:0]s00_couplers_to_auto_pc_WSTRB;
  wire s00_couplers_to_auto_pc_WVALID;

  assign M_AXI_araddr[31:0] = auto_pc_to_s00_couplers_ARADDR;
  assign M_AXI_arprot[2:0] = auto_pc_to_s00_couplers_ARPROT;
  assign M_AXI_arvalid = auto_pc_to_s00_couplers_ARVALID;
  assign M_AXI_awaddr[31:0] = auto_pc_to_s00_couplers_AWADDR;
  assign M_AXI_awprot[2:0] = auto_pc_to_s00_couplers_AWPROT;
  assign M_AXI_awvalid = auto_pc_to_s00_couplers_AWVALID;
  assign M_AXI_bready = auto_pc_to_s00_couplers_BREADY;
  assign M_AXI_rready = auto_pc_to_s00_couplers_RREADY;
  assign M_AXI_wdata[31:0] = auto_pc_to_s00_couplers_WDATA;
  assign M_AXI_wstrb[3:0] = auto_pc_to_s00_couplers_WSTRB;
  assign M_AXI_wvalid = auto_pc_to_s00_couplers_WVALID;
  assign S_ACLK_1 = S_ACLK;
  assign S_ARESETN_1 = S_ARESETN;
  assign S_AXI_arready = s00_couplers_to_auto_pc_ARREADY;
  assign S_AXI_awready = s00_couplers_to_auto_pc_AWREADY;
  assign S_AXI_bid[11:0] = s00_couplers_to_auto_pc_BID;
  assign S_AXI_bresp[1:0] = s00_couplers_to_auto_pc_BRESP;
  assign S_AXI_bvalid = s00_couplers_to_auto_pc_BVALID;
  assign S_AXI_rdata[31:0] = s00_couplers_to_auto_pc_RDATA;
  assign S_AXI_rid[11:0] = s00_couplers_to_auto_pc_RID;
  assign S_AXI_rlast = s00_couplers_to_auto_pc_RLAST;
  assign S_AXI_rresp[1:0] = s00_couplers_to_auto_pc_RRESP;
  assign S_AXI_rvalid = s00_couplers_to_auto_pc_RVALID;
  assign S_AXI_wready = s00_couplers_to_auto_pc_WREADY;
  assign auto_pc_to_s00_couplers_ARREADY = M_AXI_arready;
  assign auto_pc_to_s00_couplers_AWREADY = M_AXI_awready;
  assign auto_pc_to_s00_couplers_BRESP = M_AXI_bresp[1:0];
  assign auto_pc_to_s00_couplers_BVALID = M_AXI_bvalid;
  assign auto_pc_to_s00_couplers_RDATA = M_AXI_rdata[31:0];
  assign auto_pc_to_s00_couplers_RRESP = M_AXI_rresp[1:0];
  assign auto_pc_to_s00_couplers_RVALID = M_AXI_rvalid;
  assign auto_pc_to_s00_couplers_WREADY = M_AXI_wready;
  assign s00_couplers_to_auto_pc_ARADDR = S_AXI_araddr[31:0];
  assign s00_couplers_to_auto_pc_ARBURST = S_AXI_arburst[1:0];
  assign s00_couplers_to_auto_pc_ARCACHE = S_AXI_arcache[3:0];
  assign s00_couplers_to_auto_pc_ARID = S_AXI_arid[11:0];
  assign s00_couplers_to_auto_pc_ARLEN = S_AXI_arlen[3:0];
  assign s00_couplers_to_auto_pc_ARLOCK = S_AXI_arlock[1:0];
  assign s00_couplers_to_auto_pc_ARPROT = S_AXI_arprot[2:0];
  assign s00_couplers_to_auto_pc_ARQOS = S_AXI_arqos[3:0];
  assign s00_couplers_to_auto_pc_ARSIZE = S_AXI_arsize[2:0];
  assign s00_couplers_to_auto_pc_ARVALID = S_AXI_arvalid;
  assign s00_couplers_to_auto_pc_AWADDR = S_AXI_awaddr[31:0];
  assign s00_couplers_to_auto_pc_AWBURST = S_AXI_awburst[1:0];
  assign s00_couplers_to_auto_pc_AWCACHE = S_AXI_awcache[3:0];
  assign s00_couplers_to_auto_pc_AWID = S_AXI_awid[11:0];
  assign s00_couplers_to_auto_pc_AWLEN = S_AXI_awlen[3:0];
  assign s00_couplers_to_auto_pc_AWLOCK = S_AXI_awlock[1:0];
  assign s00_couplers_to_auto_pc_AWPROT = S_AXI_awprot[2:0];
  assign s00_couplers_to_auto_pc_AWQOS = S_AXI_awqos[3:0];
  assign s00_couplers_to_auto_pc_AWSIZE = S_AXI_awsize[2:0];
  assign s00_couplers_to_auto_pc_AWVALID = S_AXI_awvalid;
  assign s00_couplers_to_auto_pc_BREADY = S_AXI_bready;
  assign s00_couplers_to_auto_pc_RREADY = S_AXI_rready;
  assign s00_couplers_to_auto_pc_WDATA = S_AXI_wdata[31:0];
  assign s00_couplers_to_auto_pc_WID = S_AXI_wid[11:0];
  assign s00_couplers_to_auto_pc_WLAST = S_AXI_wlast;
  assign s00_couplers_to_auto_pc_WSTRB = S_AXI_wstrb[3:0];
  assign s00_couplers_to_auto_pc_WVALID = S_AXI_wvalid;
  system_auto_pc_0 auto_pc
       (.aclk(S_ACLK_1),
        .aresetn(S_ARESETN_1),
        .m_axi_araddr(auto_pc_to_s00_couplers_ARADDR),
        .m_axi_arprot(auto_pc_to_s00_couplers_ARPROT),
        .m_axi_arready(auto_pc_to_s00_couplers_ARREADY),
        .m_axi_arvalid(auto_pc_to_s00_couplers_ARVALID),
        .m_axi_awaddr(auto_pc_to_s00_couplers_AWADDR),
        .m_axi_awprot(auto_pc_to_s00_couplers_AWPROT),
        .m_axi_awready(auto_pc_to_s00_couplers_AWREADY),
        .m_axi_awvalid(auto_pc_to_s00_couplers_AWVALID),
        .m_axi_bready(auto_pc_to_s00_couplers_BREADY),
        .m_axi_bresp(auto_pc_to_s00_couplers_BRESP),
        .m_axi_bvalid(auto_pc_to_s00_couplers_BVALID),
        .m_axi_rdata(auto_pc_to_s00_couplers_RDATA),
        .m_axi_rready(auto_pc_to_s00_couplers_RREADY),
        .m_axi_rresp(auto_pc_to_s00_couplers_RRESP),
        .m_axi_rvalid(auto_pc_to_s00_couplers_RVALID),
        .m_axi_wdata(auto_pc_to_s00_couplers_WDATA),
        .m_axi_wready(auto_pc_to_s00_couplers_WREADY),
        .m_axi_wstrb(auto_pc_to_s00_couplers_WSTRB),
        .m_axi_wvalid(auto_pc_to_s00_couplers_WVALID),
        .s_axi_araddr(s00_couplers_to_auto_pc_ARADDR),
        .s_axi_arburst(s00_couplers_to_auto_pc_ARBURST),
        .s_axi_arcache(s00_couplers_to_auto_pc_ARCACHE),
        .s_axi_arid(s00_couplers_to_auto_pc_ARID),
        .s_axi_arlen(s00_couplers_to_auto_pc_ARLEN),
        .s_axi_arlock(s00_couplers_to_auto_pc_ARLOCK),
        .s_axi_arprot(s00_couplers_to_auto_pc_ARPROT),
        .s_axi_arqos(s00_couplers_to_auto_pc_ARQOS),
        .s_axi_arready(s00_couplers_to_auto_pc_ARREADY),
        .s_axi_arsize(s00_couplers_to_auto_pc_ARSIZE),
        .s_axi_arvalid(s00_couplers_to_auto_pc_ARVALID),
        .s_axi_awaddr(s00_couplers_to_auto_pc_AWADDR),
        .s_axi_awburst(s00_couplers_to_auto_pc_AWBURST),
        .s_axi_awcache(s00_couplers_to_auto_pc_AWCACHE),
        .s_axi_awid(s00_couplers_to_auto_pc_AWID),
        .s_axi_awlen(s00_couplers_to_auto_pc_AWLEN),
        .s_axi_awlock(s00_couplers_to_auto_pc_AWLOCK),
        .s_axi_awprot(s00_couplers_to_auto_pc_AWPROT),
        .s_axi_awqos(s00_couplers_to_auto_pc_AWQOS),
        .s_axi_awready(s00_couplers_to_auto_pc_AWREADY),
        .s_axi_awsize(s00_couplers_to_auto_pc_AWSIZE),
        .s_axi_awvalid(s00_couplers_to_auto_pc_AWVALID),
        .s_axi_bid(s00_couplers_to_auto_pc_BID),
        .s_axi_bready(s00_couplers_to_auto_pc_BREADY),
        .s_axi_bresp(s00_couplers_to_auto_pc_BRESP),
        .s_axi_bvalid(s00_couplers_to_auto_pc_BVALID),
        .s_axi_rdata(s00_couplers_to_auto_pc_RDATA),
        .s_axi_rid(s00_couplers_to_auto_pc_RID),
        .s_axi_rlast(s00_couplers_to_auto_pc_RLAST),
        .s_axi_rready(s00_couplers_to_auto_pc_RREADY),
        .s_axi_rresp(s00_couplers_to_auto_pc_RRESP),
        .s_axi_rvalid(s00_couplers_to_auto_pc_RVALID),
        .s_axi_wdata(s00_couplers_to_auto_pc_WDATA),
        .s_axi_wid(s00_couplers_to_auto_pc_WID),
        .s_axi_wlast(s00_couplers_to_auto_pc_WLAST),
        .s_axi_wready(s00_couplers_to_auto_pc_WREADY),
        .s_axi_wstrb(s00_couplers_to_auto_pc_WSTRB),
        .s_axi_wvalid(s00_couplers_to_auto_pc_WVALID));
endmodule

module s01_couplers_imp_ANXGUV
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_buser,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wuser,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_buser,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [2:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_buser;
  input M_AXI_bvalid;
  output [31:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wuser;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [2:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_buser;
  output S_AXI_bvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire [31:0]s01_couplers_to_s01_couplers_AWADDR;
  wire [1:0]s01_couplers_to_s01_couplers_AWBURST;
  wire [3:0]s01_couplers_to_s01_couplers_AWCACHE;
  wire [2:0]s01_couplers_to_s01_couplers_AWID;
  wire [7:0]s01_couplers_to_s01_couplers_AWLEN;
  wire s01_couplers_to_s01_couplers_AWLOCK;
  wire [2:0]s01_couplers_to_s01_couplers_AWPROT;
  wire [3:0]s01_couplers_to_s01_couplers_AWQOS;
  wire s01_couplers_to_s01_couplers_AWREADY;
  wire [2:0]s01_couplers_to_s01_couplers_AWSIZE;
  wire [0:0]s01_couplers_to_s01_couplers_AWUSER;
  wire s01_couplers_to_s01_couplers_AWVALID;
  wire [5:0]s01_couplers_to_s01_couplers_BID;
  wire s01_couplers_to_s01_couplers_BREADY;
  wire [1:0]s01_couplers_to_s01_couplers_BRESP;
  wire [0:0]s01_couplers_to_s01_couplers_BUSER;
  wire s01_couplers_to_s01_couplers_BVALID;
  wire [31:0]s01_couplers_to_s01_couplers_WDATA;
  wire s01_couplers_to_s01_couplers_WLAST;
  wire s01_couplers_to_s01_couplers_WREADY;
  wire [3:0]s01_couplers_to_s01_couplers_WSTRB;
  wire [0:0]s01_couplers_to_s01_couplers_WUSER;
  wire s01_couplers_to_s01_couplers_WVALID;

  assign M_AXI_awaddr[31:0] = s01_couplers_to_s01_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s01_couplers_to_s01_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s01_couplers_to_s01_couplers_AWCACHE;
  assign M_AXI_awid[2:0] = s01_couplers_to_s01_couplers_AWID;
  assign M_AXI_awlen[7:0] = s01_couplers_to_s01_couplers_AWLEN;
  assign M_AXI_awlock = s01_couplers_to_s01_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s01_couplers_to_s01_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s01_couplers_to_s01_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s01_couplers_to_s01_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s01_couplers_to_s01_couplers_AWUSER;
  assign M_AXI_awvalid = s01_couplers_to_s01_couplers_AWVALID;
  assign M_AXI_bready = s01_couplers_to_s01_couplers_BREADY;
  assign M_AXI_wdata[31:0] = s01_couplers_to_s01_couplers_WDATA;
  assign M_AXI_wlast = s01_couplers_to_s01_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = s01_couplers_to_s01_couplers_WSTRB;
  assign M_AXI_wuser[0] = s01_couplers_to_s01_couplers_WUSER;
  assign M_AXI_wvalid = s01_couplers_to_s01_couplers_WVALID;
  assign S_AXI_awready = s01_couplers_to_s01_couplers_AWREADY;
  assign S_AXI_bid[5:0] = s01_couplers_to_s01_couplers_BID;
  assign S_AXI_bresp[1:0] = s01_couplers_to_s01_couplers_BRESP;
  assign S_AXI_buser[0] = s01_couplers_to_s01_couplers_BUSER;
  assign S_AXI_bvalid = s01_couplers_to_s01_couplers_BVALID;
  assign S_AXI_wready = s01_couplers_to_s01_couplers_WREADY;
  assign s01_couplers_to_s01_couplers_AWADDR = S_AXI_awaddr[31:0];
  assign s01_couplers_to_s01_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s01_couplers_to_s01_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s01_couplers_to_s01_couplers_AWID = S_AXI_awid[2:0];
  assign s01_couplers_to_s01_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s01_couplers_to_s01_couplers_AWLOCK = S_AXI_awlock;
  assign s01_couplers_to_s01_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s01_couplers_to_s01_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s01_couplers_to_s01_couplers_AWREADY = M_AXI_awready;
  assign s01_couplers_to_s01_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s01_couplers_to_s01_couplers_AWUSER = S_AXI_awuser[0];
  assign s01_couplers_to_s01_couplers_AWVALID = S_AXI_awvalid;
  assign s01_couplers_to_s01_couplers_BID = M_AXI_bid[5:0];
  assign s01_couplers_to_s01_couplers_BREADY = S_AXI_bready;
  assign s01_couplers_to_s01_couplers_BRESP = M_AXI_bresp[1:0];
  assign s01_couplers_to_s01_couplers_BUSER = M_AXI_buser[0];
  assign s01_couplers_to_s01_couplers_BVALID = M_AXI_bvalid;
  assign s01_couplers_to_s01_couplers_WDATA = S_AXI_wdata[31:0];
  assign s01_couplers_to_s01_couplers_WLAST = S_AXI_wlast;
  assign s01_couplers_to_s01_couplers_WREADY = M_AXI_wready;
  assign s01_couplers_to_s01_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign s01_couplers_to_s01_couplers_WUSER = S_AXI_wuser[0];
  assign s01_couplers_to_s01_couplers_WVALID = S_AXI_wvalid;
endmodule

module s02_couplers_imp_4CCIUD
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_buser,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wuser,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_buser,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [2:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_buser;
  input M_AXI_bvalid;
  output [31:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wuser;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [2:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_buser;
  output S_AXI_bvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire [31:0]s02_couplers_to_s02_couplers_AWADDR;
  wire [1:0]s02_couplers_to_s02_couplers_AWBURST;
  wire [3:0]s02_couplers_to_s02_couplers_AWCACHE;
  wire [2:0]s02_couplers_to_s02_couplers_AWID;
  wire [7:0]s02_couplers_to_s02_couplers_AWLEN;
  wire s02_couplers_to_s02_couplers_AWLOCK;
  wire [2:0]s02_couplers_to_s02_couplers_AWPROT;
  wire [3:0]s02_couplers_to_s02_couplers_AWQOS;
  wire s02_couplers_to_s02_couplers_AWREADY;
  wire [2:0]s02_couplers_to_s02_couplers_AWSIZE;
  wire [0:0]s02_couplers_to_s02_couplers_AWUSER;
  wire s02_couplers_to_s02_couplers_AWVALID;
  wire [5:0]s02_couplers_to_s02_couplers_BID;
  wire s02_couplers_to_s02_couplers_BREADY;
  wire [1:0]s02_couplers_to_s02_couplers_BRESP;
  wire [0:0]s02_couplers_to_s02_couplers_BUSER;
  wire s02_couplers_to_s02_couplers_BVALID;
  wire [31:0]s02_couplers_to_s02_couplers_WDATA;
  wire s02_couplers_to_s02_couplers_WLAST;
  wire s02_couplers_to_s02_couplers_WREADY;
  wire [3:0]s02_couplers_to_s02_couplers_WSTRB;
  wire [0:0]s02_couplers_to_s02_couplers_WUSER;
  wire s02_couplers_to_s02_couplers_WVALID;

  assign M_AXI_awaddr[31:0] = s02_couplers_to_s02_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s02_couplers_to_s02_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s02_couplers_to_s02_couplers_AWCACHE;
  assign M_AXI_awid[2:0] = s02_couplers_to_s02_couplers_AWID;
  assign M_AXI_awlen[7:0] = s02_couplers_to_s02_couplers_AWLEN;
  assign M_AXI_awlock = s02_couplers_to_s02_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s02_couplers_to_s02_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s02_couplers_to_s02_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s02_couplers_to_s02_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s02_couplers_to_s02_couplers_AWUSER;
  assign M_AXI_awvalid = s02_couplers_to_s02_couplers_AWVALID;
  assign M_AXI_bready = s02_couplers_to_s02_couplers_BREADY;
  assign M_AXI_wdata[31:0] = s02_couplers_to_s02_couplers_WDATA;
  assign M_AXI_wlast = s02_couplers_to_s02_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = s02_couplers_to_s02_couplers_WSTRB;
  assign M_AXI_wuser[0] = s02_couplers_to_s02_couplers_WUSER;
  assign M_AXI_wvalid = s02_couplers_to_s02_couplers_WVALID;
  assign S_AXI_awready = s02_couplers_to_s02_couplers_AWREADY;
  assign S_AXI_bid[5:0] = s02_couplers_to_s02_couplers_BID;
  assign S_AXI_bresp[1:0] = s02_couplers_to_s02_couplers_BRESP;
  assign S_AXI_buser[0] = s02_couplers_to_s02_couplers_BUSER;
  assign S_AXI_bvalid = s02_couplers_to_s02_couplers_BVALID;
  assign S_AXI_wready = s02_couplers_to_s02_couplers_WREADY;
  assign s02_couplers_to_s02_couplers_AWADDR = S_AXI_awaddr[31:0];
  assign s02_couplers_to_s02_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s02_couplers_to_s02_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s02_couplers_to_s02_couplers_AWID = S_AXI_awid[2:0];
  assign s02_couplers_to_s02_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s02_couplers_to_s02_couplers_AWLOCK = S_AXI_awlock;
  assign s02_couplers_to_s02_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s02_couplers_to_s02_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s02_couplers_to_s02_couplers_AWREADY = M_AXI_awready;
  assign s02_couplers_to_s02_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s02_couplers_to_s02_couplers_AWUSER = S_AXI_awuser[0];
  assign s02_couplers_to_s02_couplers_AWVALID = S_AXI_awvalid;
  assign s02_couplers_to_s02_couplers_BID = M_AXI_bid[5:0];
  assign s02_couplers_to_s02_couplers_BREADY = S_AXI_bready;
  assign s02_couplers_to_s02_couplers_BRESP = M_AXI_bresp[1:0];
  assign s02_couplers_to_s02_couplers_BUSER = M_AXI_buser[0];
  assign s02_couplers_to_s02_couplers_BVALID = M_AXI_bvalid;
  assign s02_couplers_to_s02_couplers_WDATA = S_AXI_wdata[31:0];
  assign s02_couplers_to_s02_couplers_WLAST = S_AXI_wlast;
  assign s02_couplers_to_s02_couplers_WREADY = M_AXI_wready;
  assign s02_couplers_to_s02_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign s02_couplers_to_s02_couplers_WUSER = S_AXI_wuser[0];
  assign s02_couplers_to_s02_couplers_WVALID = S_AXI_wvalid;
endmodule

module s03_couplers_imp_18WA86S
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_buser,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wuser,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_buser,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [2:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_buser;
  input M_AXI_bvalid;
  output [31:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wuser;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [2:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_buser;
  output S_AXI_bvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire [31:0]s03_couplers_to_s03_couplers_AWADDR;
  wire [1:0]s03_couplers_to_s03_couplers_AWBURST;
  wire [3:0]s03_couplers_to_s03_couplers_AWCACHE;
  wire [2:0]s03_couplers_to_s03_couplers_AWID;
  wire [7:0]s03_couplers_to_s03_couplers_AWLEN;
  wire s03_couplers_to_s03_couplers_AWLOCK;
  wire [2:0]s03_couplers_to_s03_couplers_AWPROT;
  wire [3:0]s03_couplers_to_s03_couplers_AWQOS;
  wire s03_couplers_to_s03_couplers_AWREADY;
  wire [2:0]s03_couplers_to_s03_couplers_AWSIZE;
  wire [0:0]s03_couplers_to_s03_couplers_AWUSER;
  wire s03_couplers_to_s03_couplers_AWVALID;
  wire [5:0]s03_couplers_to_s03_couplers_BID;
  wire s03_couplers_to_s03_couplers_BREADY;
  wire [1:0]s03_couplers_to_s03_couplers_BRESP;
  wire [0:0]s03_couplers_to_s03_couplers_BUSER;
  wire s03_couplers_to_s03_couplers_BVALID;
  wire [31:0]s03_couplers_to_s03_couplers_WDATA;
  wire s03_couplers_to_s03_couplers_WLAST;
  wire s03_couplers_to_s03_couplers_WREADY;
  wire [3:0]s03_couplers_to_s03_couplers_WSTRB;
  wire [0:0]s03_couplers_to_s03_couplers_WUSER;
  wire s03_couplers_to_s03_couplers_WVALID;

  assign M_AXI_awaddr[31:0] = s03_couplers_to_s03_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s03_couplers_to_s03_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s03_couplers_to_s03_couplers_AWCACHE;
  assign M_AXI_awid[2:0] = s03_couplers_to_s03_couplers_AWID;
  assign M_AXI_awlen[7:0] = s03_couplers_to_s03_couplers_AWLEN;
  assign M_AXI_awlock = s03_couplers_to_s03_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s03_couplers_to_s03_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s03_couplers_to_s03_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s03_couplers_to_s03_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s03_couplers_to_s03_couplers_AWUSER;
  assign M_AXI_awvalid = s03_couplers_to_s03_couplers_AWVALID;
  assign M_AXI_bready = s03_couplers_to_s03_couplers_BREADY;
  assign M_AXI_wdata[31:0] = s03_couplers_to_s03_couplers_WDATA;
  assign M_AXI_wlast = s03_couplers_to_s03_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = s03_couplers_to_s03_couplers_WSTRB;
  assign M_AXI_wuser[0] = s03_couplers_to_s03_couplers_WUSER;
  assign M_AXI_wvalid = s03_couplers_to_s03_couplers_WVALID;
  assign S_AXI_awready = s03_couplers_to_s03_couplers_AWREADY;
  assign S_AXI_bid[5:0] = s03_couplers_to_s03_couplers_BID;
  assign S_AXI_bresp[1:0] = s03_couplers_to_s03_couplers_BRESP;
  assign S_AXI_buser[0] = s03_couplers_to_s03_couplers_BUSER;
  assign S_AXI_bvalid = s03_couplers_to_s03_couplers_BVALID;
  assign S_AXI_wready = s03_couplers_to_s03_couplers_WREADY;
  assign s03_couplers_to_s03_couplers_AWADDR = S_AXI_awaddr[31:0];
  assign s03_couplers_to_s03_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s03_couplers_to_s03_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s03_couplers_to_s03_couplers_AWID = S_AXI_awid[2:0];
  assign s03_couplers_to_s03_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s03_couplers_to_s03_couplers_AWLOCK = S_AXI_awlock;
  assign s03_couplers_to_s03_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s03_couplers_to_s03_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s03_couplers_to_s03_couplers_AWREADY = M_AXI_awready;
  assign s03_couplers_to_s03_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s03_couplers_to_s03_couplers_AWUSER = S_AXI_awuser[0];
  assign s03_couplers_to_s03_couplers_AWVALID = S_AXI_awvalid;
  assign s03_couplers_to_s03_couplers_BID = M_AXI_bid[5:0];
  assign s03_couplers_to_s03_couplers_BREADY = S_AXI_bready;
  assign s03_couplers_to_s03_couplers_BRESP = M_AXI_bresp[1:0];
  assign s03_couplers_to_s03_couplers_BUSER = M_AXI_buser[0];
  assign s03_couplers_to_s03_couplers_BVALID = M_AXI_bvalid;
  assign s03_couplers_to_s03_couplers_WDATA = S_AXI_wdata[31:0];
  assign s03_couplers_to_s03_couplers_WLAST = S_AXI_wlast;
  assign s03_couplers_to_s03_couplers_WREADY = M_AXI_wready;
  assign s03_couplers_to_s03_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign s03_couplers_to_s03_couplers_WUSER = S_AXI_wuser[0];
  assign s03_couplers_to_s03_couplers_WVALID = S_AXI_wvalid;
endmodule

module s04_couplers_imp_PL33WH
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_buser,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wuser,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_buser,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [2:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_buser;
  input M_AXI_bvalid;
  output [31:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wuser;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [2:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_buser;
  output S_AXI_bvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire [31:0]s04_couplers_to_s04_couplers_AWADDR;
  wire [1:0]s04_couplers_to_s04_couplers_AWBURST;
  wire [3:0]s04_couplers_to_s04_couplers_AWCACHE;
  wire [2:0]s04_couplers_to_s04_couplers_AWID;
  wire [7:0]s04_couplers_to_s04_couplers_AWLEN;
  wire s04_couplers_to_s04_couplers_AWLOCK;
  wire [2:0]s04_couplers_to_s04_couplers_AWPROT;
  wire [3:0]s04_couplers_to_s04_couplers_AWQOS;
  wire s04_couplers_to_s04_couplers_AWREADY;
  wire [2:0]s04_couplers_to_s04_couplers_AWSIZE;
  wire [0:0]s04_couplers_to_s04_couplers_AWUSER;
  wire s04_couplers_to_s04_couplers_AWVALID;
  wire [5:0]s04_couplers_to_s04_couplers_BID;
  wire s04_couplers_to_s04_couplers_BREADY;
  wire [1:0]s04_couplers_to_s04_couplers_BRESP;
  wire [0:0]s04_couplers_to_s04_couplers_BUSER;
  wire s04_couplers_to_s04_couplers_BVALID;
  wire [31:0]s04_couplers_to_s04_couplers_WDATA;
  wire s04_couplers_to_s04_couplers_WLAST;
  wire s04_couplers_to_s04_couplers_WREADY;
  wire [3:0]s04_couplers_to_s04_couplers_WSTRB;
  wire [0:0]s04_couplers_to_s04_couplers_WUSER;
  wire s04_couplers_to_s04_couplers_WVALID;

  assign M_AXI_awaddr[31:0] = s04_couplers_to_s04_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s04_couplers_to_s04_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s04_couplers_to_s04_couplers_AWCACHE;
  assign M_AXI_awid[2:0] = s04_couplers_to_s04_couplers_AWID;
  assign M_AXI_awlen[7:0] = s04_couplers_to_s04_couplers_AWLEN;
  assign M_AXI_awlock = s04_couplers_to_s04_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s04_couplers_to_s04_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s04_couplers_to_s04_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s04_couplers_to_s04_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s04_couplers_to_s04_couplers_AWUSER;
  assign M_AXI_awvalid = s04_couplers_to_s04_couplers_AWVALID;
  assign M_AXI_bready = s04_couplers_to_s04_couplers_BREADY;
  assign M_AXI_wdata[31:0] = s04_couplers_to_s04_couplers_WDATA;
  assign M_AXI_wlast = s04_couplers_to_s04_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = s04_couplers_to_s04_couplers_WSTRB;
  assign M_AXI_wuser[0] = s04_couplers_to_s04_couplers_WUSER;
  assign M_AXI_wvalid = s04_couplers_to_s04_couplers_WVALID;
  assign S_AXI_awready = s04_couplers_to_s04_couplers_AWREADY;
  assign S_AXI_bid[5:0] = s04_couplers_to_s04_couplers_BID;
  assign S_AXI_bresp[1:0] = s04_couplers_to_s04_couplers_BRESP;
  assign S_AXI_buser[0] = s04_couplers_to_s04_couplers_BUSER;
  assign S_AXI_bvalid = s04_couplers_to_s04_couplers_BVALID;
  assign S_AXI_wready = s04_couplers_to_s04_couplers_WREADY;
  assign s04_couplers_to_s04_couplers_AWADDR = S_AXI_awaddr[31:0];
  assign s04_couplers_to_s04_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s04_couplers_to_s04_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s04_couplers_to_s04_couplers_AWID = S_AXI_awid[2:0];
  assign s04_couplers_to_s04_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s04_couplers_to_s04_couplers_AWLOCK = S_AXI_awlock;
  assign s04_couplers_to_s04_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s04_couplers_to_s04_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s04_couplers_to_s04_couplers_AWREADY = M_AXI_awready;
  assign s04_couplers_to_s04_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s04_couplers_to_s04_couplers_AWUSER = S_AXI_awuser[0];
  assign s04_couplers_to_s04_couplers_AWVALID = S_AXI_awvalid;
  assign s04_couplers_to_s04_couplers_BID = M_AXI_bid[5:0];
  assign s04_couplers_to_s04_couplers_BREADY = S_AXI_bready;
  assign s04_couplers_to_s04_couplers_BRESP = M_AXI_bresp[1:0];
  assign s04_couplers_to_s04_couplers_BUSER = M_AXI_buser[0];
  assign s04_couplers_to_s04_couplers_BVALID = M_AXI_bvalid;
  assign s04_couplers_to_s04_couplers_WDATA = S_AXI_wdata[31:0];
  assign s04_couplers_to_s04_couplers_WLAST = S_AXI_wlast;
  assign s04_couplers_to_s04_couplers_WREADY = M_AXI_wready;
  assign s04_couplers_to_s04_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign s04_couplers_to_s04_couplers_WUSER = S_AXI_wuser[0];
  assign s04_couplers_to_s04_couplers_WVALID = S_AXI_wvalid;
endmodule

module s05_couplers_imp_1V8Z66O
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_buser,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wuser,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_buser,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [2:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_buser;
  input M_AXI_bvalid;
  output [31:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wuser;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [2:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_buser;
  output S_AXI_bvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire [31:0]s05_couplers_to_s05_couplers_AWADDR;
  wire [1:0]s05_couplers_to_s05_couplers_AWBURST;
  wire [3:0]s05_couplers_to_s05_couplers_AWCACHE;
  wire [2:0]s05_couplers_to_s05_couplers_AWID;
  wire [7:0]s05_couplers_to_s05_couplers_AWLEN;
  wire s05_couplers_to_s05_couplers_AWLOCK;
  wire [2:0]s05_couplers_to_s05_couplers_AWPROT;
  wire [3:0]s05_couplers_to_s05_couplers_AWQOS;
  wire s05_couplers_to_s05_couplers_AWREADY;
  wire [2:0]s05_couplers_to_s05_couplers_AWSIZE;
  wire [0:0]s05_couplers_to_s05_couplers_AWUSER;
  wire s05_couplers_to_s05_couplers_AWVALID;
  wire [5:0]s05_couplers_to_s05_couplers_BID;
  wire s05_couplers_to_s05_couplers_BREADY;
  wire [1:0]s05_couplers_to_s05_couplers_BRESP;
  wire [0:0]s05_couplers_to_s05_couplers_BUSER;
  wire s05_couplers_to_s05_couplers_BVALID;
  wire [31:0]s05_couplers_to_s05_couplers_WDATA;
  wire s05_couplers_to_s05_couplers_WLAST;
  wire s05_couplers_to_s05_couplers_WREADY;
  wire [3:0]s05_couplers_to_s05_couplers_WSTRB;
  wire [0:0]s05_couplers_to_s05_couplers_WUSER;
  wire s05_couplers_to_s05_couplers_WVALID;

  assign M_AXI_awaddr[31:0] = s05_couplers_to_s05_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s05_couplers_to_s05_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s05_couplers_to_s05_couplers_AWCACHE;
  assign M_AXI_awid[2:0] = s05_couplers_to_s05_couplers_AWID;
  assign M_AXI_awlen[7:0] = s05_couplers_to_s05_couplers_AWLEN;
  assign M_AXI_awlock = s05_couplers_to_s05_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s05_couplers_to_s05_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s05_couplers_to_s05_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s05_couplers_to_s05_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s05_couplers_to_s05_couplers_AWUSER;
  assign M_AXI_awvalid = s05_couplers_to_s05_couplers_AWVALID;
  assign M_AXI_bready = s05_couplers_to_s05_couplers_BREADY;
  assign M_AXI_wdata[31:0] = s05_couplers_to_s05_couplers_WDATA;
  assign M_AXI_wlast = s05_couplers_to_s05_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = s05_couplers_to_s05_couplers_WSTRB;
  assign M_AXI_wuser[0] = s05_couplers_to_s05_couplers_WUSER;
  assign M_AXI_wvalid = s05_couplers_to_s05_couplers_WVALID;
  assign S_AXI_awready = s05_couplers_to_s05_couplers_AWREADY;
  assign S_AXI_bid[5:0] = s05_couplers_to_s05_couplers_BID;
  assign S_AXI_bresp[1:0] = s05_couplers_to_s05_couplers_BRESP;
  assign S_AXI_buser[0] = s05_couplers_to_s05_couplers_BUSER;
  assign S_AXI_bvalid = s05_couplers_to_s05_couplers_BVALID;
  assign S_AXI_wready = s05_couplers_to_s05_couplers_WREADY;
  assign s05_couplers_to_s05_couplers_AWADDR = S_AXI_awaddr[31:0];
  assign s05_couplers_to_s05_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s05_couplers_to_s05_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s05_couplers_to_s05_couplers_AWID = S_AXI_awid[2:0];
  assign s05_couplers_to_s05_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s05_couplers_to_s05_couplers_AWLOCK = S_AXI_awlock;
  assign s05_couplers_to_s05_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s05_couplers_to_s05_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s05_couplers_to_s05_couplers_AWREADY = M_AXI_awready;
  assign s05_couplers_to_s05_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s05_couplers_to_s05_couplers_AWUSER = S_AXI_awuser[0];
  assign s05_couplers_to_s05_couplers_AWVALID = S_AXI_awvalid;
  assign s05_couplers_to_s05_couplers_BID = M_AXI_bid[5:0];
  assign s05_couplers_to_s05_couplers_BREADY = S_AXI_bready;
  assign s05_couplers_to_s05_couplers_BRESP = M_AXI_bresp[1:0];
  assign s05_couplers_to_s05_couplers_BUSER = M_AXI_buser[0];
  assign s05_couplers_to_s05_couplers_BVALID = M_AXI_bvalid;
  assign s05_couplers_to_s05_couplers_WDATA = S_AXI_wdata[31:0];
  assign s05_couplers_to_s05_couplers_WLAST = S_AXI_wlast;
  assign s05_couplers_to_s05_couplers_WREADY = M_AXI_wready;
  assign s05_couplers_to_s05_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign s05_couplers_to_s05_couplers_WUSER = S_AXI_wuser[0];
  assign s05_couplers_to_s05_couplers_WVALID = S_AXI_wvalid;
endmodule

module s06_couplers_imp_1OXE6SI
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_buser,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wuser,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_buser,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [2:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_buser;
  input M_AXI_bvalid;
  output [31:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wuser;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [2:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_buser;
  output S_AXI_bvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire [31:0]s06_couplers_to_s06_couplers_AWADDR;
  wire [1:0]s06_couplers_to_s06_couplers_AWBURST;
  wire [3:0]s06_couplers_to_s06_couplers_AWCACHE;
  wire [2:0]s06_couplers_to_s06_couplers_AWID;
  wire [7:0]s06_couplers_to_s06_couplers_AWLEN;
  wire s06_couplers_to_s06_couplers_AWLOCK;
  wire [2:0]s06_couplers_to_s06_couplers_AWPROT;
  wire [3:0]s06_couplers_to_s06_couplers_AWQOS;
  wire s06_couplers_to_s06_couplers_AWREADY;
  wire [2:0]s06_couplers_to_s06_couplers_AWSIZE;
  wire [0:0]s06_couplers_to_s06_couplers_AWUSER;
  wire s06_couplers_to_s06_couplers_AWVALID;
  wire [5:0]s06_couplers_to_s06_couplers_BID;
  wire s06_couplers_to_s06_couplers_BREADY;
  wire [1:0]s06_couplers_to_s06_couplers_BRESP;
  wire [0:0]s06_couplers_to_s06_couplers_BUSER;
  wire s06_couplers_to_s06_couplers_BVALID;
  wire [31:0]s06_couplers_to_s06_couplers_WDATA;
  wire s06_couplers_to_s06_couplers_WLAST;
  wire s06_couplers_to_s06_couplers_WREADY;
  wire [3:0]s06_couplers_to_s06_couplers_WSTRB;
  wire [0:0]s06_couplers_to_s06_couplers_WUSER;
  wire s06_couplers_to_s06_couplers_WVALID;

  assign M_AXI_awaddr[31:0] = s06_couplers_to_s06_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s06_couplers_to_s06_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s06_couplers_to_s06_couplers_AWCACHE;
  assign M_AXI_awid[2:0] = s06_couplers_to_s06_couplers_AWID;
  assign M_AXI_awlen[7:0] = s06_couplers_to_s06_couplers_AWLEN;
  assign M_AXI_awlock = s06_couplers_to_s06_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s06_couplers_to_s06_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s06_couplers_to_s06_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s06_couplers_to_s06_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s06_couplers_to_s06_couplers_AWUSER;
  assign M_AXI_awvalid = s06_couplers_to_s06_couplers_AWVALID;
  assign M_AXI_bready = s06_couplers_to_s06_couplers_BREADY;
  assign M_AXI_wdata[31:0] = s06_couplers_to_s06_couplers_WDATA;
  assign M_AXI_wlast = s06_couplers_to_s06_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = s06_couplers_to_s06_couplers_WSTRB;
  assign M_AXI_wuser[0] = s06_couplers_to_s06_couplers_WUSER;
  assign M_AXI_wvalid = s06_couplers_to_s06_couplers_WVALID;
  assign S_AXI_awready = s06_couplers_to_s06_couplers_AWREADY;
  assign S_AXI_bid[5:0] = s06_couplers_to_s06_couplers_BID;
  assign S_AXI_bresp[1:0] = s06_couplers_to_s06_couplers_BRESP;
  assign S_AXI_buser[0] = s06_couplers_to_s06_couplers_BUSER;
  assign S_AXI_bvalid = s06_couplers_to_s06_couplers_BVALID;
  assign S_AXI_wready = s06_couplers_to_s06_couplers_WREADY;
  assign s06_couplers_to_s06_couplers_AWADDR = S_AXI_awaddr[31:0];
  assign s06_couplers_to_s06_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s06_couplers_to_s06_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s06_couplers_to_s06_couplers_AWID = S_AXI_awid[2:0];
  assign s06_couplers_to_s06_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s06_couplers_to_s06_couplers_AWLOCK = S_AXI_awlock;
  assign s06_couplers_to_s06_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s06_couplers_to_s06_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s06_couplers_to_s06_couplers_AWREADY = M_AXI_awready;
  assign s06_couplers_to_s06_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s06_couplers_to_s06_couplers_AWUSER = S_AXI_awuser[0];
  assign s06_couplers_to_s06_couplers_AWVALID = S_AXI_awvalid;
  assign s06_couplers_to_s06_couplers_BID = M_AXI_bid[5:0];
  assign s06_couplers_to_s06_couplers_BREADY = S_AXI_bready;
  assign s06_couplers_to_s06_couplers_BRESP = M_AXI_bresp[1:0];
  assign s06_couplers_to_s06_couplers_BUSER = M_AXI_buser[0];
  assign s06_couplers_to_s06_couplers_BVALID = M_AXI_bvalid;
  assign s06_couplers_to_s06_couplers_WDATA = S_AXI_wdata[31:0];
  assign s06_couplers_to_s06_couplers_WLAST = S_AXI_wlast;
  assign s06_couplers_to_s06_couplers_WREADY = M_AXI_wready;
  assign s06_couplers_to_s06_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign s06_couplers_to_s06_couplers_WUSER = S_AXI_wuser[0];
  assign s06_couplers_to_s06_couplers_WVALID = S_AXI_wvalid;
endmodule

module s07_couplers_imp_WQMHDF
   (M_ACLK,
    M_ARESETN,
    M_AXI_awaddr,
    M_AXI_awburst,
    M_AXI_awcache,
    M_AXI_awid,
    M_AXI_awlen,
    M_AXI_awlock,
    M_AXI_awprot,
    M_AXI_awqos,
    M_AXI_awready,
    M_AXI_awsize,
    M_AXI_awuser,
    M_AXI_awvalid,
    M_AXI_bid,
    M_AXI_bready,
    M_AXI_bresp,
    M_AXI_buser,
    M_AXI_bvalid,
    M_AXI_wdata,
    M_AXI_wlast,
    M_AXI_wready,
    M_AXI_wstrb,
    M_AXI_wuser,
    M_AXI_wvalid,
    S_ACLK,
    S_ARESETN,
    S_AXI_awaddr,
    S_AXI_awburst,
    S_AXI_awcache,
    S_AXI_awid,
    S_AXI_awlen,
    S_AXI_awlock,
    S_AXI_awprot,
    S_AXI_awqos,
    S_AXI_awready,
    S_AXI_awsize,
    S_AXI_awuser,
    S_AXI_awvalid,
    S_AXI_bid,
    S_AXI_bready,
    S_AXI_bresp,
    S_AXI_buser,
    S_AXI_bvalid,
    S_AXI_wdata,
    S_AXI_wlast,
    S_AXI_wready,
    S_AXI_wstrb,
    S_AXI_wuser,
    S_AXI_wvalid);
  input M_ACLK;
  input M_ARESETN;
  output [31:0]M_AXI_awaddr;
  output [1:0]M_AXI_awburst;
  output [3:0]M_AXI_awcache;
  output [2:0]M_AXI_awid;
  output [7:0]M_AXI_awlen;
  output M_AXI_awlock;
  output [2:0]M_AXI_awprot;
  output [3:0]M_AXI_awqos;
  input M_AXI_awready;
  output [2:0]M_AXI_awsize;
  output [0:0]M_AXI_awuser;
  output M_AXI_awvalid;
  input [5:0]M_AXI_bid;
  output M_AXI_bready;
  input [1:0]M_AXI_bresp;
  input [0:0]M_AXI_buser;
  input M_AXI_bvalid;
  output [31:0]M_AXI_wdata;
  output M_AXI_wlast;
  input M_AXI_wready;
  output [3:0]M_AXI_wstrb;
  output [0:0]M_AXI_wuser;
  output M_AXI_wvalid;
  input S_ACLK;
  input S_ARESETN;
  input [31:0]S_AXI_awaddr;
  input [1:0]S_AXI_awburst;
  input [3:0]S_AXI_awcache;
  input [2:0]S_AXI_awid;
  input [7:0]S_AXI_awlen;
  input S_AXI_awlock;
  input [2:0]S_AXI_awprot;
  input [3:0]S_AXI_awqos;
  output S_AXI_awready;
  input [2:0]S_AXI_awsize;
  input [0:0]S_AXI_awuser;
  input S_AXI_awvalid;
  output [5:0]S_AXI_bid;
  input S_AXI_bready;
  output [1:0]S_AXI_bresp;
  output [0:0]S_AXI_buser;
  output S_AXI_bvalid;
  input [31:0]S_AXI_wdata;
  input S_AXI_wlast;
  output S_AXI_wready;
  input [3:0]S_AXI_wstrb;
  input [0:0]S_AXI_wuser;
  input S_AXI_wvalid;

  wire [31:0]s07_couplers_to_s07_couplers_AWADDR;
  wire [1:0]s07_couplers_to_s07_couplers_AWBURST;
  wire [3:0]s07_couplers_to_s07_couplers_AWCACHE;
  wire [2:0]s07_couplers_to_s07_couplers_AWID;
  wire [7:0]s07_couplers_to_s07_couplers_AWLEN;
  wire s07_couplers_to_s07_couplers_AWLOCK;
  wire [2:0]s07_couplers_to_s07_couplers_AWPROT;
  wire [3:0]s07_couplers_to_s07_couplers_AWQOS;
  wire s07_couplers_to_s07_couplers_AWREADY;
  wire [2:0]s07_couplers_to_s07_couplers_AWSIZE;
  wire [0:0]s07_couplers_to_s07_couplers_AWUSER;
  wire s07_couplers_to_s07_couplers_AWVALID;
  wire [5:0]s07_couplers_to_s07_couplers_BID;
  wire s07_couplers_to_s07_couplers_BREADY;
  wire [1:0]s07_couplers_to_s07_couplers_BRESP;
  wire [0:0]s07_couplers_to_s07_couplers_BUSER;
  wire s07_couplers_to_s07_couplers_BVALID;
  wire [31:0]s07_couplers_to_s07_couplers_WDATA;
  wire s07_couplers_to_s07_couplers_WLAST;
  wire s07_couplers_to_s07_couplers_WREADY;
  wire [3:0]s07_couplers_to_s07_couplers_WSTRB;
  wire [0:0]s07_couplers_to_s07_couplers_WUSER;
  wire s07_couplers_to_s07_couplers_WVALID;

  assign M_AXI_awaddr[31:0] = s07_couplers_to_s07_couplers_AWADDR;
  assign M_AXI_awburst[1:0] = s07_couplers_to_s07_couplers_AWBURST;
  assign M_AXI_awcache[3:0] = s07_couplers_to_s07_couplers_AWCACHE;
  assign M_AXI_awid[2:0] = s07_couplers_to_s07_couplers_AWID;
  assign M_AXI_awlen[7:0] = s07_couplers_to_s07_couplers_AWLEN;
  assign M_AXI_awlock = s07_couplers_to_s07_couplers_AWLOCK;
  assign M_AXI_awprot[2:0] = s07_couplers_to_s07_couplers_AWPROT;
  assign M_AXI_awqos[3:0] = s07_couplers_to_s07_couplers_AWQOS;
  assign M_AXI_awsize[2:0] = s07_couplers_to_s07_couplers_AWSIZE;
  assign M_AXI_awuser[0] = s07_couplers_to_s07_couplers_AWUSER;
  assign M_AXI_awvalid = s07_couplers_to_s07_couplers_AWVALID;
  assign M_AXI_bready = s07_couplers_to_s07_couplers_BREADY;
  assign M_AXI_wdata[31:0] = s07_couplers_to_s07_couplers_WDATA;
  assign M_AXI_wlast = s07_couplers_to_s07_couplers_WLAST;
  assign M_AXI_wstrb[3:0] = s07_couplers_to_s07_couplers_WSTRB;
  assign M_AXI_wuser[0] = s07_couplers_to_s07_couplers_WUSER;
  assign M_AXI_wvalid = s07_couplers_to_s07_couplers_WVALID;
  assign S_AXI_awready = s07_couplers_to_s07_couplers_AWREADY;
  assign S_AXI_bid[5:0] = s07_couplers_to_s07_couplers_BID;
  assign S_AXI_bresp[1:0] = s07_couplers_to_s07_couplers_BRESP;
  assign S_AXI_buser[0] = s07_couplers_to_s07_couplers_BUSER;
  assign S_AXI_bvalid = s07_couplers_to_s07_couplers_BVALID;
  assign S_AXI_wready = s07_couplers_to_s07_couplers_WREADY;
  assign s07_couplers_to_s07_couplers_AWADDR = S_AXI_awaddr[31:0];
  assign s07_couplers_to_s07_couplers_AWBURST = S_AXI_awburst[1:0];
  assign s07_couplers_to_s07_couplers_AWCACHE = S_AXI_awcache[3:0];
  assign s07_couplers_to_s07_couplers_AWID = S_AXI_awid[2:0];
  assign s07_couplers_to_s07_couplers_AWLEN = S_AXI_awlen[7:0];
  assign s07_couplers_to_s07_couplers_AWLOCK = S_AXI_awlock;
  assign s07_couplers_to_s07_couplers_AWPROT = S_AXI_awprot[2:0];
  assign s07_couplers_to_s07_couplers_AWQOS = S_AXI_awqos[3:0];
  assign s07_couplers_to_s07_couplers_AWREADY = M_AXI_awready;
  assign s07_couplers_to_s07_couplers_AWSIZE = S_AXI_awsize[2:0];
  assign s07_couplers_to_s07_couplers_AWUSER = S_AXI_awuser[0];
  assign s07_couplers_to_s07_couplers_AWVALID = S_AXI_awvalid;
  assign s07_couplers_to_s07_couplers_BID = M_AXI_bid[5:0];
  assign s07_couplers_to_s07_couplers_BREADY = S_AXI_bready;
  assign s07_couplers_to_s07_couplers_BRESP = M_AXI_bresp[1:0];
  assign s07_couplers_to_s07_couplers_BUSER = M_AXI_buser[0];
  assign s07_couplers_to_s07_couplers_BVALID = M_AXI_bvalid;
  assign s07_couplers_to_s07_couplers_WDATA = S_AXI_wdata[31:0];
  assign s07_couplers_to_s07_couplers_WLAST = S_AXI_wlast;
  assign s07_couplers_to_s07_couplers_WREADY = M_AXI_wready;
  assign s07_couplers_to_s07_couplers_WSTRB = S_AXI_wstrb[3:0];
  assign s07_couplers_to_s07_couplers_WUSER = S_AXI_wuser[0];
  assign s07_couplers_to_s07_couplers_WVALID = S_AXI_wvalid;
endmodule

module settings_imp_1WQD0NO
   (S00_AXI_araddr,
    S00_AXI_arprot,
    S00_AXI_arready,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awprot,
    S00_AXI_awready,
    S00_AXI_awvalid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid,
    amp_mult,
    avg_inc_cnt,
    ch_a_Y,
    ch_a_amp,
    ch_a_x,
    ch_b_X,
    ch_b_Y,
    ch_b_amp,
    ch_b_phase,
    cha_a_phase,
    counter,
    dac_a_mult,
    dac_b_mult,
    mod_phase,
    mode_flags,
    offset_end,
    offset_start,
    phase_inc,
    s00_axi_aclk,
    s00_axi_aresetn,
    sample_cnt,
    sweep_add,
    sweep_max,
    sweep_min);
  input [31:0]S00_AXI_araddr;
  input [2:0]S00_AXI_arprot;
  output S00_AXI_arready;
  input S00_AXI_arvalid;
  input [31:0]S00_AXI_awaddr;
  input [2:0]S00_AXI_awprot;
  output S00_AXI_awready;
  input S00_AXI_awvalid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;
  output [31:0]amp_mult;
  output [31:0]avg_inc_cnt;
  input [31:0]ch_a_Y;
  input [31:0]ch_a_amp;
  input [31:0]ch_a_x;
  input [31:0]ch_b_X;
  input [31:0]ch_b_Y;
  input [31:0]ch_b_amp;
  input [31:0]ch_b_phase;
  input [31:0]cha_a_phase;
  input [31:0]counter;
  output [15:0]dac_a_mult;
  output [15:0]dac_b_mult;
  output [15:0]mod_phase;
  output [31:0]mode_flags;
  input [31:0]offset_end;
  input [31:0]offset_start;
  output [31:0]phase_inc;
  input s00_axi_aclk;
  input s00_axi_aresetn;
  output [31:0]sample_cnt;
  output [31:0]sweep_add;
  output [31:0]sweep_max;
  output [31:0]sweep_min;

  wire [31:0]AXI_inout_0_out0;
  wire [31:0]AXI_inout_0_out1;
  wire [31:0]AXI_inout_0_out2;
  wire [31:0]AXI_inout_0_out3;
  wire [31:0]AXI_inout_0_out4;
  wire [31:0]AXI_inout_0_out5;
  wire [31:0]AXI_inout_0_out6;
  wire [31:0]AXI_inout_0_out7;
  wire [31:0]AXI_inout_0_out8;
  wire [31:0]AXI_inout_0_out9;
  wire [15:0]Output_mults_ch_a_out;
  wire [15:0]Output_mults_ch_b_out;
  wire [31:0]S00_AXI_1_ARADDR;
  wire [2:0]S00_AXI_1_ARPROT;
  wire S00_AXI_1_ARREADY;
  wire S00_AXI_1_ARVALID;
  wire [31:0]S00_AXI_1_AWADDR;
  wire [2:0]S00_AXI_1_AWPROT;
  wire S00_AXI_1_AWREADY;
  wire S00_AXI_1_AWVALID;
  wire S00_AXI_1_BREADY;
  wire [1:0]S00_AXI_1_BRESP;
  wire S00_AXI_1_BVALID;
  wire [31:0]S00_AXI_1_RDATA;
  wire S00_AXI_1_RREADY;
  wire [1:0]S00_AXI_1_RRESP;
  wire S00_AXI_1_RVALID;
  wire [31:0]S00_AXI_1_WDATA;
  wire S00_AXI_1_WREADY;
  wire [3:0]S00_AXI_1_WSTRB;
  wire S00_AXI_1_WVALID;
  wire [31:0]counter_1;
  wire [15:0]dac_a_mult_out_bus;
  wire [15:0]dac_b_mult_out_bus;
  wire [31:0]data_padder_0_data_out;
  wire [31:0]data_padder_0_data_out1;
  wire [31:0]data_padder_1_data_out;
  wire [31:0]data_padder_2_data_out;
  wire [31:0]data_padder_3_data_out;
  wire [31:0]data_padder_4_data_out;
  wire [31:0]data_padder_5_data_out;
  wire [31:0]data_padder_6_data_out;
  wire [31:0]default_val_0_out_bus;
  wire [31:0]default_val_0_out_bus1;
  wire [31:0]default_val_0_out_bus2;
  wire [31:0]default_val_0_out_bus3;
  wire [15:0]default_val_0_out_bus4;
  wire [31:0]offset_end_1;
  wire [31:0]offset_start_1;
  wire [31:0]out_val_0_out_bus;
  wire [31:0]out_val_0_out_bus1;
  wire ps_0_FCLK_CLK0;
  wire s00_axi_aresetn_1;
  wire [31:0]sample_cnt_out_bus;
  wire [15:0]split_AXI_0_ch_a_out;
  wire [31:0]sweep_max_out_bus;
  wire [31:0]sweep_min_out_bus;

  assign S00_AXI_1_ARADDR = S00_AXI_araddr[31:0];
  assign S00_AXI_1_ARPROT = S00_AXI_arprot[2:0];
  assign S00_AXI_1_ARVALID = S00_AXI_arvalid;
  assign S00_AXI_1_AWADDR = S00_AXI_awaddr[31:0];
  assign S00_AXI_1_AWPROT = S00_AXI_awprot[2:0];
  assign S00_AXI_1_AWVALID = S00_AXI_awvalid;
  assign S00_AXI_1_BREADY = S00_AXI_bready;
  assign S00_AXI_1_RREADY = S00_AXI_rready;
  assign S00_AXI_1_WDATA = S00_AXI_wdata[31:0];
  assign S00_AXI_1_WSTRB = S00_AXI_wstrb[3:0];
  assign S00_AXI_1_WVALID = S00_AXI_wvalid;
  assign S00_AXI_arready = S00_AXI_1_ARREADY;
  assign S00_AXI_awready = S00_AXI_1_AWREADY;
  assign S00_AXI_bresp[1:0] = S00_AXI_1_BRESP;
  assign S00_AXI_bvalid = S00_AXI_1_BVALID;
  assign S00_AXI_rdata[31:0] = S00_AXI_1_RDATA;
  assign S00_AXI_rresp[1:0] = S00_AXI_1_RRESP;
  assign S00_AXI_rvalid = S00_AXI_1_RVALID;
  assign S00_AXI_wready = S00_AXI_1_WREADY;
  assign amp_mult[31:0] = default_val_0_out_bus3;
  assign avg_inc_cnt[31:0] = out_val_0_out_bus;
  assign counter_1 = counter[31:0];
  assign dac_a_mult[15:0] = dac_a_mult_out_bus;
  assign dac_b_mult[15:0] = dac_b_mult_out_bus;
  assign data_padder_0_data_out = ch_a_x[31:0];
  assign data_padder_0_data_out1 = ch_a_Y[31:0];
  assign data_padder_1_data_out = ch_a_amp[31:0];
  assign data_padder_2_data_out = cha_a_phase[31:0];
  assign data_padder_3_data_out = ch_b_X[31:0];
  assign data_padder_4_data_out = ch_b_Y[31:0];
  assign data_padder_5_data_out = ch_b_amp[31:0];
  assign data_padder_6_data_out = ch_b_phase[31:0];
  assign mod_phase[15:0] = default_val_0_out_bus4;
  assign mode_flags[31:0] = default_val_0_out_bus1;
  assign offset_end_1 = offset_end[31:0];
  assign offset_start_1 = offset_start[31:0];
  assign phase_inc[31:0] = default_val_0_out_bus;
  assign ps_0_FCLK_CLK0 = s00_axi_aclk;
  assign s00_axi_aresetn_1 = s00_axi_aresetn;
  assign sample_cnt[31:0] = sample_cnt_out_bus;
  assign sweep_add[31:0] = default_val_0_out_bus2;
  assign sweep_max[31:0] = sweep_max_out_bus;
  assign sweep_min[31:0] = sweep_min_out_bus;
  system_AXI_inout_0_0 AXI_inout_0
       (.in32(data_padder_0_data_out),
        .in33(data_padder_0_data_out1),
        .in34(data_padder_1_data_out),
        .in35(data_padder_2_data_out),
        .in36(data_padder_3_data_out),
        .in37(data_padder_4_data_out),
        .in38(data_padder_5_data_out),
        .in39(data_padder_6_data_out),
        .in40(counter_1),
        .in41(offset_start_1),
        .in42(offset_end_1),
        .in43(out_val_0_out_bus1),
        .in44(out_val_0_out_bus1),
        .in45(out_val_0_out_bus1),
        .in46(out_val_0_out_bus1),
        .in47(out_val_0_out_bus1),
        .out0(AXI_inout_0_out0),
        .out1(AXI_inout_0_out1),
        .out2(AXI_inout_0_out2),
        .out3(AXI_inout_0_out3),
        .out4(AXI_inout_0_out4),
        .out5(AXI_inout_0_out5),
        .out6(AXI_inout_0_out6),
        .out7(AXI_inout_0_out7),
        .out8(AXI_inout_0_out8),
        .out9(AXI_inout_0_out9),
        .s00_axi_aclk(ps_0_FCLK_CLK0),
        .s00_axi_araddr(S00_AXI_1_ARADDR[7:0]),
        .s00_axi_aresetn(s00_axi_aresetn_1),
        .s00_axi_arprot(S00_AXI_1_ARPROT),
        .s00_axi_arready(S00_AXI_1_ARREADY),
        .s00_axi_arvalid(S00_AXI_1_ARVALID),
        .s00_axi_awaddr(S00_AXI_1_AWADDR[7:0]),
        .s00_axi_awprot(S00_AXI_1_AWPROT),
        .s00_axi_awready(S00_AXI_1_AWREADY),
        .s00_axi_awvalid(S00_AXI_1_AWVALID),
        .s00_axi_bready(S00_AXI_1_BREADY),
        .s00_axi_bresp(S00_AXI_1_BRESP),
        .s00_axi_bvalid(S00_AXI_1_BVALID),
        .s00_axi_rdata(S00_AXI_1_RDATA),
        .s00_axi_rready(S00_AXI_1_RREADY),
        .s00_axi_rresp(S00_AXI_1_RRESP),
        .s00_axi_rvalid(S00_AXI_1_RVALID),
        .s00_axi_wdata(S00_AXI_1_WDATA),
        .s00_axi_wready(S00_AXI_1_WREADY),
        .s00_axi_wstrb(S00_AXI_1_WSTRB),
        .s00_axi_wvalid(S00_AXI_1_WVALID));
  system_split_AXI_0_1 Output_mults
       (.ch_a_out(Output_mults_ch_a_out),
        .ch_b_out(Output_mults_ch_b_out),
        .in_data(AXI_inout_0_out7));
  system_default_val_0_6 amp_mult_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(AXI_inout_0_out6),
        .out_bus(default_val_0_out_bus3));
  system_default_val_0_1 avg_inc_cnt_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(AXI_inout_0_out1),
        .out_bus(out_val_0_out_bus));
  system_default_val_0_7 dac_a_mult_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(Output_mults_ch_a_out),
        .out_bus(dac_a_mult_out_bus));
  system_default_val_1_0 dac_b_mult_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(Output_mults_ch_b_out),
        .out_bus(dac_b_mult_out_bus));
  system_split_AXI_0_3 mod_phase_RnM
       (.ch_a_out(split_AXI_0_ch_a_out),
        .in_data(AXI_inout_0_out8));
  system_default_val_0_8 mod_phase_def
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(split_AXI_0_ch_a_out),
        .out_bus(default_val_0_out_bus4));
  system_default_val_0_2 mode_flags_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(AXI_inout_0_out2),
        .out_bus(default_val_0_out_bus1));
  system_out_val_0_3 out_val_0
       (.out_bus(out_val_0_out_bus1));
  system_default_val_0_0 phase_inc_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(AXI_inout_0_out0),
        .out_bus(default_val_0_out_bus));
  system_phase_inc_0 sample_cnt_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(AXI_inout_0_out9),
        .out_bus(sample_cnt_out_bus));
  system_default_val_0_5 sweep_add_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(AXI_inout_0_out5),
        .out_bus(default_val_0_out_bus2));
  system_default_val_0_4 sweep_max_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(AXI_inout_0_out4),
        .out_bus(sweep_max_out_bus));
  system_default_val_0_3 sweep_min_RnM
       (.clk(ps_0_FCLK_CLK0),
        .in_bus(AXI_inout_0_out3),
        .out_bus(sweep_min_out_bus));
endmodule

(* CORE_GENERATION_INFO = "system,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=system,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=115,numReposBlks=94,numNonXlnxBlks=0,numHierBlks=21,maxHierDepth=2,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=59,numPkgbdBlks=0,bdsource=USER,da_axi4_cnt=19,da_board_cnt=3,synth_mode=Global}" *) (* HW_HANDOFF = "system.hwdef" *) 
module system
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    adc_clk_n_i,
    adc_clk_p_i,
    adc_csn_o,
    adc_dat_a_i,
    adc_dat_b_i,
    adc_enc_n_o,
    adc_enc_p_o,
    dac_clk_o,
    dac_dat_o,
    dac_pwm_o,
    dac_rst_o,
    dac_sel_o,
    dac_wrt_o,
    daisy_n_i0,
    daisy_n_i1,
    daisy_n_o0,
    daisy_n_o1,
    daisy_p_i0,
    daisy_p_i1,
    daisy_p_o0,
    daisy_p_o1,
    exp_n_tri_io,
    exp_p_tri_io,
    led_o,
    reset_rtl);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input adc_clk_n_i;
  input adc_clk_p_i;
  output adc_csn_o;
  input [13:0]adc_dat_a_i;
  input [13:0]adc_dat_b_i;
  output adc_enc_n_o;
  output adc_enc_p_o;
  output dac_clk_o;
  output [13:0]dac_dat_o;
  output [3:0]dac_pwm_o;
  output dac_rst_o;
  output dac_sel_o;
  output dac_wrt_o;
  input daisy_n_i0;
  input daisy_n_i1;
  output [0:0]daisy_n_o0;
  output [0:0]daisy_n_o1;
  input daisy_p_i0;
  input daisy_p_i1;
  output [0:0]daisy_p_o0;
  output [0:0]daisy_p_o1;
  inout [7:0]exp_n_tri_io;
  inout [7:0]exp_p_tri_io;
  output [6:0]led_o;
  input reset_rtl;

  wire [15:0]DDS_cos_out;
  wire [15:0]DDS_cos_shift_out;
  wire [15:0]DDS_sin_out;
  wire [23:0]Lock_in_a_X_out_data;
  wire [23:0]Lock_in_a_Y_out_data;
  wire [7:0]Net;
  wire [7:0]Net1;
  wire [23:0]accumulator_limited_0_out;
  wire [13:0]adc_2comp_0_adc_a_o;
  wire adc_clk_n_i_1;
  wire adc_clk_p_i_1;
  wire [13:0]adc_dat_a_i_1;
  wire [13:0]adc_dat_b_i_1;
  wire [23:0]ch_b_processing_X_out;
  wire [23:0]ch_b_processing_Y_out;
  wire [23:0]ch_b_processing_amp_out;
  wire [23:0]ch_b_processing_phase_out;
  wire clk_buf_0_clk_o;
  wire clk_wiz_0_clk_ddr;
  wire clk_wiz_0_locked;
  wire clk_wiz_1_clk_out1;
  wire [23:0]cordic_0_m_axis_dout_tdata;
  wire [23:0]cordic_1_m_axis_dout_tdata;
  wire [31:0]counter_1;
  wire [15:0]dac_a_mult_out_bus;
  wire [15:0]dac_b_mult_out_bus;
  wire [13:0]dac_switch_0_dac_data_o;
  wire dac_switch_0_ddr_clk_o1;
  wire dac_switch_0_ddr_clk_o2;
  wire dac_switch_0_select_o;
  wire daisy_n_i0_1;
  wire daisy_n_i1_1;
  wire daisy_p_i0_1;
  wire daisy_p_i1_1;
  wire [31:0]default_val_0_out_bus;
  wire [31:0]default_val_0_out_bus1;
  wire [31:0]default_val_0_out_bus2;
  wire [31:0]default_val_0_out_bus3;
  wire [6:0]digital_IO_connect_0_cnt_o;
  wire freq_double_1;
  wire [6:0]loop_counter_count;
  wire [31:0]memory_interface_M00_AXI_ARADDR;
  wire [1:0]memory_interface_M00_AXI_ARBURST;
  wire [3:0]memory_interface_M00_AXI_ARCACHE;
  wire [5:0]memory_interface_M00_AXI_ARID;
  wire [3:0]memory_interface_M00_AXI_ARLEN;
  wire [1:0]memory_interface_M00_AXI_ARLOCK;
  wire [2:0]memory_interface_M00_AXI_ARPROT;
  wire [3:0]memory_interface_M00_AXI_ARQOS;
  wire memory_interface_M00_AXI_ARREADY;
  wire [2:0]memory_interface_M00_AXI_ARSIZE;
  wire memory_interface_M00_AXI_ARVALID;
  wire [31:0]memory_interface_M00_AXI_AWADDR;
  wire [1:0]memory_interface_M00_AXI_AWBURST;
  wire [3:0]memory_interface_M00_AXI_AWCACHE;
  wire [5:0]memory_interface_M00_AXI_AWID;
  wire [3:0]memory_interface_M00_AXI_AWLEN;
  wire [1:0]memory_interface_M00_AXI_AWLOCK;
  wire [2:0]memory_interface_M00_AXI_AWPROT;
  wire [3:0]memory_interface_M00_AXI_AWQOS;
  wire memory_interface_M00_AXI_AWREADY;
  wire [2:0]memory_interface_M00_AXI_AWSIZE;
  wire memory_interface_M00_AXI_AWVALID;
  wire [5:0]memory_interface_M00_AXI_BID;
  wire memory_interface_M00_AXI_BREADY;
  wire [1:0]memory_interface_M00_AXI_BRESP;
  wire memory_interface_M00_AXI_BVALID;
  wire [31:0]memory_interface_M00_AXI_RDATA;
  wire [5:0]memory_interface_M00_AXI_RID;
  wire memory_interface_M00_AXI_RLAST;
  wire memory_interface_M00_AXI_RREADY;
  wire [1:0]memory_interface_M00_AXI_RRESP;
  wire memory_interface_M00_AXI_RVALID;
  wire [31:0]memory_interface_M00_AXI_WDATA;
  wire [5:0]memory_interface_M00_AXI_WID;
  wire memory_interface_M00_AXI_WLAST;
  wire memory_interface_M00_AXI_WREADY;
  wire [3:0]memory_interface_M00_AXI_WSTRB;
  wire memory_interface_M00_AXI_WVALID;
  wire [6:0]memory_interface_counter_current;
  wire mode_control_0_cl_select;
  wire [23:0]mode_control_0_dac_a;
  wire [23:0]mode_control_0_dac_b;
  wire mode_control_0_io_slave;
  wire mode_control_0_sweep_const;
  wire mode_control_0_sync_o;
  wire mode_control_0_ttl_o;
  wire [23:0]mult_gen_0_P;
  wire [13:0]mult_gen_1_P;
  wire [13:0]mult_gen_2_P;
  wire [31:0]out_val_0_out_bus;
  wire [14:0]ps_0_DDR_ADDR;
  wire [2:0]ps_0_DDR_BA;
  wire ps_0_DDR_CAS_N;
  wire ps_0_DDR_CKE;
  wire ps_0_DDR_CK_N;
  wire ps_0_DDR_CK_P;
  wire ps_0_DDR_CS_N;
  wire [3:0]ps_0_DDR_DM;
  wire [31:0]ps_0_DDR_DQ;
  wire [3:0]ps_0_DDR_DQS_N;
  wire [3:0]ps_0_DDR_DQS_P;
  wire ps_0_DDR_ODT;
  wire ps_0_DDR_RAS_N;
  wire ps_0_DDR_RESET_N;
  wire ps_0_DDR_WE_N;
  wire ps_0_FCLK_CLK0;
  wire ps_0_FCLK_RESET0_N;
  wire ps_0_FIXED_IO_DDR_VRN;
  wire ps_0_FIXED_IO_DDR_VRP;
  wire [53:0]ps_0_FIXED_IO_MIO;
  wire ps_0_FIXED_IO_PS_CLK;
  wire ps_0_FIXED_IO_PS_PORB;
  wire ps_0_FIXED_IO_PS_SRSTB;
  wire [31:0]ps_0_M_AXI_GP0_ARADDR;
  wire [1:0]ps_0_M_AXI_GP0_ARBURST;
  wire [3:0]ps_0_M_AXI_GP0_ARCACHE;
  wire [11:0]ps_0_M_AXI_GP0_ARID;
  wire [3:0]ps_0_M_AXI_GP0_ARLEN;
  wire [1:0]ps_0_M_AXI_GP0_ARLOCK;
  wire [2:0]ps_0_M_AXI_GP0_ARPROT;
  wire [3:0]ps_0_M_AXI_GP0_ARQOS;
  wire ps_0_M_AXI_GP0_ARREADY;
  wire [2:0]ps_0_M_AXI_GP0_ARSIZE;
  wire ps_0_M_AXI_GP0_ARVALID;
  wire [31:0]ps_0_M_AXI_GP0_AWADDR;
  wire [1:0]ps_0_M_AXI_GP0_AWBURST;
  wire [3:0]ps_0_M_AXI_GP0_AWCACHE;
  wire [11:0]ps_0_M_AXI_GP0_AWID;
  wire [3:0]ps_0_M_AXI_GP0_AWLEN;
  wire [1:0]ps_0_M_AXI_GP0_AWLOCK;
  wire [2:0]ps_0_M_AXI_GP0_AWPROT;
  wire [3:0]ps_0_M_AXI_GP0_AWQOS;
  wire ps_0_M_AXI_GP0_AWREADY;
  wire [2:0]ps_0_M_AXI_GP0_AWSIZE;
  wire ps_0_M_AXI_GP0_AWVALID;
  wire [11:0]ps_0_M_AXI_GP0_BID;
  wire ps_0_M_AXI_GP0_BREADY;
  wire [1:0]ps_0_M_AXI_GP0_BRESP;
  wire ps_0_M_AXI_GP0_BVALID;
  wire [31:0]ps_0_M_AXI_GP0_RDATA;
  wire [11:0]ps_0_M_AXI_GP0_RID;
  wire ps_0_M_AXI_GP0_RLAST;
  wire ps_0_M_AXI_GP0_RREADY;
  wire [1:0]ps_0_M_AXI_GP0_RRESP;
  wire ps_0_M_AXI_GP0_RVALID;
  wire [31:0]ps_0_M_AXI_GP0_WDATA;
  wire [11:0]ps_0_M_AXI_GP0_WID;
  wire ps_0_M_AXI_GP0_WLAST;
  wire ps_0_M_AXI_GP0_WREADY;
  wire [3:0]ps_0_M_AXI_GP0_WSTRB;
  wire ps_0_M_AXI_GP0_WVALID;
  wire [15:0]settings_input_mod_phase_lead;
  wire [13:0]signal_in_1;
  wire sweep_gen_loop_o;
  wire sweep_gen_loop_o1;
  wire [31:0]sweep_max_out_bus;
  wire [31:0]sweep_min_out_bus;
  wire [13:0]ttl_insert_0_dat_out;
  wire [0:0]util_ds_buf_0_IBUF_OUT;
  wire [0:0]util_ds_buf_2_OBUF_DS_N;
  wire [0:0]util_ds_buf_2_OBUF_DS_P;
  wire [0:0]util_ds_buf_3_OBUF_DS_N;
  wire [0:0]util_ds_buf_3_OBUF_DS_P;

  assign adc_clk_n_i_1 = adc_clk_n_i;
  assign adc_clk_p_i_1 = adc_clk_p_i;
  assign adc_dat_a_i_1 = adc_dat_a_i[13:0];
  assign adc_dat_b_i_1 = adc_dat_b_i[13:0];
  assign dac_clk_o = dac_switch_0_ddr_clk_o1;
  assign dac_dat_o[13:0] = dac_switch_0_dac_data_o;
  assign dac_sel_o = dac_switch_0_select_o;
  assign dac_wrt_o = dac_switch_0_ddr_clk_o2;
  assign daisy_n_i0_1 = daisy_n_i0;
  assign daisy_n_i1_1 = daisy_n_i1;
  assign daisy_n_o0[0] = util_ds_buf_2_OBUF_DS_N;
  assign daisy_n_o1[0] = util_ds_buf_3_OBUF_DS_N;
  assign daisy_p_i0_1 = daisy_p_i0;
  assign daisy_p_i1_1 = daisy_p_i1;
  assign daisy_p_o0[0] = util_ds_buf_2_OBUF_DS_P;
  assign daisy_p_o1[0] = util_ds_buf_3_OBUF_DS_P;
  assign led_o[6:0] = memory_interface_counter_current;
  DDS_imp_75IOFP DDS
       (.cos_out(DDS_cos_out),
        .cos_shift_out(DDS_cos_shift_out),
        .count_clk(clk_buf_0_clk_o),
        .freq_double(freq_double_1),
        .inc_in(default_val_0_out_bus),
        .out_clk(ps_0_FCLK_CLK0),
        .phase_lead(settings_input_mod_phase_lead),
        .sin_out(DDS_sin_out),
        .sync_i(mode_control_0_sync_o));
  system_adc_2comp_0_0 adc_2comp_0
       (.adc_a_i(adc_dat_a_i_1),
        .adc_a_o(adc_2comp_0_adc_a_o),
        .adc_b_i(adc_dat_b_i_1),
        .adc_b_o(signal_in_1),
        .clk(ps_0_FCLK_CLK0));
  system_two_clk_accum_0_0 averaging_timer
       (.count_clk(clk_buf_0_clk_o),
        .count_out(counter_1),
        .inc_in(out_val_0_out_bus),
        .out_clk(ps_0_FCLK_CLK0),
        .sync_i(mode_control_0_sync_o));
  ch_a_processing_imp_8HXZQG ch_a_processing
       (.CLK(ps_0_FCLK_CLK0),
        .X_out(Lock_in_a_X_out_data),
        .Y_out(Lock_in_a_Y_out_data),
        .amp_out(cordic_0_m_axis_dout_tdata),
        .cnt_inc(out_val_0_out_bus),
        .counter(counter_1),
        .phase_out(cordic_1_m_axis_dout_tdata),
        .ref_in_cos(DDS_cos_out),
        .ref_in_sin(DDS_sin_out),
        .signal_in(adc_2comp_0_adc_a_o));
  ch_b_processing_imp_1VQSWGA ch_b_processing
       (.CLK(ps_0_FCLK_CLK0),
        .X_out(ch_b_processing_X_out),
        .Y_out(ch_b_processing_Y_out),
        .amp_out(ch_b_processing_amp_out),
        .cnt_inc(out_val_0_out_bus),
        .counter(counter_1),
        .phase_out(ch_b_processing_phase_out),
        .ref_in_cos(DDS_cos_out),
        .ref_in_sin(DDS_sin_out),
        .signal_in(signal_in_1));
  system_clk_switch_0_0 clk_switch_0
       (.cl_select(mode_control_0_cl_select),
        .clk_i0(ps_0_FCLK_CLK0),
        .clk_i1(clk_wiz_1_clk_out1),
        .clk_o(clk_buf_0_clk_o));
  system_clk_wiz_0_0 clk_wiz_0
       (.clk_ddr(clk_wiz_0_clk_ddr),
        .clk_in1_n(adc_clk_n_i_1),
        .clk_in1_p(adc_clk_p_i_1),
        .clk_out(ps_0_FCLK_CLK0),
        .locked(clk_wiz_0_locked),
        .reset(1'b0));
  system_clk_wiz_1_0 clk_wiz_1
       (.clk_in1_n(daisy_n_i1_1),
        .clk_in1_p(daisy_p_i1_1),
        .clk_out1(clk_wiz_1_clk_out1),
        .reset(1'b0));
  system_dac_switch_0_0 dac_switch_0
       (.dac_data_a(ttl_insert_0_dat_out),
        .dac_data_b(mult_gen_2_P),
        .dac_data_o(dac_switch_0_dac_data_o),
        .ddr_clk_i(clk_wiz_0_clk_ddr),
        .ddr_clk_o1(dac_switch_0_ddr_clk_o1),
        .ddr_clk_o2(dac_switch_0_ddr_clk_o2),
        .select_i(ps_0_FCLK_CLK0),
        .select_o(dac_switch_0_select_o));
  system_digital_IO_connect_0_0 digital_IO_connect_0
       (.clk(ps_0_FCLK_CLK0),
        .cnt_in(loop_counter_count),
        .cnt_o(digital_IO_connect_0_cnt_o),
        .io_n(exp_n_tri_io[7:0]),
        .io_p(exp_p_tri_io[7:0]),
        .io_slave(mode_control_0_io_slave),
        .loop_in(sweep_gen_loop_o1),
        .loop_out(sweep_gen_loop_o));
  system_simp_counter_0_0 loop_counter
       (.clk(ps_0_FCLK_CLK0),
        .count(loop_counter_count),
        .inc_clk(sweep_gen_loop_o),
        .sync_i(mode_control_0_sync_o));
  memory_interface_imp_4TOQ3E memory_interface
       (.M00_AXI_araddr(memory_interface_M00_AXI_ARADDR),
        .M00_AXI_arburst(memory_interface_M00_AXI_ARBURST),
        .M00_AXI_arcache(memory_interface_M00_AXI_ARCACHE),
        .M00_AXI_arid(memory_interface_M00_AXI_ARID),
        .M00_AXI_arlen(memory_interface_M00_AXI_ARLEN),
        .M00_AXI_arlock(memory_interface_M00_AXI_ARLOCK),
        .M00_AXI_arprot(memory_interface_M00_AXI_ARPROT),
        .M00_AXI_arqos(memory_interface_M00_AXI_ARQOS),
        .M00_AXI_arready(memory_interface_M00_AXI_ARREADY),
        .M00_AXI_arsize(memory_interface_M00_AXI_ARSIZE),
        .M00_AXI_arvalid(memory_interface_M00_AXI_ARVALID),
        .M00_AXI_awaddr(memory_interface_M00_AXI_AWADDR),
        .M00_AXI_awburst(memory_interface_M00_AXI_AWBURST),
        .M00_AXI_awcache(memory_interface_M00_AXI_AWCACHE),
        .M00_AXI_awid(memory_interface_M00_AXI_AWID),
        .M00_AXI_awlen(memory_interface_M00_AXI_AWLEN),
        .M00_AXI_awlock(memory_interface_M00_AXI_AWLOCK),
        .M00_AXI_awprot(memory_interface_M00_AXI_AWPROT),
        .M00_AXI_awqos(memory_interface_M00_AXI_AWQOS),
        .M00_AXI_awready(memory_interface_M00_AXI_AWREADY),
        .M00_AXI_awsize(memory_interface_M00_AXI_AWSIZE),
        .M00_AXI_awvalid(memory_interface_M00_AXI_AWVALID),
        .M00_AXI_bid(memory_interface_M00_AXI_BID),
        .M00_AXI_bready(memory_interface_M00_AXI_BREADY),
        .M00_AXI_bresp(memory_interface_M00_AXI_BRESP),
        .M00_AXI_bvalid(memory_interface_M00_AXI_BVALID),
        .M00_AXI_rdata(memory_interface_M00_AXI_RDATA),
        .M00_AXI_rid(memory_interface_M00_AXI_RID),
        .M00_AXI_rlast(memory_interface_M00_AXI_RLAST),
        .M00_AXI_rready(memory_interface_M00_AXI_RREADY),
        .M00_AXI_rresp(memory_interface_M00_AXI_RRESP),
        .M00_AXI_rvalid(memory_interface_M00_AXI_RVALID),
        .M00_AXI_wdata(memory_interface_M00_AXI_WDATA),
        .M00_AXI_wid(memory_interface_M00_AXI_WID),
        .M00_AXI_wlast(memory_interface_M00_AXI_WLAST),
        .M00_AXI_wready(memory_interface_M00_AXI_WREADY),
        .M00_AXI_wstrb(memory_interface_M00_AXI_WSTRB),
        .M00_AXI_wvalid(memory_interface_M00_AXI_WVALID),
        .S00_AXI_araddr(ps_0_M_AXI_GP0_ARADDR),
        .S00_AXI_arburst(ps_0_M_AXI_GP0_ARBURST),
        .S00_AXI_arcache(ps_0_M_AXI_GP0_ARCACHE),
        .S00_AXI_arid(ps_0_M_AXI_GP0_ARID),
        .S00_AXI_arlen(ps_0_M_AXI_GP0_ARLEN),
        .S00_AXI_arlock(ps_0_M_AXI_GP0_ARLOCK),
        .S00_AXI_arprot(ps_0_M_AXI_GP0_ARPROT),
        .S00_AXI_arqos(ps_0_M_AXI_GP0_ARQOS),
        .S00_AXI_arready(ps_0_M_AXI_GP0_ARREADY),
        .S00_AXI_arsize(ps_0_M_AXI_GP0_ARSIZE),
        .S00_AXI_arvalid(ps_0_M_AXI_GP0_ARVALID),
        .S00_AXI_awaddr(ps_0_M_AXI_GP0_AWADDR),
        .S00_AXI_awburst(ps_0_M_AXI_GP0_AWBURST),
        .S00_AXI_awcache(ps_0_M_AXI_GP0_AWCACHE),
        .S00_AXI_awid(ps_0_M_AXI_GP0_AWID),
        .S00_AXI_awlen(ps_0_M_AXI_GP0_AWLEN),
        .S00_AXI_awlock(ps_0_M_AXI_GP0_AWLOCK),
        .S00_AXI_awprot(ps_0_M_AXI_GP0_AWPROT),
        .S00_AXI_awqos(ps_0_M_AXI_GP0_AWQOS),
        .S00_AXI_awready(ps_0_M_AXI_GP0_AWREADY),
        .S00_AXI_awsize(ps_0_M_AXI_GP0_AWSIZE),
        .S00_AXI_awvalid(ps_0_M_AXI_GP0_AWVALID),
        .S00_AXI_bid(ps_0_M_AXI_GP0_BID),
        .S00_AXI_bready(ps_0_M_AXI_GP0_BREADY),
        .S00_AXI_bresp(ps_0_M_AXI_GP0_BRESP),
        .S00_AXI_bvalid(ps_0_M_AXI_GP0_BVALID),
        .S00_AXI_rdata(ps_0_M_AXI_GP0_RDATA),
        .S00_AXI_rid(ps_0_M_AXI_GP0_RID),
        .S00_AXI_rlast(ps_0_M_AXI_GP0_RLAST),
        .S00_AXI_rready(ps_0_M_AXI_GP0_RREADY),
        .S00_AXI_rresp(ps_0_M_AXI_GP0_RRESP),
        .S00_AXI_rvalid(ps_0_M_AXI_GP0_RVALID),
        .S00_AXI_wdata(ps_0_M_AXI_GP0_WDATA),
        .S00_AXI_wid(ps_0_M_AXI_GP0_WID),
        .S00_AXI_wlast(ps_0_M_AXI_GP0_WLAST),
        .S00_AXI_wready(ps_0_M_AXI_GP0_WREADY),
        .S00_AXI_wstrb(ps_0_M_AXI_GP0_WSTRB),
        .S00_AXI_wvalid(ps_0_M_AXI_GP0_WVALID),
        .amp_mult(default_val_0_out_bus3),
        .avg_inc_cnt(out_val_0_out_bus),
        .ch_a_X(Lock_in_a_X_out_data),
        .ch_a_Y(Lock_in_a_Y_out_data),
        .ch_a_amp(cordic_0_m_axis_dout_tdata),
        .ch_a_phase(cordic_1_m_axis_dout_tdata),
        .ch_b_X(ch_b_processing_X_out),
        .ch_b_Y(ch_b_processing_Y_out),
        .ch_b_amp(ch_b_processing_amp_out),
        .ch_b_phase(ch_b_processing_phase_out),
        .clk(ps_0_FCLK_CLK0),
        .count_clk(clk_buf_0_clk_o),
        .counter(digital_IO_connect_0_cnt_o),
        .counter_current(memory_interface_counter_current),
        .dac_a_mult(dac_a_mult_out_bus),
        .dac_b_mult(dac_b_mult_out_bus),
        .dcm_locked(clk_wiz_0_locked),
        .ext_reset_in(ps_0_FCLK_RESET0_N),
        .loop_flag(sweep_gen_loop_o),
        .mod_phase_lead(settings_input_mod_phase_lead),
        .mode_flags(default_val_0_out_bus1),
        .phase_inc(default_val_0_out_bus),
        .sweep_add(default_val_0_out_bus2),
        .sweep_max(sweep_max_out_bus),
        .sweep_min(sweep_min_out_bus),
        .sync_i(mode_control_0_sync_o));
  system_mode_control_0_0 mode_control_0
       (.ch_a_X_in(Lock_in_a_X_out_data),
        .ch_a_Y_in(Lock_in_a_Y_out_data),
        .ch_a_amp_in(cordic_0_m_axis_dout_tdata),
        .ch_a_phase_in(cordic_1_m_axis_dout_tdata),
        .ch_b_X_in(ch_b_processing_X_out),
        .ch_b_Y_in(ch_b_processing_Y_out),
        .ch_b_amp_in(ch_b_processing_amp_out),
        .ch_b_phase_in(ch_b_processing_phase_out),
        .cl_select(mode_control_0_cl_select),
        .clk(ps_0_FCLK_CLK0),
        .dac_a(mode_control_0_dac_a),
        .dac_b(mode_control_0_dac_b),
        .freq_double(freq_double_1),
        .io_slave(mode_control_0_io_slave),
        .mode_flags(default_val_0_out_bus1),
        .sweep_amp_in(default_val_0_out_bus3),
        .sweep_const(mode_control_0_sweep_const),
        .sweep_in(accumulator_limited_0_out),
        .sweep_loop(sweep_gen_loop_o),
        .sweep_mod_in(mult_gen_0_P),
        .sweep_mod_raw_in(DDS_cos_shift_out),
        .sync_i(util_ds_buf_0_IBUF_OUT),
        .sync_o(mode_control_0_sync_o),
        .ttl_o(mode_control_0_ttl_o));
  system_mult_gen_1_1 mult_gen_1
       (.A(mode_control_0_dac_a),
        .B(dac_a_mult_out_bus),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_1_P));
  system_mult_gen_1_6 mult_gen_2
       (.A(mode_control_0_dac_b),
        .B(dac_b_mult_out_bus),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_2_P));
  system_ps_0_0 ps_0
       (.DDR_Addr(DDR_addr[14:0]),
        .DDR_BankAddr(DDR_ba[2:0]),
        .DDR_CAS_n(DDR_cas_n),
        .DDR_CKE(DDR_cke),
        .DDR_CS_n(DDR_cs_n),
        .DDR_Clk(DDR_ck_p),
        .DDR_Clk_n(DDR_ck_n),
        .DDR_DM(DDR_dm[3:0]),
        .DDR_DQ(DDR_dq[31:0]),
        .DDR_DQS(DDR_dqs_p[3:0]),
        .DDR_DQS_n(DDR_dqs_n[3:0]),
        .DDR_DRSTB(DDR_reset_n),
        .DDR_ODT(DDR_odt),
        .DDR_RAS_n(DDR_ras_n),
        .DDR_VRN(FIXED_IO_ddr_vrn),
        .DDR_VRP(FIXED_IO_ddr_vrp),
        .DDR_WEB(DDR_we_n),
        .FCLK_RESET0_N(ps_0_FCLK_RESET0_N),
        .MIO(FIXED_IO_mio[53:0]),
        .M_AXI_GP0_ACLK(ps_0_FCLK_CLK0),
        .M_AXI_GP0_ARADDR(ps_0_M_AXI_GP0_ARADDR),
        .M_AXI_GP0_ARBURST(ps_0_M_AXI_GP0_ARBURST),
        .M_AXI_GP0_ARCACHE(ps_0_M_AXI_GP0_ARCACHE),
        .M_AXI_GP0_ARID(ps_0_M_AXI_GP0_ARID),
        .M_AXI_GP0_ARLEN(ps_0_M_AXI_GP0_ARLEN),
        .M_AXI_GP0_ARLOCK(ps_0_M_AXI_GP0_ARLOCK),
        .M_AXI_GP0_ARPROT(ps_0_M_AXI_GP0_ARPROT),
        .M_AXI_GP0_ARQOS(ps_0_M_AXI_GP0_ARQOS),
        .M_AXI_GP0_ARREADY(ps_0_M_AXI_GP0_ARREADY),
        .M_AXI_GP0_ARSIZE(ps_0_M_AXI_GP0_ARSIZE),
        .M_AXI_GP0_ARVALID(ps_0_M_AXI_GP0_ARVALID),
        .M_AXI_GP0_AWADDR(ps_0_M_AXI_GP0_AWADDR),
        .M_AXI_GP0_AWBURST(ps_0_M_AXI_GP0_AWBURST),
        .M_AXI_GP0_AWCACHE(ps_0_M_AXI_GP0_AWCACHE),
        .M_AXI_GP0_AWID(ps_0_M_AXI_GP0_AWID),
        .M_AXI_GP0_AWLEN(ps_0_M_AXI_GP0_AWLEN),
        .M_AXI_GP0_AWLOCK(ps_0_M_AXI_GP0_AWLOCK),
        .M_AXI_GP0_AWPROT(ps_0_M_AXI_GP0_AWPROT),
        .M_AXI_GP0_AWQOS(ps_0_M_AXI_GP0_AWQOS),
        .M_AXI_GP0_AWREADY(ps_0_M_AXI_GP0_AWREADY),
        .M_AXI_GP0_AWSIZE(ps_0_M_AXI_GP0_AWSIZE),
        .M_AXI_GP0_AWVALID(ps_0_M_AXI_GP0_AWVALID),
        .M_AXI_GP0_BID(ps_0_M_AXI_GP0_BID),
        .M_AXI_GP0_BREADY(ps_0_M_AXI_GP0_BREADY),
        .M_AXI_GP0_BRESP(ps_0_M_AXI_GP0_BRESP),
        .M_AXI_GP0_BVALID(ps_0_M_AXI_GP0_BVALID),
        .M_AXI_GP0_RDATA(ps_0_M_AXI_GP0_RDATA),
        .M_AXI_GP0_RID(ps_0_M_AXI_GP0_RID),
        .M_AXI_GP0_RLAST(ps_0_M_AXI_GP0_RLAST),
        .M_AXI_GP0_RREADY(ps_0_M_AXI_GP0_RREADY),
        .M_AXI_GP0_RRESP(ps_0_M_AXI_GP0_RRESP),
        .M_AXI_GP0_RVALID(ps_0_M_AXI_GP0_RVALID),
        .M_AXI_GP0_WDATA(ps_0_M_AXI_GP0_WDATA),
        .M_AXI_GP0_WID(ps_0_M_AXI_GP0_WID),
        .M_AXI_GP0_WLAST(ps_0_M_AXI_GP0_WLAST),
        .M_AXI_GP0_WREADY(ps_0_M_AXI_GP0_WREADY),
        .M_AXI_GP0_WSTRB(ps_0_M_AXI_GP0_WSTRB),
        .M_AXI_GP0_WVALID(ps_0_M_AXI_GP0_WVALID),
        .PS_CLK(FIXED_IO_ps_clk),
        .PS_PORB(FIXED_IO_ps_porb),
        .PS_SRSTB(FIXED_IO_ps_srstb),
        .SPI0_MISO_I(1'b0),
        .SPI0_MOSI_I(1'b0),
        .SPI0_SCLK_I(1'b0),
        .SPI0_SS_I(1'b0),
        .S_AXI_HP0_ACLK(ps_0_FCLK_CLK0),
        .S_AXI_HP0_ARADDR(memory_interface_M00_AXI_ARADDR),
        .S_AXI_HP0_ARBURST(memory_interface_M00_AXI_ARBURST),
        .S_AXI_HP0_ARCACHE(memory_interface_M00_AXI_ARCACHE),
        .S_AXI_HP0_ARID(memory_interface_M00_AXI_ARID),
        .S_AXI_HP0_ARLEN(memory_interface_M00_AXI_ARLEN),
        .S_AXI_HP0_ARLOCK(memory_interface_M00_AXI_ARLOCK),
        .S_AXI_HP0_ARPROT(memory_interface_M00_AXI_ARPROT),
        .S_AXI_HP0_ARQOS(memory_interface_M00_AXI_ARQOS),
        .S_AXI_HP0_ARREADY(memory_interface_M00_AXI_ARREADY),
        .S_AXI_HP0_ARSIZE(memory_interface_M00_AXI_ARSIZE),
        .S_AXI_HP0_ARVALID(memory_interface_M00_AXI_ARVALID),
        .S_AXI_HP0_AWADDR(memory_interface_M00_AXI_AWADDR),
        .S_AXI_HP0_AWBURST(memory_interface_M00_AXI_AWBURST),
        .S_AXI_HP0_AWCACHE(memory_interface_M00_AXI_AWCACHE),
        .S_AXI_HP0_AWID(memory_interface_M00_AXI_AWID),
        .S_AXI_HP0_AWLEN(memory_interface_M00_AXI_AWLEN),
        .S_AXI_HP0_AWLOCK(memory_interface_M00_AXI_AWLOCK),
        .S_AXI_HP0_AWPROT(memory_interface_M00_AXI_AWPROT),
        .S_AXI_HP0_AWQOS(memory_interface_M00_AXI_AWQOS),
        .S_AXI_HP0_AWREADY(memory_interface_M00_AXI_AWREADY),
        .S_AXI_HP0_AWSIZE(memory_interface_M00_AXI_AWSIZE),
        .S_AXI_HP0_AWVALID(memory_interface_M00_AXI_AWVALID),
        .S_AXI_HP0_BID(memory_interface_M00_AXI_BID),
        .S_AXI_HP0_BREADY(memory_interface_M00_AXI_BREADY),
        .S_AXI_HP0_BRESP(memory_interface_M00_AXI_BRESP),
        .S_AXI_HP0_BVALID(memory_interface_M00_AXI_BVALID),
        .S_AXI_HP0_RDATA(memory_interface_M00_AXI_RDATA),
        .S_AXI_HP0_RDISSUECAP1_EN(1'b0),
        .S_AXI_HP0_RID(memory_interface_M00_AXI_RID),
        .S_AXI_HP0_RLAST(memory_interface_M00_AXI_RLAST),
        .S_AXI_HP0_RREADY(memory_interface_M00_AXI_RREADY),
        .S_AXI_HP0_RRESP(memory_interface_M00_AXI_RRESP),
        .S_AXI_HP0_RVALID(memory_interface_M00_AXI_RVALID),
        .S_AXI_HP0_WDATA(memory_interface_M00_AXI_WDATA),
        .S_AXI_HP0_WID(memory_interface_M00_AXI_WID),
        .S_AXI_HP0_WLAST(memory_interface_M00_AXI_WLAST),
        .S_AXI_HP0_WREADY(memory_interface_M00_AXI_WREADY),
        .S_AXI_HP0_WRISSUECAP1_EN(1'b0),
        .S_AXI_HP0_WSTRB(memory_interface_M00_AXI_WSTRB),
        .S_AXI_HP0_WVALID(memory_interface_M00_AXI_WVALID),
        .USB0_VBUS_PWRFAULT(1'b0));
  system_mult_gen_0_1 sweep_cos_gen
       (.A(DDS_cos_shift_out),
        .B(default_val_0_out_bus3),
        .CLK(ps_0_FCLK_CLK0),
        .P(mult_gen_0_P));
  system_accumulator_limited_0_0 sweep_gen
       (.add(default_val_0_out_bus2),
        .clk(clk_buf_0_clk_o),
        .const_flag(mode_control_0_sweep_const),
        .loop_o(sweep_gen_loop_o1),
        .max(sweep_max_out_bus),
        .min(sweep_min_out_bus),
        .sweep_out(accumulator_limited_0_out),
        .sync(mode_control_0_sync_o));
  system_ttl_insert_0_0 ttl_insert_0
       (.clk(ps_0_FCLK_CLK0),
        .dat_in(mult_gen_1_P),
        .dat_out(ttl_insert_0_dat_out),
        .ttl_in(mode_control_0_ttl_o));
  system_util_ds_buf_0_0 util_ds_buf_0
       (.IBUF_DS_N(daisy_n_i0_1),
        .IBUF_DS_P(daisy_p_i0_1),
        .IBUF_OUT(util_ds_buf_0_IBUF_OUT));
  system_util_ds_buf_0_2 util_ds_buf_2
       (.OBUF_DS_N(util_ds_buf_2_OBUF_DS_N),
        .OBUF_DS_P(util_ds_buf_2_OBUF_DS_P),
        .OBUF_IN(mode_control_0_sync_o));
  system_util_ds_buf_2_0 util_ds_buf_3
       (.OBUF_DS_N(util_ds_buf_3_OBUF_DS_N),
        .OBUF_DS_P(util_ds_buf_3_OBUF_DS_P),
        .OBUF_IN(clk_buf_0_clk_o));
endmodule

module system_axi_mem_intercon_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arburst,
    M00_AXI_arcache,
    M00_AXI_arid,
    M00_AXI_arlen,
    M00_AXI_arlock,
    M00_AXI_arprot,
    M00_AXI_arqos,
    M00_AXI_arready,
    M00_AXI_arsize,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awburst,
    M00_AXI_awcache,
    M00_AXI_awid,
    M00_AXI_awlen,
    M00_AXI_awlock,
    M00_AXI_awprot,
    M00_AXI_awqos,
    M00_AXI_awready,
    M00_AXI_awsize,
    M00_AXI_awvalid,
    M00_AXI_bid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rid,
    M00_AXI_rlast,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wid,
    M00_AXI_wlast,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awid,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awuser,
    S00_AXI_awvalid,
    S00_AXI_bid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_buser,
    S00_AXI_bvalid,
    S00_AXI_wdata,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wuser,
    S00_AXI_wvalid,
    S01_ACLK,
    S01_ARESETN,
    S01_AXI_awaddr,
    S01_AXI_awburst,
    S01_AXI_awcache,
    S01_AXI_awid,
    S01_AXI_awlen,
    S01_AXI_awlock,
    S01_AXI_awprot,
    S01_AXI_awqos,
    S01_AXI_awready,
    S01_AXI_awsize,
    S01_AXI_awuser,
    S01_AXI_awvalid,
    S01_AXI_bid,
    S01_AXI_bready,
    S01_AXI_bresp,
    S01_AXI_buser,
    S01_AXI_bvalid,
    S01_AXI_wdata,
    S01_AXI_wlast,
    S01_AXI_wready,
    S01_AXI_wstrb,
    S01_AXI_wuser,
    S01_AXI_wvalid,
    S02_ACLK,
    S02_ARESETN,
    S02_AXI_awaddr,
    S02_AXI_awburst,
    S02_AXI_awcache,
    S02_AXI_awid,
    S02_AXI_awlen,
    S02_AXI_awlock,
    S02_AXI_awprot,
    S02_AXI_awqos,
    S02_AXI_awready,
    S02_AXI_awsize,
    S02_AXI_awuser,
    S02_AXI_awvalid,
    S02_AXI_bid,
    S02_AXI_bready,
    S02_AXI_bresp,
    S02_AXI_buser,
    S02_AXI_bvalid,
    S02_AXI_wdata,
    S02_AXI_wlast,
    S02_AXI_wready,
    S02_AXI_wstrb,
    S02_AXI_wuser,
    S02_AXI_wvalid,
    S03_ACLK,
    S03_ARESETN,
    S03_AXI_awaddr,
    S03_AXI_awburst,
    S03_AXI_awcache,
    S03_AXI_awid,
    S03_AXI_awlen,
    S03_AXI_awlock,
    S03_AXI_awprot,
    S03_AXI_awqos,
    S03_AXI_awready,
    S03_AXI_awsize,
    S03_AXI_awuser,
    S03_AXI_awvalid,
    S03_AXI_bid,
    S03_AXI_bready,
    S03_AXI_bresp,
    S03_AXI_buser,
    S03_AXI_bvalid,
    S03_AXI_wdata,
    S03_AXI_wlast,
    S03_AXI_wready,
    S03_AXI_wstrb,
    S03_AXI_wuser,
    S03_AXI_wvalid,
    S04_ACLK,
    S04_ARESETN,
    S04_AXI_awaddr,
    S04_AXI_awburst,
    S04_AXI_awcache,
    S04_AXI_awid,
    S04_AXI_awlen,
    S04_AXI_awlock,
    S04_AXI_awprot,
    S04_AXI_awqos,
    S04_AXI_awready,
    S04_AXI_awsize,
    S04_AXI_awuser,
    S04_AXI_awvalid,
    S04_AXI_bid,
    S04_AXI_bready,
    S04_AXI_bresp,
    S04_AXI_buser,
    S04_AXI_bvalid,
    S04_AXI_wdata,
    S04_AXI_wlast,
    S04_AXI_wready,
    S04_AXI_wstrb,
    S04_AXI_wuser,
    S04_AXI_wvalid,
    S05_ACLK,
    S05_ARESETN,
    S05_AXI_awaddr,
    S05_AXI_awburst,
    S05_AXI_awcache,
    S05_AXI_awid,
    S05_AXI_awlen,
    S05_AXI_awlock,
    S05_AXI_awprot,
    S05_AXI_awqos,
    S05_AXI_awready,
    S05_AXI_awsize,
    S05_AXI_awuser,
    S05_AXI_awvalid,
    S05_AXI_bid,
    S05_AXI_bready,
    S05_AXI_bresp,
    S05_AXI_buser,
    S05_AXI_bvalid,
    S05_AXI_wdata,
    S05_AXI_wlast,
    S05_AXI_wready,
    S05_AXI_wstrb,
    S05_AXI_wuser,
    S05_AXI_wvalid,
    S06_ACLK,
    S06_ARESETN,
    S06_AXI_awaddr,
    S06_AXI_awburst,
    S06_AXI_awcache,
    S06_AXI_awid,
    S06_AXI_awlen,
    S06_AXI_awlock,
    S06_AXI_awprot,
    S06_AXI_awqos,
    S06_AXI_awready,
    S06_AXI_awsize,
    S06_AXI_awuser,
    S06_AXI_awvalid,
    S06_AXI_bid,
    S06_AXI_bready,
    S06_AXI_bresp,
    S06_AXI_buser,
    S06_AXI_bvalid,
    S06_AXI_wdata,
    S06_AXI_wlast,
    S06_AXI_wready,
    S06_AXI_wstrb,
    S06_AXI_wuser,
    S06_AXI_wvalid,
    S07_ACLK,
    S07_ARESETN,
    S07_AXI_awaddr,
    S07_AXI_awburst,
    S07_AXI_awcache,
    S07_AXI_awid,
    S07_AXI_awlen,
    S07_AXI_awlock,
    S07_AXI_awprot,
    S07_AXI_awqos,
    S07_AXI_awready,
    S07_AXI_awsize,
    S07_AXI_awuser,
    S07_AXI_awvalid,
    S07_AXI_bid,
    S07_AXI_bready,
    S07_AXI_bresp,
    S07_AXI_buser,
    S07_AXI_bvalid,
    S07_AXI_wdata,
    S07_AXI_wlast,
    S07_AXI_wready,
    S07_AXI_wstrb,
    S07_AXI_wuser,
    S07_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [31:0]M00_AXI_araddr;
  output [1:0]M00_AXI_arburst;
  output [3:0]M00_AXI_arcache;
  output [5:0]M00_AXI_arid;
  output [3:0]M00_AXI_arlen;
  output [1:0]M00_AXI_arlock;
  output [2:0]M00_AXI_arprot;
  output [3:0]M00_AXI_arqos;
  input M00_AXI_arready;
  output [2:0]M00_AXI_arsize;
  output M00_AXI_arvalid;
  output [31:0]M00_AXI_awaddr;
  output [1:0]M00_AXI_awburst;
  output [3:0]M00_AXI_awcache;
  output [5:0]M00_AXI_awid;
  output [3:0]M00_AXI_awlen;
  output [1:0]M00_AXI_awlock;
  output [2:0]M00_AXI_awprot;
  output [3:0]M00_AXI_awqos;
  input M00_AXI_awready;
  output [2:0]M00_AXI_awsize;
  output M00_AXI_awvalid;
  input [5:0]M00_AXI_bid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [31:0]M00_AXI_rdata;
  input [5:0]M00_AXI_rid;
  input M00_AXI_rlast;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [31:0]M00_AXI_wdata;
  output [5:0]M00_AXI_wid;
  output M00_AXI_wlast;
  input M00_AXI_wready;
  output [3:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [31:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [2:0]S00_AXI_awid;
  input [7:0]S00_AXI_awlen;
  input S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input [0:0]S00_AXI_awuser;
  input S00_AXI_awvalid;
  output [5:0]S00_AXI_bid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output [0:0]S00_AXI_buser;
  output S00_AXI_bvalid;
  input [31:0]S00_AXI_wdata;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input [0:0]S00_AXI_wuser;
  input S00_AXI_wvalid;
  input S01_ACLK;
  input S01_ARESETN;
  input [31:0]S01_AXI_awaddr;
  input [1:0]S01_AXI_awburst;
  input [3:0]S01_AXI_awcache;
  input [2:0]S01_AXI_awid;
  input [7:0]S01_AXI_awlen;
  input S01_AXI_awlock;
  input [2:0]S01_AXI_awprot;
  input [3:0]S01_AXI_awqos;
  output S01_AXI_awready;
  input [2:0]S01_AXI_awsize;
  input [0:0]S01_AXI_awuser;
  input S01_AXI_awvalid;
  output [5:0]S01_AXI_bid;
  input S01_AXI_bready;
  output [1:0]S01_AXI_bresp;
  output [0:0]S01_AXI_buser;
  output S01_AXI_bvalid;
  input [31:0]S01_AXI_wdata;
  input S01_AXI_wlast;
  output S01_AXI_wready;
  input [3:0]S01_AXI_wstrb;
  input [0:0]S01_AXI_wuser;
  input S01_AXI_wvalid;
  input S02_ACLK;
  input S02_ARESETN;
  input [31:0]S02_AXI_awaddr;
  input [1:0]S02_AXI_awburst;
  input [3:0]S02_AXI_awcache;
  input [2:0]S02_AXI_awid;
  input [7:0]S02_AXI_awlen;
  input S02_AXI_awlock;
  input [2:0]S02_AXI_awprot;
  input [3:0]S02_AXI_awqos;
  output S02_AXI_awready;
  input [2:0]S02_AXI_awsize;
  input [0:0]S02_AXI_awuser;
  input S02_AXI_awvalid;
  output [5:0]S02_AXI_bid;
  input S02_AXI_bready;
  output [1:0]S02_AXI_bresp;
  output [0:0]S02_AXI_buser;
  output S02_AXI_bvalid;
  input [31:0]S02_AXI_wdata;
  input S02_AXI_wlast;
  output S02_AXI_wready;
  input [3:0]S02_AXI_wstrb;
  input [0:0]S02_AXI_wuser;
  input S02_AXI_wvalid;
  input S03_ACLK;
  input S03_ARESETN;
  input [31:0]S03_AXI_awaddr;
  input [1:0]S03_AXI_awburst;
  input [3:0]S03_AXI_awcache;
  input [2:0]S03_AXI_awid;
  input [7:0]S03_AXI_awlen;
  input S03_AXI_awlock;
  input [2:0]S03_AXI_awprot;
  input [3:0]S03_AXI_awqos;
  output S03_AXI_awready;
  input [2:0]S03_AXI_awsize;
  input [0:0]S03_AXI_awuser;
  input S03_AXI_awvalid;
  output [5:0]S03_AXI_bid;
  input S03_AXI_bready;
  output [1:0]S03_AXI_bresp;
  output [0:0]S03_AXI_buser;
  output S03_AXI_bvalid;
  input [31:0]S03_AXI_wdata;
  input S03_AXI_wlast;
  output S03_AXI_wready;
  input [3:0]S03_AXI_wstrb;
  input [0:0]S03_AXI_wuser;
  input S03_AXI_wvalid;
  input S04_ACLK;
  input S04_ARESETN;
  input [31:0]S04_AXI_awaddr;
  input [1:0]S04_AXI_awburst;
  input [3:0]S04_AXI_awcache;
  input [2:0]S04_AXI_awid;
  input [7:0]S04_AXI_awlen;
  input S04_AXI_awlock;
  input [2:0]S04_AXI_awprot;
  input [3:0]S04_AXI_awqos;
  output S04_AXI_awready;
  input [2:0]S04_AXI_awsize;
  input [0:0]S04_AXI_awuser;
  input S04_AXI_awvalid;
  output [5:0]S04_AXI_bid;
  input S04_AXI_bready;
  output [1:0]S04_AXI_bresp;
  output [0:0]S04_AXI_buser;
  output S04_AXI_bvalid;
  input [31:0]S04_AXI_wdata;
  input S04_AXI_wlast;
  output S04_AXI_wready;
  input [3:0]S04_AXI_wstrb;
  input [0:0]S04_AXI_wuser;
  input S04_AXI_wvalid;
  input S05_ACLK;
  input S05_ARESETN;
  input [31:0]S05_AXI_awaddr;
  input [1:0]S05_AXI_awburst;
  input [3:0]S05_AXI_awcache;
  input [2:0]S05_AXI_awid;
  input [7:0]S05_AXI_awlen;
  input S05_AXI_awlock;
  input [2:0]S05_AXI_awprot;
  input [3:0]S05_AXI_awqos;
  output S05_AXI_awready;
  input [2:0]S05_AXI_awsize;
  input [0:0]S05_AXI_awuser;
  input S05_AXI_awvalid;
  output [5:0]S05_AXI_bid;
  input S05_AXI_bready;
  output [1:0]S05_AXI_bresp;
  output [0:0]S05_AXI_buser;
  output S05_AXI_bvalid;
  input [31:0]S05_AXI_wdata;
  input S05_AXI_wlast;
  output S05_AXI_wready;
  input [3:0]S05_AXI_wstrb;
  input [0:0]S05_AXI_wuser;
  input S05_AXI_wvalid;
  input S06_ACLK;
  input S06_ARESETN;
  input [31:0]S06_AXI_awaddr;
  input [1:0]S06_AXI_awburst;
  input [3:0]S06_AXI_awcache;
  input [2:0]S06_AXI_awid;
  input [7:0]S06_AXI_awlen;
  input S06_AXI_awlock;
  input [2:0]S06_AXI_awprot;
  input [3:0]S06_AXI_awqos;
  output S06_AXI_awready;
  input [2:0]S06_AXI_awsize;
  input [0:0]S06_AXI_awuser;
  input S06_AXI_awvalid;
  output [5:0]S06_AXI_bid;
  input S06_AXI_bready;
  output [1:0]S06_AXI_bresp;
  output [0:0]S06_AXI_buser;
  output S06_AXI_bvalid;
  input [31:0]S06_AXI_wdata;
  input S06_AXI_wlast;
  output S06_AXI_wready;
  input [3:0]S06_AXI_wstrb;
  input [0:0]S06_AXI_wuser;
  input S06_AXI_wvalid;
  input S07_ACLK;
  input S07_ARESETN;
  input [31:0]S07_AXI_awaddr;
  input [1:0]S07_AXI_awburst;
  input [3:0]S07_AXI_awcache;
  input [2:0]S07_AXI_awid;
  input [7:0]S07_AXI_awlen;
  input S07_AXI_awlock;
  input [2:0]S07_AXI_awprot;
  input [3:0]S07_AXI_awqos;
  output S07_AXI_awready;
  input [2:0]S07_AXI_awsize;
  input [0:0]S07_AXI_awuser;
  input S07_AXI_awvalid;
  output [5:0]S07_AXI_bid;
  input S07_AXI_bready;
  output [1:0]S07_AXI_bresp;
  output [0:0]S07_AXI_buser;
  output S07_AXI_bvalid;
  input [31:0]S07_AXI_wdata;
  input S07_AXI_wlast;
  output S07_AXI_wready;
  input [3:0]S07_AXI_wstrb;
  input [0:0]S07_AXI_wuser;
  input S07_AXI_wvalid;

  wire M00_ACLK_1;
  wire M00_ARESETN_1;
  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire S01_ACLK_1;
  wire S01_ARESETN_1;
  wire S02_ACLK_1;
  wire S02_ARESETN_1;
  wire S03_ACLK_1;
  wire S03_ARESETN_1;
  wire S04_ACLK_1;
  wire S04_ARESETN_1;
  wire S05_ACLK_1;
  wire S05_ARESETN_1;
  wire S06_ACLK_1;
  wire S06_ARESETN_1;
  wire S07_ACLK_1;
  wire S07_ARESETN_1;
  wire axi_mem_intercon_ACLK_net;
  wire axi_mem_intercon_ARESETN_net;
  wire [31:0]axi_mem_intercon_to_s00_couplers_AWADDR;
  wire [1:0]axi_mem_intercon_to_s00_couplers_AWBURST;
  wire [3:0]axi_mem_intercon_to_s00_couplers_AWCACHE;
  wire [2:0]axi_mem_intercon_to_s00_couplers_AWID;
  wire [7:0]axi_mem_intercon_to_s00_couplers_AWLEN;
  wire axi_mem_intercon_to_s00_couplers_AWLOCK;
  wire [2:0]axi_mem_intercon_to_s00_couplers_AWPROT;
  wire [3:0]axi_mem_intercon_to_s00_couplers_AWQOS;
  wire axi_mem_intercon_to_s00_couplers_AWREADY;
  wire [2:0]axi_mem_intercon_to_s00_couplers_AWSIZE;
  wire [0:0]axi_mem_intercon_to_s00_couplers_AWUSER;
  wire axi_mem_intercon_to_s00_couplers_AWVALID;
  wire [5:0]axi_mem_intercon_to_s00_couplers_BID;
  wire axi_mem_intercon_to_s00_couplers_BREADY;
  wire [1:0]axi_mem_intercon_to_s00_couplers_BRESP;
  wire [0:0]axi_mem_intercon_to_s00_couplers_BUSER;
  wire axi_mem_intercon_to_s00_couplers_BVALID;
  wire [31:0]axi_mem_intercon_to_s00_couplers_WDATA;
  wire axi_mem_intercon_to_s00_couplers_WLAST;
  wire axi_mem_intercon_to_s00_couplers_WREADY;
  wire [3:0]axi_mem_intercon_to_s00_couplers_WSTRB;
  wire [0:0]axi_mem_intercon_to_s00_couplers_WUSER;
  wire axi_mem_intercon_to_s00_couplers_WVALID;
  wire [31:0]axi_mem_intercon_to_s01_couplers_AWADDR;
  wire [1:0]axi_mem_intercon_to_s01_couplers_AWBURST;
  wire [3:0]axi_mem_intercon_to_s01_couplers_AWCACHE;
  wire [2:0]axi_mem_intercon_to_s01_couplers_AWID;
  wire [7:0]axi_mem_intercon_to_s01_couplers_AWLEN;
  wire axi_mem_intercon_to_s01_couplers_AWLOCK;
  wire [2:0]axi_mem_intercon_to_s01_couplers_AWPROT;
  wire [3:0]axi_mem_intercon_to_s01_couplers_AWQOS;
  wire axi_mem_intercon_to_s01_couplers_AWREADY;
  wire [2:0]axi_mem_intercon_to_s01_couplers_AWSIZE;
  wire [0:0]axi_mem_intercon_to_s01_couplers_AWUSER;
  wire axi_mem_intercon_to_s01_couplers_AWVALID;
  wire [5:0]axi_mem_intercon_to_s01_couplers_BID;
  wire axi_mem_intercon_to_s01_couplers_BREADY;
  wire [1:0]axi_mem_intercon_to_s01_couplers_BRESP;
  wire [0:0]axi_mem_intercon_to_s01_couplers_BUSER;
  wire axi_mem_intercon_to_s01_couplers_BVALID;
  wire [31:0]axi_mem_intercon_to_s01_couplers_WDATA;
  wire axi_mem_intercon_to_s01_couplers_WLAST;
  wire axi_mem_intercon_to_s01_couplers_WREADY;
  wire [3:0]axi_mem_intercon_to_s01_couplers_WSTRB;
  wire [0:0]axi_mem_intercon_to_s01_couplers_WUSER;
  wire axi_mem_intercon_to_s01_couplers_WVALID;
  wire [31:0]axi_mem_intercon_to_s02_couplers_AWADDR;
  wire [1:0]axi_mem_intercon_to_s02_couplers_AWBURST;
  wire [3:0]axi_mem_intercon_to_s02_couplers_AWCACHE;
  wire [2:0]axi_mem_intercon_to_s02_couplers_AWID;
  wire [7:0]axi_mem_intercon_to_s02_couplers_AWLEN;
  wire axi_mem_intercon_to_s02_couplers_AWLOCK;
  wire [2:0]axi_mem_intercon_to_s02_couplers_AWPROT;
  wire [3:0]axi_mem_intercon_to_s02_couplers_AWQOS;
  wire axi_mem_intercon_to_s02_couplers_AWREADY;
  wire [2:0]axi_mem_intercon_to_s02_couplers_AWSIZE;
  wire [0:0]axi_mem_intercon_to_s02_couplers_AWUSER;
  wire axi_mem_intercon_to_s02_couplers_AWVALID;
  wire [5:0]axi_mem_intercon_to_s02_couplers_BID;
  wire axi_mem_intercon_to_s02_couplers_BREADY;
  wire [1:0]axi_mem_intercon_to_s02_couplers_BRESP;
  wire [0:0]axi_mem_intercon_to_s02_couplers_BUSER;
  wire axi_mem_intercon_to_s02_couplers_BVALID;
  wire [31:0]axi_mem_intercon_to_s02_couplers_WDATA;
  wire axi_mem_intercon_to_s02_couplers_WLAST;
  wire axi_mem_intercon_to_s02_couplers_WREADY;
  wire [3:0]axi_mem_intercon_to_s02_couplers_WSTRB;
  wire [0:0]axi_mem_intercon_to_s02_couplers_WUSER;
  wire axi_mem_intercon_to_s02_couplers_WVALID;
  wire [31:0]axi_mem_intercon_to_s03_couplers_AWADDR;
  wire [1:0]axi_mem_intercon_to_s03_couplers_AWBURST;
  wire [3:0]axi_mem_intercon_to_s03_couplers_AWCACHE;
  wire [2:0]axi_mem_intercon_to_s03_couplers_AWID;
  wire [7:0]axi_mem_intercon_to_s03_couplers_AWLEN;
  wire axi_mem_intercon_to_s03_couplers_AWLOCK;
  wire [2:0]axi_mem_intercon_to_s03_couplers_AWPROT;
  wire [3:0]axi_mem_intercon_to_s03_couplers_AWQOS;
  wire axi_mem_intercon_to_s03_couplers_AWREADY;
  wire [2:0]axi_mem_intercon_to_s03_couplers_AWSIZE;
  wire [0:0]axi_mem_intercon_to_s03_couplers_AWUSER;
  wire axi_mem_intercon_to_s03_couplers_AWVALID;
  wire [5:0]axi_mem_intercon_to_s03_couplers_BID;
  wire axi_mem_intercon_to_s03_couplers_BREADY;
  wire [1:0]axi_mem_intercon_to_s03_couplers_BRESP;
  wire [0:0]axi_mem_intercon_to_s03_couplers_BUSER;
  wire axi_mem_intercon_to_s03_couplers_BVALID;
  wire [31:0]axi_mem_intercon_to_s03_couplers_WDATA;
  wire axi_mem_intercon_to_s03_couplers_WLAST;
  wire axi_mem_intercon_to_s03_couplers_WREADY;
  wire [3:0]axi_mem_intercon_to_s03_couplers_WSTRB;
  wire [0:0]axi_mem_intercon_to_s03_couplers_WUSER;
  wire axi_mem_intercon_to_s03_couplers_WVALID;
  wire [31:0]axi_mem_intercon_to_s04_couplers_AWADDR;
  wire [1:0]axi_mem_intercon_to_s04_couplers_AWBURST;
  wire [3:0]axi_mem_intercon_to_s04_couplers_AWCACHE;
  wire [2:0]axi_mem_intercon_to_s04_couplers_AWID;
  wire [7:0]axi_mem_intercon_to_s04_couplers_AWLEN;
  wire axi_mem_intercon_to_s04_couplers_AWLOCK;
  wire [2:0]axi_mem_intercon_to_s04_couplers_AWPROT;
  wire [3:0]axi_mem_intercon_to_s04_couplers_AWQOS;
  wire axi_mem_intercon_to_s04_couplers_AWREADY;
  wire [2:0]axi_mem_intercon_to_s04_couplers_AWSIZE;
  wire [0:0]axi_mem_intercon_to_s04_couplers_AWUSER;
  wire axi_mem_intercon_to_s04_couplers_AWVALID;
  wire [5:0]axi_mem_intercon_to_s04_couplers_BID;
  wire axi_mem_intercon_to_s04_couplers_BREADY;
  wire [1:0]axi_mem_intercon_to_s04_couplers_BRESP;
  wire [0:0]axi_mem_intercon_to_s04_couplers_BUSER;
  wire axi_mem_intercon_to_s04_couplers_BVALID;
  wire [31:0]axi_mem_intercon_to_s04_couplers_WDATA;
  wire axi_mem_intercon_to_s04_couplers_WLAST;
  wire axi_mem_intercon_to_s04_couplers_WREADY;
  wire [3:0]axi_mem_intercon_to_s04_couplers_WSTRB;
  wire [0:0]axi_mem_intercon_to_s04_couplers_WUSER;
  wire axi_mem_intercon_to_s04_couplers_WVALID;
  wire [31:0]axi_mem_intercon_to_s05_couplers_AWADDR;
  wire [1:0]axi_mem_intercon_to_s05_couplers_AWBURST;
  wire [3:0]axi_mem_intercon_to_s05_couplers_AWCACHE;
  wire [2:0]axi_mem_intercon_to_s05_couplers_AWID;
  wire [7:0]axi_mem_intercon_to_s05_couplers_AWLEN;
  wire axi_mem_intercon_to_s05_couplers_AWLOCK;
  wire [2:0]axi_mem_intercon_to_s05_couplers_AWPROT;
  wire [3:0]axi_mem_intercon_to_s05_couplers_AWQOS;
  wire axi_mem_intercon_to_s05_couplers_AWREADY;
  wire [2:0]axi_mem_intercon_to_s05_couplers_AWSIZE;
  wire [0:0]axi_mem_intercon_to_s05_couplers_AWUSER;
  wire axi_mem_intercon_to_s05_couplers_AWVALID;
  wire [5:0]axi_mem_intercon_to_s05_couplers_BID;
  wire axi_mem_intercon_to_s05_couplers_BREADY;
  wire [1:0]axi_mem_intercon_to_s05_couplers_BRESP;
  wire [0:0]axi_mem_intercon_to_s05_couplers_BUSER;
  wire axi_mem_intercon_to_s05_couplers_BVALID;
  wire [31:0]axi_mem_intercon_to_s05_couplers_WDATA;
  wire axi_mem_intercon_to_s05_couplers_WLAST;
  wire axi_mem_intercon_to_s05_couplers_WREADY;
  wire [3:0]axi_mem_intercon_to_s05_couplers_WSTRB;
  wire [0:0]axi_mem_intercon_to_s05_couplers_WUSER;
  wire axi_mem_intercon_to_s05_couplers_WVALID;
  wire [31:0]axi_mem_intercon_to_s06_couplers_AWADDR;
  wire [1:0]axi_mem_intercon_to_s06_couplers_AWBURST;
  wire [3:0]axi_mem_intercon_to_s06_couplers_AWCACHE;
  wire [2:0]axi_mem_intercon_to_s06_couplers_AWID;
  wire [7:0]axi_mem_intercon_to_s06_couplers_AWLEN;
  wire axi_mem_intercon_to_s06_couplers_AWLOCK;
  wire [2:0]axi_mem_intercon_to_s06_couplers_AWPROT;
  wire [3:0]axi_mem_intercon_to_s06_couplers_AWQOS;
  wire axi_mem_intercon_to_s06_couplers_AWREADY;
  wire [2:0]axi_mem_intercon_to_s06_couplers_AWSIZE;
  wire [0:0]axi_mem_intercon_to_s06_couplers_AWUSER;
  wire axi_mem_intercon_to_s06_couplers_AWVALID;
  wire [5:0]axi_mem_intercon_to_s06_couplers_BID;
  wire axi_mem_intercon_to_s06_couplers_BREADY;
  wire [1:0]axi_mem_intercon_to_s06_couplers_BRESP;
  wire [0:0]axi_mem_intercon_to_s06_couplers_BUSER;
  wire axi_mem_intercon_to_s06_couplers_BVALID;
  wire [31:0]axi_mem_intercon_to_s06_couplers_WDATA;
  wire axi_mem_intercon_to_s06_couplers_WLAST;
  wire axi_mem_intercon_to_s06_couplers_WREADY;
  wire [3:0]axi_mem_intercon_to_s06_couplers_WSTRB;
  wire [0:0]axi_mem_intercon_to_s06_couplers_WUSER;
  wire axi_mem_intercon_to_s06_couplers_WVALID;
  wire [31:0]axi_mem_intercon_to_s07_couplers_AWADDR;
  wire [1:0]axi_mem_intercon_to_s07_couplers_AWBURST;
  wire [3:0]axi_mem_intercon_to_s07_couplers_AWCACHE;
  wire [2:0]axi_mem_intercon_to_s07_couplers_AWID;
  wire [7:0]axi_mem_intercon_to_s07_couplers_AWLEN;
  wire axi_mem_intercon_to_s07_couplers_AWLOCK;
  wire [2:0]axi_mem_intercon_to_s07_couplers_AWPROT;
  wire [3:0]axi_mem_intercon_to_s07_couplers_AWQOS;
  wire axi_mem_intercon_to_s07_couplers_AWREADY;
  wire [2:0]axi_mem_intercon_to_s07_couplers_AWSIZE;
  wire [0:0]axi_mem_intercon_to_s07_couplers_AWUSER;
  wire axi_mem_intercon_to_s07_couplers_AWVALID;
  wire [5:0]axi_mem_intercon_to_s07_couplers_BID;
  wire axi_mem_intercon_to_s07_couplers_BREADY;
  wire [1:0]axi_mem_intercon_to_s07_couplers_BRESP;
  wire [0:0]axi_mem_intercon_to_s07_couplers_BUSER;
  wire axi_mem_intercon_to_s07_couplers_BVALID;
  wire [31:0]axi_mem_intercon_to_s07_couplers_WDATA;
  wire axi_mem_intercon_to_s07_couplers_WLAST;
  wire axi_mem_intercon_to_s07_couplers_WREADY;
  wire [3:0]axi_mem_intercon_to_s07_couplers_WSTRB;
  wire [0:0]axi_mem_intercon_to_s07_couplers_WUSER;
  wire axi_mem_intercon_to_s07_couplers_WVALID;
  wire [31:0]m00_couplers_to_axi_mem_intercon_ARADDR;
  wire [1:0]m00_couplers_to_axi_mem_intercon_ARBURST;
  wire [3:0]m00_couplers_to_axi_mem_intercon_ARCACHE;
  wire [5:0]m00_couplers_to_axi_mem_intercon_ARID;
  wire [3:0]m00_couplers_to_axi_mem_intercon_ARLEN;
  wire [1:0]m00_couplers_to_axi_mem_intercon_ARLOCK;
  wire [2:0]m00_couplers_to_axi_mem_intercon_ARPROT;
  wire [3:0]m00_couplers_to_axi_mem_intercon_ARQOS;
  wire m00_couplers_to_axi_mem_intercon_ARREADY;
  wire [2:0]m00_couplers_to_axi_mem_intercon_ARSIZE;
  wire m00_couplers_to_axi_mem_intercon_ARVALID;
  wire [31:0]m00_couplers_to_axi_mem_intercon_AWADDR;
  wire [1:0]m00_couplers_to_axi_mem_intercon_AWBURST;
  wire [3:0]m00_couplers_to_axi_mem_intercon_AWCACHE;
  wire [5:0]m00_couplers_to_axi_mem_intercon_AWID;
  wire [3:0]m00_couplers_to_axi_mem_intercon_AWLEN;
  wire [1:0]m00_couplers_to_axi_mem_intercon_AWLOCK;
  wire [2:0]m00_couplers_to_axi_mem_intercon_AWPROT;
  wire [3:0]m00_couplers_to_axi_mem_intercon_AWQOS;
  wire m00_couplers_to_axi_mem_intercon_AWREADY;
  wire [2:0]m00_couplers_to_axi_mem_intercon_AWSIZE;
  wire m00_couplers_to_axi_mem_intercon_AWVALID;
  wire [5:0]m00_couplers_to_axi_mem_intercon_BID;
  wire m00_couplers_to_axi_mem_intercon_BREADY;
  wire [1:0]m00_couplers_to_axi_mem_intercon_BRESP;
  wire m00_couplers_to_axi_mem_intercon_BVALID;
  wire [31:0]m00_couplers_to_axi_mem_intercon_RDATA;
  wire [5:0]m00_couplers_to_axi_mem_intercon_RID;
  wire m00_couplers_to_axi_mem_intercon_RLAST;
  wire m00_couplers_to_axi_mem_intercon_RREADY;
  wire [1:0]m00_couplers_to_axi_mem_intercon_RRESP;
  wire m00_couplers_to_axi_mem_intercon_RVALID;
  wire [31:0]m00_couplers_to_axi_mem_intercon_WDATA;
  wire [5:0]m00_couplers_to_axi_mem_intercon_WID;
  wire m00_couplers_to_axi_mem_intercon_WLAST;
  wire m00_couplers_to_axi_mem_intercon_WREADY;
  wire [3:0]m00_couplers_to_axi_mem_intercon_WSTRB;
  wire m00_couplers_to_axi_mem_intercon_WVALID;
  wire [31:0]s00_couplers_to_xbar_AWADDR;
  wire [1:0]s00_couplers_to_xbar_AWBURST;
  wire [3:0]s00_couplers_to_xbar_AWCACHE;
  wire [2:0]s00_couplers_to_xbar_AWID;
  wire [7:0]s00_couplers_to_xbar_AWLEN;
  wire s00_couplers_to_xbar_AWLOCK;
  wire [2:0]s00_couplers_to_xbar_AWPROT;
  wire [3:0]s00_couplers_to_xbar_AWQOS;
  wire [0:0]s00_couplers_to_xbar_AWREADY;
  wire [2:0]s00_couplers_to_xbar_AWSIZE;
  wire [0:0]s00_couplers_to_xbar_AWUSER;
  wire s00_couplers_to_xbar_AWVALID;
  wire [5:0]s00_couplers_to_xbar_BID;
  wire s00_couplers_to_xbar_BREADY;
  wire [1:0]s00_couplers_to_xbar_BRESP;
  wire [0:0]s00_couplers_to_xbar_BUSER;
  wire [0:0]s00_couplers_to_xbar_BVALID;
  wire [31:0]s00_couplers_to_xbar_WDATA;
  wire s00_couplers_to_xbar_WLAST;
  wire [0:0]s00_couplers_to_xbar_WREADY;
  wire [3:0]s00_couplers_to_xbar_WSTRB;
  wire [0:0]s00_couplers_to_xbar_WUSER;
  wire s00_couplers_to_xbar_WVALID;
  wire [31:0]s01_couplers_to_xbar_AWADDR;
  wire [1:0]s01_couplers_to_xbar_AWBURST;
  wire [3:0]s01_couplers_to_xbar_AWCACHE;
  wire [2:0]s01_couplers_to_xbar_AWID;
  wire [7:0]s01_couplers_to_xbar_AWLEN;
  wire s01_couplers_to_xbar_AWLOCK;
  wire [2:0]s01_couplers_to_xbar_AWPROT;
  wire [3:0]s01_couplers_to_xbar_AWQOS;
  wire [1:1]s01_couplers_to_xbar_AWREADY;
  wire [2:0]s01_couplers_to_xbar_AWSIZE;
  wire [0:0]s01_couplers_to_xbar_AWUSER;
  wire s01_couplers_to_xbar_AWVALID;
  wire [11:6]s01_couplers_to_xbar_BID;
  wire s01_couplers_to_xbar_BREADY;
  wire [3:2]s01_couplers_to_xbar_BRESP;
  wire [1:1]s01_couplers_to_xbar_BUSER;
  wire [1:1]s01_couplers_to_xbar_BVALID;
  wire [31:0]s01_couplers_to_xbar_WDATA;
  wire s01_couplers_to_xbar_WLAST;
  wire [1:1]s01_couplers_to_xbar_WREADY;
  wire [3:0]s01_couplers_to_xbar_WSTRB;
  wire [0:0]s01_couplers_to_xbar_WUSER;
  wire s01_couplers_to_xbar_WVALID;
  wire [31:0]s02_couplers_to_xbar_AWADDR;
  wire [1:0]s02_couplers_to_xbar_AWBURST;
  wire [3:0]s02_couplers_to_xbar_AWCACHE;
  wire [2:0]s02_couplers_to_xbar_AWID;
  wire [7:0]s02_couplers_to_xbar_AWLEN;
  wire s02_couplers_to_xbar_AWLOCK;
  wire [2:0]s02_couplers_to_xbar_AWPROT;
  wire [3:0]s02_couplers_to_xbar_AWQOS;
  wire [2:2]s02_couplers_to_xbar_AWREADY;
  wire [2:0]s02_couplers_to_xbar_AWSIZE;
  wire [0:0]s02_couplers_to_xbar_AWUSER;
  wire s02_couplers_to_xbar_AWVALID;
  wire [17:12]s02_couplers_to_xbar_BID;
  wire s02_couplers_to_xbar_BREADY;
  wire [5:4]s02_couplers_to_xbar_BRESP;
  wire [2:2]s02_couplers_to_xbar_BUSER;
  wire [2:2]s02_couplers_to_xbar_BVALID;
  wire [31:0]s02_couplers_to_xbar_WDATA;
  wire s02_couplers_to_xbar_WLAST;
  wire [2:2]s02_couplers_to_xbar_WREADY;
  wire [3:0]s02_couplers_to_xbar_WSTRB;
  wire [0:0]s02_couplers_to_xbar_WUSER;
  wire s02_couplers_to_xbar_WVALID;
  wire [31:0]s03_couplers_to_xbar_AWADDR;
  wire [1:0]s03_couplers_to_xbar_AWBURST;
  wire [3:0]s03_couplers_to_xbar_AWCACHE;
  wire [2:0]s03_couplers_to_xbar_AWID;
  wire [7:0]s03_couplers_to_xbar_AWLEN;
  wire s03_couplers_to_xbar_AWLOCK;
  wire [2:0]s03_couplers_to_xbar_AWPROT;
  wire [3:0]s03_couplers_to_xbar_AWQOS;
  wire [3:3]s03_couplers_to_xbar_AWREADY;
  wire [2:0]s03_couplers_to_xbar_AWSIZE;
  wire [0:0]s03_couplers_to_xbar_AWUSER;
  wire s03_couplers_to_xbar_AWVALID;
  wire [23:18]s03_couplers_to_xbar_BID;
  wire s03_couplers_to_xbar_BREADY;
  wire [7:6]s03_couplers_to_xbar_BRESP;
  wire [3:3]s03_couplers_to_xbar_BUSER;
  wire [3:3]s03_couplers_to_xbar_BVALID;
  wire [31:0]s03_couplers_to_xbar_WDATA;
  wire s03_couplers_to_xbar_WLAST;
  wire [3:3]s03_couplers_to_xbar_WREADY;
  wire [3:0]s03_couplers_to_xbar_WSTRB;
  wire [0:0]s03_couplers_to_xbar_WUSER;
  wire s03_couplers_to_xbar_WVALID;
  wire [31:0]s04_couplers_to_xbar_AWADDR;
  wire [1:0]s04_couplers_to_xbar_AWBURST;
  wire [3:0]s04_couplers_to_xbar_AWCACHE;
  wire [2:0]s04_couplers_to_xbar_AWID;
  wire [7:0]s04_couplers_to_xbar_AWLEN;
  wire s04_couplers_to_xbar_AWLOCK;
  wire [2:0]s04_couplers_to_xbar_AWPROT;
  wire [3:0]s04_couplers_to_xbar_AWQOS;
  wire [4:4]s04_couplers_to_xbar_AWREADY;
  wire [2:0]s04_couplers_to_xbar_AWSIZE;
  wire [0:0]s04_couplers_to_xbar_AWUSER;
  wire s04_couplers_to_xbar_AWVALID;
  wire [29:24]s04_couplers_to_xbar_BID;
  wire s04_couplers_to_xbar_BREADY;
  wire [9:8]s04_couplers_to_xbar_BRESP;
  wire [4:4]s04_couplers_to_xbar_BUSER;
  wire [4:4]s04_couplers_to_xbar_BVALID;
  wire [31:0]s04_couplers_to_xbar_WDATA;
  wire s04_couplers_to_xbar_WLAST;
  wire [4:4]s04_couplers_to_xbar_WREADY;
  wire [3:0]s04_couplers_to_xbar_WSTRB;
  wire [0:0]s04_couplers_to_xbar_WUSER;
  wire s04_couplers_to_xbar_WVALID;
  wire [31:0]s05_couplers_to_xbar_AWADDR;
  wire [1:0]s05_couplers_to_xbar_AWBURST;
  wire [3:0]s05_couplers_to_xbar_AWCACHE;
  wire [2:0]s05_couplers_to_xbar_AWID;
  wire [7:0]s05_couplers_to_xbar_AWLEN;
  wire s05_couplers_to_xbar_AWLOCK;
  wire [2:0]s05_couplers_to_xbar_AWPROT;
  wire [3:0]s05_couplers_to_xbar_AWQOS;
  wire [5:5]s05_couplers_to_xbar_AWREADY;
  wire [2:0]s05_couplers_to_xbar_AWSIZE;
  wire [0:0]s05_couplers_to_xbar_AWUSER;
  wire s05_couplers_to_xbar_AWVALID;
  wire [35:30]s05_couplers_to_xbar_BID;
  wire s05_couplers_to_xbar_BREADY;
  wire [11:10]s05_couplers_to_xbar_BRESP;
  wire [5:5]s05_couplers_to_xbar_BUSER;
  wire [5:5]s05_couplers_to_xbar_BVALID;
  wire [31:0]s05_couplers_to_xbar_WDATA;
  wire s05_couplers_to_xbar_WLAST;
  wire [5:5]s05_couplers_to_xbar_WREADY;
  wire [3:0]s05_couplers_to_xbar_WSTRB;
  wire [0:0]s05_couplers_to_xbar_WUSER;
  wire s05_couplers_to_xbar_WVALID;
  wire [31:0]s06_couplers_to_xbar_AWADDR;
  wire [1:0]s06_couplers_to_xbar_AWBURST;
  wire [3:0]s06_couplers_to_xbar_AWCACHE;
  wire [2:0]s06_couplers_to_xbar_AWID;
  wire [7:0]s06_couplers_to_xbar_AWLEN;
  wire s06_couplers_to_xbar_AWLOCK;
  wire [2:0]s06_couplers_to_xbar_AWPROT;
  wire [3:0]s06_couplers_to_xbar_AWQOS;
  wire [6:6]s06_couplers_to_xbar_AWREADY;
  wire [2:0]s06_couplers_to_xbar_AWSIZE;
  wire [0:0]s06_couplers_to_xbar_AWUSER;
  wire s06_couplers_to_xbar_AWVALID;
  wire [41:36]s06_couplers_to_xbar_BID;
  wire s06_couplers_to_xbar_BREADY;
  wire [13:12]s06_couplers_to_xbar_BRESP;
  wire [6:6]s06_couplers_to_xbar_BUSER;
  wire [6:6]s06_couplers_to_xbar_BVALID;
  wire [31:0]s06_couplers_to_xbar_WDATA;
  wire s06_couplers_to_xbar_WLAST;
  wire [6:6]s06_couplers_to_xbar_WREADY;
  wire [3:0]s06_couplers_to_xbar_WSTRB;
  wire [0:0]s06_couplers_to_xbar_WUSER;
  wire s06_couplers_to_xbar_WVALID;
  wire [31:0]s07_couplers_to_xbar_AWADDR;
  wire [1:0]s07_couplers_to_xbar_AWBURST;
  wire [3:0]s07_couplers_to_xbar_AWCACHE;
  wire [2:0]s07_couplers_to_xbar_AWID;
  wire [7:0]s07_couplers_to_xbar_AWLEN;
  wire s07_couplers_to_xbar_AWLOCK;
  wire [2:0]s07_couplers_to_xbar_AWPROT;
  wire [3:0]s07_couplers_to_xbar_AWQOS;
  wire [7:7]s07_couplers_to_xbar_AWREADY;
  wire [2:0]s07_couplers_to_xbar_AWSIZE;
  wire [0:0]s07_couplers_to_xbar_AWUSER;
  wire s07_couplers_to_xbar_AWVALID;
  wire [47:42]s07_couplers_to_xbar_BID;
  wire s07_couplers_to_xbar_BREADY;
  wire [15:14]s07_couplers_to_xbar_BRESP;
  wire [7:7]s07_couplers_to_xbar_BUSER;
  wire [7:7]s07_couplers_to_xbar_BVALID;
  wire [31:0]s07_couplers_to_xbar_WDATA;
  wire s07_couplers_to_xbar_WLAST;
  wire [7:7]s07_couplers_to_xbar_WREADY;
  wire [3:0]s07_couplers_to_xbar_WSTRB;
  wire [0:0]s07_couplers_to_xbar_WUSER;
  wire s07_couplers_to_xbar_WVALID;
  wire [31:0]xbar_to_m00_couplers_ARADDR;
  wire [1:0]xbar_to_m00_couplers_ARBURST;
  wire [3:0]xbar_to_m00_couplers_ARCACHE;
  wire [5:0]xbar_to_m00_couplers_ARID;
  wire [7:0]xbar_to_m00_couplers_ARLEN;
  wire [0:0]xbar_to_m00_couplers_ARLOCK;
  wire [2:0]xbar_to_m00_couplers_ARPROT;
  wire [3:0]xbar_to_m00_couplers_ARQOS;
  wire xbar_to_m00_couplers_ARREADY;
  wire [3:0]xbar_to_m00_couplers_ARREGION;
  wire [2:0]xbar_to_m00_couplers_ARSIZE;
  wire [0:0]xbar_to_m00_couplers_ARVALID;
  wire [31:0]xbar_to_m00_couplers_AWADDR;
  wire [1:0]xbar_to_m00_couplers_AWBURST;
  wire [3:0]xbar_to_m00_couplers_AWCACHE;
  wire [5:0]xbar_to_m00_couplers_AWID;
  wire [7:0]xbar_to_m00_couplers_AWLEN;
  wire [0:0]xbar_to_m00_couplers_AWLOCK;
  wire [2:0]xbar_to_m00_couplers_AWPROT;
  wire [3:0]xbar_to_m00_couplers_AWQOS;
  wire xbar_to_m00_couplers_AWREADY;
  wire [3:0]xbar_to_m00_couplers_AWREGION;
  wire [2:0]xbar_to_m00_couplers_AWSIZE;
  wire [0:0]xbar_to_m00_couplers_AWUSER;
  wire [0:0]xbar_to_m00_couplers_AWVALID;
  wire [5:0]xbar_to_m00_couplers_BID;
  wire [0:0]xbar_to_m00_couplers_BREADY;
  wire [1:0]xbar_to_m00_couplers_BRESP;
  wire xbar_to_m00_couplers_BVALID;
  wire [31:0]xbar_to_m00_couplers_RDATA;
  wire [5:0]xbar_to_m00_couplers_RID;
  wire xbar_to_m00_couplers_RLAST;
  wire [0:0]xbar_to_m00_couplers_RREADY;
  wire [1:0]xbar_to_m00_couplers_RRESP;
  wire xbar_to_m00_couplers_RVALID;
  wire [31:0]xbar_to_m00_couplers_WDATA;
  wire [0:0]xbar_to_m00_couplers_WLAST;
  wire xbar_to_m00_couplers_WREADY;
  wire [3:0]xbar_to_m00_couplers_WSTRB;
  wire [0:0]xbar_to_m00_couplers_WUSER;
  wire [0:0]xbar_to_m00_couplers_WVALID;

  assign M00_ACLK_1 = M00_ACLK;
  assign M00_ARESETN_1 = M00_ARESETN;
  assign M00_AXI_araddr[31:0] = m00_couplers_to_axi_mem_intercon_ARADDR;
  assign M00_AXI_arburst[1:0] = m00_couplers_to_axi_mem_intercon_ARBURST;
  assign M00_AXI_arcache[3:0] = m00_couplers_to_axi_mem_intercon_ARCACHE;
  assign M00_AXI_arid[5:0] = m00_couplers_to_axi_mem_intercon_ARID;
  assign M00_AXI_arlen[3:0] = m00_couplers_to_axi_mem_intercon_ARLEN;
  assign M00_AXI_arlock[1:0] = m00_couplers_to_axi_mem_intercon_ARLOCK;
  assign M00_AXI_arprot[2:0] = m00_couplers_to_axi_mem_intercon_ARPROT;
  assign M00_AXI_arqos[3:0] = m00_couplers_to_axi_mem_intercon_ARQOS;
  assign M00_AXI_arsize[2:0] = m00_couplers_to_axi_mem_intercon_ARSIZE;
  assign M00_AXI_arvalid = m00_couplers_to_axi_mem_intercon_ARVALID;
  assign M00_AXI_awaddr[31:0] = m00_couplers_to_axi_mem_intercon_AWADDR;
  assign M00_AXI_awburst[1:0] = m00_couplers_to_axi_mem_intercon_AWBURST;
  assign M00_AXI_awcache[3:0] = m00_couplers_to_axi_mem_intercon_AWCACHE;
  assign M00_AXI_awid[5:0] = m00_couplers_to_axi_mem_intercon_AWID;
  assign M00_AXI_awlen[3:0] = m00_couplers_to_axi_mem_intercon_AWLEN;
  assign M00_AXI_awlock[1:0] = m00_couplers_to_axi_mem_intercon_AWLOCK;
  assign M00_AXI_awprot[2:0] = m00_couplers_to_axi_mem_intercon_AWPROT;
  assign M00_AXI_awqos[3:0] = m00_couplers_to_axi_mem_intercon_AWQOS;
  assign M00_AXI_awsize[2:0] = m00_couplers_to_axi_mem_intercon_AWSIZE;
  assign M00_AXI_awvalid = m00_couplers_to_axi_mem_intercon_AWVALID;
  assign M00_AXI_bready = m00_couplers_to_axi_mem_intercon_BREADY;
  assign M00_AXI_rready = m00_couplers_to_axi_mem_intercon_RREADY;
  assign M00_AXI_wdata[31:0] = m00_couplers_to_axi_mem_intercon_WDATA;
  assign M00_AXI_wid[5:0] = m00_couplers_to_axi_mem_intercon_WID;
  assign M00_AXI_wlast = m00_couplers_to_axi_mem_intercon_WLAST;
  assign M00_AXI_wstrb[3:0] = m00_couplers_to_axi_mem_intercon_WSTRB;
  assign M00_AXI_wvalid = m00_couplers_to_axi_mem_intercon_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_awready = axi_mem_intercon_to_s00_couplers_AWREADY;
  assign S00_AXI_bid[5:0] = axi_mem_intercon_to_s00_couplers_BID;
  assign S00_AXI_bresp[1:0] = axi_mem_intercon_to_s00_couplers_BRESP;
  assign S00_AXI_buser[0] = axi_mem_intercon_to_s00_couplers_BUSER;
  assign S00_AXI_bvalid = axi_mem_intercon_to_s00_couplers_BVALID;
  assign S00_AXI_wready = axi_mem_intercon_to_s00_couplers_WREADY;
  assign S01_ACLK_1 = S01_ACLK;
  assign S01_ARESETN_1 = S01_ARESETN;
  assign S01_AXI_awready = axi_mem_intercon_to_s01_couplers_AWREADY;
  assign S01_AXI_bid[5:0] = axi_mem_intercon_to_s01_couplers_BID;
  assign S01_AXI_bresp[1:0] = axi_mem_intercon_to_s01_couplers_BRESP;
  assign S01_AXI_buser[0] = axi_mem_intercon_to_s01_couplers_BUSER;
  assign S01_AXI_bvalid = axi_mem_intercon_to_s01_couplers_BVALID;
  assign S01_AXI_wready = axi_mem_intercon_to_s01_couplers_WREADY;
  assign S02_ACLK_1 = S02_ACLK;
  assign S02_ARESETN_1 = S02_ARESETN;
  assign S02_AXI_awready = axi_mem_intercon_to_s02_couplers_AWREADY;
  assign S02_AXI_bid[5:0] = axi_mem_intercon_to_s02_couplers_BID;
  assign S02_AXI_bresp[1:0] = axi_mem_intercon_to_s02_couplers_BRESP;
  assign S02_AXI_buser[0] = axi_mem_intercon_to_s02_couplers_BUSER;
  assign S02_AXI_bvalid = axi_mem_intercon_to_s02_couplers_BVALID;
  assign S02_AXI_wready = axi_mem_intercon_to_s02_couplers_WREADY;
  assign S03_ACLK_1 = S03_ACLK;
  assign S03_ARESETN_1 = S03_ARESETN;
  assign S03_AXI_awready = axi_mem_intercon_to_s03_couplers_AWREADY;
  assign S03_AXI_bid[5:0] = axi_mem_intercon_to_s03_couplers_BID;
  assign S03_AXI_bresp[1:0] = axi_mem_intercon_to_s03_couplers_BRESP;
  assign S03_AXI_buser[0] = axi_mem_intercon_to_s03_couplers_BUSER;
  assign S03_AXI_bvalid = axi_mem_intercon_to_s03_couplers_BVALID;
  assign S03_AXI_wready = axi_mem_intercon_to_s03_couplers_WREADY;
  assign S04_ACLK_1 = S04_ACLK;
  assign S04_ARESETN_1 = S04_ARESETN;
  assign S04_AXI_awready = axi_mem_intercon_to_s04_couplers_AWREADY;
  assign S04_AXI_bid[5:0] = axi_mem_intercon_to_s04_couplers_BID;
  assign S04_AXI_bresp[1:0] = axi_mem_intercon_to_s04_couplers_BRESP;
  assign S04_AXI_buser[0] = axi_mem_intercon_to_s04_couplers_BUSER;
  assign S04_AXI_bvalid = axi_mem_intercon_to_s04_couplers_BVALID;
  assign S04_AXI_wready = axi_mem_intercon_to_s04_couplers_WREADY;
  assign S05_ACLK_1 = S05_ACLK;
  assign S05_ARESETN_1 = S05_ARESETN;
  assign S05_AXI_awready = axi_mem_intercon_to_s05_couplers_AWREADY;
  assign S05_AXI_bid[5:0] = axi_mem_intercon_to_s05_couplers_BID;
  assign S05_AXI_bresp[1:0] = axi_mem_intercon_to_s05_couplers_BRESP;
  assign S05_AXI_buser[0] = axi_mem_intercon_to_s05_couplers_BUSER;
  assign S05_AXI_bvalid = axi_mem_intercon_to_s05_couplers_BVALID;
  assign S05_AXI_wready = axi_mem_intercon_to_s05_couplers_WREADY;
  assign S06_ACLK_1 = S06_ACLK;
  assign S06_ARESETN_1 = S06_ARESETN;
  assign S06_AXI_awready = axi_mem_intercon_to_s06_couplers_AWREADY;
  assign S06_AXI_bid[5:0] = axi_mem_intercon_to_s06_couplers_BID;
  assign S06_AXI_bresp[1:0] = axi_mem_intercon_to_s06_couplers_BRESP;
  assign S06_AXI_buser[0] = axi_mem_intercon_to_s06_couplers_BUSER;
  assign S06_AXI_bvalid = axi_mem_intercon_to_s06_couplers_BVALID;
  assign S06_AXI_wready = axi_mem_intercon_to_s06_couplers_WREADY;
  assign S07_ACLK_1 = S07_ACLK;
  assign S07_ARESETN_1 = S07_ARESETN;
  assign S07_AXI_awready = axi_mem_intercon_to_s07_couplers_AWREADY;
  assign S07_AXI_bid[5:0] = axi_mem_intercon_to_s07_couplers_BID;
  assign S07_AXI_bresp[1:0] = axi_mem_intercon_to_s07_couplers_BRESP;
  assign S07_AXI_buser[0] = axi_mem_intercon_to_s07_couplers_BUSER;
  assign S07_AXI_bvalid = axi_mem_intercon_to_s07_couplers_BVALID;
  assign S07_AXI_wready = axi_mem_intercon_to_s07_couplers_WREADY;
  assign axi_mem_intercon_ACLK_net = ACLK;
  assign axi_mem_intercon_ARESETN_net = ARESETN;
  assign axi_mem_intercon_to_s00_couplers_AWADDR = S00_AXI_awaddr[31:0];
  assign axi_mem_intercon_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign axi_mem_intercon_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign axi_mem_intercon_to_s00_couplers_AWID = S00_AXI_awid[2:0];
  assign axi_mem_intercon_to_s00_couplers_AWLEN = S00_AXI_awlen[7:0];
  assign axi_mem_intercon_to_s00_couplers_AWLOCK = S00_AXI_awlock;
  assign axi_mem_intercon_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign axi_mem_intercon_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign axi_mem_intercon_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign axi_mem_intercon_to_s00_couplers_AWUSER = S00_AXI_awuser[0];
  assign axi_mem_intercon_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign axi_mem_intercon_to_s00_couplers_BREADY = S00_AXI_bready;
  assign axi_mem_intercon_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign axi_mem_intercon_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign axi_mem_intercon_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign axi_mem_intercon_to_s00_couplers_WUSER = S00_AXI_wuser[0];
  assign axi_mem_intercon_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign axi_mem_intercon_to_s01_couplers_AWADDR = S01_AXI_awaddr[31:0];
  assign axi_mem_intercon_to_s01_couplers_AWBURST = S01_AXI_awburst[1:0];
  assign axi_mem_intercon_to_s01_couplers_AWCACHE = S01_AXI_awcache[3:0];
  assign axi_mem_intercon_to_s01_couplers_AWID = S01_AXI_awid[2:0];
  assign axi_mem_intercon_to_s01_couplers_AWLEN = S01_AXI_awlen[7:0];
  assign axi_mem_intercon_to_s01_couplers_AWLOCK = S01_AXI_awlock;
  assign axi_mem_intercon_to_s01_couplers_AWPROT = S01_AXI_awprot[2:0];
  assign axi_mem_intercon_to_s01_couplers_AWQOS = S01_AXI_awqos[3:0];
  assign axi_mem_intercon_to_s01_couplers_AWSIZE = S01_AXI_awsize[2:0];
  assign axi_mem_intercon_to_s01_couplers_AWUSER = S01_AXI_awuser[0];
  assign axi_mem_intercon_to_s01_couplers_AWVALID = S01_AXI_awvalid;
  assign axi_mem_intercon_to_s01_couplers_BREADY = S01_AXI_bready;
  assign axi_mem_intercon_to_s01_couplers_WDATA = S01_AXI_wdata[31:0];
  assign axi_mem_intercon_to_s01_couplers_WLAST = S01_AXI_wlast;
  assign axi_mem_intercon_to_s01_couplers_WSTRB = S01_AXI_wstrb[3:0];
  assign axi_mem_intercon_to_s01_couplers_WUSER = S01_AXI_wuser[0];
  assign axi_mem_intercon_to_s01_couplers_WVALID = S01_AXI_wvalid;
  assign axi_mem_intercon_to_s02_couplers_AWADDR = S02_AXI_awaddr[31:0];
  assign axi_mem_intercon_to_s02_couplers_AWBURST = S02_AXI_awburst[1:0];
  assign axi_mem_intercon_to_s02_couplers_AWCACHE = S02_AXI_awcache[3:0];
  assign axi_mem_intercon_to_s02_couplers_AWID = S02_AXI_awid[2:0];
  assign axi_mem_intercon_to_s02_couplers_AWLEN = S02_AXI_awlen[7:0];
  assign axi_mem_intercon_to_s02_couplers_AWLOCK = S02_AXI_awlock;
  assign axi_mem_intercon_to_s02_couplers_AWPROT = S02_AXI_awprot[2:0];
  assign axi_mem_intercon_to_s02_couplers_AWQOS = S02_AXI_awqos[3:0];
  assign axi_mem_intercon_to_s02_couplers_AWSIZE = S02_AXI_awsize[2:0];
  assign axi_mem_intercon_to_s02_couplers_AWUSER = S02_AXI_awuser[0];
  assign axi_mem_intercon_to_s02_couplers_AWVALID = S02_AXI_awvalid;
  assign axi_mem_intercon_to_s02_couplers_BREADY = S02_AXI_bready;
  assign axi_mem_intercon_to_s02_couplers_WDATA = S02_AXI_wdata[31:0];
  assign axi_mem_intercon_to_s02_couplers_WLAST = S02_AXI_wlast;
  assign axi_mem_intercon_to_s02_couplers_WSTRB = S02_AXI_wstrb[3:0];
  assign axi_mem_intercon_to_s02_couplers_WUSER = S02_AXI_wuser[0];
  assign axi_mem_intercon_to_s02_couplers_WVALID = S02_AXI_wvalid;
  assign axi_mem_intercon_to_s03_couplers_AWADDR = S03_AXI_awaddr[31:0];
  assign axi_mem_intercon_to_s03_couplers_AWBURST = S03_AXI_awburst[1:0];
  assign axi_mem_intercon_to_s03_couplers_AWCACHE = S03_AXI_awcache[3:0];
  assign axi_mem_intercon_to_s03_couplers_AWID = S03_AXI_awid[2:0];
  assign axi_mem_intercon_to_s03_couplers_AWLEN = S03_AXI_awlen[7:0];
  assign axi_mem_intercon_to_s03_couplers_AWLOCK = S03_AXI_awlock;
  assign axi_mem_intercon_to_s03_couplers_AWPROT = S03_AXI_awprot[2:0];
  assign axi_mem_intercon_to_s03_couplers_AWQOS = S03_AXI_awqos[3:0];
  assign axi_mem_intercon_to_s03_couplers_AWSIZE = S03_AXI_awsize[2:0];
  assign axi_mem_intercon_to_s03_couplers_AWUSER = S03_AXI_awuser[0];
  assign axi_mem_intercon_to_s03_couplers_AWVALID = S03_AXI_awvalid;
  assign axi_mem_intercon_to_s03_couplers_BREADY = S03_AXI_bready;
  assign axi_mem_intercon_to_s03_couplers_WDATA = S03_AXI_wdata[31:0];
  assign axi_mem_intercon_to_s03_couplers_WLAST = S03_AXI_wlast;
  assign axi_mem_intercon_to_s03_couplers_WSTRB = S03_AXI_wstrb[3:0];
  assign axi_mem_intercon_to_s03_couplers_WUSER = S03_AXI_wuser[0];
  assign axi_mem_intercon_to_s03_couplers_WVALID = S03_AXI_wvalid;
  assign axi_mem_intercon_to_s04_couplers_AWADDR = S04_AXI_awaddr[31:0];
  assign axi_mem_intercon_to_s04_couplers_AWBURST = S04_AXI_awburst[1:0];
  assign axi_mem_intercon_to_s04_couplers_AWCACHE = S04_AXI_awcache[3:0];
  assign axi_mem_intercon_to_s04_couplers_AWID = S04_AXI_awid[2:0];
  assign axi_mem_intercon_to_s04_couplers_AWLEN = S04_AXI_awlen[7:0];
  assign axi_mem_intercon_to_s04_couplers_AWLOCK = S04_AXI_awlock;
  assign axi_mem_intercon_to_s04_couplers_AWPROT = S04_AXI_awprot[2:0];
  assign axi_mem_intercon_to_s04_couplers_AWQOS = S04_AXI_awqos[3:0];
  assign axi_mem_intercon_to_s04_couplers_AWSIZE = S04_AXI_awsize[2:0];
  assign axi_mem_intercon_to_s04_couplers_AWUSER = S04_AXI_awuser[0];
  assign axi_mem_intercon_to_s04_couplers_AWVALID = S04_AXI_awvalid;
  assign axi_mem_intercon_to_s04_couplers_BREADY = S04_AXI_bready;
  assign axi_mem_intercon_to_s04_couplers_WDATA = S04_AXI_wdata[31:0];
  assign axi_mem_intercon_to_s04_couplers_WLAST = S04_AXI_wlast;
  assign axi_mem_intercon_to_s04_couplers_WSTRB = S04_AXI_wstrb[3:0];
  assign axi_mem_intercon_to_s04_couplers_WUSER = S04_AXI_wuser[0];
  assign axi_mem_intercon_to_s04_couplers_WVALID = S04_AXI_wvalid;
  assign axi_mem_intercon_to_s05_couplers_AWADDR = S05_AXI_awaddr[31:0];
  assign axi_mem_intercon_to_s05_couplers_AWBURST = S05_AXI_awburst[1:0];
  assign axi_mem_intercon_to_s05_couplers_AWCACHE = S05_AXI_awcache[3:0];
  assign axi_mem_intercon_to_s05_couplers_AWID = S05_AXI_awid[2:0];
  assign axi_mem_intercon_to_s05_couplers_AWLEN = S05_AXI_awlen[7:0];
  assign axi_mem_intercon_to_s05_couplers_AWLOCK = S05_AXI_awlock;
  assign axi_mem_intercon_to_s05_couplers_AWPROT = S05_AXI_awprot[2:0];
  assign axi_mem_intercon_to_s05_couplers_AWQOS = S05_AXI_awqos[3:0];
  assign axi_mem_intercon_to_s05_couplers_AWSIZE = S05_AXI_awsize[2:0];
  assign axi_mem_intercon_to_s05_couplers_AWUSER = S05_AXI_awuser[0];
  assign axi_mem_intercon_to_s05_couplers_AWVALID = S05_AXI_awvalid;
  assign axi_mem_intercon_to_s05_couplers_BREADY = S05_AXI_bready;
  assign axi_mem_intercon_to_s05_couplers_WDATA = S05_AXI_wdata[31:0];
  assign axi_mem_intercon_to_s05_couplers_WLAST = S05_AXI_wlast;
  assign axi_mem_intercon_to_s05_couplers_WSTRB = S05_AXI_wstrb[3:0];
  assign axi_mem_intercon_to_s05_couplers_WUSER = S05_AXI_wuser[0];
  assign axi_mem_intercon_to_s05_couplers_WVALID = S05_AXI_wvalid;
  assign axi_mem_intercon_to_s06_couplers_AWADDR = S06_AXI_awaddr[31:0];
  assign axi_mem_intercon_to_s06_couplers_AWBURST = S06_AXI_awburst[1:0];
  assign axi_mem_intercon_to_s06_couplers_AWCACHE = S06_AXI_awcache[3:0];
  assign axi_mem_intercon_to_s06_couplers_AWID = S06_AXI_awid[2:0];
  assign axi_mem_intercon_to_s06_couplers_AWLEN = S06_AXI_awlen[7:0];
  assign axi_mem_intercon_to_s06_couplers_AWLOCK = S06_AXI_awlock;
  assign axi_mem_intercon_to_s06_couplers_AWPROT = S06_AXI_awprot[2:0];
  assign axi_mem_intercon_to_s06_couplers_AWQOS = S06_AXI_awqos[3:0];
  assign axi_mem_intercon_to_s06_couplers_AWSIZE = S06_AXI_awsize[2:0];
  assign axi_mem_intercon_to_s06_couplers_AWUSER = S06_AXI_awuser[0];
  assign axi_mem_intercon_to_s06_couplers_AWVALID = S06_AXI_awvalid;
  assign axi_mem_intercon_to_s06_couplers_BREADY = S06_AXI_bready;
  assign axi_mem_intercon_to_s06_couplers_WDATA = S06_AXI_wdata[31:0];
  assign axi_mem_intercon_to_s06_couplers_WLAST = S06_AXI_wlast;
  assign axi_mem_intercon_to_s06_couplers_WSTRB = S06_AXI_wstrb[3:0];
  assign axi_mem_intercon_to_s06_couplers_WUSER = S06_AXI_wuser[0];
  assign axi_mem_intercon_to_s06_couplers_WVALID = S06_AXI_wvalid;
  assign axi_mem_intercon_to_s07_couplers_AWADDR = S07_AXI_awaddr[31:0];
  assign axi_mem_intercon_to_s07_couplers_AWBURST = S07_AXI_awburst[1:0];
  assign axi_mem_intercon_to_s07_couplers_AWCACHE = S07_AXI_awcache[3:0];
  assign axi_mem_intercon_to_s07_couplers_AWID = S07_AXI_awid[2:0];
  assign axi_mem_intercon_to_s07_couplers_AWLEN = S07_AXI_awlen[7:0];
  assign axi_mem_intercon_to_s07_couplers_AWLOCK = S07_AXI_awlock;
  assign axi_mem_intercon_to_s07_couplers_AWPROT = S07_AXI_awprot[2:0];
  assign axi_mem_intercon_to_s07_couplers_AWQOS = S07_AXI_awqos[3:0];
  assign axi_mem_intercon_to_s07_couplers_AWSIZE = S07_AXI_awsize[2:0];
  assign axi_mem_intercon_to_s07_couplers_AWUSER = S07_AXI_awuser[0];
  assign axi_mem_intercon_to_s07_couplers_AWVALID = S07_AXI_awvalid;
  assign axi_mem_intercon_to_s07_couplers_BREADY = S07_AXI_bready;
  assign axi_mem_intercon_to_s07_couplers_WDATA = S07_AXI_wdata[31:0];
  assign axi_mem_intercon_to_s07_couplers_WLAST = S07_AXI_wlast;
  assign axi_mem_intercon_to_s07_couplers_WSTRB = S07_AXI_wstrb[3:0];
  assign axi_mem_intercon_to_s07_couplers_WUSER = S07_AXI_wuser[0];
  assign axi_mem_intercon_to_s07_couplers_WVALID = S07_AXI_wvalid;
  assign m00_couplers_to_axi_mem_intercon_ARREADY = M00_AXI_arready;
  assign m00_couplers_to_axi_mem_intercon_AWREADY = M00_AXI_awready;
  assign m00_couplers_to_axi_mem_intercon_BID = M00_AXI_bid[5:0];
  assign m00_couplers_to_axi_mem_intercon_BRESP = M00_AXI_bresp[1:0];
  assign m00_couplers_to_axi_mem_intercon_BVALID = M00_AXI_bvalid;
  assign m00_couplers_to_axi_mem_intercon_RDATA = M00_AXI_rdata[31:0];
  assign m00_couplers_to_axi_mem_intercon_RID = M00_AXI_rid[5:0];
  assign m00_couplers_to_axi_mem_intercon_RLAST = M00_AXI_rlast;
  assign m00_couplers_to_axi_mem_intercon_RRESP = M00_AXI_rresp[1:0];
  assign m00_couplers_to_axi_mem_intercon_RVALID = M00_AXI_rvalid;
  assign m00_couplers_to_axi_mem_intercon_WREADY = M00_AXI_wready;
  m00_couplers_imp_1H57HJR m00_couplers
       (.M_ACLK(M00_ACLK_1),
        .M_ARESETN(M00_ARESETN_1),
        .M_AXI_araddr(m00_couplers_to_axi_mem_intercon_ARADDR),
        .M_AXI_arburst(m00_couplers_to_axi_mem_intercon_ARBURST),
        .M_AXI_arcache(m00_couplers_to_axi_mem_intercon_ARCACHE),
        .M_AXI_arid(m00_couplers_to_axi_mem_intercon_ARID),
        .M_AXI_arlen(m00_couplers_to_axi_mem_intercon_ARLEN),
        .M_AXI_arlock(m00_couplers_to_axi_mem_intercon_ARLOCK),
        .M_AXI_arprot(m00_couplers_to_axi_mem_intercon_ARPROT),
        .M_AXI_arqos(m00_couplers_to_axi_mem_intercon_ARQOS),
        .M_AXI_arready(m00_couplers_to_axi_mem_intercon_ARREADY),
        .M_AXI_arsize(m00_couplers_to_axi_mem_intercon_ARSIZE),
        .M_AXI_arvalid(m00_couplers_to_axi_mem_intercon_ARVALID),
        .M_AXI_awaddr(m00_couplers_to_axi_mem_intercon_AWADDR),
        .M_AXI_awburst(m00_couplers_to_axi_mem_intercon_AWBURST),
        .M_AXI_awcache(m00_couplers_to_axi_mem_intercon_AWCACHE),
        .M_AXI_awid(m00_couplers_to_axi_mem_intercon_AWID),
        .M_AXI_awlen(m00_couplers_to_axi_mem_intercon_AWLEN),
        .M_AXI_awlock(m00_couplers_to_axi_mem_intercon_AWLOCK),
        .M_AXI_awprot(m00_couplers_to_axi_mem_intercon_AWPROT),
        .M_AXI_awqos(m00_couplers_to_axi_mem_intercon_AWQOS),
        .M_AXI_awready(m00_couplers_to_axi_mem_intercon_AWREADY),
        .M_AXI_awsize(m00_couplers_to_axi_mem_intercon_AWSIZE),
        .M_AXI_awvalid(m00_couplers_to_axi_mem_intercon_AWVALID),
        .M_AXI_bid(m00_couplers_to_axi_mem_intercon_BID),
        .M_AXI_bready(m00_couplers_to_axi_mem_intercon_BREADY),
        .M_AXI_bresp(m00_couplers_to_axi_mem_intercon_BRESP),
        .M_AXI_bvalid(m00_couplers_to_axi_mem_intercon_BVALID),
        .M_AXI_rdata(m00_couplers_to_axi_mem_intercon_RDATA),
        .M_AXI_rid(m00_couplers_to_axi_mem_intercon_RID),
        .M_AXI_rlast(m00_couplers_to_axi_mem_intercon_RLAST),
        .M_AXI_rready(m00_couplers_to_axi_mem_intercon_RREADY),
        .M_AXI_rresp(m00_couplers_to_axi_mem_intercon_RRESP),
        .M_AXI_rvalid(m00_couplers_to_axi_mem_intercon_RVALID),
        .M_AXI_wdata(m00_couplers_to_axi_mem_intercon_WDATA),
        .M_AXI_wid(m00_couplers_to_axi_mem_intercon_WID),
        .M_AXI_wlast(m00_couplers_to_axi_mem_intercon_WLAST),
        .M_AXI_wready(m00_couplers_to_axi_mem_intercon_WREADY),
        .M_AXI_wstrb(m00_couplers_to_axi_mem_intercon_WSTRB),
        .M_AXI_wvalid(m00_couplers_to_axi_mem_intercon_WVALID),
        .S_ACLK(axi_mem_intercon_ACLK_net),
        .S_ARESETN(axi_mem_intercon_ARESETN_net),
        .S_AXI_araddr(xbar_to_m00_couplers_ARADDR),
        .S_AXI_arburst(xbar_to_m00_couplers_ARBURST),
        .S_AXI_arcache(xbar_to_m00_couplers_ARCACHE),
        .S_AXI_arid(xbar_to_m00_couplers_ARID),
        .S_AXI_arlen(xbar_to_m00_couplers_ARLEN),
        .S_AXI_arlock(xbar_to_m00_couplers_ARLOCK),
        .S_AXI_arprot(xbar_to_m00_couplers_ARPROT),
        .S_AXI_arqos(xbar_to_m00_couplers_ARQOS),
        .S_AXI_arready(xbar_to_m00_couplers_ARREADY),
        .S_AXI_arregion(xbar_to_m00_couplers_ARREGION),
        .S_AXI_arsize(xbar_to_m00_couplers_ARSIZE),
        .S_AXI_arvalid(xbar_to_m00_couplers_ARVALID),
        .S_AXI_awaddr(xbar_to_m00_couplers_AWADDR),
        .S_AXI_awburst(xbar_to_m00_couplers_AWBURST),
        .S_AXI_awcache(xbar_to_m00_couplers_AWCACHE),
        .S_AXI_awid(xbar_to_m00_couplers_AWID),
        .S_AXI_awlen(xbar_to_m00_couplers_AWLEN),
        .S_AXI_awlock(xbar_to_m00_couplers_AWLOCK),
        .S_AXI_awprot(xbar_to_m00_couplers_AWPROT),
        .S_AXI_awqos(xbar_to_m00_couplers_AWQOS),
        .S_AXI_awready(xbar_to_m00_couplers_AWREADY),
        .S_AXI_awregion(xbar_to_m00_couplers_AWREGION),
        .S_AXI_awsize(xbar_to_m00_couplers_AWSIZE),
        .S_AXI_awuser(xbar_to_m00_couplers_AWUSER),
        .S_AXI_awvalid(xbar_to_m00_couplers_AWVALID),
        .S_AXI_bid(xbar_to_m00_couplers_BID),
        .S_AXI_bready(xbar_to_m00_couplers_BREADY),
        .S_AXI_bresp(xbar_to_m00_couplers_BRESP),
        .S_AXI_bvalid(xbar_to_m00_couplers_BVALID),
        .S_AXI_rdata(xbar_to_m00_couplers_RDATA),
        .S_AXI_rid(xbar_to_m00_couplers_RID),
        .S_AXI_rlast(xbar_to_m00_couplers_RLAST),
        .S_AXI_rready(xbar_to_m00_couplers_RREADY),
        .S_AXI_rresp(xbar_to_m00_couplers_RRESP),
        .S_AXI_rvalid(xbar_to_m00_couplers_RVALID),
        .S_AXI_wdata(xbar_to_m00_couplers_WDATA),
        .S_AXI_wlast(xbar_to_m00_couplers_WLAST),
        .S_AXI_wready(xbar_to_m00_couplers_WREADY),
        .S_AXI_wstrb(xbar_to_m00_couplers_WSTRB),
        .S_AXI_wuser(xbar_to_m00_couplers_WUSER),
        .S_AXI_wvalid(xbar_to_m00_couplers_WVALID));
  s00_couplers_imp_11QQSXY s00_couplers
       (.M_ACLK(axi_mem_intercon_ACLK_net),
        .M_ARESETN(axi_mem_intercon_ARESETN_net),
        .M_AXI_awaddr(s00_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s00_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s00_couplers_to_xbar_AWCACHE),
        .M_AXI_awid(s00_couplers_to_xbar_AWID),
        .M_AXI_awlen(s00_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s00_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s00_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s00_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s00_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s00_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s00_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s00_couplers_to_xbar_AWVALID),
        .M_AXI_bid(s00_couplers_to_xbar_BID),
        .M_AXI_bready(s00_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s00_couplers_to_xbar_BRESP),
        .M_AXI_buser(s00_couplers_to_xbar_BUSER),
        .M_AXI_bvalid(s00_couplers_to_xbar_BVALID),
        .M_AXI_wdata(s00_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s00_couplers_to_xbar_WLAST),
        .M_AXI_wready(s00_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s00_couplers_to_xbar_WSTRB),
        .M_AXI_wuser(s00_couplers_to_xbar_WUSER),
        .M_AXI_wvalid(s00_couplers_to_xbar_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_awaddr(axi_mem_intercon_to_s00_couplers_AWADDR),
        .S_AXI_awburst(axi_mem_intercon_to_s00_couplers_AWBURST),
        .S_AXI_awcache(axi_mem_intercon_to_s00_couplers_AWCACHE),
        .S_AXI_awid(axi_mem_intercon_to_s00_couplers_AWID),
        .S_AXI_awlen(axi_mem_intercon_to_s00_couplers_AWLEN),
        .S_AXI_awlock(axi_mem_intercon_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(axi_mem_intercon_to_s00_couplers_AWPROT),
        .S_AXI_awqos(axi_mem_intercon_to_s00_couplers_AWQOS),
        .S_AXI_awready(axi_mem_intercon_to_s00_couplers_AWREADY),
        .S_AXI_awsize(axi_mem_intercon_to_s00_couplers_AWSIZE),
        .S_AXI_awuser(axi_mem_intercon_to_s00_couplers_AWUSER),
        .S_AXI_awvalid(axi_mem_intercon_to_s00_couplers_AWVALID),
        .S_AXI_bid(axi_mem_intercon_to_s00_couplers_BID),
        .S_AXI_bready(axi_mem_intercon_to_s00_couplers_BREADY),
        .S_AXI_bresp(axi_mem_intercon_to_s00_couplers_BRESP),
        .S_AXI_buser(axi_mem_intercon_to_s00_couplers_BUSER),
        .S_AXI_bvalid(axi_mem_intercon_to_s00_couplers_BVALID),
        .S_AXI_wdata(axi_mem_intercon_to_s00_couplers_WDATA),
        .S_AXI_wlast(axi_mem_intercon_to_s00_couplers_WLAST),
        .S_AXI_wready(axi_mem_intercon_to_s00_couplers_WREADY),
        .S_AXI_wstrb(axi_mem_intercon_to_s00_couplers_WSTRB),
        .S_AXI_wuser(axi_mem_intercon_to_s00_couplers_WUSER),
        .S_AXI_wvalid(axi_mem_intercon_to_s00_couplers_WVALID));
  s01_couplers_imp_ANXGUV s01_couplers
       (.M_ACLK(axi_mem_intercon_ACLK_net),
        .M_ARESETN(axi_mem_intercon_ARESETN_net),
        .M_AXI_awaddr(s01_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s01_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s01_couplers_to_xbar_AWCACHE),
        .M_AXI_awid(s01_couplers_to_xbar_AWID),
        .M_AXI_awlen(s01_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s01_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s01_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s01_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s01_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s01_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s01_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s01_couplers_to_xbar_AWVALID),
        .M_AXI_bid(s01_couplers_to_xbar_BID),
        .M_AXI_bready(s01_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s01_couplers_to_xbar_BRESP),
        .M_AXI_buser(s01_couplers_to_xbar_BUSER),
        .M_AXI_bvalid(s01_couplers_to_xbar_BVALID),
        .M_AXI_wdata(s01_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s01_couplers_to_xbar_WLAST),
        .M_AXI_wready(s01_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s01_couplers_to_xbar_WSTRB),
        .M_AXI_wuser(s01_couplers_to_xbar_WUSER),
        .M_AXI_wvalid(s01_couplers_to_xbar_WVALID),
        .S_ACLK(S01_ACLK_1),
        .S_ARESETN(S01_ARESETN_1),
        .S_AXI_awaddr(axi_mem_intercon_to_s01_couplers_AWADDR),
        .S_AXI_awburst(axi_mem_intercon_to_s01_couplers_AWBURST),
        .S_AXI_awcache(axi_mem_intercon_to_s01_couplers_AWCACHE),
        .S_AXI_awid(axi_mem_intercon_to_s01_couplers_AWID),
        .S_AXI_awlen(axi_mem_intercon_to_s01_couplers_AWLEN),
        .S_AXI_awlock(axi_mem_intercon_to_s01_couplers_AWLOCK),
        .S_AXI_awprot(axi_mem_intercon_to_s01_couplers_AWPROT),
        .S_AXI_awqos(axi_mem_intercon_to_s01_couplers_AWQOS),
        .S_AXI_awready(axi_mem_intercon_to_s01_couplers_AWREADY),
        .S_AXI_awsize(axi_mem_intercon_to_s01_couplers_AWSIZE),
        .S_AXI_awuser(axi_mem_intercon_to_s01_couplers_AWUSER),
        .S_AXI_awvalid(axi_mem_intercon_to_s01_couplers_AWVALID),
        .S_AXI_bid(axi_mem_intercon_to_s01_couplers_BID),
        .S_AXI_bready(axi_mem_intercon_to_s01_couplers_BREADY),
        .S_AXI_bresp(axi_mem_intercon_to_s01_couplers_BRESP),
        .S_AXI_buser(axi_mem_intercon_to_s01_couplers_BUSER),
        .S_AXI_bvalid(axi_mem_intercon_to_s01_couplers_BVALID),
        .S_AXI_wdata(axi_mem_intercon_to_s01_couplers_WDATA),
        .S_AXI_wlast(axi_mem_intercon_to_s01_couplers_WLAST),
        .S_AXI_wready(axi_mem_intercon_to_s01_couplers_WREADY),
        .S_AXI_wstrb(axi_mem_intercon_to_s01_couplers_WSTRB),
        .S_AXI_wuser(axi_mem_intercon_to_s01_couplers_WUSER),
        .S_AXI_wvalid(axi_mem_intercon_to_s01_couplers_WVALID));
  s02_couplers_imp_4CCIUD s02_couplers
       (.M_ACLK(axi_mem_intercon_ACLK_net),
        .M_ARESETN(axi_mem_intercon_ARESETN_net),
        .M_AXI_awaddr(s02_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s02_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s02_couplers_to_xbar_AWCACHE),
        .M_AXI_awid(s02_couplers_to_xbar_AWID),
        .M_AXI_awlen(s02_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s02_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s02_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s02_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s02_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s02_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s02_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s02_couplers_to_xbar_AWVALID),
        .M_AXI_bid(s02_couplers_to_xbar_BID),
        .M_AXI_bready(s02_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s02_couplers_to_xbar_BRESP),
        .M_AXI_buser(s02_couplers_to_xbar_BUSER),
        .M_AXI_bvalid(s02_couplers_to_xbar_BVALID),
        .M_AXI_wdata(s02_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s02_couplers_to_xbar_WLAST),
        .M_AXI_wready(s02_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s02_couplers_to_xbar_WSTRB),
        .M_AXI_wuser(s02_couplers_to_xbar_WUSER),
        .M_AXI_wvalid(s02_couplers_to_xbar_WVALID),
        .S_ACLK(S02_ACLK_1),
        .S_ARESETN(S02_ARESETN_1),
        .S_AXI_awaddr(axi_mem_intercon_to_s02_couplers_AWADDR),
        .S_AXI_awburst(axi_mem_intercon_to_s02_couplers_AWBURST),
        .S_AXI_awcache(axi_mem_intercon_to_s02_couplers_AWCACHE),
        .S_AXI_awid(axi_mem_intercon_to_s02_couplers_AWID),
        .S_AXI_awlen(axi_mem_intercon_to_s02_couplers_AWLEN),
        .S_AXI_awlock(axi_mem_intercon_to_s02_couplers_AWLOCK),
        .S_AXI_awprot(axi_mem_intercon_to_s02_couplers_AWPROT),
        .S_AXI_awqos(axi_mem_intercon_to_s02_couplers_AWQOS),
        .S_AXI_awready(axi_mem_intercon_to_s02_couplers_AWREADY),
        .S_AXI_awsize(axi_mem_intercon_to_s02_couplers_AWSIZE),
        .S_AXI_awuser(axi_mem_intercon_to_s02_couplers_AWUSER),
        .S_AXI_awvalid(axi_mem_intercon_to_s02_couplers_AWVALID),
        .S_AXI_bid(axi_mem_intercon_to_s02_couplers_BID),
        .S_AXI_bready(axi_mem_intercon_to_s02_couplers_BREADY),
        .S_AXI_bresp(axi_mem_intercon_to_s02_couplers_BRESP),
        .S_AXI_buser(axi_mem_intercon_to_s02_couplers_BUSER),
        .S_AXI_bvalid(axi_mem_intercon_to_s02_couplers_BVALID),
        .S_AXI_wdata(axi_mem_intercon_to_s02_couplers_WDATA),
        .S_AXI_wlast(axi_mem_intercon_to_s02_couplers_WLAST),
        .S_AXI_wready(axi_mem_intercon_to_s02_couplers_WREADY),
        .S_AXI_wstrb(axi_mem_intercon_to_s02_couplers_WSTRB),
        .S_AXI_wuser(axi_mem_intercon_to_s02_couplers_WUSER),
        .S_AXI_wvalid(axi_mem_intercon_to_s02_couplers_WVALID));
  s03_couplers_imp_18WA86S s03_couplers
       (.M_ACLK(axi_mem_intercon_ACLK_net),
        .M_ARESETN(axi_mem_intercon_ARESETN_net),
        .M_AXI_awaddr(s03_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s03_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s03_couplers_to_xbar_AWCACHE),
        .M_AXI_awid(s03_couplers_to_xbar_AWID),
        .M_AXI_awlen(s03_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s03_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s03_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s03_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s03_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s03_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s03_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s03_couplers_to_xbar_AWVALID),
        .M_AXI_bid(s03_couplers_to_xbar_BID),
        .M_AXI_bready(s03_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s03_couplers_to_xbar_BRESP),
        .M_AXI_buser(s03_couplers_to_xbar_BUSER),
        .M_AXI_bvalid(s03_couplers_to_xbar_BVALID),
        .M_AXI_wdata(s03_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s03_couplers_to_xbar_WLAST),
        .M_AXI_wready(s03_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s03_couplers_to_xbar_WSTRB),
        .M_AXI_wuser(s03_couplers_to_xbar_WUSER),
        .M_AXI_wvalid(s03_couplers_to_xbar_WVALID),
        .S_ACLK(S03_ACLK_1),
        .S_ARESETN(S03_ARESETN_1),
        .S_AXI_awaddr(axi_mem_intercon_to_s03_couplers_AWADDR),
        .S_AXI_awburst(axi_mem_intercon_to_s03_couplers_AWBURST),
        .S_AXI_awcache(axi_mem_intercon_to_s03_couplers_AWCACHE),
        .S_AXI_awid(axi_mem_intercon_to_s03_couplers_AWID),
        .S_AXI_awlen(axi_mem_intercon_to_s03_couplers_AWLEN),
        .S_AXI_awlock(axi_mem_intercon_to_s03_couplers_AWLOCK),
        .S_AXI_awprot(axi_mem_intercon_to_s03_couplers_AWPROT),
        .S_AXI_awqos(axi_mem_intercon_to_s03_couplers_AWQOS),
        .S_AXI_awready(axi_mem_intercon_to_s03_couplers_AWREADY),
        .S_AXI_awsize(axi_mem_intercon_to_s03_couplers_AWSIZE),
        .S_AXI_awuser(axi_mem_intercon_to_s03_couplers_AWUSER),
        .S_AXI_awvalid(axi_mem_intercon_to_s03_couplers_AWVALID),
        .S_AXI_bid(axi_mem_intercon_to_s03_couplers_BID),
        .S_AXI_bready(axi_mem_intercon_to_s03_couplers_BREADY),
        .S_AXI_bresp(axi_mem_intercon_to_s03_couplers_BRESP),
        .S_AXI_buser(axi_mem_intercon_to_s03_couplers_BUSER),
        .S_AXI_bvalid(axi_mem_intercon_to_s03_couplers_BVALID),
        .S_AXI_wdata(axi_mem_intercon_to_s03_couplers_WDATA),
        .S_AXI_wlast(axi_mem_intercon_to_s03_couplers_WLAST),
        .S_AXI_wready(axi_mem_intercon_to_s03_couplers_WREADY),
        .S_AXI_wstrb(axi_mem_intercon_to_s03_couplers_WSTRB),
        .S_AXI_wuser(axi_mem_intercon_to_s03_couplers_WUSER),
        .S_AXI_wvalid(axi_mem_intercon_to_s03_couplers_WVALID));
  s04_couplers_imp_PL33WH s04_couplers
       (.M_ACLK(axi_mem_intercon_ACLK_net),
        .M_ARESETN(axi_mem_intercon_ARESETN_net),
        .M_AXI_awaddr(s04_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s04_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s04_couplers_to_xbar_AWCACHE),
        .M_AXI_awid(s04_couplers_to_xbar_AWID),
        .M_AXI_awlen(s04_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s04_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s04_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s04_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s04_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s04_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s04_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s04_couplers_to_xbar_AWVALID),
        .M_AXI_bid(s04_couplers_to_xbar_BID),
        .M_AXI_bready(s04_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s04_couplers_to_xbar_BRESP),
        .M_AXI_buser(s04_couplers_to_xbar_BUSER),
        .M_AXI_bvalid(s04_couplers_to_xbar_BVALID),
        .M_AXI_wdata(s04_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s04_couplers_to_xbar_WLAST),
        .M_AXI_wready(s04_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s04_couplers_to_xbar_WSTRB),
        .M_AXI_wuser(s04_couplers_to_xbar_WUSER),
        .M_AXI_wvalid(s04_couplers_to_xbar_WVALID),
        .S_ACLK(S04_ACLK_1),
        .S_ARESETN(S04_ARESETN_1),
        .S_AXI_awaddr(axi_mem_intercon_to_s04_couplers_AWADDR),
        .S_AXI_awburst(axi_mem_intercon_to_s04_couplers_AWBURST),
        .S_AXI_awcache(axi_mem_intercon_to_s04_couplers_AWCACHE),
        .S_AXI_awid(axi_mem_intercon_to_s04_couplers_AWID),
        .S_AXI_awlen(axi_mem_intercon_to_s04_couplers_AWLEN),
        .S_AXI_awlock(axi_mem_intercon_to_s04_couplers_AWLOCK),
        .S_AXI_awprot(axi_mem_intercon_to_s04_couplers_AWPROT),
        .S_AXI_awqos(axi_mem_intercon_to_s04_couplers_AWQOS),
        .S_AXI_awready(axi_mem_intercon_to_s04_couplers_AWREADY),
        .S_AXI_awsize(axi_mem_intercon_to_s04_couplers_AWSIZE),
        .S_AXI_awuser(axi_mem_intercon_to_s04_couplers_AWUSER),
        .S_AXI_awvalid(axi_mem_intercon_to_s04_couplers_AWVALID),
        .S_AXI_bid(axi_mem_intercon_to_s04_couplers_BID),
        .S_AXI_bready(axi_mem_intercon_to_s04_couplers_BREADY),
        .S_AXI_bresp(axi_mem_intercon_to_s04_couplers_BRESP),
        .S_AXI_buser(axi_mem_intercon_to_s04_couplers_BUSER),
        .S_AXI_bvalid(axi_mem_intercon_to_s04_couplers_BVALID),
        .S_AXI_wdata(axi_mem_intercon_to_s04_couplers_WDATA),
        .S_AXI_wlast(axi_mem_intercon_to_s04_couplers_WLAST),
        .S_AXI_wready(axi_mem_intercon_to_s04_couplers_WREADY),
        .S_AXI_wstrb(axi_mem_intercon_to_s04_couplers_WSTRB),
        .S_AXI_wuser(axi_mem_intercon_to_s04_couplers_WUSER),
        .S_AXI_wvalid(axi_mem_intercon_to_s04_couplers_WVALID));
  s05_couplers_imp_1V8Z66O s05_couplers
       (.M_ACLK(axi_mem_intercon_ACLK_net),
        .M_ARESETN(axi_mem_intercon_ARESETN_net),
        .M_AXI_awaddr(s05_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s05_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s05_couplers_to_xbar_AWCACHE),
        .M_AXI_awid(s05_couplers_to_xbar_AWID),
        .M_AXI_awlen(s05_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s05_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s05_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s05_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s05_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s05_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s05_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s05_couplers_to_xbar_AWVALID),
        .M_AXI_bid(s05_couplers_to_xbar_BID),
        .M_AXI_bready(s05_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s05_couplers_to_xbar_BRESP),
        .M_AXI_buser(s05_couplers_to_xbar_BUSER),
        .M_AXI_bvalid(s05_couplers_to_xbar_BVALID),
        .M_AXI_wdata(s05_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s05_couplers_to_xbar_WLAST),
        .M_AXI_wready(s05_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s05_couplers_to_xbar_WSTRB),
        .M_AXI_wuser(s05_couplers_to_xbar_WUSER),
        .M_AXI_wvalid(s05_couplers_to_xbar_WVALID),
        .S_ACLK(S05_ACLK_1),
        .S_ARESETN(S05_ARESETN_1),
        .S_AXI_awaddr(axi_mem_intercon_to_s05_couplers_AWADDR),
        .S_AXI_awburst(axi_mem_intercon_to_s05_couplers_AWBURST),
        .S_AXI_awcache(axi_mem_intercon_to_s05_couplers_AWCACHE),
        .S_AXI_awid(axi_mem_intercon_to_s05_couplers_AWID),
        .S_AXI_awlen(axi_mem_intercon_to_s05_couplers_AWLEN),
        .S_AXI_awlock(axi_mem_intercon_to_s05_couplers_AWLOCK),
        .S_AXI_awprot(axi_mem_intercon_to_s05_couplers_AWPROT),
        .S_AXI_awqos(axi_mem_intercon_to_s05_couplers_AWQOS),
        .S_AXI_awready(axi_mem_intercon_to_s05_couplers_AWREADY),
        .S_AXI_awsize(axi_mem_intercon_to_s05_couplers_AWSIZE),
        .S_AXI_awuser(axi_mem_intercon_to_s05_couplers_AWUSER),
        .S_AXI_awvalid(axi_mem_intercon_to_s05_couplers_AWVALID),
        .S_AXI_bid(axi_mem_intercon_to_s05_couplers_BID),
        .S_AXI_bready(axi_mem_intercon_to_s05_couplers_BREADY),
        .S_AXI_bresp(axi_mem_intercon_to_s05_couplers_BRESP),
        .S_AXI_buser(axi_mem_intercon_to_s05_couplers_BUSER),
        .S_AXI_bvalid(axi_mem_intercon_to_s05_couplers_BVALID),
        .S_AXI_wdata(axi_mem_intercon_to_s05_couplers_WDATA),
        .S_AXI_wlast(axi_mem_intercon_to_s05_couplers_WLAST),
        .S_AXI_wready(axi_mem_intercon_to_s05_couplers_WREADY),
        .S_AXI_wstrb(axi_mem_intercon_to_s05_couplers_WSTRB),
        .S_AXI_wuser(axi_mem_intercon_to_s05_couplers_WUSER),
        .S_AXI_wvalid(axi_mem_intercon_to_s05_couplers_WVALID));
  s06_couplers_imp_1OXE6SI s06_couplers
       (.M_ACLK(axi_mem_intercon_ACLK_net),
        .M_ARESETN(axi_mem_intercon_ARESETN_net),
        .M_AXI_awaddr(s06_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s06_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s06_couplers_to_xbar_AWCACHE),
        .M_AXI_awid(s06_couplers_to_xbar_AWID),
        .M_AXI_awlen(s06_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s06_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s06_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s06_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s06_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s06_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s06_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s06_couplers_to_xbar_AWVALID),
        .M_AXI_bid(s06_couplers_to_xbar_BID),
        .M_AXI_bready(s06_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s06_couplers_to_xbar_BRESP),
        .M_AXI_buser(s06_couplers_to_xbar_BUSER),
        .M_AXI_bvalid(s06_couplers_to_xbar_BVALID),
        .M_AXI_wdata(s06_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s06_couplers_to_xbar_WLAST),
        .M_AXI_wready(s06_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s06_couplers_to_xbar_WSTRB),
        .M_AXI_wuser(s06_couplers_to_xbar_WUSER),
        .M_AXI_wvalid(s06_couplers_to_xbar_WVALID),
        .S_ACLK(S06_ACLK_1),
        .S_ARESETN(S06_ARESETN_1),
        .S_AXI_awaddr(axi_mem_intercon_to_s06_couplers_AWADDR),
        .S_AXI_awburst(axi_mem_intercon_to_s06_couplers_AWBURST),
        .S_AXI_awcache(axi_mem_intercon_to_s06_couplers_AWCACHE),
        .S_AXI_awid(axi_mem_intercon_to_s06_couplers_AWID),
        .S_AXI_awlen(axi_mem_intercon_to_s06_couplers_AWLEN),
        .S_AXI_awlock(axi_mem_intercon_to_s06_couplers_AWLOCK),
        .S_AXI_awprot(axi_mem_intercon_to_s06_couplers_AWPROT),
        .S_AXI_awqos(axi_mem_intercon_to_s06_couplers_AWQOS),
        .S_AXI_awready(axi_mem_intercon_to_s06_couplers_AWREADY),
        .S_AXI_awsize(axi_mem_intercon_to_s06_couplers_AWSIZE),
        .S_AXI_awuser(axi_mem_intercon_to_s06_couplers_AWUSER),
        .S_AXI_awvalid(axi_mem_intercon_to_s06_couplers_AWVALID),
        .S_AXI_bid(axi_mem_intercon_to_s06_couplers_BID),
        .S_AXI_bready(axi_mem_intercon_to_s06_couplers_BREADY),
        .S_AXI_bresp(axi_mem_intercon_to_s06_couplers_BRESP),
        .S_AXI_buser(axi_mem_intercon_to_s06_couplers_BUSER),
        .S_AXI_bvalid(axi_mem_intercon_to_s06_couplers_BVALID),
        .S_AXI_wdata(axi_mem_intercon_to_s06_couplers_WDATA),
        .S_AXI_wlast(axi_mem_intercon_to_s06_couplers_WLAST),
        .S_AXI_wready(axi_mem_intercon_to_s06_couplers_WREADY),
        .S_AXI_wstrb(axi_mem_intercon_to_s06_couplers_WSTRB),
        .S_AXI_wuser(axi_mem_intercon_to_s06_couplers_WUSER),
        .S_AXI_wvalid(axi_mem_intercon_to_s06_couplers_WVALID));
  s07_couplers_imp_WQMHDF s07_couplers
       (.M_ACLK(axi_mem_intercon_ACLK_net),
        .M_ARESETN(axi_mem_intercon_ARESETN_net),
        .M_AXI_awaddr(s07_couplers_to_xbar_AWADDR),
        .M_AXI_awburst(s07_couplers_to_xbar_AWBURST),
        .M_AXI_awcache(s07_couplers_to_xbar_AWCACHE),
        .M_AXI_awid(s07_couplers_to_xbar_AWID),
        .M_AXI_awlen(s07_couplers_to_xbar_AWLEN),
        .M_AXI_awlock(s07_couplers_to_xbar_AWLOCK),
        .M_AXI_awprot(s07_couplers_to_xbar_AWPROT),
        .M_AXI_awqos(s07_couplers_to_xbar_AWQOS),
        .M_AXI_awready(s07_couplers_to_xbar_AWREADY),
        .M_AXI_awsize(s07_couplers_to_xbar_AWSIZE),
        .M_AXI_awuser(s07_couplers_to_xbar_AWUSER),
        .M_AXI_awvalid(s07_couplers_to_xbar_AWVALID),
        .M_AXI_bid(s07_couplers_to_xbar_BID),
        .M_AXI_bready(s07_couplers_to_xbar_BREADY),
        .M_AXI_bresp(s07_couplers_to_xbar_BRESP),
        .M_AXI_buser(s07_couplers_to_xbar_BUSER),
        .M_AXI_bvalid(s07_couplers_to_xbar_BVALID),
        .M_AXI_wdata(s07_couplers_to_xbar_WDATA),
        .M_AXI_wlast(s07_couplers_to_xbar_WLAST),
        .M_AXI_wready(s07_couplers_to_xbar_WREADY),
        .M_AXI_wstrb(s07_couplers_to_xbar_WSTRB),
        .M_AXI_wuser(s07_couplers_to_xbar_WUSER),
        .M_AXI_wvalid(s07_couplers_to_xbar_WVALID),
        .S_ACLK(S07_ACLK_1),
        .S_ARESETN(S07_ARESETN_1),
        .S_AXI_awaddr(axi_mem_intercon_to_s07_couplers_AWADDR),
        .S_AXI_awburst(axi_mem_intercon_to_s07_couplers_AWBURST),
        .S_AXI_awcache(axi_mem_intercon_to_s07_couplers_AWCACHE),
        .S_AXI_awid(axi_mem_intercon_to_s07_couplers_AWID),
        .S_AXI_awlen(axi_mem_intercon_to_s07_couplers_AWLEN),
        .S_AXI_awlock(axi_mem_intercon_to_s07_couplers_AWLOCK),
        .S_AXI_awprot(axi_mem_intercon_to_s07_couplers_AWPROT),
        .S_AXI_awqos(axi_mem_intercon_to_s07_couplers_AWQOS),
        .S_AXI_awready(axi_mem_intercon_to_s07_couplers_AWREADY),
        .S_AXI_awsize(axi_mem_intercon_to_s07_couplers_AWSIZE),
        .S_AXI_awuser(axi_mem_intercon_to_s07_couplers_AWUSER),
        .S_AXI_awvalid(axi_mem_intercon_to_s07_couplers_AWVALID),
        .S_AXI_bid(axi_mem_intercon_to_s07_couplers_BID),
        .S_AXI_bready(axi_mem_intercon_to_s07_couplers_BREADY),
        .S_AXI_bresp(axi_mem_intercon_to_s07_couplers_BRESP),
        .S_AXI_buser(axi_mem_intercon_to_s07_couplers_BUSER),
        .S_AXI_bvalid(axi_mem_intercon_to_s07_couplers_BVALID),
        .S_AXI_wdata(axi_mem_intercon_to_s07_couplers_WDATA),
        .S_AXI_wlast(axi_mem_intercon_to_s07_couplers_WLAST),
        .S_AXI_wready(axi_mem_intercon_to_s07_couplers_WREADY),
        .S_AXI_wstrb(axi_mem_intercon_to_s07_couplers_WSTRB),
        .S_AXI_wuser(axi_mem_intercon_to_s07_couplers_WUSER),
        .S_AXI_wvalid(axi_mem_intercon_to_s07_couplers_WVALID));
  system_xbar_0 xbar
       (.aclk(axi_mem_intercon_ACLK_net),
        .aresetn(axi_mem_intercon_ARESETN_net),
        .m_axi_araddr(xbar_to_m00_couplers_ARADDR),
        .m_axi_arburst(xbar_to_m00_couplers_ARBURST),
        .m_axi_arcache(xbar_to_m00_couplers_ARCACHE),
        .m_axi_arid(xbar_to_m00_couplers_ARID),
        .m_axi_arlen(xbar_to_m00_couplers_ARLEN),
        .m_axi_arlock(xbar_to_m00_couplers_ARLOCK),
        .m_axi_arprot(xbar_to_m00_couplers_ARPROT),
        .m_axi_arqos(xbar_to_m00_couplers_ARQOS),
        .m_axi_arready(xbar_to_m00_couplers_ARREADY),
        .m_axi_arregion(xbar_to_m00_couplers_ARREGION),
        .m_axi_arsize(xbar_to_m00_couplers_ARSIZE),
        .m_axi_arvalid(xbar_to_m00_couplers_ARVALID),
        .m_axi_awaddr(xbar_to_m00_couplers_AWADDR),
        .m_axi_awburst(xbar_to_m00_couplers_AWBURST),
        .m_axi_awcache(xbar_to_m00_couplers_AWCACHE),
        .m_axi_awid(xbar_to_m00_couplers_AWID),
        .m_axi_awlen(xbar_to_m00_couplers_AWLEN),
        .m_axi_awlock(xbar_to_m00_couplers_AWLOCK),
        .m_axi_awprot(xbar_to_m00_couplers_AWPROT),
        .m_axi_awqos(xbar_to_m00_couplers_AWQOS),
        .m_axi_awready(xbar_to_m00_couplers_AWREADY),
        .m_axi_awregion(xbar_to_m00_couplers_AWREGION),
        .m_axi_awsize(xbar_to_m00_couplers_AWSIZE),
        .m_axi_awuser(xbar_to_m00_couplers_AWUSER),
        .m_axi_awvalid(xbar_to_m00_couplers_AWVALID),
        .m_axi_bid(xbar_to_m00_couplers_BID),
        .m_axi_bready(xbar_to_m00_couplers_BREADY),
        .m_axi_bresp(xbar_to_m00_couplers_BRESP),
        .m_axi_buser(1'b0),
        .m_axi_bvalid(xbar_to_m00_couplers_BVALID),
        .m_axi_rdata(xbar_to_m00_couplers_RDATA),
        .m_axi_rid(xbar_to_m00_couplers_RID),
        .m_axi_rlast(xbar_to_m00_couplers_RLAST),
        .m_axi_rready(xbar_to_m00_couplers_RREADY),
        .m_axi_rresp(xbar_to_m00_couplers_RRESP),
        .m_axi_rvalid(xbar_to_m00_couplers_RVALID),
        .m_axi_wdata(xbar_to_m00_couplers_WDATA),
        .m_axi_wlast(xbar_to_m00_couplers_WLAST),
        .m_axi_wready(xbar_to_m00_couplers_WREADY),
        .m_axi_wstrb(xbar_to_m00_couplers_WSTRB),
        .m_axi_wuser(xbar_to_m00_couplers_WUSER),
        .m_axi_wvalid(xbar_to_m00_couplers_WVALID),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arcache({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlock({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arprot({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arqos({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arsize({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arvalid({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awaddr({s07_couplers_to_xbar_AWADDR,s06_couplers_to_xbar_AWADDR,s05_couplers_to_xbar_AWADDR,s04_couplers_to_xbar_AWADDR,s03_couplers_to_xbar_AWADDR,s02_couplers_to_xbar_AWADDR,s01_couplers_to_xbar_AWADDR,s00_couplers_to_xbar_AWADDR}),
        .s_axi_awburst({s07_couplers_to_xbar_AWBURST,s06_couplers_to_xbar_AWBURST,s05_couplers_to_xbar_AWBURST,s04_couplers_to_xbar_AWBURST,s03_couplers_to_xbar_AWBURST,s02_couplers_to_xbar_AWBURST,s01_couplers_to_xbar_AWBURST,s00_couplers_to_xbar_AWBURST}),
        .s_axi_awcache({s07_couplers_to_xbar_AWCACHE,s06_couplers_to_xbar_AWCACHE,s05_couplers_to_xbar_AWCACHE,s04_couplers_to_xbar_AWCACHE,s03_couplers_to_xbar_AWCACHE,s02_couplers_to_xbar_AWCACHE,s01_couplers_to_xbar_AWCACHE,s00_couplers_to_xbar_AWCACHE}),
        .s_axi_awid({1'b0,1'b0,1'b0,s07_couplers_to_xbar_AWID,1'b0,1'b0,1'b0,s06_couplers_to_xbar_AWID,1'b0,1'b0,1'b0,s05_couplers_to_xbar_AWID,1'b0,1'b0,1'b0,s04_couplers_to_xbar_AWID,1'b0,1'b0,1'b0,s03_couplers_to_xbar_AWID,1'b0,1'b0,1'b0,s02_couplers_to_xbar_AWID,1'b0,1'b0,1'b0,s01_couplers_to_xbar_AWID,1'b0,1'b0,1'b0,s00_couplers_to_xbar_AWID}),
        .s_axi_awlen({s07_couplers_to_xbar_AWLEN,s06_couplers_to_xbar_AWLEN,s05_couplers_to_xbar_AWLEN,s04_couplers_to_xbar_AWLEN,s03_couplers_to_xbar_AWLEN,s02_couplers_to_xbar_AWLEN,s01_couplers_to_xbar_AWLEN,s00_couplers_to_xbar_AWLEN}),
        .s_axi_awlock({s07_couplers_to_xbar_AWLOCK,s06_couplers_to_xbar_AWLOCK,s05_couplers_to_xbar_AWLOCK,s04_couplers_to_xbar_AWLOCK,s03_couplers_to_xbar_AWLOCK,s02_couplers_to_xbar_AWLOCK,s01_couplers_to_xbar_AWLOCK,s00_couplers_to_xbar_AWLOCK}),
        .s_axi_awprot({s07_couplers_to_xbar_AWPROT,s06_couplers_to_xbar_AWPROT,s05_couplers_to_xbar_AWPROT,s04_couplers_to_xbar_AWPROT,s03_couplers_to_xbar_AWPROT,s02_couplers_to_xbar_AWPROT,s01_couplers_to_xbar_AWPROT,s00_couplers_to_xbar_AWPROT}),
        .s_axi_awqos({s07_couplers_to_xbar_AWQOS,s06_couplers_to_xbar_AWQOS,s05_couplers_to_xbar_AWQOS,s04_couplers_to_xbar_AWQOS,s03_couplers_to_xbar_AWQOS,s02_couplers_to_xbar_AWQOS,s01_couplers_to_xbar_AWQOS,s00_couplers_to_xbar_AWQOS}),
        .s_axi_awready({s07_couplers_to_xbar_AWREADY,s06_couplers_to_xbar_AWREADY,s05_couplers_to_xbar_AWREADY,s04_couplers_to_xbar_AWREADY,s03_couplers_to_xbar_AWREADY,s02_couplers_to_xbar_AWREADY,s01_couplers_to_xbar_AWREADY,s00_couplers_to_xbar_AWREADY}),
        .s_axi_awsize({s07_couplers_to_xbar_AWSIZE,s06_couplers_to_xbar_AWSIZE,s05_couplers_to_xbar_AWSIZE,s04_couplers_to_xbar_AWSIZE,s03_couplers_to_xbar_AWSIZE,s02_couplers_to_xbar_AWSIZE,s01_couplers_to_xbar_AWSIZE,s00_couplers_to_xbar_AWSIZE}),
        .s_axi_awuser({s07_couplers_to_xbar_AWUSER,s06_couplers_to_xbar_AWUSER,s05_couplers_to_xbar_AWUSER,s04_couplers_to_xbar_AWUSER,s03_couplers_to_xbar_AWUSER,s02_couplers_to_xbar_AWUSER,s01_couplers_to_xbar_AWUSER,s00_couplers_to_xbar_AWUSER}),
        .s_axi_awvalid({s07_couplers_to_xbar_AWVALID,s06_couplers_to_xbar_AWVALID,s05_couplers_to_xbar_AWVALID,s04_couplers_to_xbar_AWVALID,s03_couplers_to_xbar_AWVALID,s02_couplers_to_xbar_AWVALID,s01_couplers_to_xbar_AWVALID,s00_couplers_to_xbar_AWVALID}),
        .s_axi_bid({s07_couplers_to_xbar_BID,s06_couplers_to_xbar_BID,s05_couplers_to_xbar_BID,s04_couplers_to_xbar_BID,s03_couplers_to_xbar_BID,s02_couplers_to_xbar_BID,s01_couplers_to_xbar_BID,s00_couplers_to_xbar_BID}),
        .s_axi_bready({s07_couplers_to_xbar_BREADY,s06_couplers_to_xbar_BREADY,s05_couplers_to_xbar_BREADY,s04_couplers_to_xbar_BREADY,s03_couplers_to_xbar_BREADY,s02_couplers_to_xbar_BREADY,s01_couplers_to_xbar_BREADY,s00_couplers_to_xbar_BREADY}),
        .s_axi_bresp({s07_couplers_to_xbar_BRESP,s06_couplers_to_xbar_BRESP,s05_couplers_to_xbar_BRESP,s04_couplers_to_xbar_BRESP,s03_couplers_to_xbar_BRESP,s02_couplers_to_xbar_BRESP,s01_couplers_to_xbar_BRESP,s00_couplers_to_xbar_BRESP}),
        .s_axi_buser({s07_couplers_to_xbar_BUSER,s06_couplers_to_xbar_BUSER,s05_couplers_to_xbar_BUSER,s04_couplers_to_xbar_BUSER,s03_couplers_to_xbar_BUSER,s02_couplers_to_xbar_BUSER,s01_couplers_to_xbar_BUSER,s00_couplers_to_xbar_BUSER}),
        .s_axi_bvalid({s07_couplers_to_xbar_BVALID,s06_couplers_to_xbar_BVALID,s05_couplers_to_xbar_BVALID,s04_couplers_to_xbar_BVALID,s03_couplers_to_xbar_BVALID,s02_couplers_to_xbar_BVALID,s01_couplers_to_xbar_BVALID,s00_couplers_to_xbar_BVALID}),
        .s_axi_rready({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wdata({s07_couplers_to_xbar_WDATA,s06_couplers_to_xbar_WDATA,s05_couplers_to_xbar_WDATA,s04_couplers_to_xbar_WDATA,s03_couplers_to_xbar_WDATA,s02_couplers_to_xbar_WDATA,s01_couplers_to_xbar_WDATA,s00_couplers_to_xbar_WDATA}),
        .s_axi_wlast({s07_couplers_to_xbar_WLAST,s06_couplers_to_xbar_WLAST,s05_couplers_to_xbar_WLAST,s04_couplers_to_xbar_WLAST,s03_couplers_to_xbar_WLAST,s02_couplers_to_xbar_WLAST,s01_couplers_to_xbar_WLAST,s00_couplers_to_xbar_WLAST}),
        .s_axi_wready({s07_couplers_to_xbar_WREADY,s06_couplers_to_xbar_WREADY,s05_couplers_to_xbar_WREADY,s04_couplers_to_xbar_WREADY,s03_couplers_to_xbar_WREADY,s02_couplers_to_xbar_WREADY,s01_couplers_to_xbar_WREADY,s00_couplers_to_xbar_WREADY}),
        .s_axi_wstrb({s07_couplers_to_xbar_WSTRB,s06_couplers_to_xbar_WSTRB,s05_couplers_to_xbar_WSTRB,s04_couplers_to_xbar_WSTRB,s03_couplers_to_xbar_WSTRB,s02_couplers_to_xbar_WSTRB,s01_couplers_to_xbar_WSTRB,s00_couplers_to_xbar_WSTRB}),
        .s_axi_wuser({s07_couplers_to_xbar_WUSER,s06_couplers_to_xbar_WUSER,s05_couplers_to_xbar_WUSER,s04_couplers_to_xbar_WUSER,s03_couplers_to_xbar_WUSER,s02_couplers_to_xbar_WUSER,s01_couplers_to_xbar_WUSER,s00_couplers_to_xbar_WUSER}),
        .s_axi_wvalid({s07_couplers_to_xbar_WVALID,s06_couplers_to_xbar_WVALID,s05_couplers_to_xbar_WVALID,s04_couplers_to_xbar_WVALID,s03_couplers_to_xbar_WVALID,s02_couplers_to_xbar_WVALID,s01_couplers_to_xbar_WVALID,s00_couplers_to_xbar_WVALID}));
endmodule

module system_ps_0_axi_periph_0
   (ACLK,
    ARESETN,
    M00_ACLK,
    M00_ARESETN,
    M00_AXI_araddr,
    M00_AXI_arprot,
    M00_AXI_arready,
    M00_AXI_arvalid,
    M00_AXI_awaddr,
    M00_AXI_awprot,
    M00_AXI_awready,
    M00_AXI_awvalid,
    M00_AXI_bready,
    M00_AXI_bresp,
    M00_AXI_bvalid,
    M00_AXI_rdata,
    M00_AXI_rready,
    M00_AXI_rresp,
    M00_AXI_rvalid,
    M00_AXI_wdata,
    M00_AXI_wready,
    M00_AXI_wstrb,
    M00_AXI_wvalid,
    S00_ACLK,
    S00_ARESETN,
    S00_AXI_araddr,
    S00_AXI_arburst,
    S00_AXI_arcache,
    S00_AXI_arid,
    S00_AXI_arlen,
    S00_AXI_arlock,
    S00_AXI_arprot,
    S00_AXI_arqos,
    S00_AXI_arready,
    S00_AXI_arsize,
    S00_AXI_arvalid,
    S00_AXI_awaddr,
    S00_AXI_awburst,
    S00_AXI_awcache,
    S00_AXI_awid,
    S00_AXI_awlen,
    S00_AXI_awlock,
    S00_AXI_awprot,
    S00_AXI_awqos,
    S00_AXI_awready,
    S00_AXI_awsize,
    S00_AXI_awvalid,
    S00_AXI_bid,
    S00_AXI_bready,
    S00_AXI_bresp,
    S00_AXI_bvalid,
    S00_AXI_rdata,
    S00_AXI_rid,
    S00_AXI_rlast,
    S00_AXI_rready,
    S00_AXI_rresp,
    S00_AXI_rvalid,
    S00_AXI_wdata,
    S00_AXI_wid,
    S00_AXI_wlast,
    S00_AXI_wready,
    S00_AXI_wstrb,
    S00_AXI_wvalid);
  input ACLK;
  input ARESETN;
  input M00_ACLK;
  input M00_ARESETN;
  output [31:0]M00_AXI_araddr;
  output [2:0]M00_AXI_arprot;
  input M00_AXI_arready;
  output M00_AXI_arvalid;
  output [31:0]M00_AXI_awaddr;
  output [2:0]M00_AXI_awprot;
  input M00_AXI_awready;
  output M00_AXI_awvalid;
  output M00_AXI_bready;
  input [1:0]M00_AXI_bresp;
  input M00_AXI_bvalid;
  input [31:0]M00_AXI_rdata;
  output M00_AXI_rready;
  input [1:0]M00_AXI_rresp;
  input M00_AXI_rvalid;
  output [31:0]M00_AXI_wdata;
  input M00_AXI_wready;
  output [3:0]M00_AXI_wstrb;
  output M00_AXI_wvalid;
  input S00_ACLK;
  input S00_ARESETN;
  input [31:0]S00_AXI_araddr;
  input [1:0]S00_AXI_arburst;
  input [3:0]S00_AXI_arcache;
  input [11:0]S00_AXI_arid;
  input [3:0]S00_AXI_arlen;
  input [1:0]S00_AXI_arlock;
  input [2:0]S00_AXI_arprot;
  input [3:0]S00_AXI_arqos;
  output S00_AXI_arready;
  input [2:0]S00_AXI_arsize;
  input S00_AXI_arvalid;
  input [31:0]S00_AXI_awaddr;
  input [1:0]S00_AXI_awburst;
  input [3:0]S00_AXI_awcache;
  input [11:0]S00_AXI_awid;
  input [3:0]S00_AXI_awlen;
  input [1:0]S00_AXI_awlock;
  input [2:0]S00_AXI_awprot;
  input [3:0]S00_AXI_awqos;
  output S00_AXI_awready;
  input [2:0]S00_AXI_awsize;
  input S00_AXI_awvalid;
  output [11:0]S00_AXI_bid;
  input S00_AXI_bready;
  output [1:0]S00_AXI_bresp;
  output S00_AXI_bvalid;
  output [31:0]S00_AXI_rdata;
  output [11:0]S00_AXI_rid;
  output S00_AXI_rlast;
  input S00_AXI_rready;
  output [1:0]S00_AXI_rresp;
  output S00_AXI_rvalid;
  input [31:0]S00_AXI_wdata;
  input [11:0]S00_AXI_wid;
  input S00_AXI_wlast;
  output S00_AXI_wready;
  input [3:0]S00_AXI_wstrb;
  input S00_AXI_wvalid;

  wire S00_ACLK_1;
  wire S00_ARESETN_1;
  wire ps_0_axi_periph_ACLK_net;
  wire ps_0_axi_periph_ARESETN_net;
  wire [31:0]ps_0_axi_periph_to_s00_couplers_ARADDR;
  wire [1:0]ps_0_axi_periph_to_s00_couplers_ARBURST;
  wire [3:0]ps_0_axi_periph_to_s00_couplers_ARCACHE;
  wire [11:0]ps_0_axi_periph_to_s00_couplers_ARID;
  wire [3:0]ps_0_axi_periph_to_s00_couplers_ARLEN;
  wire [1:0]ps_0_axi_periph_to_s00_couplers_ARLOCK;
  wire [2:0]ps_0_axi_periph_to_s00_couplers_ARPROT;
  wire [3:0]ps_0_axi_periph_to_s00_couplers_ARQOS;
  wire ps_0_axi_periph_to_s00_couplers_ARREADY;
  wire [2:0]ps_0_axi_periph_to_s00_couplers_ARSIZE;
  wire ps_0_axi_periph_to_s00_couplers_ARVALID;
  wire [31:0]ps_0_axi_periph_to_s00_couplers_AWADDR;
  wire [1:0]ps_0_axi_periph_to_s00_couplers_AWBURST;
  wire [3:0]ps_0_axi_periph_to_s00_couplers_AWCACHE;
  wire [11:0]ps_0_axi_periph_to_s00_couplers_AWID;
  wire [3:0]ps_0_axi_periph_to_s00_couplers_AWLEN;
  wire [1:0]ps_0_axi_periph_to_s00_couplers_AWLOCK;
  wire [2:0]ps_0_axi_periph_to_s00_couplers_AWPROT;
  wire [3:0]ps_0_axi_periph_to_s00_couplers_AWQOS;
  wire ps_0_axi_periph_to_s00_couplers_AWREADY;
  wire [2:0]ps_0_axi_periph_to_s00_couplers_AWSIZE;
  wire ps_0_axi_periph_to_s00_couplers_AWVALID;
  wire [11:0]ps_0_axi_periph_to_s00_couplers_BID;
  wire ps_0_axi_periph_to_s00_couplers_BREADY;
  wire [1:0]ps_0_axi_periph_to_s00_couplers_BRESP;
  wire ps_0_axi_periph_to_s00_couplers_BVALID;
  wire [31:0]ps_0_axi_periph_to_s00_couplers_RDATA;
  wire [11:0]ps_0_axi_periph_to_s00_couplers_RID;
  wire ps_0_axi_periph_to_s00_couplers_RLAST;
  wire ps_0_axi_periph_to_s00_couplers_RREADY;
  wire [1:0]ps_0_axi_periph_to_s00_couplers_RRESP;
  wire ps_0_axi_periph_to_s00_couplers_RVALID;
  wire [31:0]ps_0_axi_periph_to_s00_couplers_WDATA;
  wire [11:0]ps_0_axi_periph_to_s00_couplers_WID;
  wire ps_0_axi_periph_to_s00_couplers_WLAST;
  wire ps_0_axi_periph_to_s00_couplers_WREADY;
  wire [3:0]ps_0_axi_periph_to_s00_couplers_WSTRB;
  wire ps_0_axi_periph_to_s00_couplers_WVALID;
  wire [31:0]s00_couplers_to_ps_0_axi_periph_ARADDR;
  wire [2:0]s00_couplers_to_ps_0_axi_periph_ARPROT;
  wire s00_couplers_to_ps_0_axi_periph_ARREADY;
  wire s00_couplers_to_ps_0_axi_periph_ARVALID;
  wire [31:0]s00_couplers_to_ps_0_axi_periph_AWADDR;
  wire [2:0]s00_couplers_to_ps_0_axi_periph_AWPROT;
  wire s00_couplers_to_ps_0_axi_periph_AWREADY;
  wire s00_couplers_to_ps_0_axi_periph_AWVALID;
  wire s00_couplers_to_ps_0_axi_periph_BREADY;
  wire [1:0]s00_couplers_to_ps_0_axi_periph_BRESP;
  wire s00_couplers_to_ps_0_axi_periph_BVALID;
  wire [31:0]s00_couplers_to_ps_0_axi_periph_RDATA;
  wire s00_couplers_to_ps_0_axi_periph_RREADY;
  wire [1:0]s00_couplers_to_ps_0_axi_periph_RRESP;
  wire s00_couplers_to_ps_0_axi_periph_RVALID;
  wire [31:0]s00_couplers_to_ps_0_axi_periph_WDATA;
  wire s00_couplers_to_ps_0_axi_periph_WREADY;
  wire [3:0]s00_couplers_to_ps_0_axi_periph_WSTRB;
  wire s00_couplers_to_ps_0_axi_periph_WVALID;

  assign M00_AXI_araddr[31:0] = s00_couplers_to_ps_0_axi_periph_ARADDR;
  assign M00_AXI_arprot[2:0] = s00_couplers_to_ps_0_axi_periph_ARPROT;
  assign M00_AXI_arvalid = s00_couplers_to_ps_0_axi_periph_ARVALID;
  assign M00_AXI_awaddr[31:0] = s00_couplers_to_ps_0_axi_periph_AWADDR;
  assign M00_AXI_awprot[2:0] = s00_couplers_to_ps_0_axi_periph_AWPROT;
  assign M00_AXI_awvalid = s00_couplers_to_ps_0_axi_periph_AWVALID;
  assign M00_AXI_bready = s00_couplers_to_ps_0_axi_periph_BREADY;
  assign M00_AXI_rready = s00_couplers_to_ps_0_axi_periph_RREADY;
  assign M00_AXI_wdata[31:0] = s00_couplers_to_ps_0_axi_periph_WDATA;
  assign M00_AXI_wstrb[3:0] = s00_couplers_to_ps_0_axi_periph_WSTRB;
  assign M00_AXI_wvalid = s00_couplers_to_ps_0_axi_periph_WVALID;
  assign S00_ACLK_1 = S00_ACLK;
  assign S00_ARESETN_1 = S00_ARESETN;
  assign S00_AXI_arready = ps_0_axi_periph_to_s00_couplers_ARREADY;
  assign S00_AXI_awready = ps_0_axi_periph_to_s00_couplers_AWREADY;
  assign S00_AXI_bid[11:0] = ps_0_axi_periph_to_s00_couplers_BID;
  assign S00_AXI_bresp[1:0] = ps_0_axi_periph_to_s00_couplers_BRESP;
  assign S00_AXI_bvalid = ps_0_axi_periph_to_s00_couplers_BVALID;
  assign S00_AXI_rdata[31:0] = ps_0_axi_periph_to_s00_couplers_RDATA;
  assign S00_AXI_rid[11:0] = ps_0_axi_periph_to_s00_couplers_RID;
  assign S00_AXI_rlast = ps_0_axi_periph_to_s00_couplers_RLAST;
  assign S00_AXI_rresp[1:0] = ps_0_axi_periph_to_s00_couplers_RRESP;
  assign S00_AXI_rvalid = ps_0_axi_periph_to_s00_couplers_RVALID;
  assign S00_AXI_wready = ps_0_axi_periph_to_s00_couplers_WREADY;
  assign ps_0_axi_periph_ACLK_net = M00_ACLK;
  assign ps_0_axi_periph_ARESETN_net = M00_ARESETN;
  assign ps_0_axi_periph_to_s00_couplers_ARADDR = S00_AXI_araddr[31:0];
  assign ps_0_axi_periph_to_s00_couplers_ARBURST = S00_AXI_arburst[1:0];
  assign ps_0_axi_periph_to_s00_couplers_ARCACHE = S00_AXI_arcache[3:0];
  assign ps_0_axi_periph_to_s00_couplers_ARID = S00_AXI_arid[11:0];
  assign ps_0_axi_periph_to_s00_couplers_ARLEN = S00_AXI_arlen[3:0];
  assign ps_0_axi_periph_to_s00_couplers_ARLOCK = S00_AXI_arlock[1:0];
  assign ps_0_axi_periph_to_s00_couplers_ARPROT = S00_AXI_arprot[2:0];
  assign ps_0_axi_periph_to_s00_couplers_ARQOS = S00_AXI_arqos[3:0];
  assign ps_0_axi_periph_to_s00_couplers_ARSIZE = S00_AXI_arsize[2:0];
  assign ps_0_axi_periph_to_s00_couplers_ARVALID = S00_AXI_arvalid;
  assign ps_0_axi_periph_to_s00_couplers_AWADDR = S00_AXI_awaddr[31:0];
  assign ps_0_axi_periph_to_s00_couplers_AWBURST = S00_AXI_awburst[1:0];
  assign ps_0_axi_periph_to_s00_couplers_AWCACHE = S00_AXI_awcache[3:0];
  assign ps_0_axi_periph_to_s00_couplers_AWID = S00_AXI_awid[11:0];
  assign ps_0_axi_periph_to_s00_couplers_AWLEN = S00_AXI_awlen[3:0];
  assign ps_0_axi_periph_to_s00_couplers_AWLOCK = S00_AXI_awlock[1:0];
  assign ps_0_axi_periph_to_s00_couplers_AWPROT = S00_AXI_awprot[2:0];
  assign ps_0_axi_periph_to_s00_couplers_AWQOS = S00_AXI_awqos[3:0];
  assign ps_0_axi_periph_to_s00_couplers_AWSIZE = S00_AXI_awsize[2:0];
  assign ps_0_axi_periph_to_s00_couplers_AWVALID = S00_AXI_awvalid;
  assign ps_0_axi_periph_to_s00_couplers_BREADY = S00_AXI_bready;
  assign ps_0_axi_periph_to_s00_couplers_RREADY = S00_AXI_rready;
  assign ps_0_axi_periph_to_s00_couplers_WDATA = S00_AXI_wdata[31:0];
  assign ps_0_axi_periph_to_s00_couplers_WID = S00_AXI_wid[11:0];
  assign ps_0_axi_periph_to_s00_couplers_WLAST = S00_AXI_wlast;
  assign ps_0_axi_periph_to_s00_couplers_WSTRB = S00_AXI_wstrb[3:0];
  assign ps_0_axi_periph_to_s00_couplers_WVALID = S00_AXI_wvalid;
  assign s00_couplers_to_ps_0_axi_periph_ARREADY = M00_AXI_arready;
  assign s00_couplers_to_ps_0_axi_periph_AWREADY = M00_AXI_awready;
  assign s00_couplers_to_ps_0_axi_periph_BRESP = M00_AXI_bresp[1:0];
  assign s00_couplers_to_ps_0_axi_periph_BVALID = M00_AXI_bvalid;
  assign s00_couplers_to_ps_0_axi_periph_RDATA = M00_AXI_rdata[31:0];
  assign s00_couplers_to_ps_0_axi_periph_RRESP = M00_AXI_rresp[1:0];
  assign s00_couplers_to_ps_0_axi_periph_RVALID = M00_AXI_rvalid;
  assign s00_couplers_to_ps_0_axi_periph_WREADY = M00_AXI_wready;
  s00_couplers_imp_H3WDR2 s00_couplers
       (.M_ACLK(ps_0_axi_periph_ACLK_net),
        .M_ARESETN(ps_0_axi_periph_ARESETN_net),
        .M_AXI_araddr(s00_couplers_to_ps_0_axi_periph_ARADDR),
        .M_AXI_arprot(s00_couplers_to_ps_0_axi_periph_ARPROT),
        .M_AXI_arready(s00_couplers_to_ps_0_axi_periph_ARREADY),
        .M_AXI_arvalid(s00_couplers_to_ps_0_axi_periph_ARVALID),
        .M_AXI_awaddr(s00_couplers_to_ps_0_axi_periph_AWADDR),
        .M_AXI_awprot(s00_couplers_to_ps_0_axi_periph_AWPROT),
        .M_AXI_awready(s00_couplers_to_ps_0_axi_periph_AWREADY),
        .M_AXI_awvalid(s00_couplers_to_ps_0_axi_periph_AWVALID),
        .M_AXI_bready(s00_couplers_to_ps_0_axi_periph_BREADY),
        .M_AXI_bresp(s00_couplers_to_ps_0_axi_periph_BRESP),
        .M_AXI_bvalid(s00_couplers_to_ps_0_axi_periph_BVALID),
        .M_AXI_rdata(s00_couplers_to_ps_0_axi_periph_RDATA),
        .M_AXI_rready(s00_couplers_to_ps_0_axi_periph_RREADY),
        .M_AXI_rresp(s00_couplers_to_ps_0_axi_periph_RRESP),
        .M_AXI_rvalid(s00_couplers_to_ps_0_axi_periph_RVALID),
        .M_AXI_wdata(s00_couplers_to_ps_0_axi_periph_WDATA),
        .M_AXI_wready(s00_couplers_to_ps_0_axi_periph_WREADY),
        .M_AXI_wstrb(s00_couplers_to_ps_0_axi_periph_WSTRB),
        .M_AXI_wvalid(s00_couplers_to_ps_0_axi_periph_WVALID),
        .S_ACLK(S00_ACLK_1),
        .S_ARESETN(S00_ARESETN_1),
        .S_AXI_araddr(ps_0_axi_periph_to_s00_couplers_ARADDR),
        .S_AXI_arburst(ps_0_axi_periph_to_s00_couplers_ARBURST),
        .S_AXI_arcache(ps_0_axi_periph_to_s00_couplers_ARCACHE),
        .S_AXI_arid(ps_0_axi_periph_to_s00_couplers_ARID),
        .S_AXI_arlen(ps_0_axi_periph_to_s00_couplers_ARLEN),
        .S_AXI_arlock(ps_0_axi_periph_to_s00_couplers_ARLOCK),
        .S_AXI_arprot(ps_0_axi_periph_to_s00_couplers_ARPROT),
        .S_AXI_arqos(ps_0_axi_periph_to_s00_couplers_ARQOS),
        .S_AXI_arready(ps_0_axi_periph_to_s00_couplers_ARREADY),
        .S_AXI_arsize(ps_0_axi_periph_to_s00_couplers_ARSIZE),
        .S_AXI_arvalid(ps_0_axi_periph_to_s00_couplers_ARVALID),
        .S_AXI_awaddr(ps_0_axi_periph_to_s00_couplers_AWADDR),
        .S_AXI_awburst(ps_0_axi_periph_to_s00_couplers_AWBURST),
        .S_AXI_awcache(ps_0_axi_periph_to_s00_couplers_AWCACHE),
        .S_AXI_awid(ps_0_axi_periph_to_s00_couplers_AWID),
        .S_AXI_awlen(ps_0_axi_periph_to_s00_couplers_AWLEN),
        .S_AXI_awlock(ps_0_axi_periph_to_s00_couplers_AWLOCK),
        .S_AXI_awprot(ps_0_axi_periph_to_s00_couplers_AWPROT),
        .S_AXI_awqos(ps_0_axi_periph_to_s00_couplers_AWQOS),
        .S_AXI_awready(ps_0_axi_periph_to_s00_couplers_AWREADY),
        .S_AXI_awsize(ps_0_axi_periph_to_s00_couplers_AWSIZE),
        .S_AXI_awvalid(ps_0_axi_periph_to_s00_couplers_AWVALID),
        .S_AXI_bid(ps_0_axi_periph_to_s00_couplers_BID),
        .S_AXI_bready(ps_0_axi_periph_to_s00_couplers_BREADY),
        .S_AXI_bresp(ps_0_axi_periph_to_s00_couplers_BRESP),
        .S_AXI_bvalid(ps_0_axi_periph_to_s00_couplers_BVALID),
        .S_AXI_rdata(ps_0_axi_periph_to_s00_couplers_RDATA),
        .S_AXI_rid(ps_0_axi_periph_to_s00_couplers_RID),
        .S_AXI_rlast(ps_0_axi_periph_to_s00_couplers_RLAST),
        .S_AXI_rready(ps_0_axi_periph_to_s00_couplers_RREADY),
        .S_AXI_rresp(ps_0_axi_periph_to_s00_couplers_RRESP),
        .S_AXI_rvalid(ps_0_axi_periph_to_s00_couplers_RVALID),
        .S_AXI_wdata(ps_0_axi_periph_to_s00_couplers_WDATA),
        .S_AXI_wid(ps_0_axi_periph_to_s00_couplers_WID),
        .S_AXI_wlast(ps_0_axi_periph_to_s00_couplers_WLAST),
        .S_AXI_wready(ps_0_axi_periph_to_s00_couplers_WREADY),
        .S_AXI_wstrb(ps_0_axi_periph_to_s00_couplers_WSTRB),
        .S_AXI_wvalid(ps_0_axi_periph_to_s00_couplers_WVALID));
endmodule
