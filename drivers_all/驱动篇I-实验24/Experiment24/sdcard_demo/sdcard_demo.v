module sdcard_demo
(
    input CLOCK,RESET,
	 output SD_NCS, 
	 output SD_CLK,
	 input SD_DOUT,
	 output SD_DI,
	 output TXD
);
    wire DoneU1;
	 wire [7:0]TagU1;
    wire [7:0]DataU1;

    sdcard_basemod U1
	 (
	     .CLOCK( CLOCK ), 
		  .RESET( RESET ),
		  .SD_DOUT( SD_DOUT ),
	     .SD_CLK( SD_CLK ),
	     .SD_DI( SD_DI ),
	     .SD_NCS( SD_NCS ), 
		  .iCall( isCall ),
		  .oDone( DoneU1 ),
		  .iAddr( D1 ),
		  .oTag( TagU1 ),
		  /**********/
		  .iEn( isEn ),
		  .iData( D2 ),
		  .oData( DataU1 )
	 );
	 
    parameter B115K2 = 11'd434, TXFUNC = 6'd16;
	 
	 reg [5:0]i,Go;
	 reg [10:0]C1,C2;
	 reg [22:0]D1;
	 reg [7:0]D2;
	 reg [10:0]T;
	 reg [3:0]isCall;
	 reg [1:0]isEn;
	 reg rTXD;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
		          { i,Go } <= { 6'd0,6'd0 };
					 { C1,C2 } <= { 11'd0,11'd0 };
					 { D1,D2,T } <= { 23'd0,8'd0,11'd0 };
					 { isCall,isEn } <= { 4'd0,2'd0 };
					 rTXD <= 1'b1;
		      end
			else
			    case( i )
					 
                0: // cmd0
					 if( DoneU1 ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 1:
					 begin T <= { 2'b11, TagU1, 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /********************/
					 
					 2: // cmd1
					 if( DoneU1 ) begin isCall[1] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[1] <= 1'b1; end
					 
					 3:
					 begin T <= { 2'b11, TagU1, 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /*********************/
					 
					 4: // write data to fifo
					 begin isEn[1] <= 1'b1; i <= i + 1'b1; end
					 
					 5:
					 begin isEn[1] <= 1'b0; i <= i + 1'b1; end
					 
					 6:
					 if( C2 == 511 ) begin C2 <= 11'd0; i <= i + 1'b1; end
					 else begin D2 <= D2 + 1'b1; C2 <= C2 + 1'b1; i <= 6'd4; end
					 
				    /**************/	
					 
					 7:  // cmd24
					 if( DoneU1 ) begin isCall[3] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[3] <= 1'b1; D1 <= 23'd0; end
					 
					 8:
					 begin T <= { 2'b11, TagU1, 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /***************/
					 
					 9: // cmd17
					 if( DoneU1 ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 23'd0; end
					 
					 10:
					 begin T <= { 2'b11, TagU1, 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /****************/
					 
					 11: // Read data from fifo
					 begin isEn[0] <= 1'b1; i <= i + 1'b1; end
					 
					 12:
					 begin isEn[0] <= 1'b0; i <= i + 1'b1; end
					 
					 13:
					 begin T <= { 2'b11, DataU1, 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 14:
					 if( C2 == 511 ) begin C2 <= 11'd0; i <= i + 1'b1; end
					 else begin C2 <= C2 + 1'b1; i <= 6'd11; end
					 
					 15: 
					 i <= i;
					 
					 /****************/
					
					 16,17,18,19,20,21,22,23,24,25,26:
					 if( C1 == B115K2 -1 ) begin C1 <= 11'd0; i <= i + 1'b1; end
					 else begin rTXD <= T[i - 16]; C1 <= C1 + 1'b1; end
					 
					 27:
					 i <= Go;
				 
				 endcase
				 
	assign TXD = rTXD;

endmodule
