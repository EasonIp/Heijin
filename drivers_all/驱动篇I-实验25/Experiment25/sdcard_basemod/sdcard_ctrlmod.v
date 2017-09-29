module sdcard_ctrlmod
(
    input CLOCK, RESET,
	 output SD_NCS,
	 
	 input [7:0]iCall, // WR,RD,CMD1,CMD8,CMD0
	 output oDone,
	 input [31:0]iAddr,
	 output [39:0]oTag,
	 
	 output [1:0]oEn, // [1] Write [0] Read
	 input [7:0]iDataFF,
	 output [7:0]oDataFF,
	 
	 output [1:0]oCall, // [5]WR[4]RD[3]CMD, [3]wr[2]rd[1]cmd
	 input iDone,
	 output [47:0]oAddr,
	 input [7:0]iData,
	 output [7:0]oData
);			
     parameter CMD0ERR = 8'hA1, CMD0OK = 8'hA2, CMD1ERR = 8'hA3, CMD1OK = 8'hA4;
	 parameter CMD24ERR = 8'hA5, CMD24OK = 8'hA6,  CMD17ERR = 8'hA9, CMD17OK = 8'hAA;
	 parameter CMD16ERR = 8'hA7,CMD16OK = 8'hA8;
	 parameter CMD8ERR = 8'hB1, CMD41ERR = 8'hC0, CMD58ERR = 8'hC1;
	 parameter SDV2 = 8'hD1, SDV2HC = 8'hD2;
	 parameter T1MS = 16'd10;
	
    reg [3:0]i;
	 reg [15:0]C1;
	 reg [7:0]D1,D3;  // D1 WrData, D2 FbData, D3 RdData
	 reg [39:0]D2;
	 reg [47:0]D4;       // D4 Cmd
	 reg [1:0]isCall,isEn;
	 reg rCS;
    reg isDone;
	 
    always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    i <= 4'd0;
					 C1 <= 16'd0;
					 { D1,D3 } <= { 8'd0,8'd0 };
					 D2 <= 40'd0;
					 D4 <= 48'd0;
					 { isCall, isEn } <= { 2'd0,2'd0 }; 
					 rCS <= 1'b1;
				end
		else if( iCall[7] ) // write block
		      case( i )

				    0: // Enable cs and prepare cmd 24
					 begin rCS <= 1'b0; D4 = { 8'h58, iAddr, 8'hFF }; i <= i + 1'b1; end
					 
					 1: // Try 100 times , 8'h03 for error code.
					 if( C1 == 100 ) begin D2[7:0] <= CMD24ERR; C1 <= 16'd0; i <= 4'd14; end
					 else if( iDone && iData != 8'h00) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( iDone && iData == 8'h00 ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end
					 else isCall[1] <= 1'b1;
					 
					 2: // Send 800 free clock 
					 if( C1 == 100 ) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else if( iDone ) begin isCall[0] <= 1'b0; C1 <= C1 + 1'b1; end 
					 else isCall[0] <= 1'b1;
					 
					 3: // Send Call Byte 0xfe
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFE; end
					 
					 /*****************/
					 
					 4: // Pull up read req.
					 begin isEn[0] <= 1'b1; i <= i + 1'b1; end
					 
					 5: // Pull down read req.
					 begin isEn[0] <= 1'b0; i <= i + 1'b1; end
					 
					 6: // Write byte read from fifo
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
					 
					 10: // Read respond
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 11: // if not 8'h05, write block faild,  8'h03 for error code.
					 if( (iData & 8'h1F) != 8'h05 ) begin D2[7:0] <= CMD24ERR; i <= 4'd14; end
					 else i <= i + 1'b1;
					 
					 12: // Wait unitl sdcard free
					 if( iDone && iData == 8'hff ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else if( iDone ) begin isCall[0] <= 1'b0; end
					 else begin isCall[0] <= 1'b1; end
					 
					 /*****************/
					 
					 13: // Read OK code;
					 begin D2[7:0] <= CMD24OK; i <= i + 1'b1; end
					 
					 14: // Disable cs and generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 15:
					 begin isDone <= 1'b0; i <= 4'd0; end
				
				endcase
		else if( iCall[6] ) // read block
		      case( i )
					 				
				    0: // Enable cs and prepare cmd 17;
					 begin rCS <= 1'b0; D4 <= { 8'h51, iAddr, 8'hff }; i <= i + 1'b1; end
					 
					 1: // Try 100 times,  ready error code;
					 if( C1 == 100 ) begin D2[7:0] <= CMD17ERR; C1 <= 16'd0; i <= 4'd11; end
					 else if( iDone && iData != 8'h00 ) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( iDone && iData == 8'h00 ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end
					 else isCall[1] <= 1'b1;
					 
					 2: // Waiting read ready 8'hfe
					 if( iDone && iData == 8'hfe ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else if( iDone && iData != 8'hfe ) begin isCall[0] <= 1'b0; end
					 else isCall[0] <= 1'b1;
					 
					 /********/
					 
					 3:  // Read 1 byte form sdcard
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
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end 
					 else isCall[0] <= 1'b1;
					 
					 9: // Disable CS, ready OK code.
					 begin D2[7:0] <= CMD17OK;  rCS <= 1'b1; i <= i + 1'b1; end
					 
					 /********/
					 
					 10: // Send 8 free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end 
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFF; end
					 
					 11: // Disable cs, generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 12:
					 begin isDone <= 1'b0; i <= 4'd0; end
					 
				endcase
		else if( iCall[5] ) // cmd16 
		      case( i )
				
                0: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 1:  // Enable CS
					 begin rCS <= 1'b0; i <= i + 1'b1; end
					 
					 2: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 /************/
					 
					 3: // Prepare cmd 16, 512 block length
					 begin D4 <= { 8'h50,32'd512,8'hff }; i <= i + 1'b1; end
					 
					 4: // Try 100 times, ready error code.
					 if( C1 == 10'd100 ) begin D2[7:0] <= CMD16ERR; C1 <= 16'd0; i <= 4'd8; end
					 else if( (iDone && iData != 8'h00)  ) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( (iDone && iData == 8'h00)  ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 5: // Ready OK code
					 begin D2[7:0] <= CMD16OK; i <= i + 1'b1; end
					 
					 /******************/
					 
					 6,7: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFF; end
					
					 8: // Disable cs , generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 9:
					 begin isDone <= 1'b0; i <= 4'd0; end
					 
				endcase
      else if( iCall[4] ) // cmd58 transfer mode
		      case( i )
				
                0: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 1: // Enable cs
					 begin rCS <= 1'b0; i <= i + 1'b1; end
					 
					 2: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 /************/
					 
					 3: // Prepare cmd 58
					 begin D4 <= { 8'h7A,32'd0,8'h01 }; i <= i + 1'b1; end
					 
					 4: // Try 100 times, ready error code
					 if( C1 == 10'd100 ) begin D2[7:0] <= CMD58ERR; C1 <= 16'd0; i <= 4'd12; end
					 else if( (iDone && iData != 8'h00)  ) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( (iDone && iData == 8'h00)  ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 5: // Store R3
					 begin D2[39:32] <= iData; i <= i + 1'b1; end
					 
					 6: // Read and store R3
					 if( iDone ) begin D2[31:24] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 7: // Read and store R3
					 if( iDone ) begin D2[23:16] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 8: // Read and store R3
					 if( iDone ) begin D2[15:8] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 9: // Read and store R3
					 if( iDone ) begin D2[7:0] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 /******************/
					 
					 10,11: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFF; end
					
					 12: // Disable cs, generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 13:
					 begin isDone <= 1'b0; i <= 4'd0; end
					 
				endcase				
		else if( iCall[3] ) // cmd55 + acmd41
		      case( i )
											    
					 0: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
				
					 1: // Enable cs
					 begin rCS <= 1'b0; i <= i + 1'b1; end
					 
					 2: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
				    /*************/	
					
					 3: // Prepare cmd55
					 begin D4 <= { 8'h77,32'd0,8'hff }; i <= i + 1'b1; end
					 
					 4: // Send and store R1 
					 if( iDone ) begin D2[39:32] <= iData; isCall[1] <= 1'b0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 5: // Prepare acmd41
					 begin D4 <= { 8'h69,8'h40,24'd0,8'hff }; i <= i + 1'b1; end
					  
					 6: // Send and store R1
					 if( iDone ) begin D2[31:24] <= iData; isCall[1] <= 1'b0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 7: // Try 1000 times, ready error code.
					 if( C1 == 16'd1000 ) begin D2[7:0] <= CMD41ERR; C1 <= 16'd0; i <= 4'd10; end
					 else if( iData != 8'h00 ) begin C1 <= C1 + 1'b1; i <= 4'd3; end
					 else if( iData == 8'h00 ) begin C1 <= 16'd0; i <= i + 1'b1; end
					 
					 /******************/
					 					 
					 8: // Disable cs
					 begin rCS <= 1'b1; i <= i + 1'b1; end
					 
					 9: // Send free clock
					 if( C1 == 10 ) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else if( iDone ) begin isCall[0] <= 1'b0; C1 <= C1 + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFF; end
					 
					 10: // Disable cs, generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 11:
					 begin isDone <= 1'b0; i <= 4'd0; end
					 
				endcase
	  else if( iCall[2] ) // cmd58 idle mode
		      case( i )
				
                0: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					  
					 1: // Enable cs 
					 begin rCS <= 1'b0; i <= i + 1'b1; end
					 
					 2: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 /************/
					 
					 3: // prepare cmd 58
					 begin D4 <= { 8'h7A,32'd0,8'h01 }; i <= i + 1'b1; end
					 
					 4: // Try 100 time, ready error code.
					 if( C1 == 10'd100 ) begin D2[7:0] <= CMD58ERR; C1 <= 16'd0; i <= 4'd12; end
					 else if( (iDone && iData != 8'h01)  ) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( (iDone && iData == 8'h01)  ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 5: // Store R3
					 begin D2[39:32] <= iData; i <= i + 1'b1; end
					 
					 6: // Read and store R3
					 if( iDone ) begin D2[31:24] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 7: // Read and store R3
					 if( iDone ) begin D2[23:16] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 8: // Read and store R3
					 if( iDone ) begin D2[15:8] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 9: // Read and store R3
					 if( iDone ) begin D2[7:0] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 /******************/
					 
					 10,11:  // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFF; end
					
					 12: // Disable cs, genarate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 13:
					 begin isDone <= 1'b0; i <= 4'd0; end
					 
				endcase
		 else if( iCall[1] ) // Cmd8
		      case( i )
				   
					 0: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 1: // Enable cs
					 begin rCS <= 1'b0; i <= i + 1'b1; end
					 
					 2: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 /************/
					 
					 3: // Prepare Cmd8 // 8'h01 = 2.7~3.6v, 8'hA0A0 default check pattern
					 begin D4 <= { 8'h48,16'd0,8'h01,8'hAA,8'h87 }; i <= i + 1'b1; end
					 
					 4: // Try 100 times, ready error code.
					 if( C1 == 10'd100 ) begin D2[7:0] <= CMD8ERR; C1 <= 16'd0; i <= 4'd13; end
					 else if( (iDone && iData != 8'h01)  ) begin isCall[1]<= 1'b0; C1 <= C1 + 1'b1; end
					 else if( (iDone && iData == 8'h01)  ) begin isCall[1] <= 1'b0; C1 <= 16'd0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 5: // Store R7
					 begin D2[39:32] <= iData; i <= i + 1'b1; end
					 
					 6: // Read and store R7
					 if( iDone ) begin D2[31:24] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 7: // Read and store R7
					 if( iDone ) begin D2[23:16] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 8: // Read and store R7
					 if( iDone ) begin D2[15:8] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 9: // Read and store R7
					 if( iDone ) begin D2[7:0] <= iData; isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; end
					 
					 10: // Disable cs
					 begin rCS <= 1'b1; i <= i + 1'b1; end
					 
					 /******************/
					 
					 11,12:  // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hFF; end
					 
					 13: // Disable cs, generate done signal
					 begin rCS <= 1'b1; isDone <= 1'b1; i <= i + 1'b1; end
					 
					 14:
					 begin isDone <= 1'b0; i <= 4'd0; end
					 
				endcase
		else if( iCall[0] ) // cmd0
		      case( i )
				
				    0: // Prepare Cmd0
					 begin D4 <= 48'h40_00_00_00_00_95; i <= i + 1'b1; end
				    
					 1: // Wait 1MS for warm up;
					 if( C1 == T1MS -1) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else begin C1 <= C1 + 1'b1; end

					 2: // Send free clock
					 if( C1 == 10'd10 ) begin C1 <= 16'd0; i <= i + 1'b1; end
					 else if( iDone ) begin isCall[0] <= 1'b0; C1 <= C1 + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 3: // Disable cs
					 begin rCS <= 1'b0; i <= i + 1'b1; end
					
					 4: // Try 200 time, ready error code.
					 if( C1 == 10'd200 ) begin D2[7:0] <= CMD0ERR; C1 <= 16'd0; i <= 4'd8; end
					 else if( iDone && iData != 8'h01) begin isCall[1] <= 1'b0; C1 <= C1 + 1'b1; end
					 else if( iDone && iData == 8'h01 ) begin isCall[1] <= 1'b0; D2<= iData; C1 <= 16'd0; i <= i + 1'b1; end 
					 else isCall[1] <= 1'b1;  
					 
					 5: // Disable cs
					 begin rCS <= 1'b1 ; i <= i + 1'b1; end
					 
					 6: // Send free clock
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D1 <= 8'hff; end
					 
					 7: // Ready OK code.
					 begin D2[7:0] <= CMD0OK; i <= i + 1'b1; end
					 
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
