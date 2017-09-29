module smg_basemod
(
    input CLOCK, RESET,
	 output [7:0]DIG,
	 output [5:0]SEL
); 
    wire [9:0]DataU1;

    smg_funcmod U1
    (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
	     .iData( 24'hABCDEF ), // < top
		  .oData( DataU1 )      // > U2
	 );
	 
	 smg_encode_immdmod U2
	 (
		  .iData( DataU1[9:6] ),  // < U1
		  .oData( DIG )           // > top
	 );
	 
	 assign SEL = DataU1[5:0];
	 
endmodule
