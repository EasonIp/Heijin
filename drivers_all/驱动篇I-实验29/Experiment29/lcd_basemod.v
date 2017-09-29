module lcd_basemod
(
    input CLOCK, RESET,
	 
	 output LCD_CLOCK,
	 output LCD_HSYNC, LCD_VSYNC,
	 output [5:0]LCD_RED,LCD_GREEN,LCD_BLUE, 
	 output LCD_DE,
	 output LCD_UD, LCD_LR,
	 output LCD_MODE,
	 output LCD_PWM
);
    wire CLOCK_25M;
	 
    pll_module U1  
    (
	    .inclk0 ( CLOCK ),
	    .c0 ( CLOCK_25M ) 
	 );
	 
	 wire [13:0]AddrU2; 
	 
	 lcd_funcmod U2 
	 (
	   .CLOCK( CLOCK_25M ), 
	   .RESET( RESET ),
		.LCD_CLOCK( LCD_CLOCK ),
	   .LCD_HSYNC( LCD_HSYNC ), 
	   .LCD_VSYNC( LCD_VSYNC ),
		.LCD_RED( LCD_RED ),
		.LCD_GREEN( LCD_GREEN ),
		.LCD_BLUE( LCD_BLUE ),
		.LCD_DE( LCD_DE ),
		.LCD_LR( LCD_LR ),
		.LCD_UD( LCD_UD ),
		.LCD_MODE( LCD_MODE ),
		.LCD_PWM( LCD_PWM ),
	   .oAddr( AddrU2 ),
		.iData( DataU3 )
	 );			 
	 
	 wire [15:0]DataU3;
	 
	 lcd_savemod U3
	 (
	    .CLOCK( CLOCK_25M ),
		 .RESET( RESET ),
		 .iAddr( AddrU2 ),
	    .oData ( DataU3 )
    );
	 
endmodule
