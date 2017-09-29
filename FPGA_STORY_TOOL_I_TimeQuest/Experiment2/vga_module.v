module vga_module 
(
     input CLK,
	 input RSTn,
	 output HSYNC,
	 output VSYNC,
	 output [2:0]RGB_Sig
);

    /****************************/
	 
	 wire CLK_40Mhz;
	 
	 pll_module	U0 
	 (
	    .inclk0 ( CLK ),    // in 20MHz
	    .c0 ( CLK_40Mhz )   // output 40Mhz
	 );

    /****************************/
	 
	 wire [10:0]qC1;
	 wire [9:0]qC2;
	 wire U1_HSYNC, U1_VSYNC;
	 
	 sync_module U1
	 (
	      .CLK( CLK_40Mhz ),   // input - from U0
		  .RSTn( RSTn ),    
		  .qC1( qC1 ),         // output - to U3
		  .qC2( qC2 ),         // output - to U3
		  .HSYNC( U1_HSYNC ),  // output - to bypass register
		  .VSYNC( U1_VSYNC )   // output - to bypass register
	 );
	 
	 /****************************/
	 
	 wire [7:0]ROM_Data; 
	 
	 rom_module U2
	 (  
	    .clock( CLK_40Mhz ),  // input - from U0
	    .address( ROM_Addr ), // input - from U3
	    .q( ROM_Data )        // output - to U3
	 );
	 
	 /***************************/
	 
	 wire [10:0]ROM_Addr;
	 
	 vga_control_module U3
	 (
	      .CLK( CLK_40Mhz ),     // input - from U0
		  .RSTn( RSTn ), 
		  .qC1( qC1 ),           // input - from U1
		  .qC2( qC2 ),           // input - from U1
		  .ROM_Addr( ROM_Addr ), // output - to U2
		  .ROM_Data( ROM_Data ), // input - from U2
		  .RGB_Sig( RGB_Sig )    // output - to top
	 );
	 
	 /***************************/ 
	 
	 // sync. sync_module and vga_control_module
	 // vga_control_module use 3 clock than sync_module
	 // well, sync_module bypass-ing 3 shift-reg.
	 
	 reg [1:0]rBy1,rBy2,rBy3;
	 
	 always @ ( posedge CLK_40Mhz or negedge RSTn )
	     if( !RSTn )
		      begin
				     rBy1 <= 2'b11;
					 rBy2 <= 2'b11;
					 rBy3 <= 2'b11;
				end
		  else 
		      begin
				     rBy1 <= { U1_HSYNC, U1_VSYNC };
					 rBy2 <= rBy1;
					 rBy3 <= rBy2;
				end
				
	/***************************/
	
	assign { HSYNC, VSYNC } = rBy3; 
	
	/***************************/

endmodule
