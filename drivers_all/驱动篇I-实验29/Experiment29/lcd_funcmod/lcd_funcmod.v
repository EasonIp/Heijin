module lcd_funcmod 
(
    input CLOCK, RESET,
	 output LCD_CLOCK,
	 output LCD_HSYNC, LCD_VSYNC,
	 output [5:0]LCD_RED,LCD_GREEN,LCD_BLUE,
	 output LCD_DE,
	 output LCD_UD, LCD_LR,
	 output LCD_MODE,
	 output LCD_PWM,
	 output [13:0]oAddr,
	 input [15:0]iData
);
	 parameter SA = 11'd48, SB = 11'd40, SC = 11'd800, SD = 11'd40, SE = 11'd928;
	 parameter SO = 11'd3, SP = 11'd29, SQ = 11'd480, SR = 11'd13, SS = 11'd525;
	
	 reg [10:0]CH;
	 always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     CH <= 11'd0;
		 else if( CH == SE -1 )
		     CH <= 11'd0;
		 else 
		     CH <= CH + 1'b1;
		
    reg [9:0]CV;		
	 always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     CV <= 10'd0;
		 else if( CV == SS -1 )
		     CV <= 10'd0;
		 else if( CH == SE -1 )
		     CV <= CV + 1'b1;
			  
	 reg H;
	 always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     H <= 1'b1;
		 else if( CH == SE -1 )
		     H <= 1'B0;
		 else if( CH == SA -1 )
		     H <= 1'b1;
			  
	 reg V;
	 always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     V <= 1'b1;
		 else if( CV == SS -1 )
		     V <= 1'b0;
		 else if( CV == SO -1 )
		     V <= 1'b1;
	 
	 parameter XSIZE = 8'd128, YSIZE = 8'd96, XOFF = 10'd0, YOFF = 10'd0; 
    
	 wire isX = ( (CH >= SA + SB + XOFF -1 ) && ( CH <= SA + SB + XOFF + XSIZE -1) );
	 wire isY = ( (CV >= SO + SP + YOFF -1 ) && ( CV <= SO + SP + YOFF + YSIZE -1) );
	 wire isReady = isX & isY;
	 
	 wire [31:0] x = CH - XOFF - SA - SB -1; 
	 wire [31:0] y = CV - YOFF - SO - SP -1;
	 
	 reg [31:0]D1;
	 reg [15:0]D2;
	 
     always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    D1 <= 18'd0;
				    D2 <= 16'd0;
				end
			else
			   begin
				
				    // step 1 : compute data address and index-n
					 if( isReady )
					     D1 <= (y << 7) + x; 
					 else
					     D1 <= 14'd0;
					 
					 // step 2 : reading data from rom
					 // but do-nothing
					 
					 // step 3 : assign RGB_Sig
					 D2 <= isReady ? iData : 16'd0;
					 
				end
				
	 reg [1:0]B1,B2,B3;
	 
    always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      {  B3, B2, B1 } <= 6'b11_11_11;
		  else
		      begin
				    B1 <= { H,V };
				    B2 <= B1;
					 B3 <= B2;
				end	
    
	assign LCD_CLOCK = CLOCK;
	assign { LCD_HSYNC, LCD_VSYNC } = B3;
   assign LCD_RED = { D2[15:11],1'b0};
	assign LCD_GREEN = D2[10:5];
	assign LCD_BLUE = { D2[4:0],1'b0};
	assign LCD_DE = 1'b1;
	assign {LCD_LR, LCD_UD} = 2'b10;
	assign LCD_MODE = 1'b0;
	assign LCD_PWM = 1'b1;
	assign oAddr = D1[13:0];
	 
endmodule
