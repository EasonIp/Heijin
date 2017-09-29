module touch_demo
(
    input CLOCK, RESET,
	 output TFT_RST,
	 output TFT_RS,     
	 output TFT_CS_N,  
	 output TFT_WR_N,
	 output TFT_RD_N,
	 output [15:0]TFT_DB,
	 
	 output TP_CS_N,
	 output TP_CLK,
	 input TP_IRQ,
	 output TP_DI,
	 input TP_DO
);
    wire DoneU1;
	 wire [15:0]DataU1; // [15:8] X, [7:0]Y;
    
	 touch_basemod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .TP_CS_N( TP_CS_N ),
	     .TP_CLK( TP_CLK ),
	     .TP_IRQ( TP_IRQ ),
		  .TP_DI( TP_DI ),
	     .TP_DO( TP_DO ),
		  .oDone( DoneU1 ),
		  .oData( DataU1 )
	 );
	 
	  wire DoneU2; 
	 
	 tft_basemod U2
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
		  .oDone( DoneU2 ),
		  .iData( { D1,D2,D3 } )
	 );
	 
	 reg [5:0]i,Go;
	 reg [2:0]isCall;
	 reg [7:0]D1;
	 reg [7:0]D2;
	 reg [15:0]D3;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    {i,Go} <= { 6'd0,6'd0 };
					 isCall <= 3'd0;
					 { D1,D2,D3 } <= { 8'd0,8'd0,16'd0 };
				end
		  else
		      case( i )
				
				    0: // Inital TFT
					 if( DoneU2 ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 1: // Clear Screen
					 if( DoneU2 ) begin isCall[1] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[1] <= 1'b1; end
					 
					 2:
					 if( DoneU1 ) begin i <= i + 1'b1; end
					 
					 3:
					 if( DoneU2 ) begin isCall[2] <= 1'b0; i <= i + 1'b1;  end
					 else begin isCall[2] <= 1'b1; D1 <= DataU1[15:8]; D2 <= DataU1[7:0]; D3 <= 16'd0; end
					 
					 4:
					 i <= 2;

				endcase
   
endmodule
