return

# ZYNQ7 Processing System IP
create_ip -vendor xilinx.com -library ip -name processing_system7 -module_name processing_system7 -dir ${ipdir} -force
set_property -dict [list \
	CONFIG.preset {ZedBoard} \
	CONFIG.PCW_USE_M_AXI_GP0 {0} \
	CONFIG.PCW_USE_S_AXI_GP0 {0} \
	CONFIG.PCW_USE_S_AXI_HP0 {1} \
	] [get_ips processing_system7]

# AXI4 to AXI3 Protocol Converter
create_ip -vendor xilinx.com -library ip -name axi_protocol_converter -module_name axi_protocol_converter -dir ${ipdir} -force
set_property -dict [list \
	CONFIG.MI_PROTOCOL {AXI3} \
	CONFIG.TRANSLATION_MODE {2} \
	CONFIG.ID_WIDTH {6} \
	CONFIG.DATA_WIDTH {64} \
	] [get_ips axi_protocol_converter]
