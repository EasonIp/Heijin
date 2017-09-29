module ps2_demo
(
    input CLOCK, RESET,
	 inout PS2_CLK, PS2_DAT,
	 output [7:0]DIG,
	 output [5:0]SEL,
	 output [2:0]LED
);
    wire [1:0]EnU1;

     ps2_init_funcmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .PS2_CLK( PS2_CLK ), // < top
		  .PS2_DAT( PS2_DAT ), // < top
		  .oEn( EnU1 ) // > U2
	 );
	 
	 wire [31:0]DataU2;
	 
	  ps2_read_funcmod U2
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .PS2_CLK( PS2_CLK ), // < top
		  .PS2_DAT( PS2_DAT ), // < top
		  .iEn( EnU1 ),      // < U1
		  .oTrig(),
		  .oData( DataU2 )  // > U3
	 );
	 
    smg_basemod U3
	(
	   .CLOCK( CLOCK ),
	   .RESET( RESET ),
		.DIG( DIG ),  // > top
		.SEL( SEL ),  // > top
		.iData( { 2'd0,DataU2[5],DataU2[4],DataU2[27:24],DataU2[23:16],DataU2[15:8] }) // < U2
	);
	
	assign LED = {DataU2[1], DataU2[2], DataU2[0]};
		 		     
endmodule
