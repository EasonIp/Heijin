## Generated SDC file "sdram_demo3.sdc"

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

## DATE    "Thu Jan 24 16:51:08 2013"

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

create_clock -name {CLK} -period 50.000 -waveform { 0.000 25.000 } [get_ports {CLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************

derive_pll_clocks
create_generated_clock -name SDRAM_CLK -source [get_nets {U1|altpll_component|_clk1}] [get_ports {SDRAM_CLK}]


#**************************************************************
# Set Clock Latency
#**************************************************************

set_clock_latency -source   0.022 [get_clocks {CLK}]
set_clock_latency -source   0.158 [get_clocks {SDRAM_CLK}]


#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[0]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[0]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[1]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[1]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[2]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[2]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[3]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[3]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[4]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[4]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[5]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[5]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[6]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[6]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[7]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[7]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[8]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[8]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[9]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[9]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[10]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[10]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[11]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[11]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[12]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[12]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[13]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[13]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[14]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[14]}]
set_input_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[15]}]
set_input_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[15]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[0]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[0]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[1]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[1]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[2]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[2]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[3]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[3]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[4]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[4]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[5]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[5]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[6]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[6]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[7]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[7]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[8]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[8]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[9]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[9]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[10]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[10]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[11]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[11]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[12]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[12]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.218 [get_ports {SDRAM_BA[13]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.172 [get_ports {SDRAM_BA[13]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.227 [get_ports {SDRAM_CMD[0]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.156 [get_ports {SDRAM_CMD[0]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.227 [get_ports {SDRAM_CMD[1]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.156 [get_ports {SDRAM_CMD[1]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.227 [get_ports {SDRAM_CMD[2]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.156 [get_ports {SDRAM_CMD[2]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.227 [get_ports {SDRAM_CMD[3]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.156 [get_ports {SDRAM_CMD[3]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.227 [get_ports {SDRAM_CMD[4]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.156 [get_ports {SDRAM_CMD[4]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[0]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[0]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[1]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[1]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[2]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[2]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[3]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[3]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[4]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[4]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[5]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[5]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[6]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[6]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[7]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[7]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[8]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[8]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[9]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[9]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[10]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[10]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[11]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[11]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[12]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[12]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[13]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[13]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[14]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[14]}]
set_output_delay -add_delay -max -clock [get_clocks {SDRAM_CLK}]  0.136 [get_ports {SDRAM_DATA[15]}]
set_output_delay -add_delay -min -clock [get_clocks {SDRAM_CLK}]  0.068 [get_ports {SDRAM_DATA[15]}]
set_output_delay -add_delay  -clock [get_clocks {SDRAM_CLK}]  0.149 [get_ports {SDRAM_LDQM}]
set_output_delay -add_delay  -clock [get_clocks {SDRAM_CLK}]  0.152 [get_ports {SDRAM_UDQM}]


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

