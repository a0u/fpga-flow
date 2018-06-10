set top "top"

set scriptdir [file dirname [info script]]
set commondir [file dirname ${scriptdir}]
set boarddir [file join [file dirname ${commondir}] ${name}]

set projdir [file join [pwd] project ${name}]
set bddir [file join ${projdir} bd]
set ipdir [file join ${projdir} ip src]
set ipuserdir [file join ${projdir} ip user_files]
set ckptdir [file join ${projdir} checkpoint]
set rptdir [file join ${projdir} report]

set projfile [file join ${projdir} "${name}.xpr"]
if {[file exists ${projfile}]} {
	open_project ${projfile}
} else {
	create_project -part ${part_fpga} -force ${name} ${projdir}
}
#create_project -part ${part_fpga} -in_memory ${name}

set obj [current_project]
set_property BOARD_PART ${part_board} ${obj}
set_property TARGET_LANGUAGE {Verilog} ${obj}
set_property DEFAULT_LIB {xil_defaultlib} ${obj}

set_property IP_REPO_PATHS ${ipdir} ${obj}
set_property IP.USER_FILES_DIR ${ipuserdir} ${obj}

# Add HDL source files
add_files -fileset [current_fileset] [file join ${boarddir} hdl]

# Add constraint files
add_files -fileset [current_fileset -constrset] [file join ${boarddir} xdc]
