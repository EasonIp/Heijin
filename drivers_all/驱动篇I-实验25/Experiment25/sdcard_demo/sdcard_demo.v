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
	 wire [39:0]TagU1;
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
	 
    parameter B115K2 = 11'd434, TXFUNC = 6'd48;
	 
	 reg [5:0]i,Go;
	 reg [10:0]C1,C2;
	 reg [31:0]D1;
	 reg [7:0]D2;
	 reg [10:0]T;
	 reg [7:0]isCall;
	 reg [1:0]isEn;
	 reg rTXD;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
		          { i,Go } <= { 6'd0,6'd0 };
					 { C1,C2 } <= { 11'd0,11'd0 };
					 { D1,D2,T } <= { 32'd0,8'd0,11'd0 };
					 { isCall,isEn } <= { 8'd0,2'd0 };
					 rTXD <= 1'b1;
		      end
			else
			    case( i )
					 
                0: // cmd0
					 if( DoneU1 ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 1:
					 begin T <= { 2'b11, TagU1[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /********************/
					 
					 2: // cmd8
					 if( DoneU1 ) begin isCall[1] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[1] <= 1'b1; end
					 
					 3:
					 begin T <= { 2'b11, TagU1[39:32], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 4:
					 begin T <= { 2'b11, TagU1[31:24], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 5:
					 begin T <= { 2'b11, TagU1[23:16], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 6:
					 begin T <= { 2'b11, TagU1[15:8], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 7:
					 begin T <= { 2'b11, TagU1[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /********************/
					 
					 8: // cmd58
					 if( DoneU1 ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; end
					 
					 9:
					 begin T <= { 2'b11, TagU1[39:32], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 10:
					 begin T <= { 2'b11, TagU1[31:24], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
				    11:
					 begin T <= { 2'b11, TagU1[23:16], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 12:
					 begin T <= { 2'b11, TagU1[15:8], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 13:
					 begin T <= { 2'b11, TagU1[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /********************/
					 
					 14: // cmd55 + acmd41
					 if( DoneU1 ) begin isCall[3] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[3] <= 1'b1; end
					 
					 15:
					 begin T <= { 2'b11, TagU1[39:32], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 16:
					 begin T <= { 2'b11, TagU1[31:24], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
				    17:
					 begin T <= { 2'b11, TagU1[23:16], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 18:
					 begin T <= { 2'b11, TagU1[15:8], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 19:
					 begin T <= { 2'b11, TagU1[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /********/
					 
					 20: // cmd58
					 if( DoneU1 ) begin isCall[4] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[4] <= 1'b1; end
					 
					 21:
					 begin T <= { 2'b11, TagU1[39:32], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 22:
					 begin T <= { 2'b11, TagU1[31:24], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
				    23:
					 begin T <= { 2'b11, TagU1[23:16], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 24:
					 begin T <= { 2'b11, TagU1[15:8], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 25:
					 begin T <= { 2'b11, TagU1[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /********************/
					 
					 26: // cmd16
					 if( DoneU1 ) begin isCall[5] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[5] <= 1'b1; end
					 
					 27:
					 begin T <= { 2'b11, TagU1[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /*****************/
					 
					 28: // Write Data 00~FF
					 begin isEn[1] <= 1'b1; i <= i + 1'b1; end
					 
					 29:
					 begin isEn[1] <= 1'b0; i <= i + 1'b1; end
					 
					 30:
					 if( C2 == 511 ) begin C2 <= 11'd0; i <= i + 1'b1; end
					 else begin D2 <= D2 + 1'b1; C2 <= C2 + 1'b1; i <= 6'd28; end
					 
				    /**************/	
					 
					 31:  // cmd24
					 if( DoneU1 ) begin isCall[7] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[7] <= 1'b1; D1 <= 32'd0; end
					 
					 32:
					 begin T <= { 2'b11, TagU1[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 /***************/
					 
					 33: // cmd17
					 if( DoneU1 ) begin isCall[6] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[6] <= 1'b1; D1 <= 32'd0; end
					 
					 34:
					 begin T <= { 2'b11, TagU1[7:0], 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end

					 /****************/
					 
					 35: // Read Data 00~FF
					 begin isEn[0] <= 1'b1; i <= i + 1'b1; end
					 
					 36:
					 begin isEn[0] <= 1'b0; i <= i + 1'b1; end
					 
					 37:
					 begin T <= { 2'b11, DataU1, 1'b0 }; i <= TXFUNC; Go <= i + 1'b1; end
					 
					 38:
					 if( C2 == 511 ) begin C2 <= 11'd0; i <= i + 1'b1; end
					 else begin C2 <= C2 + 1'b1; i <= 6'd35; end
					 
					 39: 
					 i <= i;
					 
					 /****************/
					
					 48,49,50,51,52,53,54,55,56,57,58:
					 if( C1 == B115K2 -1 ) begin C1 <= 11'd0; i <= i + 1'b1; end
					 else begin rTXD <= T[i - 48]; C1 <= C1 + 1'b1; end
					 
					 59:
					 i <= Go;
				 
				 endcase
				 
	assign TXD = rTXD;

endmodule
