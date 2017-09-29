module sdcard_ctrlmod
(
    input CLOCK, RESET,
	 output SD_NCS,
	 
	 input [3:0]iCall,
	 output oDone,
	 input [22:0]iAddr,
	 output [7:0]oTag,
	 
	 output [1:0]oEn, // [1] Write [0] Read
	 input [7:0]iDataFF,
	 output [7:0]oDataFF,
	 
	 output [1:0]oCall, 
	 input iDone,
	 output [47:0]oAddr,
	 input [7:0]iData,
	 output [7:0]oData
);			
    parameter CMD0ERR = 8'hA1, CMD0OK = 8'hA2, CMD1ERR = 8'hA3, CMD1OK = 8'hA4; 
	 parameter CMD24ERR = 8'hA5, CMD24OK = 8'hA6, CMD17ERR = 8'hA7, CMD17OK = 8'hA8;
	 parameter T1MS = 16'd10;
	
    reg [3:0]i;
	 reg [15:0]C1;
	 reg [7:0]D1,D2,D3;  // D1 WrData, D2 FbData, D3 RdData
	 reg [47:0]D4;       // D4 Cmd
	 reg [1:0]isCall,isEn;
	 reg rCS;
    reg isDone;
	 
    always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    i <= 4'd0;
					 C1 <= 16'd0;
					 { D1,D2,D3 } <= { 8'd0, 8'd0, 8'd0 };
					 D4 <= 48'd0;
					 { isCall, isEn } <= { 2'd0,2'd0 }; 
					 rCS <= 1'b1;
				end
		else if( iCall[3] ) // cmd24
		      case( i )
				
				    0: // Enable cs, prepare cmd24
					 begin rCS <= 1'b0; D4 = { 8'h58, iAddr, 9'd0, 8'hFF }; i <= i + 1'b1; end
					 
					 1: // Try 100 times, ready error code.
					 if( C1 == 100 ) begin D2 <= CMD24ERR; C1 <= 16'd0; i <= 4'd14; end
					 else if( iDone && iData != 8'h00) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( iDone && iData == 8'h00 ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end
					 else isCall[1] <= 1'b1;
					 
					 2: // Send 800 free clock 
					 if( C1 == 100 ) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else if( iDone ) begin isCall[0] <= 1'b0; C1 <= C1 + 1'b1; end 
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFF; end
					 
					 3: // Send Call byte 0xfe
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFE; end
					 
					 /*****************/
					 
					 4: // Pull up read req.
					 begin isEn[0] <= 1'b1; i <= i + 1'b1; end
					 
					 5: // Pull down read req.
					 begin isEn[0] <= 1'b0; i <= i + 1'b1; end
					 
					 6: // Write byte from fifo
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= iDataFF; end
					 
					 7: // Repeat 512 times
					 if( C1 == 10'd511 ) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else begin C1 <= C1 + 1'b1; i <= 4'd4; end
					 
                /*****************/
					 
					 8: // Write 1st CRC
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 9: // Write 2nd CRC
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 10: // Read Respond
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 11: // if not 8'h05, faild and ready error code
					 if( (iData & 8'h1F) != 8'h05 ) begin D2 <= CMD24ERR; i <= 4'd14; end
					 else i <= i + 1'b1;
					 
					 12: // Wait unitl sdcard free
					 if( iDone && iData == 8'hff ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else if( iDone ) begin isCall[0] <= 1'b0; end
					 else begin isCall[0] <= 1'b1; end
					 
					 /*****************/
					 
					 13: // Disable cs, ready OK code;
					 begin D2 <= CMD24OK; i <= i + 1'b1; end
					 
					 14: // Disable cs, generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 15:
					 begin isDone <= 1'b0; i <= 4'd0; end
				
				endcase
		else if( iCall[2] ) // cmd17
		      case( i )
				
				    0: // Enable cs, prepare cmd17
					 begin rCS <= 1'b0; D4 <= { 8'h51, iAddr, 9'd0, 8'hFF }; i <= i + 1'b1; end
					 
					 1: // Try 100 times, ready error code
					 if( C1 == 100 ) begin D2 <= CMD17ERR; C1 <= 16'd0; i <= 4'd12; end
					 else if( iDone && iData != 8'h00 ) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( iDone && iData == 8'h00 ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end
					 else isCall[1] <= 1'b1;
					 
					 2: // Wait read ready
					 if( iDone && iData == 8'hfe ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else if( iDone && iData != 8'hfe ) begin isCall[0] <= 1'b0; end
					 else isCall[0] <= 1'b1;
					 
					 /********/
					 
					 3:  // Read byte
					 if( iDone ) begin D3 <= iData; isCall[0] <= 1'b0; i <= i + 1'b1;  end
					 else begin isCall[0] <= 1'b1; end
					 
					 4: // Pull up write req.
					 begin isEn[1] <= 1'b1; i <= i + 1'b1; end
										  
					 5: // Pull down write req.
					 begin isEn[1] <= 1'b0; i <= i + 1'b1; end 
					 
					 6: // Repeat 512 times
					 if( C1 == 10'd511 ) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else begin C1 <= C1 + 1'b1; i <= 4'd3; end
					 
					 /********/
					 
					 7,8: // Read 1st and 2nd byte CRC
					 if( iDone ) begin D3 <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end 
					 else isCall[0] <= 1'b1;
					 
					 9: // Disable cs
					 begin rCS <= 1'b1; i <= i + 1'b1; end
					 
					 10: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end 
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFF; end
					 
					 11: // Ready OK code
					 begin D2 <= CMD17OK; i <= i + 1'b1; end
					 
					 12: // Disable cs, generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 13:
					 begin isDone <= 1'b0; i <= 4'd0; end
					 
				endcase		
		 else if( iCall[1] ) // cmd1
		      case( i )
				
					 0: // Enable cs, prepare Cmd1
					 begin rCS <= 1'b0; D4 <= { 8'h41,32'd0,8'hff }; i <= i + 1'b1; end
					 
					 1: // Try 100 times, ready error code.
					 if( C1 == 10'd100 ) begin D2 <= CMD1ERR; C1 <= 16'd0; i <= 4'd5; end
					 else if( iDone && iData != 8'h00) begin isCall[1]<= 1'b0; C1 <= C1 + 1'b1; end
					 else if( iDone && iData == 8'h00 ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 2: // Disable cs
					 begin rCS <= 1'b1; i <= i + 1'b1; end
					 
					 3: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 /******************/
					 
					 4: // Disable cs, ready OK code.
					 begin D2 <= CMD1OK; i <= i + 1'b1; end
					 
					 5: // Disable cs, generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 6:
					 begin isDone <= 1'b0; i <= 4'd0; end
					 
				endcase
		else if( iCall[0] ) // cmd0
		      case( i )
				
				     0: // Disable cs, prepare Cmd0
					 begin rCS <= 1'b1; D4 <= {8'h40, 32'd0, 8'h95}; i <= i + 1'b1; end
				    
					 1: // Wait 1MS for warm up;
					 if( C1 == T1MS -1) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else begin C1 <= C1 + 1'b1; end

					 2: // Send 80 free clock
					 if( C1 == 10'd10 ) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else if( iDone ) begin isCall[0] <= 1'b0; C1 <= C1 + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 3: // Enable cs
					 begin rCS <= 1'b0; i <= i + 1'b1; end
					
					 4: // Try 200 time, ready error code.
					 if( C1 == 10'd200 ) begin D2 <= CMD0ERR; C1 <= 16'd0; i <= 4'd8; end
					 else if( iDone && iData != 8'h01) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( iDone && iData == 8'h01 ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 5: // Disable cs
					 begin rCS <= 1'b1 ; i <= i + 1'b1; end
					 
					 6: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 7: // Disable cs, ready OK code
					 begin D2 <= CMD0OK; i <= i + 1'b1; end
					 
					 8: // Disbale cs, generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 9:
					 begin isDone <= 1'b0; i <= 4'd0; end
				
				endcase
	
	assign SD_NCS = rCS;
	assign oDone = isDone;
	assign oTag = D2;
	assign oEn = isEn; 
	assign oDataFF = D3;
	assign oCall = isCall;
	assign oAddr = D4;
	assign oData = D1;

endmodule
