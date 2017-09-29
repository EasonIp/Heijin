module iic_demo
(
    input CLOCK, RESET,
	 output SCL,
	 inout SDA,
	 output [7:0]DIG,
	 output [5:0]SEL
);
    reg [3:0]j;
	 reg [7:0]D1;
	 reg isWR;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin 
				    j <= 4'd0;
				    D1 <= 8'd0;
					 isWR <= 1'b0;
			   end
		  else
		      case( j )

				    0:
					 if( !TagU1[1] ) j <= j + 1'b1;
					 
					 1:
					 if( DoneU1[1] ) begin isWR <= 1'b0; j <= j + 1'b1; end
				    else begin isWR <= 1'b1; D1 <= 8'hAB; end			
		
				    2:
					 if( !TagU1[1] ) j <= j + 1'b1;
					 
					 3:
					 if( DoneU1[1] ) begin isWR <= 1'b0; j <= j + 1'b1; end
				    else begin isWR <= 1'b1; D1 <= 8'hCD; end		
					
					 4:
					 if( !TagU1[1] ) j <= j + 1'b1;
					 
					 5:
					 if( DoneU1[1] ) begin isWR <= 1'b0; j <= j + 1'b1; end
				    else begin isWR <= 1'b1; D1 <= 8'hEF; end		
					 
					 6:
					 i <= i;
				
				endcase
					 
    wire [7:0]DataU1;
	 wire [1:0]DoneU1;
	 wire [1:0]TagU1;
    
    iic_savemod U1
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .SCL( SCL ),         // > top
		  .SDA( SDA ),         // <> top
		  .iCall( { isWR, isRD } ),  // < sub & core
		  .oDone( DoneU1 ),    // > core
		  .iData( D1 ),        // < core
		  .oData( DataU1 ),     // > core
		  .oTag( TagU1 )
	 );
	 
	 reg [3:0]i;
	 reg [23:0]D2;
	 reg isRD;
	  
    always @ ( posedge CLOCK or negedge RESET )	// core
	     if( !RESET )
		      begin
				    i <= 4'd0;
					 D2 <= 24'd0;
					 isRD <= 1'b0;
				end
		  else
		      case( i )
				
				    0:
					 if( !TagU1[0] ) i <= i + 1'b1;
					 
					 1:
					 if( DoneU1[0] ) begin D2[23:16] <= DataU1; isRD <= 1'b0; i <= i + 1'b1; end
					 else isRD <= 1'b1;
					 
					 2:
					 if( !TagU1[0] ) i <= i + 1'b1;
					 
					 3:
					 if( DoneU1[0] ) begin D2[15:8] <= DataU1; isRD <= 1'b0; i <= i + 1'b1; end
					 else isRD <= 1'b1;
					 
					 4:
					 if( !TagU1[0] ) i <= i + 1'b1;
					 
					 5:
					 if( DoneU1[0] ) begin D2[7:0] <= DataU1; isRD <= 1'b0; i <= i + 1'b1; end
					 else isRD <= 1'b1;
					 
					 6:
					 i <= i;
		
				endcase
	 
	 smg_basemod U2
	 (
	     .CLOCK( CLOCK ),
		  .RESET( RESET ),
		  .DIG( DIG ),          // > top
		  .SEL( SEL ),          // > top
		  .iData( D2 )          // < core
	 );
	 
endmodule
