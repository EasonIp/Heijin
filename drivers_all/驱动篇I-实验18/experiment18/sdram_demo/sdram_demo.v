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
	        .c0 ( CLOCK1 ),  // 133Mhz -180 degree phase
	        .c1 ( CLOCK2 )   // 133Mhz 
	 );
	 
	 wire [1:0]DoneU2;
	 wire [15:0]DataU2;
	 
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
	     .iCall( isCall ),
	     .oDone( DoneU2 ),
		  .iAddr( D1 ),
        .iData( D2 ),
		  .oData( DataU2 )
	 );

	 parameter B115K2 = 11'd1157, TXFUNC = 6'd16;
	 
	 reg [5:0]i,Go;
	 reg [10:0]C1;
	 reg [23:0]D1;
	 reg [15:0]D2,D3;
	 reg [10:0]T;
	 reg [1:0]isCall;
	 reg rTXD;
	 
	 always @ ( posedge CLOCK1 or negedge RESET )
         if( !RESET )
             begin
                 i <= 6'd0;
					  Go <= 6'd0;
					  C1 <= 11'd0;
                 D1 <= 24'd0;
					  D2 <= 16'd0;
					  D3 <= 16'd0;
					  T <= 11'd0;
					  isCall <= 2'b00;
					  rTXD <= 1'b1;
             end
         else 
             case( i )
				    
					 0:
				    if( DoneU2[1] ) begin isCall[1] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[1] <= 1'b1; D1 <= 24'd0; D2 <= 16'hABCD; end
					 
					 1:
					 if( DoneU2[0] ) begin D3 <= DataU2; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin D1 <= 24'd0; isCall[0] <= 1'b1; end
					 
					 2:
					 begin T <= { 2'b11, D3[15:8], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 3:
					 begin T <= { 2'b11, D3[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
				    4:
					 i <= i;
					 
				    /******************************/
				 
				 	 16,17,18,19,20,21,22,23,24,25,26:
					 if( C1 == B115K2 -1 ) begin C1 <= 11'd0; i <= i + 1'b1; end
					 else begin rTXD <= T[i - 16]; C1 <= C1 + 1'b1; end
					 
					 27:
					 i <= Go;
					 
            endcase

     assign S_CLK = CLOCK2;
	 assign TXD = rTXD;

endmodule
