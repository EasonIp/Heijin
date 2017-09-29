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
	 output [1:0]oTag,
	 input [15:0]iData,
	 output [15:0]oData
); 
	 wire [3:0]CallU1; // [3]Refresh, [2]Read, [1]Write, [0]Initial
     wire [23:0]AddrU2;
	 
    sdram_ctrlmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .iCall( iCall ),   // < top ,[1]Write [0]Read
		  .oDone( oDone ),     // > top ,[1]Write [0]Read
		  .oAddr( AddrU2 ),    // > U2
		  .oTag( oTag ),    // > top
		  .oCall( CallU1 ),  // > U2 
		  .iDone( DoneU2 )	   // < U2
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
		  .oDone( DoneU2 ),  // > U1
		  .iAddr( AddrU2 ),       // < U1
		  .iData( iData ),       // < top
		  .oData( oData )       // > top
	 );
	 
endmodule
