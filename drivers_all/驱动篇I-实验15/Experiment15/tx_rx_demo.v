module tx_rx_demo
(
    input CLOCK, RESET, 
	 input RXD,
	 output TXD
); 
    wire DoneU1;
	 wire [7:0]DataU1;
    
    rx_funcmod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .RXD( RXD ),       // < top
		  .iCall( isRX ),   // < sub
		  .oDone( DoneU1 ),  // > U2
		  .oData( DataU1 )   // > U2
	 );
	 
	reg isRX;
	 
	always @ ( posedge CLOCK or negedge RESET ) // sub
	    if( !RESET ) isRX <= 1'b0;
	    else if( DoneU1 ) isRX <= 1'b0; 
	    else isRX <= 1'b1; 
		  
	 wire [1:0]TagU2;
	 wire [7:0]DataU2;
	 
	 fifo_savemod U2
	 (
	    .CLOCK( CLOCK ),
		 .RESET( RESET ),
		 .iEn ( { DoneU1 , isRead } ), // < U1 & Core
	    .iData ( DataU1 ),   // < U1
		 .oData ( DataU2 ),   // > U3
	    .oTag ( TagU2 )  // > core
	 );
	
	 wire DoneU3;
	 
	 tx_funcmod U3
	 (
	     .CLOCK( CLOCK ), 
		  .RESET( RESET ),
		  .TXD( TXD ),      // > top
		  .iCall( isTX ),  // < core
		  .oDone( DoneU3 ), // > core
		  .iData( DataU2 )  // < U2
	 );
	 
	 reg [3:0]i;
	 reg isRead;
	 reg isTX;
	
	 always @ ( posedge CLOCK or negedge RESET ) // core
	     if( !RESET )
		      begin 
				     i <= 4'd0;
					 isRead <= 1'b0;
					 isTX<= 1'b0;
				end
		  else
		      case(  i )
				
				    0:
					 if( !TagU2[0] ) begin isRead <= 1'b1; i <= i + 1'b1; end
					 
					 1:
					 begin isRead <= 1'b0; i <= i + 1'b1; end
					 
					 2:
					 if( DoneU3 ) begin isTX <= 1'b0; i <= 4'd0; end
					 else isTX <= 1'b1;
					
				endcase
		      			 
endmodule
