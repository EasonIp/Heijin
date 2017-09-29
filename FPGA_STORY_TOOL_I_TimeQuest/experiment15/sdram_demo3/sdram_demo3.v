module sdram_demo3
(
    input CLK,
    input RSTn,
    
    output SDRAM_CLK,
    output [4:0]SDRAM_CMD,
    output [13:0]SDRAM_BA,
    inout [15:0]SDRAM_DATA,
    
    output SDRAM_UDQM,
    output SDRAM_LDQM
);

     /********************************/
	 
	 wire CLK_100Mhz;
	 wire CLK_100Mhz2;
	 
	 pll_module U1
	 (
	     	.inclk0 ( CLK ),
	        .c0 ( CLK_100Mhz ),
	        .c1 ( CLK_100Mhz2 )
	 );
	 
	 /********************************/
	 
	 wire Done_Sig;
	 wire Busy_Sig;
	 wire [15:0]RdData;
	 
	 sdram_module3 U2
	 (
	     .CLK( CLK_100Mhz ),
	     .RSTn( RSTn ),
	     .WrEN_Sig( 1'b1 ),
	     .RdEN_Sig( 1'b1 ),
	     .Done_Sig( Done_Sig ),
	     .Busy_Sig( Busy_Sig ),
	     .BRC_Addr( 22'd1 ),
	     .WrData( 16'd1 ),
	     .RdData( RdData ),
	     .SDRAM_CMD( SDRAM_CMD ),
	     .SDRAM_BA( SDRAM_BA ),
	     .SDRAM_DATA( SDRAM_DATA ),
	     .SDRAM_UDQM( SDRAM_UDQM ),
	     .SDRAM_LDQM( SDRAM_LDQM )
	 );
	 
	 /***********************************/
     
     assign SDRAM_CLK = CLK_100Mhz2;
     
     /****************************/
     
endmodule
