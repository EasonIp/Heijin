## Generated SDC file "center_module.sdc"

## Copyright (C) 1991-2009 Altera Corporation
## Your use of Altera Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Altera Program License 
## Subscription Agreement, Altera MegaCore Function License 
## Agreement, or other applicable license agreement, including, 
## without limitation, that your use is for the sole purpose of 
## programming logic devices manufactured by Altera and sold by 
## Altera or its authorized distributors.  Please refer to the 
## applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus II"
## VERSION "Version 9.1 Build 222 10/21/2009 SJ Full Version"

## DATE    "Wed Jan 23 15:33:14 2013"

##
## DEVICE  "EP2C8Q208C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {fpga_clk} -period 10.000 -waveform { 0.000 5.000 } [get_ports {CLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {ext_clk} -source [get_ports {CLK}] -master_clock {fpga_clk} [get_ports {ext_clk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************

set_clock_latency -source   1.000 [get_clocks {fpga_clk}]
set_clock_latency -source   2.000 [get_clocks {ext_clk}]


#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {ext_clk}]  4.500 [get_ports {Data[0]}]
set_input_delay -add_delay -min -clock [get_clocks {ext_clk}]  2.500 [get_ports {Data[0]}]
set_input_delay -add_delay -max -clock [get_clocks {ext_clk}]  4.500 [get_ports {Data[1]}]
set_input_delay -add_delay -min -clock [get_clocks {ext_clk}]  2.500 [get_ports {Data[1]}]
set_input_delay -add_delay -max -clock [get_clocks {ext_clk}]  4.500 [get_ports {Data[2]}]
set_input_delay -add_delay -min -clock [get_clocks {ext_clk}]  2.500 [get_ports {Data[2]}]
set_input_delay -add_delay -max -clock [get_clocks {ext_clk}]  4.500 [get_ports {Data[3]}]
set_input_delay -add_delay -min -clock [get_clocks {ext_clk}]  2.500 [get_ports {Data[3]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {ext_clk}]  4.500 [get_ports {Data[0]}]
set_output_delay -add_delay -min -clock [get_clocks {ext_clk}]  1.500 [get_ports {Data[0]}]
set_output_delay -add_delay -max -clock [get_clocks {ext_clk}]  4.500 [get_ports {Data[1]}]
set_output_delay -add_delay -min -clock [get_clocks {ext_clk}]  1.500 [get_ports {Data[1]}]
set_output_delay -add_delay -max -clock [get_clocks {ext_clk}]  4.500 [get_ports {Data[2]}]
set_output_delay -add_delay -min -clock [get_clocks {ext_clk}]  1.500 [get_ports {Data[2]}]
set_output_delay -add_delay -max -clock [get_clocks {ext_clk}]  4.500 [get_ports {Data[3]}]
set_output_delay -add_delay -min -clock [get_clocks {ext_clk}]  1.500 [get_ports {Data[3]}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

