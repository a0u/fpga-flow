# Purge existing BDs
foreach bd [get_files -all "*.bd"] {
	remove_files ${bd}
}

# Add board-specific BDs
set board_bd_tcl [file join ${boarddir} tcl bd.tcl]
if {[file exists ${board_bd_tcl}]} {
	source ${board_bd_tcl}
}

# TODO: Handle multiple block designs
set bd [current_bd_design -quiet]
if {${bd} ne ""} {
	set obj [get_files [get_property FILE_NAME ${bd}]]

	# AR 68238 <https://www.xilinx.com/support/answers/68238.html>
	# Change BD generation mode from Out-of-Context (OOC) per IP to
	# global synthesis
	set_property synth_checkpoint_mode {None} ${obj}

	# Generate target data for BD
	generate_target all ${obj}

	# Generate and export BD user files
	export_ip_user_files -of_objects ${obj} -no_script -force

	# Generate BD diagram
#	write_bd_layout -format pdf -orientation landscape [file join ${bddir} "${bd}.pdf"]
}

exit
