module sdcard_basemod
(
     input CLOCK, RESET,
     input SD_DOUT,
	 output SD_CLK,
	 output SD_DI,
	 output SD_NCS,  
	 
	 input [3:0]iCall,
	 output oDone,
	 input [22:0]iAddr,
	 output [7:0]oTag,
	 
	 input [1:0]iEn,
	 input [7:0]iData,
	 output [7:0]oData
); 
	 wire [1:0]EnU1;
	 wire [7:0]DataFFU1;
	 wire [1:0]CallU1;
	 wire [47:0]AddrU1;
	 wire [7:0]DataU1;
	
    sdcard_ctrlmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .SD_NCS(  SD_NCS ), // > top
	     .iCall( iCall ),    // < top
	     .oDone( oDone ),      // < top
	     .iAddr( iAddr ),      // < top
		  .oTag( oTag ),    // > top
	     .oEn( EnU1 ),         // > U2 & U3
	     .iDataFF( DataFFU2 ), // < U2 
	     .oDataFF( DataFFU1 ), // > U3
	     .oCall( CallU1 ),   // > U4 
	     .iDone( DoneU4 ),     // < U4
	     .oAddr( AddrU1 ),       // > U4
	     .iData( DataU4 ),     // < U4
	     .oData( DataU1 )     // > U4
	 );
	 
	 wire [7:0]DataFFU2;
	 
    fifo_savemod U2
    (
	    .CLOCK ( CLOCK ),
		 .RESET( RESET ),
	    .iEn ( {iEn[1],EnU1[0]} ),  // < top & U1
	    .iData ( iData ),           // < top
	    .oData ( DataFFU2 ),        // > U1
	    .oTag ()
	);
	
    fifo_savemod U3
    (
	    .CLOCK ( CLOCK ),
		 .RESET( RESET ),
	    .iEn ( {EnU1[1],iEn[0]} ),  // < top & U1
	    .iData ( DataFFU1 ),        // < U1
	    .oData ( oData ),           // > top
	    .oTag ()
	);
	
	wire DoneU4;
	wire [7:0]DataU4;
	
	 sdcard_funcmod U4
	 (
	     .CLOCK( CLOCK ), 
		  .RESET( RESET ),
		  .SD_CLK( SD_CLK ),   // > top
		  .SD_DOUT( SD_DOUT ),   // < top
		  .SD_DI( SD_DI ),     // > top
		  .iCall( CallU1 ),  // < U1
		  .oDone( DoneU4 ),    // > U1
		  .iAddr( AddrU1 ),      // < U1
		  .iData( DataU1 ),    // < U1
		  .oData( DataU4 )     // > U1
	 );
	 
endmodule
