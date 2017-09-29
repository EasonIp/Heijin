## Generated SDC file "Delay_monster.sdc"

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

## DATE    "Thu Jan 03 11:27:14 2013"

##
## DEVICE  "EP2C8Q208I8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {CLK} -period 10.000 -waveform { 0.000 5.000 } [get_ports {CLK}]


#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************



#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************

set_multicycle_path -setup -end -from [get_cells {rA[0] rA[1] rA[2] rA[3] rA[4] rA[5] rA[6] rA[7] rB[0] rB[1] rB[2] rB[3] rB[4] rB[5] rB[6] rB[7]}] -to [get_cells {rProduct[0] rProduct[1] rProduct[2] rProduct[3] rProduct[4] rProduct[5] rProduct[6] rProduct[7] rProduct[8] rProduct[9] rProduct[10] rProduct[11] rProduct[12] rProduct[13] rProduct[14] rProduct[15]}] 4
set_multicycle_path -hold -end -from [get_cells {rA[0] rA[1] rA[2] rA[3] rA[4] rA[5] rA[6] rA[7] rB[0] rB[1] rB[2] rB[3] rB[4] rB[5] rB[6] rB[7]}] -to [get_cells {rProduct[0] rProduct[1] rProduct[2] rProduct[3] rProduct[4] rProduct[5] rProduct[6] rProduct[7] rProduct[8] rProduct[9] rProduct[10] rProduct[11] rProduct[12] rProduct[13] rProduct[14] rProduct[15]}] 3


#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

