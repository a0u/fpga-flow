file mkdir ${rptdir}

report_datasheet -file [file join ${rptdir} "datasheet.txt"]

set rptfile [file join ${rptdir} "utilization.txt"]
report_utilization -hierarchical -file ${rptfile}
report_clock_utilization -file ${rptfile} -append
report_ram_utilization -file ${rptfile} -append

report_timing_summary -file [file join ${rptdir} "timing.txt"] -max_paths 25
report_high_fanout_nets -file [file join ${rptdir} "fanout.txt"] -timing -load_types -max_nets 25

report_drc -file [file join ${rptdir} "drc.txt"]

report_io -file [file join ${rptdir} "io.txt"]
report_clocks -file [file join ${rptdir} "clocks.txt"]
