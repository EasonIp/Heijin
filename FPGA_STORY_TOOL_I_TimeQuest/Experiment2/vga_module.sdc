create_clock -name {CLK} -period 50.000 -waveform { 0.000 25.000 } [get_ports {CLK}]

derive_pll_clocks
derive_clock_uncertainty
