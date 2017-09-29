module sdram_basemod
(
    input CLOCK,
	 input RESET,
	 
	 output S_CKE, S_NCS, S_NRAS, S_NCAS, S_NWE,
	 output [1:0]S_BA,
	 output [12:0]S_A, 
	 output [1:0]S_DQM,
	 inout [15:0]S_DQ,
	 
	 input [1:0]iCall,
	 output [1:0]oDone,
	 input [23:0]iAddr,
	 input [15:0]iData,
	 output [15:0]oData
);
	 wire [3:0]CallU1; // [3]Write, [2]Read, [1]A.Ref, [0]Initial

    sdram_ctrlmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .iCall( iCall ),   // < top ,[1]Write [0]Read
		  .oDone( oDone ),     // > top ,[1]Write [0]Read
		  .oCall( CallU1 ),  // > U2 
		  .iDone( DoneU2 )     // > U2
	 );
	 
	 wire DoneU2;
	 
	 sdram_funcmod U2
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
		  .iCall( CallU1 ),    // < U1
		  .oDone( DoneU2 ),      // > U1
		  .iAddr( iAddr ),       // < top
		  .iData( iData ),       // < top
		  .oData( oData )        // > top
	 );
	 
endmodule
