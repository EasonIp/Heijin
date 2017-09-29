module sdram_basemod
(
    input CLOCK,
	 input RESET,
	 
	 output S_CKE, S_NCS, S_NRAS, S_NCAS, S_NWE,
	 output [1:0]S_BA,
	 output [12:0]S_A, 
	 output [1:0]S_DQM,
	 inout [15:0]S_DQ,
	 
	 input [1:0]iEn,
	 input [23:0]iAddr,
	 input [15:0]iData,
	 output [15:0]oData,
	 output [1:0]oTag,
	 
	 input [1:0]iCall,
	 output [1:0]oDone
);
	 wire [3:0]CallU1; // [3]Write, [2]Read, [1]A.Ref, [0]Initial

    sdram_ctrlmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .iCall( iCall ),   // < top ,[1]Write [0]Read
		  .oDone( oDone ),     // > top ,[1]Write [0]Read
		  .oCall( CallU1 ),  // > U4
		  .iDone( DoneU4 )  // < U4

	 );
	 
	 wire [15:0]DataU2;
	 
	 fifo_savemod U2
	 ( 
	      .CLOCK( CLOCK ),
			.RESET( RESET ),
			.iEn( {iEn[1],EnU4[0]} ),  // < top
			.iData( iData ), // < top
			.oData( DataU2 ), // > top
			.oTag() // 
	 );
	 
	 fifo_savemod U3
	 ( 
	      .CLOCK( CLOCK ),
			.RESET( RESET ),
			.iEn( {EnU4[1],iEn[0]} ),  // < U4 & top
			.iData( DataU4 ), // < U4
			.oData( oData ), // > top
			.oTag() // 
	 );
	 
	 wire DoneU4;
	 wire [1:0]EnU4;
	 wire [15:0]DataU4;
	 
	 sdram_funcmod U4
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .S_CKE( S_CKE ),   // > top
		  .S_NCS( S_NCS ),   // > top
		  .S_NRAS( S_NRAS ), // > top
		  .S_NCAS( S_NCAS ), // > top
		  .S_NWE( S_NWE ), // > top
		  .S_BA( S_BA ),   // > top
		  .S_A( S_A ),     // > top
		  .S_DQM( S_DQM ), // > top
		  .S_DQ( S_DQ ),   // <> top        
          .oEn( EnU4 ),    // > U2 && U3
		  .iAddr( iAddr ),       // < top
		  .iData( DataU2 ),       // < U2
		  .oData( DataU4 ),       // > top
		  .iCall( CallU1 ),    // < U1
		  .oDone( DoneU4 ) // > U1
	 );
	 
endmodule
