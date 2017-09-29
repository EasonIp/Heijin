module sdram_demo
(
    input CLOCK,
    input RESET,
    output S_CLK,
	 output S_CKE, S_NCS, S_NRAS, S_NCAS, S_NWE,
	 output [12:0]S_A, 
    output [1:0]S_BA,
    output [1:0]S_DQM,
    inout [15:0]S_DQ,
	 output TXD
); 
	 wire CLOCK1,CLOCK2;
	 
	 pll_module U1
	 (
	     	  .inclk0 ( CLOCK ), // 50Mhz
	        .c0 ( CLOCK1 ),  // 133Mhz -210 degree phase
	        .c1 ( CLOCK2 )   // 133Mhz 
	 );
	 
	 wire [1:0]DoneU2;
	 wire [15:0]DataU2;
	 wire [1:0]TagU2;
	 
	 sdram_basemod U2
	 (
	     .CLOCK( CLOCK1 ),
	     .RESET( RESET ),
		  .S_CKE( S_CKE ),
		  .S_NCS( S_NCS ),
		  .S_NRAS( S_NRAS ),
		  .S_NCAS( S_NCAS ),
		  .S_NWE( S_NWE ),
		  .S_A( S_A ),
		  .S_BA( S_BA ),
		  .S_DQM( S_DQM ),
		  .S_DQ( S_DQ ),
	     .iCall( {isWR,isRD} ),
	     .oDone( DoneU2 ),
         .iData( D2 ),
		  .oData( DataU2 ),
		  .oTag( TagU2 )
	 );
	 
	 reg [5:0]i;
	 reg [15:0]D2;
	 reg isWR;
	 
	 always @ ( posedge CLOCK1 or negedge RESET )
         if( !RESET )
             begin
                 i <= 6'd0;
					  D2 <= 16'hA000;
					  isWR <= 1'b0;
             end
         else 
             case( i )
			 
			 		 0:
					 if( !TagU2[1] ) i <= i + 1'b1;
				    
					 1:
				     if( DoneU2[1] ) begin isWR <= 1'b0; i <= i + 1'b1; end
					 else begin isWR <= 1'b1; end
					 
					 2:
					 if( D2 == 16'hA1FF ) i <= i + 1'b1;
					 else begin D2[11:0] <= D2[11:0] +  1'b1; i <= 6'd0; end
					 
					 3:
					 i <= i;
				
            endcase
			
	 reg [5:0]j,Go;
	 reg [10:0]C1;
	 reg [15:0]D3;
	 reg [10:0]T;
	 reg isRD;
	 reg rTXD;	
	 
	 parameter B115K2 = 11'd1157, TXFUNC = 6'd16;
			
    always @ ( posedge CLOCK1 or negedge RESET )
         if( !RESET )
             begin
                 j <= 6'd0;
					  Go <= 6'd0;
					  C1 <= 11'd0;
					  D3 <= 16'd0;
					  T <= 11'd0;
					  isRD <= 1'b0;
					  rTXD <= 1'b1;
             end
         else 
             case( j )
			 
			         0:
					 if( !TagU2[0] ) j <= j + 1'b1;
					 
					 1:
					 if( DoneU2[0] ) begin D3 <= DataU2; isRD <= 1'b0; j <= j + 1'b1; end
					 else begin isRD <= 1'b1; end
					 
					 2:
					 begin T <= { 2'b11, D3[15:8], 1'b0 }; j <= TXFUNC; Go <= j + 1'b1; end
					 
					 3:
					 begin T <= { 2'b11, D3[7:0], 1'b0 }; j <= TXFUNC; Go <= j + 1'b1; end
					 
					 4:
					 if( D3 == 16'hA1FF ) j <= j + 1'b1; 
					 else j <= 6'd0;
					 
				    5:
					 j <= j;
					 
				    /******************************/
				 
				 	 16,17,18,19,20,21,22,23,24,25,26:
					 if( C1 == B115K2 -1 ) begin C1 <= 11'd0; j <= j + 1'b1; end
					 else begin rTXD <= T[j - 16]; C1 <= C1 + 1'b1; end
					 
					 27:
					 j <= Go;
					 
            endcase

     assign S_CLK = CLOCK2;
	 assign TXD = rTXD;

endmodule
