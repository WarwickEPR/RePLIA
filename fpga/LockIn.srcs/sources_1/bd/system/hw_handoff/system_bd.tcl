
################################################################
# This is a generated script based on design: system
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2016.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source system_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# adc_2comp, two_clk_accum, clk_switch, dac_switch, digital_IO_connect, simp_counter, mode_control, accumulator_limited, ttl_insert, freq_doubler, out_val, two_clk_accum, split_AXI, split_AXI, comb_AXI, out_val, comb_AXI, out_val, data_padder, data_padder, data_padder, data_padder, data_padder, data_padder, data_padder, data_padder, data_writer, data_writer, data_writer, data_writer, data_writer, data_writer, data_writer, data_writer, highest_bit, mem_manager, two_clk_accum, moving_average, simple_summation, moving_average, simple_summation, moving_average, simple_summation, moving_average, simple_summation, split_AXI, default_val, default_val, default_val, default_val, split_AXI, default_val, default_val, out_val, default_val, default_val, default_val, default_val, default_val

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
set design_name system

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

##################################################################
# DESIGN PROCs
##################################################################


# Hierarchical cell: settings
proc create_hier_cell_settings { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_settings() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  # Create pins
  create_bd_pin -dir O -from 31 -to 0 amp_mult
  create_bd_pin -dir O -from 31 -to 0 avg_inc_cnt
  create_bd_pin -dir I -from 31 -to 0 ch_a_Y
  create_bd_pin -dir I -from 31 -to 0 ch_a_amp
  create_bd_pin -dir I -from 31 -to 0 ch_a_x
  create_bd_pin -dir I -from 31 -to 0 ch_b_X
  create_bd_pin -dir I -from 31 -to 0 ch_b_Y
  create_bd_pin -dir I -from 31 -to 0 ch_b_amp
  create_bd_pin -dir I -from 31 -to 0 ch_b_phase
  create_bd_pin -dir I -from 31 -to 0 cha_a_phase
  create_bd_pin -dir I -from 31 -to 0 counter
  create_bd_pin -dir O -from 15 -to 0 dac_a_mult
  create_bd_pin -dir O -from 15 -to 0 dac_b_mult
  create_bd_pin -dir O -from 15 -to 0 mod_phase
  create_bd_pin -dir O -from 31 -to 0 mode_flags
  create_bd_pin -dir I -from 31 -to 0 offset_end
  create_bd_pin -dir I -from 31 -to 0 offset_start
  create_bd_pin -dir O -from 31 -to 0 phase_inc
  create_bd_pin -dir I -type clk s00_axi_aclk
  create_bd_pin -dir I -type rst s00_axi_aresetn
  create_bd_pin -dir O -from 31 -to 0 sample_cnt
  create_bd_pin -dir O -from 31 -to 0 sweep_add
  create_bd_pin -dir O -from 31 -to 0 sweep_max
  create_bd_pin -dir O -from 31 -to 0 sweep_min

  # Create instance: AXI_inout_0, and set properties
  set AXI_inout_0 [ create_bd_cell -type ip -vlnv xilinx.com:user:AXI_inout:1.0 AXI_inout_0 ]

  # Create instance: Output_mults, and set properties
  set block_name split_AXI
  set block_cell_name Output_mults
  if { [catch {set Output_mults [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $Output_mults eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.OUT_DATA_WIDTH {16} \
 ] $Output_mults

  # Create instance: amp_mult, and set properties
  set block_name default_val
  set block_cell_name amp_mult
  if { [catch {set amp_mult [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $amp_mult eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {1073741824} \
 ] $amp_mult

  # Create instance: avg_inc_cnt, and set properties
  set block_name default_val
  set block_cell_name avg_inc_cnt
  if { [catch {set avg_inc_cnt [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $avg_inc_cnt eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {10995116} \
 ] $avg_inc_cnt

  # Create instance: dac_a_mult, and set properties
  set block_name default_val
  set block_cell_name dac_a_mult
  if { [catch {set dac_a_mult [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dac_a_mult eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {16} \
 ] $dac_a_mult

  # Create instance: dac_b_mult, and set properties
  set block_name default_val
  set block_cell_name dac_b_mult
  if { [catch {set dac_b_mult [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dac_b_mult eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {16} \
 ] $dac_b_mult

  # Create instance: mod_phase, and set properties
  set block_name split_AXI
  set block_cell_name mod_phase
  if { [catch {set mod_phase [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mod_phase eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.OUT_DATA_WIDTH {16} \
 ] $mod_phase

  # Create instance: mod_phase_def, and set properties
  set block_name default_val
  set block_cell_name mod_phase_def
  if { [catch {set mod_phase_def [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mod_phase_def eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {16} \
CONFIG.value {0} \
 ] $mod_phase_def

  # Create instance: mode_flags, and set properties
  set block_name default_val
  set block_cell_name mode_flags
  if { [catch {set mode_flags [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mode_flags eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {0} \
 ] $mode_flags

  # Create instance: out_val_0, and set properties
  set block_name out_val
  set block_cell_name out_val_0
  if { [catch {set out_val_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_val_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {0} \
 ] $out_val_0

  # Create instance: phase_inc, and set properties
  set block_name default_val
  set block_cell_name phase_inc
  if { [catch {set phase_inc [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $phase_inc eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {343597} \
 ] $phase_inc

  # Create instance: sample_cnt, and set properties
  set block_name default_val
  set block_cell_name sample_cnt
  if { [catch {set sample_cnt [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_cnt eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {343597} \
 ] $sample_cnt

  # Create instance: sweep_add, and set properties
  set block_name default_val
  set block_cell_name sweep_add
  if { [catch {set sweep_add [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sweep_add eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {4398} \
 ] $sweep_add

  # Create instance: sweep_max, and set properties
  set block_name default_val
  set block_cell_name sweep_max
  if { [catch {set sweep_max [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sweep_max eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {3221225472} \
 ] $sweep_max

  # Create instance: sweep_min, and set properties
  set block_name default_val
  set block_cell_name sweep_min
  if { [catch {set sweep_min [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sweep_min eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.num_bits {32} \
CONFIG.value {1073741824} \
 ] $sweep_min

  # Create interface connections
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins AXI_inout_0/S00_AXI]

  # Create port connections
  connect_bd_net -net AXI_inout_0_out0 [get_bd_pins AXI_inout_0/out0] [get_bd_pins phase_inc/in_bus]
  connect_bd_net -net AXI_inout_0_out1 [get_bd_pins AXI_inout_0/out1] [get_bd_pins avg_inc_cnt/in_bus]
  connect_bd_net -net AXI_inout_0_out2 [get_bd_pins AXI_inout_0/out2] [get_bd_pins mode_flags/in_bus]
  connect_bd_net -net AXI_inout_0_out3 [get_bd_pins AXI_inout_0/out3] [get_bd_pins sweep_min/in_bus]
  connect_bd_net -net AXI_inout_0_out4 [get_bd_pins AXI_inout_0/out4] [get_bd_pins sweep_max/in_bus]
  connect_bd_net -net AXI_inout_0_out5 [get_bd_pins AXI_inout_0/out5] [get_bd_pins sweep_add/in_bus]
  connect_bd_net -net AXI_inout_0_out6 [get_bd_pins AXI_inout_0/out6] [get_bd_pins amp_mult/in_bus]
  connect_bd_net -net AXI_inout_0_out7 [get_bd_pins AXI_inout_0/out7] [get_bd_pins Output_mults/in_data]
  connect_bd_net -net AXI_inout_0_out8 [get_bd_pins AXI_inout_0/out8] [get_bd_pins mod_phase/in_data]
  connect_bd_net -net AXI_inout_0_out9 [get_bd_pins AXI_inout_0/out9] [get_bd_pins sample_cnt/in_bus]
  connect_bd_net -net Output_mults_ch_a_out [get_bd_pins Output_mults/ch_a_out] [get_bd_pins dac_a_mult/in_bus]
  connect_bd_net -net Output_mults_ch_b_out [get_bd_pins Output_mults/ch_b_out] [get_bd_pins dac_b_mult/in_bus]
  connect_bd_net -net counter_1 [get_bd_pins counter] [get_bd_pins AXI_inout_0/in40]
  connect_bd_net -net dac_a_mult_out_bus [get_bd_pins dac_a_mult] [get_bd_pins dac_a_mult/out_bus]
  connect_bd_net -net dac_b_mult_out_bus [get_bd_pins dac_b_mult] [get_bd_pins dac_b_mult/out_bus]
  connect_bd_net -net data_padder_0_data_out [get_bd_pins ch_a_x] [get_bd_pins AXI_inout_0/in32]
  connect_bd_net -net data_padder_0_data_out1 [get_bd_pins ch_a_Y] [get_bd_pins AXI_inout_0/in33]
  connect_bd_net -net data_padder_1_data_out [get_bd_pins ch_a_amp] [get_bd_pins AXI_inout_0/in34]
  connect_bd_net -net data_padder_2_data_out [get_bd_pins cha_a_phase] [get_bd_pins AXI_inout_0/in35]
  connect_bd_net -net data_padder_3_data_out [get_bd_pins ch_b_X] [get_bd_pins AXI_inout_0/in36]
  connect_bd_net -net data_padder_4_data_out [get_bd_pins ch_b_Y] [get_bd_pins AXI_inout_0/in37]
  connect_bd_net -net data_padder_5_data_out [get_bd_pins ch_b_amp] [get_bd_pins AXI_inout_0/in38]
  connect_bd_net -net data_padder_6_data_out [get_bd_pins ch_b_phase] [get_bd_pins AXI_inout_0/in39]
  connect_bd_net -net default_val_0_out_bus [get_bd_pins phase_inc] [get_bd_pins phase_inc/out_bus]
  connect_bd_net -net default_val_0_out_bus1 [get_bd_pins mode_flags] [get_bd_pins mode_flags/out_bus]
  connect_bd_net -net default_val_0_out_bus2 [get_bd_pins sweep_add] [get_bd_pins sweep_add/out_bus]
  connect_bd_net -net default_val_0_out_bus3 [get_bd_pins amp_mult] [get_bd_pins amp_mult/out_bus]
  connect_bd_net -net default_val_0_out_bus4 [get_bd_pins mod_phase] [get_bd_pins mod_phase_def/out_bus]
  connect_bd_net -net offset_end_1 [get_bd_pins offset_end] [get_bd_pins AXI_inout_0/in42]
  connect_bd_net -net offset_start_1 [get_bd_pins offset_start] [get_bd_pins AXI_inout_0/in41]
  connect_bd_net -net out_val_0_out_bus [get_bd_pins avg_inc_cnt] [get_bd_pins avg_inc_cnt/out_bus]
  connect_bd_net -net out_val_0_out_bus1 [get_bd_pins AXI_inout_0/in43] [get_bd_pins AXI_inout_0/in44] [get_bd_pins AXI_inout_0/in45] [get_bd_pins AXI_inout_0/in46] [get_bd_pins AXI_inout_0/in47] [get_bd_pins out_val_0/out_bus]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins s00_axi_aclk] [get_bd_pins AXI_inout_0/s00_axi_aclk] [get_bd_pins amp_mult/clk] [get_bd_pins avg_inc_cnt/clk] [get_bd_pins dac_a_mult/clk] [get_bd_pins dac_b_mult/clk] [get_bd_pins mod_phase_def/clk] [get_bd_pins mode_flags/clk] [get_bd_pins phase_inc/clk] [get_bd_pins sample_cnt/clk] [get_bd_pins sweep_add/clk] [get_bd_pins sweep_max/clk] [get_bd_pins sweep_min/clk]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins s00_axi_aresetn] [get_bd_pins AXI_inout_0/s00_axi_aresetn]
  connect_bd_net -net sample_cnt_out_bus [get_bd_pins sample_cnt] [get_bd_pins sample_cnt/out_bus]
  connect_bd_net -net split_AXI_0_ch_a_out [get_bd_pins mod_phase/ch_a_out] [get_bd_pins mod_phase_def/in_bus]
  connect_bd_net -net sweep_max_out_bus [get_bd_pins sweep_max] [get_bd_pins sweep_max/out_bus]
  connect_bd_net -net sweep_min_out_bus [get_bd_pins sweep_min] [get_bd_pins sweep_min/out_bus]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Lock_in_Y
proc create_hier_cell_Lock_in_Y_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_Lock_in_Y_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 31 -to 0 cnt_inc
  create_bd_pin -dir I -from 31 -to 0 counter
  create_bd_pin -dir O -from 23 -to 0 out_data
  create_bd_pin -dir I -from 15 -to 0 ref_in
  create_bd_pin -dir I -from 13 -to 0 -type data signal_in

  # Create instance: moving_average_0, and set properties
  set block_name moving_average
  set block_cell_name moving_average_0
  if { [catch {set moving_average_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $moving_average_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.in_bits {24} \
CONFIG.log2_samples {6} \
CONFIG.out_bits {24} \
 ] $moving_average_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
CONFIG.MultType {Parallel_Multiplier} \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {28} \
CONFIG.OutputWidthLow {5} \
CONFIG.PipeStages {3} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {14} \
CONFIG.PortBType {Signed} \
CONFIG.PortBWidth {16} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {55} \
CONFIG.OutputWidthLow {32} \
CONFIG.PipeStages {8} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {56} \
CONFIG.PortBType {Unsigned} \
CONFIG.PortBWidth {32} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_1

  # Create instance: simple_summation_0, and set properties
  set block_name simple_summation
  set block_cell_name simple_summation_0
  if { [catch {set simple_summation_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $simple_summation_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.cnt_in_bits {32} \
CONFIG.dat_in_bits {24} \
 ] $simple_summation_0

  # Create port connections
  connect_bd_net -net adc_2comp_0_adc_a_o [get_bd_pins signal_in] [get_bd_pins mult_gen_0/A]
  connect_bd_net -net cnt_inc_1 [get_bd_pins cnt_inc] [get_bd_pins mult_gen_1/B]
  connect_bd_net -net counter_1 [get_bd_pins counter] [get_bd_pins simple_summation_0/counter]
  connect_bd_net -net moving_average_0_out_data [get_bd_pins out_data] [get_bd_pins moving_average_0/out_data]
  connect_bd_net -net mult_gen_0_P [get_bd_pins mult_gen_0/P] [get_bd_pins simple_summation_0/in_data]
  connect_bd_net -net mult_gen_1_P [get_bd_pins moving_average_0/in_data] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins CLK] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK] [get_bd_pins simple_summation_0/clk]
  connect_bd_net -net ref_in_1 [get_bd_pins ref_in] [get_bd_pins mult_gen_0/B]
  connect_bd_net -net simple_summation_0_cnt_timer [get_bd_pins moving_average_0/clk] [get_bd_pins simple_summation_0/cnt_timer]
  connect_bd_net -net simple_summation_0_sum_out [get_bd_pins mult_gen_1/A] [get_bd_pins simple_summation_0/sum_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Lock_in_X
proc create_hier_cell_Lock_in_X_1 { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_Lock_in_X_1() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 31 -to 0 cnt_inc
  create_bd_pin -dir I -from 31 -to 0 counter
  create_bd_pin -dir O -from 23 -to 0 out_data
  create_bd_pin -dir I -from 15 -to 0 ref_in
  create_bd_pin -dir I -from 13 -to 0 -type data signal_in

  # Create instance: moving_average_0, and set properties
  set block_name moving_average
  set block_cell_name moving_average_0
  if { [catch {set moving_average_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $moving_average_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.in_bits {24} \
CONFIG.log2_samples {6} \
CONFIG.out_bits {24} \
 ] $moving_average_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
CONFIG.MultType {Parallel_Multiplier} \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {28} \
CONFIG.OutputWidthLow {5} \
CONFIG.PipeStages {3} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {14} \
CONFIG.PortBType {Signed} \
CONFIG.PortBWidth {16} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {55} \
CONFIG.OutputWidthLow {32} \
CONFIG.PipeStages {8} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {56} \
CONFIG.PortBType {Unsigned} \
CONFIG.PortBWidth {32} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_1

  # Create instance: simple_summation_0, and set properties
  set block_name simple_summation
  set block_cell_name simple_summation_0
  if { [catch {set simple_summation_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $simple_summation_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.cnt_in_bits {32} \
CONFIG.dat_in_bits {24} \
 ] $simple_summation_0

  # Create port connections
  connect_bd_net -net adc_2comp_0_adc_a_o [get_bd_pins signal_in] [get_bd_pins mult_gen_0/A]
  connect_bd_net -net cnt_inc_1 [get_bd_pins cnt_inc] [get_bd_pins mult_gen_1/B]
  connect_bd_net -net counter_1 [get_bd_pins counter] [get_bd_pins simple_summation_0/counter]
  connect_bd_net -net moving_average_0_out_data [get_bd_pins out_data] [get_bd_pins moving_average_0/out_data]
  connect_bd_net -net mult_gen_0_P [get_bd_pins mult_gen_0/P] [get_bd_pins simple_summation_0/in_data]
  connect_bd_net -net mult_gen_1_P [get_bd_pins moving_average_0/in_data] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins CLK] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK] [get_bd_pins simple_summation_0/clk]
  connect_bd_net -net ref_in_1 [get_bd_pins ref_in] [get_bd_pins mult_gen_0/B]
  connect_bd_net -net simple_summation_0_cnt_timer [get_bd_pins moving_average_0/clk] [get_bd_pins simple_summation_0/cnt_timer]
  connect_bd_net -net simple_summation_0_sum_out [get_bd_pins mult_gen_1/A] [get_bd_pins simple_summation_0/sum_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Lock_in_Y
proc create_hier_cell_Lock_in_Y { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_Lock_in_Y() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 31 -to 0 cnt_inc
  create_bd_pin -dir I -from 31 -to 0 counter
  create_bd_pin -dir O -from 23 -to 0 out_data
  create_bd_pin -dir I -from 15 -to 0 ref_in
  create_bd_pin -dir I -from 13 -to 0 -type data signal_in

  # Create instance: moving_average_0, and set properties
  set block_name moving_average
  set block_cell_name moving_average_0
  if { [catch {set moving_average_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $moving_average_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.in_bits {24} \
CONFIG.log2_samples {6} \
CONFIG.out_bits {24} \
 ] $moving_average_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
CONFIG.MultType {Parallel_Multiplier} \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {28} \
CONFIG.OutputWidthLow {5} \
CONFIG.PipeStages {3} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {14} \
CONFIG.PortBType {Signed} \
CONFIG.PortBWidth {16} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {55} \
CONFIG.OutputWidthLow {32} \
CONFIG.PipeStages {8} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {56} \
CONFIG.PortBType {Unsigned} \
CONFIG.PortBWidth {32} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_1

  # Create instance: simple_summation_0, and set properties
  set block_name simple_summation
  set block_cell_name simple_summation_0
  if { [catch {set simple_summation_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $simple_summation_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.cnt_in_bits {32} \
CONFIG.dat_in_bits {24} \
 ] $simple_summation_0

  # Create port connections
  connect_bd_net -net adc_2comp_0_adc_a_o [get_bd_pins signal_in] [get_bd_pins mult_gen_0/A]
  connect_bd_net -net cnt_inc_1 [get_bd_pins cnt_inc] [get_bd_pins mult_gen_1/B]
  connect_bd_net -net counter_1 [get_bd_pins counter] [get_bd_pins simple_summation_0/counter]
  connect_bd_net -net moving_average_0_out_data [get_bd_pins out_data] [get_bd_pins moving_average_0/out_data]
  connect_bd_net -net mult_gen_0_P [get_bd_pins mult_gen_0/P] [get_bd_pins simple_summation_0/in_data]
  connect_bd_net -net mult_gen_1_P [get_bd_pins moving_average_0/in_data] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins CLK] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK] [get_bd_pins simple_summation_0/clk]
  connect_bd_net -net ref_in_1 [get_bd_pins ref_in] [get_bd_pins mult_gen_0/B]
  connect_bd_net -net simple_summation_0_cnt_timer [get_bd_pins moving_average_0/clk] [get_bd_pins simple_summation_0/cnt_timer]
  connect_bd_net -net simple_summation_0_sum_out [get_bd_pins mult_gen_1/A] [get_bd_pins simple_summation_0/sum_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: Lock_in_X
proc create_hier_cell_Lock_in_X { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_Lock_in_X() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir I -from 31 -to 0 cnt_inc
  create_bd_pin -dir I -from 31 -to 0 counter
  create_bd_pin -dir O -from 23 -to 0 out_data
  create_bd_pin -dir I -from 15 -to 0 ref_in
  create_bd_pin -dir I -from 13 -to 0 -type data signal_in

  # Create instance: moving_average_0, and set properties
  set block_name moving_average
  set block_cell_name moving_average_0
  if { [catch {set moving_average_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $moving_average_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.in_bits {24} \
CONFIG.log2_samples {6} \
CONFIG.out_bits {24} \
 ] $moving_average_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
CONFIG.MultType {Parallel_Multiplier} \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {28} \
CONFIG.OutputWidthLow {5} \
CONFIG.PipeStages {3} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {14} \
CONFIG.PortBType {Signed} \
CONFIG.PortBWidth {16} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OptGoal {Speed} \
CONFIG.OutputWidthHigh {55} \
CONFIG.OutputWidthLow {32} \
CONFIG.PipeStages {8} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {56} \
CONFIG.PortBType {Unsigned} \
CONFIG.PortBWidth {32} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_1

  # Create instance: simple_summation_0, and set properties
  set block_name simple_summation
  set block_cell_name simple_summation_0
  if { [catch {set simple_summation_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $simple_summation_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.cnt_in_bits {32} \
CONFIG.dat_in_bits {24} \
 ] $simple_summation_0

  # Create port connections
  connect_bd_net -net adc_2comp_0_adc_a_o [get_bd_pins signal_in] [get_bd_pins mult_gen_0/A]
  connect_bd_net -net cnt_inc_1 [get_bd_pins cnt_inc] [get_bd_pins mult_gen_1/B]
  connect_bd_net -net counter_1 [get_bd_pins counter] [get_bd_pins simple_summation_0/counter]
  connect_bd_net -net moving_average_0_out_data [get_bd_pins out_data] [get_bd_pins moving_average_0/out_data]
  connect_bd_net -net mult_gen_0_P [get_bd_pins mult_gen_0/P] [get_bd_pins simple_summation_0/in_data]
  connect_bd_net -net mult_gen_1_P [get_bd_pins moving_average_0/in_data] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins CLK] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK] [get_bd_pins simple_summation_0/clk]
  connect_bd_net -net ref_in_1 [get_bd_pins ref_in] [get_bd_pins mult_gen_0/B]
  connect_bd_net -net simple_summation_0_cnt_timer [get_bd_pins moving_average_0/clk] [get_bd_pins simple_summation_0/cnt_timer]
  connect_bd_net -net simple_summation_0_sum_out [get_bd_pins mult_gen_1/A] [get_bd_pins simple_summation_0/sum_out]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: memory_interface
proc create_hier_cell_memory_interface { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_memory_interface() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins
  create_bd_intf_pin -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 M00_AXI
  create_bd_intf_pin -mode Slave -vlnv xilinx.com:interface:aximm_rtl:1.0 S00_AXI

  # Create pins
  create_bd_pin -dir O -from 31 -to 0 amp_mult
  create_bd_pin -dir O -from 31 -to 0 avg_inc_cnt
  create_bd_pin -dir I -from 23 -to 0 ch_a_X
  create_bd_pin -dir I -from 23 -to 0 ch_a_Y
  create_bd_pin -dir I -from 23 -to 0 ch_a_amp
  create_bd_pin -dir I -from 23 -to 0 ch_a_phase
  create_bd_pin -dir I -from 23 -to 0 ch_b_X
  create_bd_pin -dir I -from 23 -to 0 ch_b_Y
  create_bd_pin -dir I -from 23 -to 0 ch_b_amp
  create_bd_pin -dir I -from 23 -to 0 ch_b_phase
  create_bd_pin -dir I -type clk clk
  create_bd_pin -dir I count_clk
  create_bd_pin -dir I -from 6 -to 0 counter
  create_bd_pin -dir O -from 6 -to 0 counter_current
  create_bd_pin -dir O -from 15 -to 0 dac_a_mult
  create_bd_pin -dir O -from 15 -to 0 dac_b_mult
  create_bd_pin -dir I dcm_locked
  create_bd_pin -dir I -type rst ext_reset_in
  create_bd_pin -dir I loop_flag
  create_bd_pin -dir O -from 15 -to 0 mod_phase_lead
  create_bd_pin -dir O -from 31 -to 0 mode_flags
  create_bd_pin -dir O -from 31 -to 0 phase_inc
  create_bd_pin -dir O -from 31 -to 0 sweep_add
  create_bd_pin -dir O -from 31 -to 0 sweep_max
  create_bd_pin -dir O -from 31 -to 0 sweep_min
  create_bd_pin -dir I sync_i

  # Create instance: axi_mem_intercon, and set properties
  set axi_mem_intercon [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_mem_intercon ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
CONFIG.NUM_SI {8} \
 ] $axi_mem_intercon

  # Create instance: ch_a_amp, and set properties
  set block_name data_padder
  set block_cell_name ch_a_amp
  if { [catch {set ch_a_amp [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ch_a_amp eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ch_a_phase, and set properties
  set block_name data_padder
  set block_cell_name ch_a_phase
  if { [catch {set ch_a_phase [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ch_a_phase eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ch_a_x, and set properties
  set block_name data_padder
  set block_cell_name ch_a_x
  if { [catch {set ch_a_x [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ch_a_x eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ch_a_y, and set properties
  set block_name data_padder
  set block_cell_name ch_a_y
  if { [catch {set ch_a_y [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ch_a_y eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ch_b_X, and set properties
  set block_name data_padder
  set block_cell_name ch_b_X
  if { [catch {set ch_b_X [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ch_b_X eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ch_b_Y, and set properties
  set block_name data_padder
  set block_cell_name ch_b_Y
  if { [catch {set ch_b_Y [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ch_b_Y eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ch_b_amp, and set properties
  set block_name data_padder
  set block_cell_name ch_b_amp
  if { [catch {set ch_b_amp [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ch_b_amp eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ch_b_phase, and set properties
  set block_name data_padder
  set block_cell_name ch_b_phase
  if { [catch {set ch_b_phase [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ch_b_phase eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: data_writer_a_amp, and set properties
  set block_name data_writer
  set block_cell_name data_writer_a_amp
  if { [catch {set data_writer_a_amp [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_writer_a_amp eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.C_M_AXI_ID_WIDTH {3} \
CONFIG.C_M_TARGET_SLAVE_BASE_ADDR {0x19000000} \
CONFIG.USER_ID {"0010"} \
 ] $data_writer_a_amp

  set_property -dict [ list \
CONFIG.SUPPORTS_NARROW_BURST {1} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /memory_interface/data_writer_a_amp/M_AXI]

  # Create instance: data_writer_a_phase, and set properties
  set block_name data_writer
  set block_cell_name data_writer_a_phase
  if { [catch {set data_writer_a_phase [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_writer_a_phase eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.C_M_AXI_ID_WIDTH {3} \
CONFIG.C_M_TARGET_SLAVE_BASE_ADDR {0x19800000} \
CONFIG.USER_ID {"0011"} \
 ] $data_writer_a_phase

  set_property -dict [ list \
CONFIG.SUPPORTS_NARROW_BURST {1} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /memory_interface/data_writer_a_phase/M_AXI]

  # Create instance: data_writer_a_x, and set properties
  set block_name data_writer
  set block_cell_name data_writer_a_x
  if { [catch {set data_writer_a_x [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_writer_a_x eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.C_M_AXI_ID_WIDTH {3} \
CONFIG.C_M_TARGET_SLAVE_BASE_ADDR {0x18000000} \
 ] $data_writer_a_x

  # Create instance: data_writer_a_y, and set properties
  set block_name data_writer
  set block_cell_name data_writer_a_y
  if { [catch {set data_writer_a_y [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_writer_a_y eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.C_M_AXI_ID_WIDTH {3} \
CONFIG.C_M_TARGET_SLAVE_BASE_ADDR {0x18800000} \
CONFIG.USER_ID {"0001"} \
 ] $data_writer_a_y

  set_property -dict [ list \
CONFIG.SUPPORTS_NARROW_BURST {1} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /memory_interface/data_writer_a_y/M_AXI]

  # Create instance: data_writer_b_amp, and set properties
  set block_name data_writer
  set block_cell_name data_writer_b_amp
  if { [catch {set data_writer_b_amp [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_writer_b_amp eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.C_M_AXI_ID_WIDTH {3} \
CONFIG.C_M_TARGET_SLAVE_BASE_ADDR {0x1B000000} \
CONFIG.USER_ID {"0110"} \
 ] $data_writer_b_amp

  set_property -dict [ list \
CONFIG.SUPPORTS_NARROW_BURST {1} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /memory_interface/data_writer_b_amp/M_AXI]

  # Create instance: data_writer_b_phase, and set properties
  set block_name data_writer
  set block_cell_name data_writer_b_phase
  if { [catch {set data_writer_b_phase [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_writer_b_phase eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.C_M_AXI_ID_WIDTH {3} \
CONFIG.C_M_TARGET_SLAVE_BASE_ADDR {0x1B800000} \
CONFIG.USER_ID {"0111"} \
 ] $data_writer_b_phase

  set_property -dict [ list \
CONFIG.SUPPORTS_NARROW_BURST {1} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /memory_interface/data_writer_b_phase/M_AXI]

  # Create instance: data_writer_b_x, and set properties
  set block_name data_writer
  set block_cell_name data_writer_b_x
  if { [catch {set data_writer_b_x [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_writer_b_x eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.C_M_AXI_ID_WIDTH {3} \
CONFIG.C_M_TARGET_SLAVE_BASE_ADDR {0x1A000000} \
CONFIG.USER_ID {"0100"} \
 ] $data_writer_b_x

  set_property -dict [ list \
CONFIG.SUPPORTS_NARROW_BURST {1} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /memory_interface/data_writer_b_x/M_AXI]

  # Create instance: data_writer_b_y, and set properties
  set block_name data_writer
  set block_cell_name data_writer_b_y
  if { [catch {set data_writer_b_y [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $data_writer_b_y eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.C_M_AXI_ID_WIDTH {3} \
CONFIG.C_M_TARGET_SLAVE_BASE_ADDR {0x1A800000} \
CONFIG.USER_ID {"0101"} \
 ] $data_writer_b_y

  set_property -dict [ list \
CONFIG.SUPPORTS_NARROW_BURST {1} \
CONFIG.NUM_READ_OUTSTANDING {2} \
CONFIG.NUM_WRITE_OUTSTANDING {2} \
CONFIG.MAX_BURST_LENGTH {256} \
 ] [get_bd_intf_pins /memory_interface/data_writer_b_y/M_AXI]

  # Create instance: highest_bit_0, and set properties
  set block_name highest_bit
  set block_cell_name highest_bit_0
  if { [catch {set highest_bit_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $highest_bit_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: mem_manager_0, and set properties
  set block_name mem_manager
  set block_cell_name mem_manager_0
  if { [catch {set mem_manager_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mem_manager_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.COUNTER_WIDTH {7} \
CONFIG.MEM_WIDTH {0x00800000} \
 ] $mem_manager_0

  # Create instance: ps_0_axi_periph, and set properties
  set ps_0_axi_periph [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 ps_0_axi_periph ]
  set_property -dict [ list \
CONFIG.NUM_MI {1} \
 ] $ps_0_axi_periph

  # Create instance: rst_clk_wiz_0_125M, and set properties
  set rst_clk_wiz_0_125M [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_clk_wiz_0_125M ]

  # Create instance: sample_clk, and set properties
  set block_name two_clk_accum
  set block_cell_name sample_clk
  if { [catch {set sample_clk [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sample_clk eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: settings
  create_hier_cell_settings $hier_obj settings

  # Create interface connections
  connect_bd_intf_net -intf_net Conn1 [get_bd_intf_pins S00_AXI] [get_bd_intf_pins ps_0_axi_periph/S00_AXI]
  connect_bd_intf_net -intf_net Conn2 [get_bd_intf_pins M00_AXI] [get_bd_intf_pins axi_mem_intercon/M00_AXI]
  connect_bd_intf_net -intf_net S00_AXI_1 [get_bd_intf_pins ps_0_axi_periph/M00_AXI] [get_bd_intf_pins settings/S00_AXI]
  connect_bd_intf_net -intf_net data_writer_0_M_AXI [get_bd_intf_pins axi_mem_intercon/S00_AXI] [get_bd_intf_pins data_writer_a_x/M_AXI]
  connect_bd_intf_net -intf_net data_writer_1_M_AXI [get_bd_intf_pins axi_mem_intercon/S01_AXI] [get_bd_intf_pins data_writer_a_y/M_AXI]
  connect_bd_intf_net -intf_net data_writer_2_M_AXI [get_bd_intf_pins axi_mem_intercon/S02_AXI] [get_bd_intf_pins data_writer_a_amp/M_AXI]
  connect_bd_intf_net -intf_net data_writer_3_M_AXI [get_bd_intf_pins axi_mem_intercon/S03_AXI] [get_bd_intf_pins data_writer_a_phase/M_AXI]
  connect_bd_intf_net -intf_net data_writer_4_M_AXI [get_bd_intf_pins axi_mem_intercon/S04_AXI] [get_bd_intf_pins data_writer_b_x/M_AXI]
  connect_bd_intf_net -intf_net data_writer_5_M_AXI [get_bd_intf_pins axi_mem_intercon/S05_AXI] [get_bd_intf_pins data_writer_b_y/M_AXI]
  connect_bd_intf_net -intf_net data_writer_6_M_AXI [get_bd_intf_pins axi_mem_intercon/S06_AXI] [get_bd_intf_pins data_writer_b_amp/M_AXI]
  connect_bd_intf_net -intf_net data_writer_7_M_AXI [get_bd_intf_pins axi_mem_intercon/S07_AXI] [get_bd_intf_pins data_writer_b_phase/M_AXI]

  # Create port connections
  connect_bd_net -net Net [get_bd_pins data_writer_a_amp/offset] [get_bd_pins data_writer_a_phase/offset] [get_bd_pins data_writer_a_x/offset] [get_bd_pins data_writer_a_y/offset] [get_bd_pins data_writer_b_amp/offset] [get_bd_pins data_writer_b_phase/offset] [get_bd_pins data_writer_b_x/offset] [get_bd_pins data_writer_b_y/offset] [get_bd_pins mem_manager_0/offset]
  connect_bd_net -net Net1 [get_bd_pins data_writer_a_amp/do_output] [get_bd_pins data_writer_a_phase/do_output] [get_bd_pins data_writer_a_x/do_output] [get_bd_pins data_writer_a_y/do_output] [get_bd_pins data_writer_b_amp/do_output] [get_bd_pins data_writer_b_phase/do_output] [get_bd_pins data_writer_b_x/do_output] [get_bd_pins data_writer_b_y/do_output] [get_bd_pins highest_bit_0/bit_out] [get_bd_pins mem_manager_0/sample]
  connect_bd_net -net ch_a_X_1 [get_bd_pins ch_a_X] [get_bd_pins ch_a_x/data_in]
  connect_bd_net -net ch_a_Y_1 [get_bd_pins ch_a_Y] [get_bd_pins ch_a_y/data_in]
  connect_bd_net -net ch_a_amp_1 [get_bd_pins ch_a_amp] [get_bd_pins ch_a_amp/data_in]
  connect_bd_net -net ch_a_phase_1 [get_bd_pins ch_a_phase] [get_bd_pins ch_a_phase/data_in]
  connect_bd_net -net ch_b_X_1 [get_bd_pins ch_b_X] [get_bd_pins ch_b_X/data_in]
  connect_bd_net -net ch_b_Y_1 [get_bd_pins ch_b_Y] [get_bd_pins ch_b_Y/data_in]
  connect_bd_net -net ch_b_amp_1 [get_bd_pins ch_b_amp] [get_bd_pins ch_b_amp/data_in]
  connect_bd_net -net ch_b_phase_1 [get_bd_pins ch_b_phase] [get_bd_pins ch_b_phase/data_in]
  connect_bd_net -net count_clk_1 [get_bd_pins count_clk] [get_bd_pins sample_clk/count_clk]
  connect_bd_net -net counter_1 [get_bd_pins counter] [get_bd_pins mem_manager_0/counter]
  connect_bd_net -net dac_a_mult_out_bus [get_bd_pins dac_a_mult] [get_bd_pins settings/dac_a_mult]
  connect_bd_net -net dac_b_mult_out_bus [get_bd_pins dac_b_mult] [get_bd_pins settings/dac_b_mult]
  connect_bd_net -net data_padder_0_data_out [get_bd_pins ch_a_x/data_out] [get_bd_pins data_writer_a_x/data_in] [get_bd_pins settings/ch_a_x]
  connect_bd_net -net data_padder_0_data_out1 [get_bd_pins ch_a_y/data_out] [get_bd_pins data_writer_a_y/data_in] [get_bd_pins settings/ch_a_Y]
  connect_bd_net -net data_padder_1_data_out [get_bd_pins ch_a_amp/data_out] [get_bd_pins data_writer_a_amp/data_in] [get_bd_pins settings/ch_a_amp]
  connect_bd_net -net data_padder_2_data_out [get_bd_pins ch_a_phase/data_out] [get_bd_pins data_writer_a_phase/data_in] [get_bd_pins settings/cha_a_phase]
  connect_bd_net -net data_padder_3_data_out [get_bd_pins ch_b_X/data_out] [get_bd_pins data_writer_b_x/data_in] [get_bd_pins settings/ch_b_X]
  connect_bd_net -net data_padder_4_data_out [get_bd_pins ch_b_Y/data_out] [get_bd_pins data_writer_b_y/data_in] [get_bd_pins settings/ch_b_Y]
  connect_bd_net -net data_padder_5_data_out [get_bd_pins ch_b_amp/data_out] [get_bd_pins data_writer_b_amp/data_in] [get_bd_pins settings/ch_b_amp]
  connect_bd_net -net data_padder_6_data_out [get_bd_pins ch_b_phase/data_out] [get_bd_pins data_writer_b_phase/data_in] [get_bd_pins settings/ch_b_phase]
  connect_bd_net -net dcm_locked_1 [get_bd_pins dcm_locked] [get_bd_pins rst_clk_wiz_0_125M/dcm_locked]
  connect_bd_net -net default_val_0_out_bus [get_bd_pins phase_inc] [get_bd_pins settings/phase_inc]
  connect_bd_net -net default_val_0_out_bus1 [get_bd_pins mode_flags] [get_bd_pins settings/mode_flags]
  connect_bd_net -net default_val_0_out_bus2 [get_bd_pins sweep_add] [get_bd_pins settings/sweep_add]
  connect_bd_net -net default_val_0_out_bus3 [get_bd_pins amp_mult] [get_bd_pins settings/amp_mult]
  connect_bd_net -net default_val_0_out_bus4 [get_bd_pins mod_phase_lead] [get_bd_pins settings/mod_phase]
  connect_bd_net -net ext_reset_in_1 [get_bd_pins ext_reset_in] [get_bd_pins rst_clk_wiz_0_125M/ext_reset_in]
  connect_bd_net -net loop_flag_1 [get_bd_pins loop_flag] [get_bd_pins mem_manager_0/loop_flag]
  connect_bd_net -net mem_manager_0_counter_min [get_bd_pins counter_current] [get_bd_pins mem_manager_0/counter_min]
  connect_bd_net -net mem_manager_0_counter_o [get_bd_pins mem_manager_0/counter_full] [get_bd_pins settings/counter]
  connect_bd_net -net mem_manager_0_end_addr [get_bd_pins mem_manager_0/end_addr] [get_bd_pins settings/offset_end]
  connect_bd_net -net mem_manager_0_start_addr [get_bd_pins mem_manager_0/start_addr] [get_bd_pins settings/offset_start]
  connect_bd_net -net out_val_0_out_bus [get_bd_pins avg_inc_cnt] [get_bd_pins settings/avg_inc_cnt]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins clk] [get_bd_pins axi_mem_intercon/ACLK] [get_bd_pins axi_mem_intercon/M00_ACLK] [get_bd_pins axi_mem_intercon/S00_ACLK] [get_bd_pins axi_mem_intercon/S01_ACLK] [get_bd_pins axi_mem_intercon/S02_ACLK] [get_bd_pins axi_mem_intercon/S03_ACLK] [get_bd_pins axi_mem_intercon/S04_ACLK] [get_bd_pins axi_mem_intercon/S05_ACLK] [get_bd_pins axi_mem_intercon/S06_ACLK] [get_bd_pins axi_mem_intercon/S07_ACLK] [get_bd_pins data_writer_a_amp/CLK] [get_bd_pins data_writer_a_phase/CLK] [get_bd_pins data_writer_a_x/CLK] [get_bd_pins data_writer_a_y/CLK] [get_bd_pins data_writer_b_amp/CLK] [get_bd_pins data_writer_b_phase/CLK] [get_bd_pins data_writer_b_x/CLK] [get_bd_pins data_writer_b_y/CLK] [get_bd_pins mem_manager_0/clk] [get_bd_pins ps_0_axi_periph/ACLK] [get_bd_pins ps_0_axi_periph/M00_ACLK] [get_bd_pins ps_0_axi_periph/S00_ACLK] [get_bd_pins rst_clk_wiz_0_125M/slowest_sync_clk] [get_bd_pins sample_clk/out_clk] [get_bd_pins settings/s00_axi_aclk]
  connect_bd_net -net rst_clk_wiz_0_125M_interconnect_aresetn [get_bd_pins axi_mem_intercon/ARESETN] [get_bd_pins ps_0_axi_periph/ARESETN] [get_bd_pins rst_clk_wiz_0_125M/interconnect_aresetn]
  connect_bd_net -net s00_axi_aresetn_1 [get_bd_pins axi_mem_intercon/M00_ARESETN] [get_bd_pins axi_mem_intercon/S00_ARESETN] [get_bd_pins axi_mem_intercon/S01_ARESETN] [get_bd_pins axi_mem_intercon/S02_ARESETN] [get_bd_pins axi_mem_intercon/S03_ARESETN] [get_bd_pins axi_mem_intercon/S04_ARESETN] [get_bd_pins axi_mem_intercon/S05_ARESETN] [get_bd_pins axi_mem_intercon/S06_ARESETN] [get_bd_pins axi_mem_intercon/S07_ARESETN] [get_bd_pins data_writer_a_amp/M_AXI_ARESETN] [get_bd_pins data_writer_a_phase/M_AXI_ARESETN] [get_bd_pins data_writer_a_x/M_AXI_ARESETN] [get_bd_pins data_writer_a_y/M_AXI_ARESETN] [get_bd_pins data_writer_b_amp/M_AXI_ARESETN] [get_bd_pins data_writer_b_phase/M_AXI_ARESETN] [get_bd_pins data_writer_b_x/M_AXI_ARESETN] [get_bd_pins data_writer_b_y/M_AXI_ARESETN] [get_bd_pins ps_0_axi_periph/M00_ARESETN] [get_bd_pins ps_0_axi_periph/S00_ARESETN] [get_bd_pins rst_clk_wiz_0_125M/peripheral_aresetn] [get_bd_pins settings/s00_axi_aresetn]
  connect_bd_net -net sample_clk_count_out [get_bd_pins highest_bit_0/bus_in] [get_bd_pins sample_clk/count_out]
  connect_bd_net -net settings_sample_cnt [get_bd_pins sample_clk/inc_in] [get_bd_pins settings/sample_cnt]
  connect_bd_net -net sweep_max_out_bus [get_bd_pins sweep_max] [get_bd_pins settings/sweep_max]
  connect_bd_net -net sweep_min_out_bus [get_bd_pins sweep_min] [get_bd_pins settings/sweep_min]
  connect_bd_net -net sync_i_1 [get_bd_pins sync_i] [get_bd_pins sample_clk/sync_i]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ch_b_processing
proc create_hier_cell_ch_b_processing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_ch_b_processing() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 23 -to 0 X_out
  create_bd_pin -dir O -from 23 -to 0 Y_out
  create_bd_pin -dir O -from 23 -to 0 amp_out
  create_bd_pin -dir I -from 31 -to 0 cnt_inc
  create_bd_pin -dir I -from 31 -to 0 counter
  create_bd_pin -dir O -from 23 -to 0 phase_out
  create_bd_pin -dir I -from 15 -to 0 ref_in_cos
  create_bd_pin -dir I -from 15 -to 0 ref_in_sin
  create_bd_pin -dir I -from 13 -to 0 -type data signal_in

  # Create instance: Lock_in_X
  create_hier_cell_Lock_in_X_1 $hier_obj Lock_in_X

  # Create instance: Lock_in_Y
  create_hier_cell_Lock_in_Y_1 $hier_obj Lock_in_Y

  # Create instance: atan, and set properties
  set atan [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 atan ]
  set_property -dict [ list \
CONFIG.Architectural_Configuration {Word_Serial} \
CONFIG.Coarse_Rotation {true} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Arc_Tan} \
CONFIG.Input_Width {24} \
CONFIG.Iterations {0} \
CONFIG.Output_Width {24} \
CONFIG.Phase_Format {Scaled_Radians} \
CONFIG.Pipelining_Mode {Optimal} \
CONFIG.Precision {0} \
CONFIG.optimize_goal {Performance} \
 ] $atan

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.optimize_goal.VALUE_SRC {DEFAULT} \
 ] $atan

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
CONFIG.A_Type {Signed} \
CONFIG.A_Width {48} \
CONFIG.B_Type {Signed} \
CONFIG.B_Value {000000000000000000000000000000000000000000000000} \
CONFIG.B_Width {48} \
CONFIG.CE {false} \
CONFIG.Latency {4} \
CONFIG.Latency_Configuration {Automatic} \
CONFIG.Out_Width {48} \
 ] $c_addsub_0

  # Create instance: comb_AXI_0, and set properties
  set block_name comb_AXI
  set block_cell_name comb_AXI_0
  if { [catch {set comb_AXI_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $comb_AXI_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.fract {1} \
 ] $comb_AXI_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OutputWidthHigh {47} \
CONFIG.PipeStages {4} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {24} \
CONFIG.PortBType {Signed} \
CONFIG.PortBWidth {24} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OutputWidthHigh {47} \
CONFIG.PipeStages {4} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {24} \
CONFIG.PortBType {Signed} \
CONFIG.PortBWidth {24} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_1

  # Create instance: out_val_0, and set properties
  set block_name out_val
  set block_cell_name out_val_0
  if { [catch {set out_val_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_val_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: sqrt, and set properties
  set sqrt [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 sqrt ]
  set_property -dict [ list \
CONFIG.Coarse_Rotation {false} \
CONFIG.Data_Format {UnsignedInteger} \
CONFIG.Functional_Selection {Square_Root} \
CONFIG.Input_Width {47} \
CONFIG.Output_Width {24} \
CONFIG.Pipelining_Mode {Optimal} \
CONFIG.optimize_goal {Performance} \
 ] $sqrt

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.optimize_goal.VALUE_SRC {DEFAULT} \
 ] $sqrt

  # Create port connections
  connect_bd_net -net Lock_in_a_X_out_data [get_bd_pins X_out] [get_bd_pins Lock_in_X/out_data] [get_bd_pins comb_AXI_0/ch_a_in] [get_bd_pins mult_gen_1/A] [get_bd_pins mult_gen_1/B]
  connect_bd_net -net Lock_in_a_Y_out_data [get_bd_pins Y_out] [get_bd_pins Lock_in_Y/out_data] [get_bd_pins comb_AXI_0/ch_b_in] [get_bd_pins mult_gen_0/A] [get_bd_pins mult_gen_0/B]
  connect_bd_net -net adc_2comp_0_adc_a_o [get_bd_pins signal_in] [get_bd_pins Lock_in_X/signal_in] [get_bd_pins Lock_in_Y/signal_in]
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins sqrt/s_axis_cartesian_tdata]
  connect_bd_net -net comb_AXI_0_out_data [get_bd_pins atan/s_axis_cartesian_tdata] [get_bd_pins comb_AXI_0/out_data]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins amp_out] [get_bd_pins sqrt/m_axis_dout_tdata]
  connect_bd_net -net cordic_1_m_axis_dout_tdata [get_bd_pins phase_out] [get_bd_pins atan/m_axis_dout_tdata]
  connect_bd_net -net counter_1 [get_bd_pins counter] [get_bd_pins Lock_in_X/counter] [get_bd_pins Lock_in_Y/counter]
  connect_bd_net -net mult_gen_0_P [get_bd_pins c_addsub_0/A] [get_bd_pins mult_gen_0/P]
  connect_bd_net -net mult_gen_1_P [get_bd_pins c_addsub_0/B] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net out_val_0_out_bus [get_bd_pins cnt_inc] [get_bd_pins Lock_in_X/cnt_inc] [get_bd_pins Lock_in_Y/cnt_inc]
  connect_bd_net -net out_val_0_out_bus1 [get_bd_pins atan/s_axis_cartesian_tvalid] [get_bd_pins out_val_0/out_bus] [get_bd_pins sqrt/s_axis_cartesian_tvalid]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins CLK] [get_bd_pins Lock_in_X/CLK] [get_bd_pins Lock_in_Y/CLK] [get_bd_pins atan/aclk] [get_bd_pins c_addsub_0/CLK] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK] [get_bd_pins sqrt/aclk]
  connect_bd_net -net ref_in_cos_1 [get_bd_pins ref_in_cos] [get_bd_pins Lock_in_X/ref_in]
  connect_bd_net -net ref_in_sin_1 [get_bd_pins ref_in_sin] [get_bd_pins Lock_in_Y/ref_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: ch_a_processing
proc create_hier_cell_ch_a_processing { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_ch_a_processing() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir I -type clk CLK
  create_bd_pin -dir O -from 23 -to 0 X_out
  create_bd_pin -dir O -from 23 -to 0 Y_out
  create_bd_pin -dir O -from 23 -to 0 amp_out
  create_bd_pin -dir I -from 31 -to 0 cnt_inc
  create_bd_pin -dir I -from 31 -to 0 counter
  create_bd_pin -dir O -from 23 -to 0 phase_out
  create_bd_pin -dir I -from 15 -to 0 ref_in_cos
  create_bd_pin -dir I -from 15 -to 0 ref_in_sin
  create_bd_pin -dir I -from 13 -to 0 -type data signal_in

  # Create instance: Lock_in_X
  create_hier_cell_Lock_in_X $hier_obj Lock_in_X

  # Create instance: Lock_in_Y
  create_hier_cell_Lock_in_Y $hier_obj Lock_in_Y

  # Create instance: atan, and set properties
  set atan [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 atan ]
  set_property -dict [ list \
CONFIG.Architectural_Configuration {Word_Serial} \
CONFIG.Coarse_Rotation {true} \
CONFIG.Data_Format {SignedFraction} \
CONFIG.Functional_Selection {Arc_Tan} \
CONFIG.Input_Width {24} \
CONFIG.Iterations {0} \
CONFIG.Output_Width {24} \
CONFIG.Phase_Format {Scaled_Radians} \
CONFIG.Pipelining_Mode {Optimal} \
CONFIG.Precision {0} \
CONFIG.optimize_goal {Performance} \
 ] $atan

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.optimize_goal.VALUE_SRC {DEFAULT} \
 ] $atan

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
CONFIG.A_Type {Signed} \
CONFIG.A_Width {48} \
CONFIG.B_Type {Signed} \
CONFIG.B_Value {000000000000000000000000000000000000000000000000} \
CONFIG.B_Width {48} \
CONFIG.CE {false} \
CONFIG.Latency {4} \
CONFIG.Latency_Configuration {Automatic} \
CONFIG.Out_Width {48} \
 ] $c_addsub_0

  # Create instance: comb_AXI_0, and set properties
  set block_name comb_AXI
  set block_cell_name comb_AXI_0
  if { [catch {set comb_AXI_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $comb_AXI_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.fract {1} \
 ] $comb_AXI_0

  # Create instance: mult_gen_0, and set properties
  set mult_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_0 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OutputWidthHigh {47} \
CONFIG.PipeStages {4} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {24} \
CONFIG.PortBType {Signed} \
CONFIG.PortBWidth {24} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OutputWidthHigh {47} \
CONFIG.PipeStages {4} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {24} \
CONFIG.PortBType {Signed} \
CONFIG.PortBWidth {24} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_1

  # Create instance: out_val_0, and set properties
  set block_name out_val
  set block_cell_name out_val_0
  if { [catch {set out_val_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_val_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: sqrt, and set properties
  set sqrt [ create_bd_cell -type ip -vlnv xilinx.com:ip:cordic:6.0 sqrt ]
  set_property -dict [ list \
CONFIG.Coarse_Rotation {false} \
CONFIG.Data_Format {UnsignedInteger} \
CONFIG.Functional_Selection {Square_Root} \
CONFIG.Input_Width {47} \
CONFIG.Output_Width {24} \
CONFIG.Pipelining_Mode {Optimal} \
CONFIG.optimize_goal {Performance} \
 ] $sqrt

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.optimize_goal.VALUE_SRC {DEFAULT} \
 ] $sqrt

  # Create port connections
  connect_bd_net -net Lock_in_a_X_out_data [get_bd_pins X_out] [get_bd_pins Lock_in_X/out_data] [get_bd_pins comb_AXI_0/ch_a_in] [get_bd_pins mult_gen_1/A] [get_bd_pins mult_gen_1/B]
  connect_bd_net -net Lock_in_a_Y_out_data [get_bd_pins Y_out] [get_bd_pins Lock_in_Y/out_data] [get_bd_pins comb_AXI_0/ch_b_in] [get_bd_pins mult_gen_0/A] [get_bd_pins mult_gen_0/B]
  connect_bd_net -net adc_2comp_0_adc_a_o [get_bd_pins signal_in] [get_bd_pins Lock_in_X/signal_in] [get_bd_pins Lock_in_Y/signal_in]
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins sqrt/s_axis_cartesian_tdata]
  connect_bd_net -net comb_AXI_0_out_data [get_bd_pins atan/s_axis_cartesian_tdata] [get_bd_pins comb_AXI_0/out_data]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins amp_out] [get_bd_pins sqrt/m_axis_dout_tdata]
  connect_bd_net -net cordic_1_m_axis_dout_tdata [get_bd_pins phase_out] [get_bd_pins atan/m_axis_dout_tdata]
  connect_bd_net -net counter_1 [get_bd_pins counter] [get_bd_pins Lock_in_X/counter] [get_bd_pins Lock_in_Y/counter]
  connect_bd_net -net mult_gen_0_P [get_bd_pins c_addsub_0/A] [get_bd_pins mult_gen_0/P]
  connect_bd_net -net mult_gen_1_P [get_bd_pins c_addsub_0/B] [get_bd_pins mult_gen_1/P]
  connect_bd_net -net out_val_0_out_bus [get_bd_pins cnt_inc] [get_bd_pins Lock_in_X/cnt_inc] [get_bd_pins Lock_in_Y/cnt_inc]
  connect_bd_net -net out_val_0_out_bus1 [get_bd_pins atan/s_axis_cartesian_tvalid] [get_bd_pins out_val_0/out_bus] [get_bd_pins sqrt/s_axis_cartesian_tvalid]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins CLK] [get_bd_pins Lock_in_X/CLK] [get_bd_pins Lock_in_Y/CLK] [get_bd_pins atan/aclk] [get_bd_pins c_addsub_0/CLK] [get_bd_pins mult_gen_0/CLK] [get_bd_pins mult_gen_1/CLK] [get_bd_pins sqrt/aclk]
  connect_bd_net -net ref_in_cos_1 [get_bd_pins ref_in_cos] [get_bd_pins Lock_in_X/ref_in]
  connect_bd_net -net ref_in_sin_1 [get_bd_pins ref_in_sin] [get_bd_pins Lock_in_Y/ref_in]

  # Restore current instance
  current_bd_instance $oldCurInst
}

# Hierarchical cell: DDS
proc create_hier_cell_DDS { parentCell nameHier } {

  variable script_folder

  if { $parentCell eq "" || $nameHier eq "" } {
     catch {common::send_msg_id "BD_TCL-102" "ERROR" create_hier_cell_DDS() - Empty argument(s)!"}
     return
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj

  # Create cell and set as current instance
  set hier_obj [create_bd_cell -type hier $nameHier]
  current_bd_instance $hier_obj

  # Create interface pins

  # Create pins
  create_bd_pin -dir O -from 15 -to 0 cos_out
  create_bd_pin -dir O -from 15 -to 0 cos_shift_out
  create_bd_pin -dir I count_clk
  create_bd_pin -dir I freq_double
  create_bd_pin -dir I -from 31 -to 0 inc_in
  create_bd_pin -dir I out_clk
  create_bd_pin -dir I -from 15 -to 0 phase_lead
  create_bd_pin -dir O -from 15 -to 0 sin_out
  create_bd_pin -dir I sync_i

  # Create instance: c_addsub_0, and set properties
  set c_addsub_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:c_addsub:12.0 c_addsub_0 ]
  set_property -dict [ list \
CONFIG.A_Type {Signed} \
CONFIG.A_Width {16} \
CONFIG.B_Type {Signed} \
CONFIG.B_Value {0000000000000000} \
CONFIG.B_Width {16} \
CONFIG.CE {false} \
CONFIG.Latency {1} \
CONFIG.Latency_Configuration {Manual} \
CONFIG.Out_Width {16} \
 ] $c_addsub_0

  # Create instance: dds_compiler_0, and set properties
  set dds_compiler_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 dds_compiler_0 ]
  set_property -dict [ list \
CONFIG.DATA_Has_TLAST {Not_Required} \
CONFIG.DDS_Clock_Rate {100} \
CONFIG.Frequency_Resolution {0.4} \
CONFIG.Has_Phase_Out {false} \
CONFIG.Latency {6} \
CONFIG.M_DATA_Has_TUSER {Not_Required} \
CONFIG.Noise_Shaping {None} \
CONFIG.Output_Frequency1 {0} \
CONFIG.Output_Width {16} \
CONFIG.PINC1 {0} \
CONFIG.Parameter_Entry {Hardware_Parameters} \
CONFIG.PartsPresent {SIN_COS_LUT_only} \
CONFIG.Phase_Increment {Streaming} \
CONFIG.Phase_Width {16} \
CONFIG.S_PHASE_Has_TUSER {Not_Required} \
 ] $dds_compiler_0

  # Create instance: dds_compiler_1, and set properties
  set dds_compiler_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:dds_compiler:6.0 dds_compiler_1 ]
  set_property -dict [ list \
CONFIG.DATA_Has_TLAST {Not_Required} \
CONFIG.DDS_Clock_Rate {100} \
CONFIG.Frequency_Resolution {0.4} \
CONFIG.Has_Phase_Out {false} \
CONFIG.Latency {6} \
CONFIG.M_DATA_Has_TUSER {Not_Required} \
CONFIG.Noise_Shaping {None} \
CONFIG.Output_Frequency1 {0} \
CONFIG.Output_Width {16} \
CONFIG.PINC1 {0} \
CONFIG.Parameter_Entry {Hardware_Parameters} \
CONFIG.PartsPresent {SIN_COS_LUT_only} \
CONFIG.Phase_Increment {Fixed} \
CONFIG.Phase_Width {16} \
CONFIG.S_PHASE_Has_TUSER {Not_Required} \
 ] $dds_compiler_1

  # Create instance: freq_doubler_0, and set properties
  set block_name freq_doubler
  set block_cell_name freq_doubler_0
  if { [catch {set freq_doubler_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $freq_doubler_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: out_val_0, and set properties
  set block_name out_val
  set block_cell_name out_val_0
  if { [catch {set out_val_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $out_val_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: phase_gen, and set properties
  set block_name two_clk_accum
  set block_cell_name phase_gen
  if { [catch {set phase_gen [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $phase_gen eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.out_bits {16} \
CONFIG.out_bus_size {16} \
 ] $phase_gen

  # Create instance: split_AXI_0, and set properties
  set block_name split_AXI
  set block_cell_name split_AXI_0
  if { [catch {set split_AXI_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $split_AXI_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.OUT_DATA_WIDTH {16} \
 ] $split_AXI_0

  # Create instance: split_AXI_1, and set properties
  set block_name split_AXI
  set block_cell_name split_AXI_1
  if { [catch {set split_AXI_1 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $split_AXI_1 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.OUT_DATA_WIDTH {16} \
 ] $split_AXI_1

  # Create port connections
  connect_bd_net -net c_addsub_0_S [get_bd_pins c_addsub_0/S] [get_bd_pins dds_compiler_1/s_axis_phase_tdata]
  connect_bd_net -net count_clk_1 [get_bd_pins count_clk] [get_bd_pins phase_gen/count_clk]
  connect_bd_net -net dds_compiler_0_m_axis_data_tdata [get_bd_pins dds_compiler_0/m_axis_data_tdata] [get_bd_pins split_AXI_0/in_data]
  connect_bd_net -net dds_compiler_1_m_axis_data_tdata [get_bd_pins dds_compiler_1/m_axis_data_tdata] [get_bd_pins split_AXI_1/in_data]
  connect_bd_net -net freq_double_1 [get_bd_pins freq_double] [get_bd_pins freq_doubler_0/freq_double]
  connect_bd_net -net freq_doubler_0_phase_out [get_bd_pins dds_compiler_0/s_axis_phase_tdata] [get_bd_pins freq_doubler_0/phase_out]
  connect_bd_net -net inc_in_1 [get_bd_pins inc_in] [get_bd_pins phase_gen/inc_in]
  connect_bd_net -net out_clk_1 [get_bd_pins out_clk] [get_bd_pins c_addsub_0/CLK] [get_bd_pins dds_compiler_0/aclk] [get_bd_pins dds_compiler_1/aclk] [get_bd_pins freq_doubler_0/clk] [get_bd_pins phase_gen/out_clk]
  connect_bd_net -net out_val_0_out_bus [get_bd_pins dds_compiler_0/s_axis_phase_tvalid] [get_bd_pins dds_compiler_1/s_axis_phase_tvalid] [get_bd_pins out_val_0/out_bus]
  connect_bd_net -net phase_gen_count_out [get_bd_pins c_addsub_0/A] [get_bd_pins freq_doubler_0/phase_in] [get_bd_pins phase_gen/count_out]
  connect_bd_net -net phase_lead_1 [get_bd_pins phase_lead] [get_bd_pins c_addsub_0/B]
  connect_bd_net -net split_AXI_0_ch_a_out [get_bd_pins cos_out] [get_bd_pins split_AXI_0/ch_a_out]
  connect_bd_net -net split_AXI_0_ch_b_out [get_bd_pins sin_out] [get_bd_pins split_AXI_0/ch_b_out]
  connect_bd_net -net split_AXI_1_ch_a_out [get_bd_pins cos_shift_out] [get_bd_pins split_AXI_1/ch_a_out]
  connect_bd_net -net sync_i_1 [get_bd_pins sync_i] [get_bd_pins phase_gen/sync_i]

  # Restore current instance
  current_bd_instance $oldCurInst
}


# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR ]
  set FIXED_IO [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO ]
  set Vaux0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux0 ]
  set Vaux1 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux1 ]
  set Vaux8 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux8 ]
  set Vaux9 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vaux9 ]
  set Vp_Vn [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_analog_io_rtl:1.0 Vp_Vn ]

  # Create ports
  set adc_clk_n_i [ create_bd_port -dir I adc_clk_n_i ]
  set adc_clk_p_i [ create_bd_port -dir I adc_clk_p_i ]
  set adc_csn_o [ create_bd_port -dir O adc_csn_o ]
  set adc_dat_a_i [ create_bd_port -dir I -from 13 -to 0 adc_dat_a_i ]
  set adc_dat_b_i [ create_bd_port -dir I -from 13 -to 0 adc_dat_b_i ]
  set adc_enc_n_o [ create_bd_port -dir O adc_enc_n_o ]
  set adc_enc_p_o [ create_bd_port -dir O adc_enc_p_o ]
  set dac_clk_o [ create_bd_port -dir O dac_clk_o ]
  set dac_dat_o [ create_bd_port -dir O -from 13 -to 0 dac_dat_o ]
  set dac_pwm_o [ create_bd_port -dir O -from 3 -to 0 dac_pwm_o ]
  set dac_rst_o [ create_bd_port -dir O dac_rst_o ]
  set dac_sel_o [ create_bd_port -dir O dac_sel_o ]
  set dac_wrt_o [ create_bd_port -dir O dac_wrt_o ]
  set daisy_n_i0 [ create_bd_port -dir I daisy_n_i0 ]
  set daisy_n_i1 [ create_bd_port -dir I daisy_n_i1 ]
  set daisy_n_o0 [ create_bd_port -dir O -from 0 -to 0 daisy_n_o0 ]
  set daisy_n_o1 [ create_bd_port -dir O -from 0 -to 0 daisy_n_o1 ]
  set daisy_p_i0 [ create_bd_port -dir I daisy_p_i0 ]
  set daisy_p_i1 [ create_bd_port -dir I daisy_p_i1 ]
  set daisy_p_o0 [ create_bd_port -dir O -from 0 -to 0 daisy_p_o0 ]
  set daisy_p_o1 [ create_bd_port -dir O -from 0 -to 0 daisy_p_o1 ]
  set exp_n_tri_io [ create_bd_port -dir IO -from 7 -to 0 exp_n_tri_io ]
  set exp_p_tri_io [ create_bd_port -dir IO -from 7 -to 0 exp_p_tri_io ]
  set led_o [ create_bd_port -dir O -from 6 -to 0 led_o ]
  set reset_rtl [ create_bd_port -dir I -type rst reset_rtl ]
  set_property -dict [ list \
CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $reset_rtl

  # Create instance: DDS
  create_hier_cell_DDS [current_bd_instance .] DDS

  # Create instance: adc_2comp_0, and set properties
  set block_name adc_2comp
  set block_cell_name adc_2comp_0
  if { [catch {set adc_2comp_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $adc_2comp_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: averaging_timer, and set properties
  set block_name two_clk_accum
  set block_cell_name averaging_timer
  if { [catch {set averaging_timer [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $averaging_timer eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: ch_a_processing
  create_hier_cell_ch_a_processing [current_bd_instance .] ch_a_processing

  # Create instance: ch_b_processing
  create_hier_cell_ch_b_processing [current_bd_instance .] ch_b_processing

  # Create instance: clk_switch_0, and set properties
  set block_name clk_switch
  set block_cell_name clk_switch_0
  if { [catch {set clk_switch_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $clk_switch_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 clk_wiz_0 ]
  set_property -dict [ list \
CONFIG.CLKFB_IN_SIGNALING {SINGLE} \
CONFIG.CLKIN1_JITTER_PS {80.0} \
CONFIG.CLKIN2_JITTER_PS {80.0} \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {119.348} \
CONFIG.CLKOUT1_PHASE_ERROR {96.948} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
CONFIG.CLKOUT2_DRIVES {BUFG} \
CONFIG.CLKOUT2_JITTER {104.759} \
CONFIG.CLKOUT2_PHASE_ERROR {96.948} \
CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {250} \
CONFIG.CLKOUT2_USED {true} \
CONFIG.CLKOUT3_DRIVES {BUFG} \
CONFIG.CLKOUT3_JITTER {119.348} \
CONFIG.CLKOUT3_PHASE_ERROR {96.948} \
CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {100.000} \
CONFIG.CLKOUT3_REQUESTED_PHASE {0.000} \
CONFIG.CLKOUT3_USED {false} \
CONFIG.CLKOUT4_DRIVES {BUFG} \
CONFIG.CLKOUT5_DRIVES {BUFG} \
CONFIG.CLKOUT6_DRIVES {BUFG} \
CONFIG.CLKOUT7_DRIVES {BUFG} \
CONFIG.CLK_OUT1_PORT {clk_out} \
CONFIG.CLK_OUT2_PORT {clk_ddr} \
CONFIG.ENABLE_CLOCK_MONITOR {false} \
CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
CONFIG.MMCM_CLKFBOUT_MULT_F {8.000} \
CONFIG.MMCM_CLKIN1_PERIOD {8.0} \
CONFIG.MMCM_CLKIN2_PERIOD {8.000} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {8.000} \
CONFIG.MMCM_CLKOUT1_DIVIDE {4} \
CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
CONFIG.MMCM_CLKOUT2_PHASE {0.000} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.NUM_OUT_CLKS {2} \
CONFIG.OVERRIDE_MMCM {false} \
CONFIG.PRIMITIVE {MMCM} \
CONFIG.PRIM_IN_FREQ {125.000} \
CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
CONFIG.SECONDARY_IN_FREQ {125} \
CONFIG.SECONDARY_SOURCE {Differential_clock_capable_pin} \
CONFIG.USE_CLKFB_STOPPED {false} \
CONFIG.USE_INCLK_SWITCHOVER {false} \
 ] $clk_wiz_0

  # Create instance: clk_wiz_1, and set properties
  set clk_wiz_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:5.3 clk_wiz_1 ]
  set_property -dict [ list \
CONFIG.CLKIN1_JITTER_PS {80.0} \
CONFIG.CLKOUT1_DRIVES {BUFG} \
CONFIG.CLKOUT1_JITTER {125.031} \
CONFIG.CLKOUT1_PHASE_ERROR {104.065} \
CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {125} \
CONFIG.CLKOUT2_DRIVES {BUFG} \
CONFIG.CLKOUT3_DRIVES {BUFG} \
CONFIG.CLKOUT4_DRIVES {BUFG} \
CONFIG.CLKOUT5_DRIVES {BUFG} \
CONFIG.CLKOUT6_DRIVES {BUFG} \
CONFIG.CLKOUT7_DRIVES {BUFG} \
CONFIG.MMCM_CLKFBOUT_MULT_F {7} \
CONFIG.MMCM_CLKIN1_PERIOD {8.0} \
CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
CONFIG.MMCM_CLKOUT0_DIVIDE_F {7} \
CONFIG.MMCM_COMPENSATION {ZHOLD} \
CONFIG.MMCM_DIVCLK_DIVIDE {1} \
CONFIG.PRIMITIVE {PLL} \
CONFIG.PRIM_IN_FREQ {125} \
CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
 ] $clk_wiz_1

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.MMCM_CLKIN2_PERIOD.VALUE_SRC {DEFAULT} \
 ] $clk_wiz_1

  # Create instance: dac_switch_0, and set properties
  set block_name dac_switch
  set block_cell_name dac_switch_0
  if { [catch {set dac_switch_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $dac_switch_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: digital_IO_connect_0, and set properties
  set block_name digital_IO_connect
  set block_cell_name digital_IO_connect_0
  if { [catch {set digital_IO_connect_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $digital_IO_connect_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.cnt_bits {7} \
 ] $digital_IO_connect_0

  # Create instance: loop_counter, and set properties
  set block_name simp_counter
  set block_cell_name loop_counter
  if { [catch {set loop_counter [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $loop_counter eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.CNT_BITS {7} \
 ] $loop_counter

  # Create instance: memory_interface
  create_hier_cell_memory_interface [current_bd_instance .] memory_interface

  # Create instance: mode_control_0, and set properties
  set block_name mode_control
  set block_cell_name mode_control_0
  if { [catch {set mode_control_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $mode_control_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.in_bits_sweep {24} \
CONFIG.in_bits_sweep_mod {24} \
CONFIG.out_bits_dac {24} \
CONFIG.phase_correct_bits {2} \
 ] $mode_control_0

  # Create instance: mult_gen_1, and set properties
  set mult_gen_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_1 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OutputWidthHigh {23} \
CONFIG.OutputWidthLow {10} \
CONFIG.PipeStages {3} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {24} \
CONFIG.PortBType {Unsigned} \
CONFIG.PortBWidth {16} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_1

  # Create instance: mult_gen_2, and set properties
  set mult_gen_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 mult_gen_2 ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OutputWidthHigh {23} \
CONFIG.OutputWidthLow {10} \
CONFIG.PipeStages {3} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {24} \
CONFIG.PortBType {Unsigned} \
CONFIG.PortBWidth {16} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $mult_gen_2

  # Create instance: ps_0, and set properties
  set ps_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 ps_0 ]
  set_property -dict [ list \
CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {125.000000} \
CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {10.000000} \
CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
CONFIG.PCW_CAN0_CAN0_IO {<Select>} \
CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
CONFIG.PCW_CAN0_GRP_CLK_IO {<Select>} \
CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN1_CAN1_IO {<Select>} \
CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
CONFIG.PCW_CAN1_GRP_CLK_IO {<Select>} \
CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_CLK0_FREQ {10000000} \
CONFIG.PCW_CLK1_FREQ {10000000} \
CONFIG.PCW_CLK2_FREQ {10000000} \
CONFIG.PCW_CLK3_FREQ {10000000} \
CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {667} \
CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
CONFIG.PCW_DDR_PRIORITY_READPORT_0 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_1 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_2 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_READPORT_3 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2 {<Select>} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3 {<Select>} \
CONFIG.PCW_DDR_RAM_HIGHADDR {0x1FFFFFFF} \
CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
CONFIG.PCW_ENET0_ENET0_IO {MIO 16 .. 27} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
CONFIG.PCW_ENET0_GRP_MDIO_IO {MIO 52 .. 53} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {8} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET0_RESET_ENABLE {0} \
CONFIG.PCW_ENET0_RESET_IO {<Select>} \
CONFIG.PCW_ENET1_ENET1_IO {<Select>} \
CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
CONFIG.PCW_ENET1_GRP_MDIO_IO {<Select>} \
CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
CONFIG.PCW_ENET1_RESET_ENABLE {0} \
CONFIG.PCW_ENET1_RESET_IO {<Select>} \
CONFIG.PCW_ENET_RESET_ENABLE {1} \
CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
CONFIG.PCW_ENET_RESET_SELECT {Share reset pin} \
CONFIG.PCW_EN_4K_TIMER {0} \
CONFIG.PCW_EN_CLK0_PORT {0} \
CONFIG.PCW_EN_CLK1_PORT {0} \
CONFIG.PCW_EN_EMIO_SPI0 {1} \
CONFIG.PCW_EN_EMIO_TTC0 {1} \
CONFIG.PCW_EN_ENET0 {1} \
CONFIG.PCW_EN_I2C0 {1} \
CONFIG.PCW_EN_QSPI {1} \
CONFIG.PCW_EN_SDIO0 {1} \
CONFIG.PCW_EN_SPI0 {1} \
CONFIG.PCW_EN_SPI1 {1} \
CONFIG.PCW_EN_TTC0 {1} \
CONFIG.PCW_EN_UART0 {1} \
CONFIG.PCW_EN_UART1 {1} \
CONFIG.PCW_EN_USB0 {1} \
CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
CONFIG.PCW_FCLK_CLK0_BUF {FALSE} \
CONFIG.PCW_FCLK_CLK1_BUF {FALSE} \
CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {125} \
CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {250} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_FTM_CTI_IN0 {<Select>} \
CONFIG.PCW_FTM_CTI_IN1 {<Select>} \
CONFIG.PCW_FTM_CTI_IN2 {<Select>} \
CONFIG.PCW_FTM_CTI_IN3 {<Select>} \
CONFIG.PCW_FTM_CTI_OUT0 {<Select>} \
CONFIG.PCW_FTM_CTI_OUT1 {<Select>} \
CONFIG.PCW_FTM_CTI_OUT2 {<Select>} \
CONFIG.PCW_FTM_CTI_OUT3 {<Select>} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {0} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO {<Select>} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {1} \
CONFIG.PCW_GPIO_MIO_GPIO_IO {MIO} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C0_GRP_INT_IO {<Select>} \
CONFIG.PCW_I2C0_I2C0_IO {MIO 50 .. 51} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_I2C0_RESET_ENABLE {0} \
CONFIG.PCW_I2C0_RESET_IO {<Select>} \
CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
CONFIG.PCW_I2C1_GRP_INT_IO {<Select>} \
CONFIG.PCW_I2C1_I2C1_IO {<Select>} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_I2C1_RESET_ENABLE {0} \
CONFIG.PCW_I2C1_RESET_IO {<Select>} \
CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {111.111115} \
CONFIG.PCW_I2C_RESET_ENABLE {1} \
CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
CONFIG.PCW_I2C_RESET_SELECT {Share reset pin} \
CONFIG.PCW_IMPORT_BOARD_PRESET {cfg/red_pitaya.xml} \
CONFIG.PCW_IOPLL_CTRL_FBDIV {30} \
CONFIG.PCW_IO_IO_PLL_FREQMHZ {1000.000} \
CONFIG.PCW_MIO_0_DIRECTION {inout} \
CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_0_PULLUP {disabled} \
CONFIG.PCW_MIO_0_SLEW {slow} \
CONFIG.PCW_MIO_10_DIRECTION {inout} \
CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_10_PULLUP {enabled} \
CONFIG.PCW_MIO_10_SLEW {slow} \
CONFIG.PCW_MIO_11_DIRECTION {inout} \
CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_11_PULLUP {enabled} \
CONFIG.PCW_MIO_11_SLEW {slow} \
CONFIG.PCW_MIO_12_DIRECTION {inout} \
CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_12_PULLUP {enabled} \
CONFIG.PCW_MIO_12_SLEW {slow} \
CONFIG.PCW_MIO_13_DIRECTION {inout} \
CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_13_PULLUP {enabled} \
CONFIG.PCW_MIO_13_SLEW {slow} \
CONFIG.PCW_MIO_14_DIRECTION {in} \
CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_14_PULLUP {enabled} \
CONFIG.PCW_MIO_14_SLEW {slow} \
CONFIG.PCW_MIO_15_DIRECTION {out} \
CONFIG.PCW_MIO_15_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_15_PULLUP {enabled} \
CONFIG.PCW_MIO_15_SLEW {slow} \
CONFIG.PCW_MIO_16_DIRECTION {out} \
CONFIG.PCW_MIO_16_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_16_PULLUP {disabled} \
CONFIG.PCW_MIO_16_SLEW {fast} \
CONFIG.PCW_MIO_17_DIRECTION {out} \
CONFIG.PCW_MIO_17_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_17_PULLUP {disabled} \
CONFIG.PCW_MIO_17_SLEW {fast} \
CONFIG.PCW_MIO_18_DIRECTION {out} \
CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_18_PULLUP {disabled} \
CONFIG.PCW_MIO_18_SLEW {fast} \
CONFIG.PCW_MIO_19_DIRECTION {out} \
CONFIG.PCW_MIO_19_IOTYPE {out} \
CONFIG.PCW_MIO_19_PULLUP {disabled} \
CONFIG.PCW_MIO_19_SLEW {fast} \
CONFIG.PCW_MIO_1_DIRECTION {out} \
CONFIG.PCW_MIO_1_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_1_PULLUP {enabled} \
CONFIG.PCW_MIO_1_SLEW {slow} \
CONFIG.PCW_MIO_20_DIRECTION {out} \
CONFIG.PCW_MIO_20_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_20_PULLUP {disabled} \
CONFIG.PCW_MIO_20_SLEW {fast} \
CONFIG.PCW_MIO_21_DIRECTION {out} \
CONFIG.PCW_MIO_21_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_21_PULLUP {disabled} \
CONFIG.PCW_MIO_21_SLEW {fast} \
CONFIG.PCW_MIO_22_DIRECTION {in} \
CONFIG.PCW_MIO_22_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_22_PULLUP {disabled} \
CONFIG.PCW_MIO_22_SLEW {fast} \
CONFIG.PCW_MIO_23_DIRECTION {in} \
CONFIG.PCW_MIO_23_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_23_PULLUP {disabled} \
CONFIG.PCW_MIO_23_SLEW {fast} \
CONFIG.PCW_MIO_24_DIRECTION {in} \
CONFIG.PCW_MIO_24_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_24_PULLUP {disabled} \
CONFIG.PCW_MIO_24_SLEW {fast} \
CONFIG.PCW_MIO_25_DIRECTION {in} \
CONFIG.PCW_MIO_25_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_25_PULLUP {disabled} \
CONFIG.PCW_MIO_25_SLEW {fast} \
CONFIG.PCW_MIO_26_DIRECTION {in} \
CONFIG.PCW_MIO_26_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_26_PULLUP {disabled} \
CONFIG.PCW_MIO_26_SLEW {fast} \
CONFIG.PCW_MIO_27_DIRECTION {in} \
CONFIG.PCW_MIO_27_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_27_PULLUP {disabled} \
CONFIG.PCW_MIO_27_SLEW {fast} \
CONFIG.PCW_MIO_28_DIRECTION {inout} \
CONFIG.PCW_MIO_28_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_28_PULLUP {enabled} \
CONFIG.PCW_MIO_28_SLEW {fast} \
CONFIG.PCW_MIO_29_DIRECTION {in} \
CONFIG.PCW_MIO_29_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_29_PULLUP {enabled} \
CONFIG.PCW_MIO_29_SLEW {fast} \
CONFIG.PCW_MIO_2_DIRECTION {inout} \
CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_2_PULLUP {disabled} \
CONFIG.PCW_MIO_2_SLEW {slow} \
CONFIG.PCW_MIO_30_DIRECTION {out} \
CONFIG.PCW_MIO_30_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_30_PULLUP {enabled} \
CONFIG.PCW_MIO_30_SLEW {fast} \
CONFIG.PCW_MIO_31_DIRECTION {in} \
CONFIG.PCW_MIO_31_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_31_PULLUP {enabled} \
CONFIG.PCW_MIO_31_SLEW {fast} \
CONFIG.PCW_MIO_32_DIRECTION {inout} \
CONFIG.PCW_MIO_32_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_32_PULLUP {enabled} \
CONFIG.PCW_MIO_32_SLEW {fast} \
CONFIG.PCW_MIO_33_DIRECTION {inout} \
CONFIG.PCW_MIO_33_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_33_PULLUP {enabled} \
CONFIG.PCW_MIO_33_SLEW {fast} \
CONFIG.PCW_MIO_34_DIRECTION {inout} \
CONFIG.PCW_MIO_34_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_34_PULLUP {enabled} \
CONFIG.PCW_MIO_34_SLEW {fast} \
CONFIG.PCW_MIO_35_DIRECTION {inout} \
CONFIG.PCW_MIO_35_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_35_PULLUP {enabled} \
CONFIG.PCW_MIO_35_SLEW {fast} \
CONFIG.PCW_MIO_36_DIRECTION {in} \
CONFIG.PCW_MIO_36_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_36_PULLUP {enabled} \
CONFIG.PCW_MIO_36_SLEW {fast} \
CONFIG.PCW_MIO_37_DIRECTION {inout} \
CONFIG.PCW_MIO_37_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_37_PULLUP {enabled} \
CONFIG.PCW_MIO_37_SLEW {fast} \
CONFIG.PCW_MIO_38_DIRECTION {inout} \
CONFIG.PCW_MIO_38_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_38_PULLUP {enabled} \
CONFIG.PCW_MIO_38_SLEW {fast} \
CONFIG.PCW_MIO_39_DIRECTION {inout} \
CONFIG.PCW_MIO_39_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_39_PULLUP {enabled} \
CONFIG.PCW_MIO_39_SLEW {fast} \
CONFIG.PCW_MIO_3_DIRECTION {inout} \
CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_3_PULLUP {disabled} \
CONFIG.PCW_MIO_3_SLEW {slow} \
CONFIG.PCW_MIO_40_DIRECTION {inout} \
CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_40_PULLUP {enabled} \
CONFIG.PCW_MIO_40_SLEW {slow} \
CONFIG.PCW_MIO_41_DIRECTION {inout} \
CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_41_PULLUP {enabled} \
CONFIG.PCW_MIO_41_SLEW {slow} \
CONFIG.PCW_MIO_42_DIRECTION {inout} \
CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_42_PULLUP {enabled} \
CONFIG.PCW_MIO_42_SLEW {slow} \
CONFIG.PCW_MIO_43_DIRECTION {inout} \
CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_43_PULLUP {enabled} \
CONFIG.PCW_MIO_43_SLEW {slow} \
CONFIG.PCW_MIO_44_DIRECTION {inout} \
CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_44_PULLUP {enabled} \
CONFIG.PCW_MIO_44_SLEW {slow} \
CONFIG.PCW_MIO_45_DIRECTION {inout} \
CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_45_PULLUP {enabled} \
CONFIG.PCW_MIO_45_SLEW {slow} \
CONFIG.PCW_MIO_46_DIRECTION {in} \
CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_46_PULLUP {enabled} \
CONFIG.PCW_MIO_46_SLEW {slow} \
CONFIG.PCW_MIO_47_DIRECTION {in} \
CONFIG.PCW_MIO_47_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_47_PULLUP {enabled} \
CONFIG.PCW_MIO_47_SLEW {slow} \
CONFIG.PCW_MIO_48_DIRECTION {out} \
CONFIG.PCW_MIO_48_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_48_PULLUP {enabled} \
CONFIG.PCW_MIO_48_SLEW {slow} \
CONFIG.PCW_MIO_49_DIRECTION {inout} \
CONFIG.PCW_MIO_49_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_49_PULLUP {enabled} \
CONFIG.PCW_MIO_49_SLEW {slow} \
CONFIG.PCW_MIO_4_DIRECTION {inout} \
CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_4_PULLUP {disabled} \
CONFIG.PCW_MIO_4_SLEW {slow} \
CONFIG.PCW_MIO_50_DIRECTION {inout} \
CONFIG.PCW_MIO_50_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_50_PULLUP {enabled} \
CONFIG.PCW_MIO_50_SLEW {slow} \
CONFIG.PCW_MIO_51_DIRECTION {inout} \
CONFIG.PCW_MIO_51_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_51_PULLUP {enabled} \
CONFIG.PCW_MIO_51_SLEW {slow} \
CONFIG.PCW_MIO_52_DIRECTION {out} \
CONFIG.PCW_MIO_52_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_52_PULLUP {enabled} \
CONFIG.PCW_MIO_52_SLEW {slow} \
CONFIG.PCW_MIO_53_DIRECTION {inout} \
CONFIG.PCW_MIO_53_IOTYPE {LVCMOS 2.5V} \
CONFIG.PCW_MIO_53_PULLUP {enabled} \
CONFIG.PCW_MIO_53_SLEW {slow} \
CONFIG.PCW_MIO_5_DIRECTION {inout} \
CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_5_PULLUP {disabled} \
CONFIG.PCW_MIO_5_SLEW {slow} \
CONFIG.PCW_MIO_6_DIRECTION {out} \
CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_6_PULLUP {disabled} \
CONFIG.PCW_MIO_6_SLEW {slow} \
CONFIG.PCW_MIO_7_DIRECTION {out} \
CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_7_PULLUP {disabled} \
CONFIG.PCW_MIO_7_SLEW {slow} \
CONFIG.PCW_MIO_8_DIRECTION {out} \
CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_8_PULLUP {disabled} \
CONFIG.PCW_MIO_8_SLEW {slow} \
CONFIG.PCW_MIO_9_DIRECTION {in} \
CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
CONFIG.PCW_MIO_9_PULLUP {enabled} \
CONFIG.PCW_MIO_9_SLEW {slow} \
CONFIG.PCW_MIO_TREE_PERIPHERALS {GPIO#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#Quad SPI Flash#GPIO#UART 1#UART 1#SPI 1#SPI 1#SPI 1#SPI 1#UART 0#UART 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#Enet 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#USB 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#SD 0#USB Reset#GPIO#I2C 0#I2C 0#Enet 0#Enet 0} \
CONFIG.PCW_MIO_TREE_SIGNALS {gpio[0]#qspi0_ss_b#qspi0_io[0]#qspi0_io[1]#qspi0_io[2]#qspi0_io[3]#qspi0_sclk#gpio[7]#tx#rx#mosi#miso#sclk#ss[0]#rx#tx#tx_clk#txd[0]#txd[1]#txd[2]#txd[3]#tx_ctl#rx_clk#rxd[0]#rxd[1]#rxd[2]#rxd[3]#rx_ctl#data[4]#dir#stp#nxt#data[0]#data[1]#data[2]#data[3]#clk#data[5]#data[6]#data[7]#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#wp#reset#gpio[49]#scl#sda#mdc#mdio} \
CONFIG.PCW_NAND_CYCLES_T_AR {1} \
CONFIG.PCW_NAND_CYCLES_T_CLR {1} \
CONFIG.PCW_NAND_CYCLES_T_RC {11} \
CONFIG.PCW_NAND_CYCLES_T_REA {1} \
CONFIG.PCW_NAND_CYCLES_T_RR {1} \
CONFIG.PCW_NAND_CYCLES_T_WC {11} \
CONFIG.PCW_NAND_CYCLES_T_WP {1} \
CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
CONFIG.PCW_NAND_GRP_D8_IO {<Select>} \
CONFIG.PCW_NAND_NAND_IO {<Select>} \
CONFIG.PCW_NAND_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_NOR_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_CS0_T_PC {1} \
CONFIG.PCW_NOR_CS0_T_RC {11} \
CONFIG.PCW_NOR_CS0_T_TR {1} \
CONFIG.PCW_NOR_CS0_T_WC {11} \
CONFIG.PCW_NOR_CS0_T_WP {1} \
CONFIG.PCW_NOR_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_CS1_T_CEOE {1} \
CONFIG.PCW_NOR_CS1_T_PC {1} \
CONFIG.PCW_NOR_CS1_T_RC {11} \
CONFIG.PCW_NOR_CS1_T_TR {1} \
CONFIG.PCW_NOR_CS1_T_WC {11} \
CONFIG.PCW_NOR_CS1_T_WP {1} \
CONFIG.PCW_NOR_CS1_WE_TIME {0} \
CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
CONFIG.PCW_NOR_GRP_A25_IO {<Select>} \
CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
CONFIG.PCW_NOR_GRP_CS0_IO {<Select>} \
CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
CONFIG.PCW_NOR_GRP_CS1_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_IO {<Select>} \
CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
CONFIG.PCW_NOR_GRP_SRAM_INT_IO {<Select>} \
CONFIG.PCW_NOR_NOR_IO {<Select>} \
CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.080} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.063} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.057} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.068} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.047} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {-0.025} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.006} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.017} \
CONFIG.PCW_PACKAGE_NAME {clg400} \
CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {5} \
CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_PJTAG_PJTAG_IO {<Select>} \
CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 2.5V} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO {<Select>} \
CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_IO1_IO {<Select>} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {1} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO {MIO 1 .. 6} \
CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
CONFIG.PCW_QSPI_GRP_SS1_IO {<Select>} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {8} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {125} \
CONFIG.PCW_QSPI_QSPI_IO {MIO 1 .. 6} \
CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD0_GRP_POW_IO {<Select>} \
CONFIG.PCW_SD0_GRP_WP_ENABLE {1} \
CONFIG.PCW_SD0_GRP_WP_IO {MIO 47} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
CONFIG.PCW_SD1_GRP_CD_IO {<Select>} \
CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
CONFIG.PCW_SD1_GRP_POW_IO {<Select>} \
CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
CONFIG.PCW_SD1_GRP_WP_IO {<Select>} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_SD1_SD1_IO {<Select>} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {10} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_SPI0_GRP_SS0_ENABLE {1} \
CONFIG.PCW_SPI0_GRP_SS0_IO {EMIO} \
CONFIG.PCW_SPI0_GRP_SS1_ENABLE {1} \
CONFIG.PCW_SPI0_GRP_SS1_IO {EMIO} \
CONFIG.PCW_SPI0_GRP_SS2_ENABLE {1} \
CONFIG.PCW_SPI0_GRP_SS2_IO {EMIO} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI0_SPI0_IO {EMIO} \
CONFIG.PCW_SPI1_GRP_SS0_ENABLE {1} \
CONFIG.PCW_SPI1_GRP_SS0_IO {MIO 13} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS1_IO {<Select>} \
CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
CONFIG.PCW_SPI1_GRP_SS2_IO {<Select>} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_SPI1_SPI1_IO {MIO 10 .. 15} \
CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {6} \
CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
CONFIG.PCW_SPI_PERIPHERAL_VALID {1} \
CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {32} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_16BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_2BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_32BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_4BIT_IO {<Select>} \
CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
CONFIG.PCW_TRACE_GRP_8BIT_IO {<Select>} \
CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TRACE_TRACE_IO {<Select>} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_TTC0_TTC0_IO {EMIO} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_TTC1_TTC1_IO {<Select>} \
CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
CONFIG.PCW_UART0_BAUD_RATE {115200} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART0_GRP_FULL_IO {<Select>} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART0_UART0_IO {MIO 14 .. 15} \
CONFIG.PCW_UART1_BAUD_RATE {115200} \
CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
CONFIG.PCW_UART1_GRP_FULL_IO {<Select>} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_UART1_UART1_IO {MIO 8 .. 9} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {10} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
CONFIG.PCW_UIPARAM_DDR_AL {0} \
CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
CONFIG.PCW_UIPARAM_DDR_BL {8} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.25} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.25} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.25} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.25} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {16 Bit} \
CONFIG.PCW_UIPARAM_DDR_CL {7} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {54.563} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {54.563} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {54.563} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {54.563} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
CONFIG.PCW_UIPARAM_DDR_CWL {6} \
CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {101.239} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {79.5025} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {60.536} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {71.7715} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.0} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {104.5365} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {70.676} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {59.1615} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {81.319} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41J256M16 RE-125} \
CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
CONFIG.PCW_UIPARAM_DDR_T_RC {48.91} \
CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE {1} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_USB0_RESET_ENABLE {1} \
CONFIG.PCW_USB0_RESET_IO {MIO 48} \
CONFIG.PCW_USB0_USB0_IO {MIO 28 .. 39} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
CONFIG.PCW_USB1_RESET_ENABLE {0} \
CONFIG.PCW_USB1_RESET_IO {<Select>} \
CONFIG.PCW_USB1_USB1_IO {<Select>} \
CONFIG.PCW_USB_RESET_ENABLE {1} \
CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
CONFIG.PCW_USB_RESET_SELECT {Share reset pin} \
CONFIG.PCW_USE_CROSS_TRIGGER {0} \
CONFIG.PCW_USE_DMA0 {0} \
CONFIG.PCW_USE_S_AXI_HP0 {1} \
CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
CONFIG.PCW_WDT_WDT_IO {<Select>} \
 ] $ps_0

  # Need to retain value_src of defaults
  set_property -dict [ list \
CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_APU_CLK_RATIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_APU_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ARMPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_CAN0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_GRP_CLK_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_GRP_CLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_CAN1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_GRP_CLK_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_GRP_CLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK0_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK1_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK2_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CLK3_FREQ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_CPU_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDRPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_DDR_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT0_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT1_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT2_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PORT3_HPR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_READPORT_3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_PRIORITY_WRITEPORT_3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_RAM_HIGHADDR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_ENET0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_GRP_MDIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_GRP_MDIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET0_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_ENET1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_GRP_MDIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_GRP_MDIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_ENET_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_4K_TIMER.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_EMIO_SPI0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_EMIO_TTC0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_ENET0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_I2C0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_QSPI.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_SDIO0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_SPI0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_SPI1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_TTC0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_UART0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_UART1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_EN_USB0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK0_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK1_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK2_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FCLK_CLK3_BUF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_IN0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_IN1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_IN2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_IN3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_OUT0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_OUT1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_OUT2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_FTM_CTI_OUT3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_EMIO_GPIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_MIO_GPIO_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_MIO_GPIO_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_GPIO_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_GRP_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_GRP_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_I2C0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C0_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_GRP_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_GRP_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_I2C1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_I2C_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_IOPLL_CTRL_FBDIV.VALUE_SRC {DEFAULT} \
CONFIG.PCW_IO_IO_PLL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_0_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_10_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_11_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_12_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_13_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_14_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_15_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_16_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_17_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_18_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_19_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_1_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_20_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_21_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_22_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_23_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_24_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_25_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_26_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_27_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_28_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_29_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_2_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_30_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_31_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_32_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_33_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_34_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_35_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_36_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_37_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_38_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_39_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_3_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_40_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_41_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_42_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_43_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_44_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_45_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_46_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_47_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_48_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_49_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_4_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_50_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_51_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_52_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_53_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_5_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_6_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_7_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_8_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_DIRECTION.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_IOTYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_PULLUP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_9_SLEW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_TREE_PERIPHERALS.VALUE_SRC {DEFAULT} \
CONFIG.PCW_MIO_TREE_SIGNALS.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_AR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_CLR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_REA.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_RR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_CYCLES_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_GRP_D8_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_GRP_D8_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_NAND_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NAND_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS0_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_CS1_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_A25_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_A25_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_CS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_CS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_GRP_SRAM_INT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_NOR_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS0_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_CEOE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_PC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_TR.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_WC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_T_WP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_NOR_SRAM_CS1_WE_TIME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PACKAGE_NAME.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PJTAG_PJTAG_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PLL_BYPASSMODE_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PRESET_BANK0_VOLTAGE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_PRESET_BANK1_VOLTAGE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_FBCLK_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_IO1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_IO1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SINGLE_SS_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_QSPI_QSPI_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_CD_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_CD_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_POW_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_POW_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_WP_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_GRP_WP_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD0_SD0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_CD_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_CD_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_POW_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_POW_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_WP_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_GRP_WP_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SD1_SD1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SDIO_PERIPHERAL_VALID.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS2_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_GRP_SS2_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI0_SPI0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS0_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS1_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS2_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_GRP_SS2_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI1_SPI1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_SPI_PERIPHERAL_VALID.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP1_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP2_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_S_AXI_HP3_DATA_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_16BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_16BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_2BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_2BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_32BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_32BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_4BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_4BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_8BIT_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_GRP_8BIT_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_INTERNAL_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TRACE_TRACE_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC0_TTC0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC1_TTC1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_BAUD_RATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_GRP_FULL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_GRP_FULL_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART0_UART0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_BAUD_RATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_GRP_FULL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_GRP_FULL_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART1_UART1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UART_PERIPHERAL_VALID.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_AL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_CWL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ECC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_PARTNO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_SPEED_BIN.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_T_FAW.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_T_RC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_T_RCD.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_T_RP.VALUE_SRC {DEFAULT} \
CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB0_USB0_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_RESET_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB1_USB1_IO.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_POLARITY.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USB_RESET_SELECT.VALUE_SRC {DEFAULT} \
CONFIG.PCW_USE_CROSS_TRIGGER.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_CLKSRC.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_ENABLE.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ.VALUE_SRC {DEFAULT} \
CONFIG.PCW_WDT_WDT_IO.VALUE_SRC {DEFAULT} \
 ] $ps_0

  # Create instance: sweep_cos_gen, and set properties
  set sweep_cos_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:mult_gen:12.0 sweep_cos_gen ]
  set_property -dict [ list \
CONFIG.Multiplier_Construction {Use_Mults} \
CONFIG.OutputWidthHigh {47} \
CONFIG.OutputWidthLow {24} \
CONFIG.PipeStages {4} \
CONFIG.PortAType {Signed} \
CONFIG.PortAWidth {16} \
CONFIG.PortBType {Unsigned} \
CONFIG.PortBWidth {32} \
CONFIG.Use_Custom_Output_Width {true} \
 ] $sweep_cos_gen

  # Create instance: sweep_gen, and set properties
  set block_name accumulator_limited
  set block_cell_name sweep_gen
  if { [catch {set sweep_gen [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $sweep_gen eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [ list \
CONFIG.accum_bits {40} \
CONFIG.out_bits {24} \
 ] $sweep_gen

  # Create instance: ttl_insert_0, and set properties
  set block_name ttl_insert
  set block_cell_name ttl_insert_0
  if { [catch {set ttl_insert_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $ttl_insert_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_0 ]

  # Create instance: util_ds_buf_2, and set properties
  set util_ds_buf_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_2 ]
  set_property -dict [ list \
CONFIG.C_BUF_TYPE {OBUFDS} \
 ] $util_ds_buf_2

  # Create instance: util_ds_buf_3, and set properties
  set util_ds_buf_3 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.1 util_ds_buf_3 ]
  set_property -dict [ list \
CONFIG.C_BUF_TYPE {OBUFDS} \
 ] $util_ds_buf_3

  # Create interface connections
  connect_bd_intf_net -intf_net memory_interface_M00_AXI [get_bd_intf_pins memory_interface/M00_AXI] [get_bd_intf_pins ps_0/S_AXI_HP0]
  connect_bd_intf_net -intf_net ps_0_DDR [get_bd_intf_ports DDR] [get_bd_intf_pins ps_0/DDR]
  connect_bd_intf_net -intf_net ps_0_FIXED_IO [get_bd_intf_ports FIXED_IO] [get_bd_intf_pins ps_0/FIXED_IO]
  connect_bd_intf_net -intf_net ps_0_M_AXI_GP0 [get_bd_intf_pins memory_interface/S00_AXI] [get_bd_intf_pins ps_0/M_AXI_GP0]

  # Create port connections
  connect_bd_net -net DDS_cos_out [get_bd_pins DDS/cos_out] [get_bd_pins ch_a_processing/ref_in_cos] [get_bd_pins ch_b_processing/ref_in_cos]
  connect_bd_net -net DDS_cos_shift_out [get_bd_pins DDS/cos_shift_out] [get_bd_pins mode_control_0/sweep_mod_raw_in] [get_bd_pins sweep_cos_gen/A]
  connect_bd_net -net DDS_sin_out [get_bd_pins DDS/sin_out] [get_bd_pins ch_a_processing/ref_in_sin] [get_bd_pins ch_b_processing/ref_in_sin]
  connect_bd_net -net Lock_in_a_X_out_data [get_bd_pins ch_a_processing/X_out] [get_bd_pins memory_interface/ch_a_X] [get_bd_pins mode_control_0/ch_a_X_in]
  connect_bd_net -net Lock_in_a_Y_out_data [get_bd_pins ch_a_processing/Y_out] [get_bd_pins memory_interface/ch_a_Y] [get_bd_pins mode_control_0/ch_a_Y_in]
  connect_bd_net -net Net [get_bd_ports exp_n_tri_io] [get_bd_pins digital_IO_connect_0/io_n]
  connect_bd_net -net Net1 [get_bd_ports exp_p_tri_io] [get_bd_pins digital_IO_connect_0/io_p]
  connect_bd_net -net accumulator_limited_0_out [get_bd_pins mode_control_0/sweep_in] [get_bd_pins sweep_gen/sweep_out]
  connect_bd_net -net adc_2comp_0_adc_a_o [get_bd_pins adc_2comp_0/adc_a_o] [get_bd_pins ch_a_processing/signal_in]
  connect_bd_net -net adc_clk_n_i_1 [get_bd_ports adc_clk_n_i] [get_bd_pins clk_wiz_0/clk_in1_n]
  connect_bd_net -net adc_clk_p_i_1 [get_bd_ports adc_clk_p_i] [get_bd_pins clk_wiz_0/clk_in1_p]
  connect_bd_net -net adc_dat_a_i_1 [get_bd_ports adc_dat_a_i] [get_bd_pins adc_2comp_0/adc_a_i]
  connect_bd_net -net adc_dat_b_i_1 [get_bd_ports adc_dat_b_i] [get_bd_pins adc_2comp_0/adc_b_i]
  connect_bd_net -net ch_b_processing_X_out [get_bd_pins ch_b_processing/X_out] [get_bd_pins memory_interface/ch_b_X] [get_bd_pins mode_control_0/ch_b_X_in]
  connect_bd_net -net ch_b_processing_Y_out [get_bd_pins ch_b_processing/Y_out] [get_bd_pins memory_interface/ch_b_Y] [get_bd_pins mode_control_0/ch_b_Y_in]
  connect_bd_net -net ch_b_processing_amp_out [get_bd_pins ch_b_processing/amp_out] [get_bd_pins memory_interface/ch_b_amp] [get_bd_pins mode_control_0/ch_b_amp_in]
  connect_bd_net -net ch_b_processing_phase_out [get_bd_pins ch_b_processing/phase_out] [get_bd_pins memory_interface/ch_b_phase] [get_bd_pins mode_control_0/ch_b_phase_in]
  connect_bd_net -net clk_buf_0_clk_o [get_bd_pins DDS/count_clk] [get_bd_pins averaging_timer/count_clk] [get_bd_pins clk_switch_0/clk_o] [get_bd_pins memory_interface/count_clk] [get_bd_pins sweep_gen/clk] [get_bd_pins util_ds_buf_3/OBUF_IN]
  connect_bd_net -net clk_wiz_0_clk_ddr [get_bd_pins clk_wiz_0/clk_ddr] [get_bd_pins dac_switch_0/ddr_clk_i]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins memory_interface/dcm_locked]
  connect_bd_net -net clk_wiz_1_clk_out1 [get_bd_pins clk_switch_0/clk_i1] [get_bd_pins clk_wiz_1/clk_out1]
  connect_bd_net -net cordic_0_m_axis_dout_tdata [get_bd_pins ch_a_processing/amp_out] [get_bd_pins memory_interface/ch_a_amp] [get_bd_pins mode_control_0/ch_a_amp_in]
  connect_bd_net -net cordic_1_m_axis_dout_tdata [get_bd_pins ch_a_processing/phase_out] [get_bd_pins memory_interface/ch_a_phase] [get_bd_pins mode_control_0/ch_a_phase_in]
  connect_bd_net -net counter_1 [get_bd_pins averaging_timer/count_out] [get_bd_pins ch_a_processing/counter] [get_bd_pins ch_b_processing/counter]
  connect_bd_net -net dac_a_mult_out_bus [get_bd_pins memory_interface/dac_a_mult] [get_bd_pins mult_gen_1/B]
  connect_bd_net -net dac_b_mult_out_bus [get_bd_pins memory_interface/dac_b_mult] [get_bd_pins mult_gen_2/B]
  connect_bd_net -net dac_switch_0_dac_data_o [get_bd_ports dac_dat_o] [get_bd_pins dac_switch_0/dac_data_o]
  connect_bd_net -net dac_switch_0_ddr_clk_o1 [get_bd_ports dac_clk_o] [get_bd_pins dac_switch_0/ddr_clk_o1]
  connect_bd_net -net dac_switch_0_ddr_clk_o2 [get_bd_ports dac_wrt_o] [get_bd_pins dac_switch_0/ddr_clk_o2]
  connect_bd_net -net dac_switch_0_select_o [get_bd_ports dac_sel_o] [get_bd_pins dac_switch_0/select_o]
  connect_bd_net -net daisy_n_i0_1 [get_bd_ports daisy_n_i0] [get_bd_pins util_ds_buf_0/IBUF_DS_N]
  connect_bd_net -net daisy_n_i1_1 [get_bd_ports daisy_n_i1] [get_bd_pins clk_wiz_1/clk_in1_n]
  connect_bd_net -net daisy_p_i0_1 [get_bd_ports daisy_p_i0] [get_bd_pins util_ds_buf_0/IBUF_DS_P]
  connect_bd_net -net daisy_p_i1_1 [get_bd_ports daisy_p_i1] [get_bd_pins clk_wiz_1/clk_in1_p]
  connect_bd_net -net default_val_0_out_bus [get_bd_pins DDS/inc_in] [get_bd_pins memory_interface/phase_inc]
  connect_bd_net -net default_val_0_out_bus1 [get_bd_pins memory_interface/mode_flags] [get_bd_pins mode_control_0/mode_flags]
  connect_bd_net -net default_val_0_out_bus2 [get_bd_pins memory_interface/sweep_add] [get_bd_pins sweep_gen/add]
  connect_bd_net -net default_val_0_out_bus3 [get_bd_pins memory_interface/amp_mult] [get_bd_pins mode_control_0/sweep_amp_in] [get_bd_pins sweep_cos_gen/B]
  connect_bd_net -net digital_IO_connect_0_cnt_o [get_bd_pins digital_IO_connect_0/cnt_o] [get_bd_pins memory_interface/counter]
  connect_bd_net -net freq_double_1 [get_bd_pins DDS/freq_double] [get_bd_pins mode_control_0/freq_double]
  connect_bd_net -net loop_counter_count [get_bd_pins digital_IO_connect_0/cnt_in] [get_bd_pins loop_counter/count]
  connect_bd_net -net memory_interface_counter_current [get_bd_ports led_o] [get_bd_pins memory_interface/counter_current]
  connect_bd_net -net mode_control_0_cl_select [get_bd_pins clk_switch_0/cl_select] [get_bd_pins mode_control_0/cl_select]
  connect_bd_net -net mode_control_0_dac_a [get_bd_pins mode_control_0/dac_a] [get_bd_pins mult_gen_1/A]
  connect_bd_net -net mode_control_0_dac_b [get_bd_pins mode_control_0/dac_b] [get_bd_pins mult_gen_2/A]
  connect_bd_net -net mode_control_0_io_slave [get_bd_pins digital_IO_connect_0/io_slave] [get_bd_pins mode_control_0/io_slave]
  connect_bd_net -net mode_control_0_sweep_const [get_bd_pins mode_control_0/sweep_const] [get_bd_pins sweep_gen/const_flag]
  connect_bd_net -net mode_control_0_sync_o [get_bd_pins DDS/sync_i] [get_bd_pins averaging_timer/sync_i] [get_bd_pins loop_counter/sync_i] [get_bd_pins memory_interface/sync_i] [get_bd_pins mode_control_0/sync_o] [get_bd_pins sweep_gen/sync] [get_bd_pins util_ds_buf_2/OBUF_IN]
  connect_bd_net -net mode_control_0_ttl_o [get_bd_pins mode_control_0/ttl_o] [get_bd_pins ttl_insert_0/ttl_in]
  connect_bd_net -net mult_gen_0_P [get_bd_pins mode_control_0/sweep_mod_in] [get_bd_pins sweep_cos_gen/P]
  connect_bd_net -net mult_gen_1_P [get_bd_pins mult_gen_1/P] [get_bd_pins ttl_insert_0/dat_in]
  connect_bd_net -net mult_gen_2_P [get_bd_pins dac_switch_0/dac_data_b] [get_bd_pins mult_gen_2/P]
  connect_bd_net -net out_val_0_out_bus [get_bd_pins averaging_timer/inc_in] [get_bd_pins ch_a_processing/cnt_inc] [get_bd_pins ch_b_processing/cnt_inc] [get_bd_pins memory_interface/avg_inc_cnt]
  connect_bd_net -net ps_0_FCLK_CLK0 [get_bd_pins DDS/out_clk] [get_bd_pins adc_2comp_0/clk] [get_bd_pins averaging_timer/out_clk] [get_bd_pins ch_a_processing/CLK] [get_bd_pins ch_b_processing/CLK] [get_bd_pins clk_switch_0/clk_i0] [get_bd_pins clk_wiz_0/clk_out] [get_bd_pins dac_switch_0/select_i] [get_bd_pins digital_IO_connect_0/clk] [get_bd_pins loop_counter/clk] [get_bd_pins memory_interface/clk] [get_bd_pins mode_control_0/clk] [get_bd_pins mult_gen_1/CLK] [get_bd_pins mult_gen_2/CLK] [get_bd_pins ps_0/M_AXI_GP0_ACLK] [get_bd_pins ps_0/S_AXI_HP0_ACLK] [get_bd_pins sweep_cos_gen/CLK] [get_bd_pins ttl_insert_0/clk]
  connect_bd_net -net ps_0_FCLK_RESET0_N [get_bd_pins memory_interface/ext_reset_in] [get_bd_pins ps_0/FCLK_RESET0_N]
  connect_bd_net -net settings_input_mod_phase_lead [get_bd_pins DDS/phase_lead] [get_bd_pins memory_interface/mod_phase_lead]
  connect_bd_net -net signal_in_1 [get_bd_pins adc_2comp_0/adc_b_o] [get_bd_pins ch_b_processing/signal_in]
  connect_bd_net -net sweep_gen_loop_o [get_bd_pins digital_IO_connect_0/loop_out] [get_bd_pins loop_counter/inc_clk] [get_bd_pins memory_interface/loop_flag] [get_bd_pins mode_control_0/sweep_loop]
  connect_bd_net -net sweep_gen_loop_o1 [get_bd_pins digital_IO_connect_0/loop_in] [get_bd_pins sweep_gen/loop_o]
  connect_bd_net -net sweep_max_out_bus [get_bd_pins memory_interface/sweep_max] [get_bd_pins sweep_gen/max]
  connect_bd_net -net sweep_min_out_bus [get_bd_pins memory_interface/sweep_min] [get_bd_pins sweep_gen/min]
  connect_bd_net -net ttl_insert_0_dat_out [get_bd_pins dac_switch_0/dac_data_a] [get_bd_pins ttl_insert_0/dat_out]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins mode_control_0/sync_i] [get_bd_pins util_ds_buf_0/IBUF_OUT]
  connect_bd_net -net util_ds_buf_2_OBUF_DS_N [get_bd_ports daisy_n_o0] [get_bd_pins util_ds_buf_2/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_2_OBUF_DS_P [get_bd_ports daisy_p_o0] [get_bd_pins util_ds_buf_2/OBUF_DS_P]
  connect_bd_net -net util_ds_buf_3_OBUF_DS_N [get_bd_ports daisy_n_o1] [get_bd_pins util_ds_buf_3/OBUF_DS_N]
  connect_bd_net -net util_ds_buf_3_OBUF_DS_P [get_bd_ports daisy_p_o1] [get_bd_pins util_ds_buf_3/OBUF_DS_P]

  # Create address segments
  create_bd_addr_seg -range 0x00001000 -offset 0x43C00000 [get_bd_addr_spaces ps_0/Data] [get_bd_addr_segs memory_interface/settings/AXI_inout_0/S00_AXI/S00_AXI_reg] SEG_AXI_inout_0_S00_AXI_reg
  create_bd_addr_seg -range 0x04000000 -offset 0x18000000 [get_bd_addr_spaces memory_interface/data_writer_a_amp/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x18000000 [get_bd_addr_spaces memory_interface/data_writer_a_phase/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x18000000 [get_bd_addr_spaces memory_interface/data_writer_a_x/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x18000000 [get_bd_addr_spaces memory_interface/data_writer_a_y/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x18000000 [get_bd_addr_spaces memory_interface/data_writer_b_amp/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x18000000 [get_bd_addr_spaces memory_interface/data_writer_b_phase/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x18000000 [get_bd_addr_spaces memory_interface/data_writer_b_x/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM
  create_bd_addr_seg -range 0x04000000 -offset 0x18000000 [get_bd_addr_spaces memory_interface/data_writer_b_y/M_AXI] [get_bd_addr_segs ps_0/S_AXI_HP0/HP0_DDR_LOWOCM] SEG_ps_0_HP0_DDR_LOWOCM

  # Perform GUI Layout
  regenerate_bd_layout -layout_string {
   guistr: "# # String gsaved with Nlview 6.6.5b  2016-09-06 bk=1.3687 VDI=39 GEI=35 GUI=JA:1.6
#  -string -flagsOSRD
preplace port daisy_p_i0 -pg 1 -y 570 -defaultsOSRD
preplace port daisy_n_i0 -pg 1 -y 590 -defaultsOSRD
preplace port adc_enc_p_o -pg 1 -y 10 -defaultsOSRD
preplace port DDR -pg 1 -y 770 -defaultsOSRD
preplace port daisy_n_i1 -pg 1 -y 1280 -defaultsOSRD
preplace port daisy_p_i1 -pg 1 -y 1300 -defaultsOSRD
preplace port Vp_Vn -pg 1 -y 70 -defaultsOSRD
preplace port reset_rtl -pg 1 -y 90 -defaultsOSRD
preplace port Vaux0 -pg 1 -y -10 -defaultsOSRD
preplace port adc_csn_o -pg 1 -y 50 -defaultsOSRD
preplace port Vaux1 -pg 1 -y 10 -defaultsOSRD
preplace port adc_clk_p_i -pg 1 -y 1080 -defaultsOSRD
preplace port dac_rst_o -pg 1 -y -10 -defaultsOSRD
preplace port dac_clk_o -pg 1 -y 690 -defaultsOSRD
preplace port adc_enc_n_o -pg 1 -y 30 -defaultsOSRD
preplace port FIXED_IO -pg 1 -y 790 -defaultsOSRD
preplace port dac_sel_o -pg 1 -y 670 -defaultsOSRD
preplace port dac_wrt_o -pg 1 -y 710 -defaultsOSRD
preplace port Vaux8 -pg 1 -y 30 -defaultsOSRD
preplace port adc_clk_n_i -pg 1 -y 1060 -defaultsOSRD
preplace port Vaux9 -pg 1 -y 50 -defaultsOSRD
preplace portBus daisy_n_o0 -pg 1 -y 1290 -defaultsOSRD
preplace portBus daisy_n_o1 -pg 1 -y 1190 -defaultsOSRD
preplace portBus adc_dat_b_i -pg 1 -y 1140 -defaultsOSRD
preplace portBus exp_p_tri_io -pg 1 -y 1030 -defaultsOSRD
preplace portBus exp_n_tri_io -pg 1 -y 1050 -defaultsOSRD
preplace portBus led_o -pg 1 -y 840 -defaultsOSRD
preplace portBus dac_pwm_o -pg 1 -y 70 -defaultsOSRD
preplace portBus daisy_p_o0 -pg 1 -y 1270 -defaultsOSRD
preplace portBus adc_dat_a_i -pg 1 -y 1160 -defaultsOSRD
preplace portBus daisy_p_o1 -pg 1 -y 1170 -defaultsOSRD
preplace portBus dac_dat_o -pg 1 -y 650 -defaultsOSRD
preplace inst ch_b_processing|Lock_in_Y|mult_gen_0 -pg 1 -lvl 1 -y 1222 -defaultsOSRD
preplace inst ch_b_processing|mult_gen_1 -pg 1 -lvl 1 -y 914 -defaultsOSRD
preplace inst digital_IO_connect_0 -pg 1 -lvl 11 -y 1020 -defaultsOSRD
preplace inst ttl_insert_0 -pg 1 -lvl 10 -y 690 -defaultsOSRD
preplace inst ch_b_processing|Lock_in_Y|mult_gen_1 -pg 1 -lvl 3 -y 1182 -defaultsOSRD
preplace inst ch_b_processing|out_val_0 -pg 1 -lvl 2 -y 884 -defaultsOSRD
preplace inst ch_b_processing|sqrt -pg 1 -lvl 3 -y 842 -defaultsOSRD
preplace inst util_ds_buf_2 -pg 1 -lvl 11 -y 1280 -defaultsOSRD
preplace inst DDS -pg 1 -lvl 2 -y 780 -defaultsOSRD
preplace inst adc_2comp_0 -pg 1 -lvl 2 -y 1140 -defaultsOSRD
preplace inst memory_interface -pg 1 -lvl 8 -y 730 -defaultsOSRD
preplace inst util_ds_buf_3 -pg 1 -lvl 11 -y 1180 -defaultsOSRD
preplace inst ch_b_processing -pg 1 -lvl 3 -y 784 -defaultsOSRD
preplace inst ch_b_processing|Lock_in_Y|moving_average_0 -pg 1 -lvl 4 -y 1192 -defaultsOSRD
preplace inst mode_control_0 -pg 1 -lvl 4 -y 430 -defaultsOSRD
preplace inst ch_b_processing|Lock_in_X -pg 1 -lvl 3 -y 1444 -defaultsOSRD
preplace inst averaging_timer -pg 1 -lvl 6 -y 1020 -defaultsOSRD
preplace inst ch_b_processing|Lock_in_Y -pg 1 -lvl 3 -y 1192 -defaultsOSRD
preplace inst mult_gen_1 -pg 1 -lvl 9 -y 620 -defaultsOSRD
preplace inst clk_switch_0 -pg 1 -lvl 5 -y 1040 -defaultsOSRD
preplace inst mult_gen_2 -pg 1 -lvl 10 -y 570 -defaultsOSRD
preplace inst sweep_gen -pg 1 -lvl 3 -y 90 -defaultsOSRD
preplace inst ch_b_processing|comb_AXI_0 -pg 1 -lvl 2 -y 994 -defaultsOSRD
preplace inst ch_b_processing|atan -pg 1 -lvl 3 -y 1002 -defaultsOSRD
preplace inst dac_switch_0 -pg 1 -lvl 11 -y 680 -defaultsOSRD
preplace inst ch_a_processing -pg 1 -lvl 7 -y 900 -defaultsOSRD
preplace inst clk_wiz_0 -pg 1 -lvl 1 -y 1070 -defaultsOSRD
preplace inst ch_b_processing|Lock_in_Y|simple_summation_0 -pg 1 -lvl 2 -y 1242 -defaultsOSRD
preplace inst ch_b_processing|c_addsub_0 -pg 1 -lvl 2 -y 784 -defaultsOSRD
preplace inst sweep_cos_gen -pg 1 -lvl 3 -y 430 -defaultsOSRD
preplace inst clk_wiz_1 -pg 1 -lvl 4 -y 1290 -defaultsOSRD
preplace inst ch_b_processing|mult_gen_0 -pg 1 -lvl 1 -y 764 -defaultsOSRD
preplace inst loop_counter -pg 1 -lvl 10 -y 1100 -defaultsOSRD
preplace inst util_ds_buf_0 -pg 1 -lvl 3 -y 570 -defaultsOSRD
preplace inst ps_0 -pg 1 -lvl 9 -y 850 -defaultsOSRD
preplace netloc default_val_0_out_bus2 1 2 7 620 190 2670J 160 NJ 160 NJ 160 NJ 160 NJ 160 6200
preplace netloc default_val_0_out_bus3 1 2 7 630 350 2790 150 NJ 150 NJ 150 NJ 150 NJ 150 6210
preplace netloc adc_clk_n_i_1 1 0 1 NJ
preplace netloc ch_b_processing|cordic_1_m_axis_dout_tdata 1 3 1 N
preplace netloc ch_b_processing|mult_gen_1_P 1 1 1 1020
preplace netloc ch_b_processing|c_addsub_0_S 1 2 1 1300
preplace netloc ch_b_processing|out_val_0_out_bus 1 0 3 NJ 1464 NJ 1464 1340
preplace netloc counter_1 1 2 5 620 250 2700J 890 NJ 890 NJ 890 5390
preplace netloc ch_b_processing_Y_out 1 3 5 2730 720 NJ 720 NJ 720 NJ 720 NJ
preplace netloc accumulator_limited_0_out 1 3 1 2780
preplace netloc ch_b_processing_amp_out 1 3 5 2750 740 NJ 740 NJ 740 NJ 740 NJ
preplace netloc util_ds_buf_2_OBUF_DS_N 1 11 1 NJ
preplace netloc ch_b_processing|comb_AXI_0_out_data 1 2 1 1330
preplace netloc ch_b_processing|Lock_in_Y|ref_in_1 1 0 1 1500
preplace netloc ch_b_processing|Lock_in_a_X_out_data 1 0 4 860 984 1020 934 1300J 924 2500
preplace netloc memory_interface_counter_current 1 8 4 6220J 980 6780J 840 NJ 840 NJ
preplace netloc util_ds_buf_2_OBUF_DS_P 1 11 1 NJ
preplace netloc loop_counter_count 1 10 1 7040
preplace netloc mult_gen_2_P 1 10 1 7090
preplace netloc ch_b_processing|Lock_in_Y|simple_summation_0_sum_out 1 2 1 1930
preplace netloc ch_b_processing|Lock_in_Y|adc_2comp_0_adc_a_o 1 0 1 N
preplace netloc ch_b_processing|Lock_in_Y|mult_gen_0_P 1 1 1 N
preplace netloc freq_double_1 1 1 4 280 340 NJ 340 2690J 210 4800
preplace netloc ps_0_FCLK_CLK0 1 1 10 240 670 590 280 2770 230 4840 230 5080 230 5420 230 5800 230 6270 230 6760 230 7100
preplace netloc mode_control_0_io_slave 1 4 7 N 500 NJ 500 NJ 500 NJ 500 NJ 500 NJ 500 7070J
preplace netloc mult_gen_0_P 1 3 1 2740
preplace netloc ps_0_FIXED_IO 1 9 3 NJ 790 NJ 790 NJ
preplace netloc util_ds_buf_0_IBUF_OUT 1 3 1 2650
preplace netloc util_ds_buf_3_OBUF_DS_N 1 11 1 NJ
preplace netloc signal_in_1 1 2 1 580
preplace netloc ch_b_processing|Lock_in_Y|counter_1 1 0 2 NJ 1292 1670
preplace netloc ch_b_processing|ref_in_cos_1 1 0 3 NJ 1504 NJ 1504 1320
preplace netloc settings_input_mod_phase_lead 1 1 8 250 -10 NJ -10 NJ -10 NJ -10 NJ -10 NJ -10 NJ -10 6240
preplace netloc ttl_insert_0_dat_out 1 10 1 7080
preplace netloc util_ds_buf_3_OBUF_DS_P 1 11 1 NJ
preplace netloc Lock_in_a_Y_out_data 1 3 5 2810 700 NJ 700 NJ 700 NJ 700 5750
preplace netloc dac_switch_0_ddr_clk_o1 1 11 1 NJ
preplace netloc DDS_cos_shift_out 1 2 2 570 500 2720J
preplace netloc clk_wiz_0_clk_ddr 1 1 10 220J 330 NJ 330 2650J 130 NJ 130 NJ 130 NJ 130 NJ 130 NJ 130 NJ 130 7120
preplace netloc dac_switch_0_ddr_clk_o2 1 11 1 NJ
preplace netloc mode_control_0_ttl_o 1 4 6 N 440 NJ 440 NJ 440 NJ 440 NJ 440 6750J
preplace netloc ps_0_M_AXI_GP0 1 7 3 5820 180 NJ 180 6720
preplace netloc default_val_0_out_bus 1 1 8 260 -20 NJ -20 NJ -20 NJ -20 NJ -20 NJ -20 NJ -20 6220
preplace netloc adc_2comp_0_adc_a_o 1 2 5 580J 660 NJ 660 NJ 660 NJ 660 5390
preplace netloc daisy_p_i1_1 1 0 4 10J 1570 NJ 1570 NJ 1570 2830J
preplace netloc ch_b_processing|Lock_in_Y|ps_0_FCLK_CLK0 1 0 3 1500 1152 1660 1152 1930
preplace netloc cordic_1_m_axis_dout_tdata 1 3 5 2840 630 NJ 630 NJ 630 NJ 630 5730
preplace netloc ch_b_processing|Lock_in_Y|simple_summation_0_cnt_timer 1 2 2 NJ 1252 2100
preplace netloc out_val_0_out_bus 1 2 7 630 670 2650J 680 NJ 680 5060 680 5410 680 5720J 1000 6190
preplace netloc sweep_max_out_bus 1 2 7 610 210 2680J 190 NJ 190 NJ 190 NJ 190 NJ 190 6180
preplace netloc mult_gen_1_P 1 9 1 6740
preplace netloc daisy_p_i0_1 1 0 3 NJ 570 NJ 570 NJ
preplace netloc mode_control_0_dac_a 1 4 5 N 360 NJ 360 NJ 360 NJ 360 6280J
preplace netloc digital_IO_connect_0_cnt_o 1 7 5 5810 470 NJ 470 NJ 470 NJ 470 7420
preplace netloc DDS_sin_out 1 2 5 600 640 NJ 640 NJ 640 NJ 640 5400J
preplace netloc mode_control_0_dac_b 1 4 6 N 380 NJ 380 NJ 380 NJ 380 NJ 380 6780J
preplace netloc Lock_in_a_X_out_data 1 3 5 2800 690 NJ 690 NJ 690 NJ 690 5740
preplace netloc ch_b_processing|Lock_in_Y|moving_average_0_out_data 1 4 1 N
preplace netloc ch_b_processing|cordic_0_m_axis_dout_tdata 1 3 1 N
preplace netloc daisy_n_i1_1 1 0 4 20J 1560 NJ 1560 NJ 1560 2710J
preplace netloc ch_b_processing|counter_1 1 0 3 NJ 1444 NJ 1444 1330
preplace netloc ch_b_processing|out_val_0_out_bus1 1 2 1 1340
preplace netloc Net 1 11 1 NJ
preplace netloc ch_b_processing|ref_in_sin_1 1 0 3 860J 1332 NJ 1332 N
preplace netloc mode_control_0_sync_o 1 1 10 270 230 580 230 2660J 140 4830 140 5090 140 NJ 140 5780 140 NJ 140 6770 140 7060J
preplace netloc Net1 1 11 1 NJ
preplace netloc sweep_gen_loop_o 1 3 9 2820 780 NJ 780 5050J 1100 NJ 1100 5790 1100 NJ 1100 6780 1010 7050J 1100 7420
preplace netloc ch_b_processing|Lock_in_Y|cnt_inc_1 1 0 3 NJ 1312 NJ 1312 1940
preplace netloc cordic_0_m_axis_dout_tdata 1 3 5 2830 670 NJ 670 NJ 670 NJ 670 5770
preplace netloc mode_control_0_cl_select 1 4 1 4820
preplace netloc DDS_cos_out 1 2 5 610 650 NJ 650 NJ 650 NJ 650 5370J
preplace netloc adc_dat_a_i_1 1 0 2 NJ 1160 220J
preplace netloc ch_b_processing|adc_2comp_0_adc_a_o 1 0 3 NJ 1424 NJ 1424 1320
preplace netloc ch_b_processing_X_out 1 3 5 2770 924 NJ 924 NJ 924 5380J 710 5760J
preplace netloc clk_wiz_0_locked 1 1 7 230J 360 NJ 360 2680J 770 NJ 770 NJ 770 NJ 770 5760
preplace netloc ps_0_DDR 1 9 3 NJ 770 NJ 770 NJ
preplace netloc ch_b_processing_phase_out 1 3 5 2760 760 NJ 760 NJ 760 NJ 760 NJ
preplace netloc memory_interface_M00_AXI 1 8 1 6260
preplace netloc clk_buf_0_clk_o 1 1 10 290 240 570 240 2710J 1180 NJ 1180 5070 1180 NJ 1180 5800 1180 NJ 1180 NJ 1180 NJ
preplace netloc clk_wiz_1_clk_out1 1 4 1 4840
preplace netloc ch_b_processing|ps_0_FCLK_CLK0 1 0 3 840 1404 1030 1404 1310
preplace netloc ps_0_FCLK_RESET0_N 1 7 3 5830 520 NJ 520 6710
preplace netloc mode_control_0_sweep_const 1 2 3 630 200 NJ 200 4810
preplace netloc dac_b_mult_out_bus 1 8 2 6280J 690 6730
preplace netloc dac_switch_0_dac_data_o 1 11 1 NJ
preplace netloc ch_b_processing|Lock_in_Y|mult_gen_1_P 1 3 1 N
preplace netloc ch_b_processing|mult_gen_0_P 1 1 1 N
preplace netloc dac_switch_0_select_o 1 11 1 NJ
preplace netloc sweep_gen_loop_o1 1 3 8 N 100 NJ 100 NJ 100 NJ 100 NJ 100 NJ 100 NJ 100 7110J
preplace netloc dac_a_mult_out_bus 1 8 1 6250
preplace netloc adc_dat_b_i_1 1 0 2 20J 1150 280J
preplace netloc ch_b_processing|Lock_in_a_Y_out_data 1 0 4 850 1084 1040 1084 NJ 1084 2510
preplace netloc adc_clk_p_i_1 1 0 1 NJ
preplace netloc daisy_n_i0_1 1 0 3 NJ 590 NJ 590 NJ
preplace netloc sweep_min_out_bus 1 2 7 590 220 NJ 220 NJ 220 NJ 220 NJ 220 NJ 220 6170
preplace netloc default_val_0_out_bus1 1 3 6 2800 120 NJ 120 NJ 120 NJ 120 NJ 120 6230
levelinfo -pg 1 -10 120 430 920 4639 4960 5240 5590 6020 6500 6910 7270 7440 -top -30 -bot 2280
levelinfo -hier ch_b_processing * 940 1170 1560 *
levelinfo -hier ch_b_processing|Lock_in_Y * 1580 1800 2020 2230 *
",
}

  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


