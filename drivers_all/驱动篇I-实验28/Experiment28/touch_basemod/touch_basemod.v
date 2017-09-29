module touch_basemod
(
    input CLOCK,RESET,
	 output TP_CS_N,
	 output TP_CLK,
	 input TP_IRQ,
	 output TP_DI,
	 input TP_DO,
	 
	 output oDone,
	 output [15:0]oData
);
    wire [1:0]CallU1;

    touch_ctrlmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET(  RESET ),
		  .TP_IRQ( TP_IRQ ),  // < top
		  .oDone( oDone ),    // > top
		  .oData( oData ),  // > top
		  .oCall( CallU1 ), // > U2
		  .iDone( DoneU2 ),  // < U1
		  .iData( DataU2 )   // < U1
	 );
	 
	 wire DoneU2;
	 wire [7:0]DataU2;
	 
	 touch_funcmod U2
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .TP_CS_N( TP_CS_N ),  // > top
		  .TP_CLK( TP_CLK ),    // > top
		  .TP_DI( TP_DI ),      // > top
		  .TP_DO( TP_DO ),  // < top
		  .iCall( CallU1 ),   // < U1
		  .oDone( DoneU2 ),     // > U1
		  .oData( DataU2 )      // > U1
	 );

endmodule
