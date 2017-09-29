module tft_basemod
(
    input CLOCK,RESET,
	 output TFT_RST,
	 output TFT_RS,     // 1 = Data, 0 = Command(Register)
	 output TFT_CS_N,  
	 output TFT_WR_N,
	 output TFT_RD_N,
	 output [15:0]TFT_DB,
	 input [2:0]iCall,
	 output oDone,
	 input [31:0]iData
);
    wire [2:0]CallU1;
	 wire [7:0]AddrU1;
	 wire [15:0]DataU1;

    tft_ctrlmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
	     .iCall( iCall ),  // < top
		  .oDone( oDone ),    // > top
		  .iData( iData ),
		  .oCall( CallU1 ),  // > U2
		  .iDone( DoneU2 ),    // < U2
		  .oAddr( AddrU1 ),    // > U2
		  .oData( DataU1 )     // > U2
	 );
	 
	 wire DoneU2;
	 
    tft_funcmod U2
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .TFT_RS( TFT_RS ),      // > top
		  .TFT_CS_N( TFT_CS_N ),  // > top
		  .TFT_WR_N( TFT_WR_N ),  // > top
		  .TFT_RD_N( TFT_RD_N ),  // > top
		  .TFT_DB( TFT_DB ),      // > top
		  .iCall( CallU1 ),     // < U1
		  .oDone( DoneU2 ),       // > U1
		  .iAddr( AddrU1 ),       // < U1
		  .iData( DataU1 )        // < U1
	 );
   
	assign TFT_RST = 1'b1;
	
endmodule
