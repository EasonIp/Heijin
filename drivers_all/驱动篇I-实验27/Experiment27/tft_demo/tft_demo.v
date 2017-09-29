module tft_demo
(
    input CLOCK, RESET,
	 output TFT_RST,
	 output TFT_RS,     
	 output TFT_CS_N,  
	 output TFT_WR_N,
	 output TFT_RD_N,
	 output [15:0]TFT_DB
);
    wire DoneU1; 
	 
    tft_basemod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .TFT_RST( TFT_RST ),
		  .TFT_RS( TFT_RS ),
		  .TFT_CS_N( TFT_CS_N ),
		  .TFT_WR_N( TFT_WR_N ),
		  .TFT_RD_N( TFT_RD_N ),
		  .TFT_DB( TFT_DB ),
		  .iCall( isCall ),
		  .oDone( DoneU1 )
	 );
	 
	 reg [3:0]i;
	 reg [2:0]isCall;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		       begin
				      i <= 4'd0;
					  isCall <= 3'd0;
				 end
		  else 
		      case( i )
				
				    0: // Inital TFT
					 if( DoneU1 ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 1: // Clear Screen
					 if( DoneU1 ) begin isCall[1] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[1] <= 1'b1; end
					 
					 2: // Draw Function
					 if( DoneU1 ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; end
					 
					 3:
					 i <= i;
				
				endcase
	 
endmodule
