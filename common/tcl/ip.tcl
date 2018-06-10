file mkdir ${ipdir}

# Rebuild IP catalog index
update_ip_catalog -rebuild

# Add board-specific IP blocks
set board_ip_tcl [file join ${boarddir} tcl ip.tcl]
if {[file exists ${board_ip_tcl}]} {
	source ${board_ip_tcl}
}

# AR 58526 <http://www.xilinx.com/support/answers/58526.html>
#foreach xci [get_files -all "*.xci"] {
#	set_property generate_synth_checkpoint false ${xci}
#}

set obj [get_ips]

# Generate target data for included IP blocks
generate_target all ${obj}

# Generate and export IP user files
export_ip_user_files -of_objects ${obj} -no_script -force

exit
