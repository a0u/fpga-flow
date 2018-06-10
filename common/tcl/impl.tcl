file mkdir ${ckptdir}

# Synthesis
synth_design -top ${top} -flatten_hierarchy rebuilt
write_checkpoint -force [file join ${ckptdir} synth]

# Optimization
opt_design
write_checkpoint -force [file join ${ckptdir} opt]

# Placement
place_design -directive Explore
phys_opt_design -directive Explore
power_opt_design
write_checkpoint -force [file join ${ckptdir} place]

# Routing
route_design -directive Explore
phys_opt_design -directive Explore
write_checkpoint -force [file join ${ckptdir} route]

# Outputs
write_bitstream -force [file join ${projdir} "${name}.bit"]
write_verilog -mode timesim -force [file join ${projdir} "${name}.v"]
write_sdf -force [file join ${projdir} "${name}.sdf"]

# Reports
source [file join ${scriptdir} rpt.tcl]
