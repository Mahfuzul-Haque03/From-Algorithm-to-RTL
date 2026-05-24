file mkdir reports

set PART   "xc7z020clg484-1"
set TOP    "main"
set DESIGN "gelu"

set RTL_FILES [list \
  "$::env(HOME)/ReadySv/GeLU/Output/gelu.sv" \
]

puts "Using TOP=$TOP PART=$PART"
puts "RTL_FILES=$RTL_FILES"

read_verilog -sv $RTL_FILES

# --- Real synthesis (opens a synthesized design) ---
synth_design -top $TOP -part $PART

# --- Apply timing constraints on the OPEN design (this is key) ---
# Change 10.000 if you want a different target period.
if {[llength [get_ports clk]] > 0} {
  create_clock -name clk -period 10.000 [get_ports clk]
} else {
  puts "WARNING: no port named clk; skipping create_clock"
}

if {[llength [get_ports reset]] > 0} {
  set_false_path -from [get_ports reset]
}


# Save clock report (for Fmax computation)
report_clocks -file reports/${DESIGN}_clocks.rpt

# Post-synth reports
write_checkpoint -force reports/${DESIGN}_post_synth.dcp
report_utilization -hierarchical -file reports/${DESIGN}_util_synth_hier.rpt
report_utilization               -file reports/${DESIGN}_util_synth.rpt
report_timing_summary            -file reports/${DESIGN}_timing_synth.rpt

# --- Implementation ---
opt_design
place_design
route_design

# Post-route reports
write_checkpoint -force reports/${DESIGN}_post_route.dcp
report_utilization -hierarchical -file reports/${DESIGN}_util_route_hier.rpt
report_utilization               -file reports/${DESIGN}_util_route.rpt
report_timing_summary            -file reports/${DESIGN}_timing_route.rpt
report_power                     -file reports/${DESIGN}_power_route_est.rpt

quit
