create_bd_design -dir ${bddir} "${name}_ps"

# ZYNQ7 processing system IP
set cell_ps7 [create_bd_cell -type ip -vlnv "xilinx.com:ip:processing_system7" processing_system7]
set_property -dict [list \
	CONFIG.preset {ZedBoard} \
	CONFIG.PCW_USE_M_AXI_GP0 {0} \
	CONFIG.PCW_USE_S_AXI_GP0 {0} \
	CONFIG.PCW_USE_S_AXI_HP0 {1} \
	CONFIG.PCW_EN_CLK0_PORT {0} \
	] ${cell_ps7}

apply_bd_automation -rule "xilinx.com:bd_rule:processing_system7" -config [list \
	make_external "FIXED_IO, DDR" \
	apply_board_preset "1" \
	Master "Disable" \
	Slave "Disable" \
	] ${cell_ps7}

# Mixed-mode clock manager
set cell_mmcm [create_bd_cell -type ip -vlnv "xilinx.com:ip:clk_wiz" mmcm]
set_property -dict [list \
	CONFIG.PRIMITIVE {MMCM} \
	CONFIG.RESET_TYPE {ACTIVE_LOW} \
	CONFIG.CLKOUT1_USED {true} \
	CONFIG.CLKOUT2_USED {false} \
	CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
	CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
	] ${cell_mmcm}

# System clock input port
apply_bd_automation -rule "xilinx.com:bd_rule:board" \
	-config {Board_Interface "sys_clock"} [get_bd_pins "mmcm/clk_in1"]

# Host clock output port
set port_hostclk [create_bd_port -dir O -type clk host_clock]
connect_bd_net [get_bd_pins "mmcm/clk_out1"] ${port_hostclk}

# Processor system reset
set cell_reset [create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset proc_sys_reset]
set_property -dict [list \
	CONFIG.C_NUM_BUS_RST {1} \
	CONFIG.C_NUM_PERP_RST {1} \
	CONFIG.C_NUM_INTERCONNECT_ARESETN {1} \
	CONFIG.C_NUM_PERP_ARESETN {1} \
	] ${cell_reset}

apply_bd_automation -rule "xilinx.com:bd_rule:clkrst" \
	-config {Clk "/mmcm/clk_out1"} [get_bd_pins "proc_sys_reset/slowest_sync_clk"]

connect_bd_net \
	[get_bd_pins "processing_system7/FCLK_RESET0_N"] \
	[get_bd_pins "mmcm/resetn"] \
	[get_bd_pins "proc_sys_reset/ext_reset_in"]
connect_bd_net \
	[get_bd_pins "mmcm/locked"] \
	[get_bd_pins "proc_sys_reset/dcm_locked"]

# Host reset output port
set port_hostrst [create_bd_port -dir O -type rst host_reset]
connect_bd_net [get_bd_pins "proc_sys_reset/mb_reset"] ${port_hostrst}

# AXI memory interface port
set intf_axi_mem [create_bd_intf_port -mode Slave -vlnv "xilinx.com:interface:aximm_rtl:1.0" axi_mem]
set_property -dict [list \
	CONFIG.PROTOCOL {AXI4} \
	CONFIG.ID_WIDTH {6} \
	CONFIG.DATA_WIDTH {64} \
	CONFIG.MAX_BURST_LENGTH {16} \
	] ${intf_axi_mem}

set_property CONFIG.ASSOCIATED_BUSIF "axi_mem" ${port_hostclk}

apply_bd_automation -rule "xilinx.com:bd_rule:axi4" -config [list \
	Clk_master {Auto} \
	Clk_slave {/mmcm/clk_out1} \
	Clk_xbar {Auto} \
	Master {/axi_mem} \
	Slave {/processing_system7/S_AXI_HP0} \
	intc_ip {Auto} \
	master_apm {0} \
	] [get_bd_intf_pins "processing_system7/S_AXI_HP0"]

# Address segments
#create_bd_addr_seg -range 0x20000000 -offset 0x00000000 \
	[get_bd_addr_spaces "axi_mem"] \
	[get_bd_addr_segs "processing_system7/S_AXI_HP0/HP0_DDR_LOWOCM"] \
	seg_hp0_ddr

validate_bd_design
save_bd_design
