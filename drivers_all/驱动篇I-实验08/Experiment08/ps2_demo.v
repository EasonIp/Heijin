module ps2_demo
(
    input CLOCK, RESET,
	 input PS2_CLK, PS2_DAT,
	 output [7:0]DIG,
	 output [5:0]SEL
);
    wire [7:0]DataU1;
	 wire [2:0]TagU1;

     ps2_funcmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .PS2_CLK( PS2_CLK ), // < top
		  .PS2_DAT( PS2_DAT ), // < top
		  .oTrig(),
		  .oData( DataU1 ),  // > U2
		  .oTag( TagU1 ) // > U2
	 );
	 
   smg_basemod U2
	(
	   .CLOCK( CLOCK ),
	   .RESET( RESET ),
		.DIG( DIG ),  // > top
		.SEL( SEL ),  // > top
		.iData( { 12'h000 , 1'b0, TagU1, DataU1 } ) // < U1
	);
		     
endmodule
