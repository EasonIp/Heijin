module vga_savemod
(
    input CLOCK, RESET,
	 input [13:0]iAddr,
	 output [15:0]oData
);
    (* ramstyle = "no_rw_check , m9k" , ram_init_file = "pikachu_128x96_16_msb.mif" *) 
	 reg [15:0] RAM[12287:0]; 
	 reg [15:0]D1;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      D1 <= 16'd0;
		  else 
		      D1 <= RAM[ iAddr ];
	 
	 assign oData = D1;

endmodule
