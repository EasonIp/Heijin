module vga_basemod
(
    input CLOCK, RESET,
	 output VGA_HSYNC, VGA_VSYNC,
	 output [15:0]VGAD
);
    wire CLOCK_65M;
	 
    pll_module U1  
    (
	    .inclk0 ( CLOCK ),
	    .c0 ( CLOCK_65M ) // CLOCK 65Mhz
	 );
	 
	 wire [20:0]AddrU2; // [20:10]X ,[9:0]Y
	 
	 vga_funcmod U2    // 1024 * 758 @ 60Hz
	 (
	   .CLOCK( CLOCK_65M ), 
	   .RESET( RESET ),
	   .VGA_HSYNC( VGA_HSYNC ), 
	   .VGA_VSYNC( VGA_VSYNC ),
	   .oAddr( AddrU2 )
	 );			 
	 
	 wire [15:0]DataU3;
	 
	 vga_savemod U3
	 (
	    .CLOCK( CLOCK_65M ),
		 .RESET( RESET ),
		 .iAddr( AddrU4 ),
	    .oData ( DataU3 )
    );
    
	 wire [13:0]AddrU4;
	 
	 vga_ctrlmod U4  // 128 * 96 * 16bit, X0,Y0
	 (
	     .CLOCK( CLOCK_65M ),
		  .RESET( RESET ),
		  .VGAD( VGAD ),
		  .iData( DataU3 ),
	     .oAddr( AddrU4 ),
	     .iAddr( AddrU2 )
	 );
	 
endmodule
