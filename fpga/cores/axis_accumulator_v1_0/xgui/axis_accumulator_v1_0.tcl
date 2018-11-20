# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  set AXIS_TDATA_SIGNED [ipgui::add_param $IPINST -name "AXIS_TDATA_SIGNED" -parent ${Page_0}]
  set_property tooltip {If TRUE, the S_AXIS data are signed values.} ${AXIS_TDATA_SIGNED}
  set CNTR_WIDTH [ipgui::add_param $IPINST -name "CNTR_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of the counter register.} ${CNTR_WIDTH}
  set CONTINUOUS [ipgui::add_param $IPINST -name "CONTINUOUS" -parent ${Page_0}]
  set_property tooltip {If TRUE, accumulator runs continuously.} ${CONTINUOUS}
  set M_AXIS_TDATA_WIDTH [ipgui::add_param $IPINST -name "M_AXIS_TDATA_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of the M_AXIS data buses.} ${M_AXIS_TDATA_WIDTH}
  set S_AXIS_TDATA_WIDTH [ipgui::add_param $IPINST -name "S_AXIS_TDATA_WIDTH" -parent ${Page_0}]
  set_property tooltip {Width of the S_AXIS data buses.} ${S_AXIS_TDATA_WIDTH}


}

proc update_PARAM_VALUE.AXIS_TDATA_SIGNED { PARAM_VALUE.AXIS_TDATA_SIGNED } {
	# Procedure called to update AXIS_TDATA_SIGNED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIS_TDATA_SIGNED { PARAM_VALUE.AXIS_TDATA_SIGNED } {
	# Procedure called to validate AXIS_TDATA_SIGNED
	return true
}

proc update_PARAM_VALUE.CNTR_WIDTH { PARAM_VALUE.CNTR_WIDTH } {
	# Procedure called to update CNTR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CNTR_WIDTH { PARAM_VALUE.CNTR_WIDTH } {
	# Procedure called to validate CNTR_WIDTH
	return true
}

proc update_PARAM_VALUE.CONTINUOUS { PARAM_VALUE.CONTINUOUS } {
	# Procedure called to update CONTINUOUS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CONTINUOUS { PARAM_VALUE.CONTINUOUS } {
	# Procedure called to validate CONTINUOUS
	return true
}

proc update_PARAM_VALUE.M_AXIS_TDATA_WIDTH { PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to update M_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_AXIS_TDATA_WIDTH { PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to validate M_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.S_AXIS_TDATA_WIDTH { PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to update S_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_AXIS_TDATA_WIDTH { PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to validate S_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH PARAM_VALUE.S_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.S_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH PARAM_VALUE.M_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.M_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.M_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.CNTR_WIDTH { MODELPARAM_VALUE.CNTR_WIDTH PARAM_VALUE.CNTR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CNTR_WIDTH}] ${MODELPARAM_VALUE.CNTR_WIDTH}
}

proc update_MODELPARAM_VALUE.AXIS_TDATA_SIGNED { MODELPARAM_VALUE.AXIS_TDATA_SIGNED PARAM_VALUE.AXIS_TDATA_SIGNED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIS_TDATA_SIGNED}] ${MODELPARAM_VALUE.AXIS_TDATA_SIGNED}
}

proc update_MODELPARAM_VALUE.CONTINUOUS { MODELPARAM_VALUE.CONTINUOUS PARAM_VALUE.CONTINUOUS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CONTINUOUS}] ${MODELPARAM_VALUE.CONTINUOUS}
}

