module tft_ctrlmod
(
    input CLOCK, RESET,
	 input [2:0]iCall,
	 output oDone,
	 input [31:0]iData,   // [31:24]X ,[23:16]Y ,[15:0] Color
	 output [2:0]oCall,
	 input iDone,
	 output [7:0]oAddr,
	 output [15:0]oData
);
    reg [5:0]i,Go;
	 reg [7:0]D1;   // Command(Register)
	 reg [15:0]D2;  // Data
	 reg [16:0]C1;
	 reg [2:0]isCall;
	 reg isDone;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin 
				    { i,Go } <= { 6'd0,6'd0 };
					 D1 <= 8'd0;
					 D2 <= 16'd0;
					 C1 <= 17'd0;
					 isCall <= 3'd0;
					 isDone <= 1'b0;
				end
		  else if( iCall[2] )  
		      case( i )
				
				    0: // X0
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h4E; D2 <= { 8'd0, iData[31:24] }; end
					 
					 1: // Y0
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h4F; D2 <= { 8'd0, iData[23:16] }; end
					 
					 2: // Write data to ram 0x22
					 if( iDone ) begin isCall[1] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[1] <= 1'b1; D1 <= 8'h22; end
					 
					 /**********/
					 
					 3: // Write color
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[0] <= 1'b1; D2 <= iData[15:0]; end
					
					 /**********/
					 
					 4:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 5:
					 begin isDone <= 1'b0; i <= 6'd0; end
					 
				endcase
		else if( iCall[1] )  // White blank page
		      case( i )
				
				    0: // X0
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h4E; D2 <= 16'h0000; end
					 
					 1: // Y0
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h4F; D2 <= 16'h0000; end
					 
					 2: // Write data to ram 0x22
					 if( iDone ) begin isCall[1] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[1] <= 1'b1; D1 <= 8'h22; end
					 
					 /**********/
					 
					 3: // Write white color 0~768000
					 if( iDone ) begin isCall[0] <= 1'b0; i <= i + 1'b1; Go <= i; end
					 else begin isCall[0] <= 1'b1; D2 <= 16'hFFFF ; end
					 
					 4:
					 if( C1 == 76800 -1 ) begin C1 <= 17'd0; i <= i + 1'b1; end
					 else begin C1 <= C1 + 1'b1; i <= Go; end
					 
					 5:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 6:
					 begin isDone <= 1'b0; i <= 6'd0; end
					 
				endcase
		  else if( iCall[0] )  // Initial TFT
		      case( i )
				
				    0: // Oscillator, On
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h00; D2 <= 16'h0001; end
					 
					 1: // Power control 1
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h03; D2 <= 16'h6664; end
					 
					 2: // Power control 2
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h0C; D2 <= 16'h0000; end
					 
					 3: // Power control 3
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h0D; D2 <= 16'h080C; end
					 
					 4: // Power control 4
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h0E; D2 <= 16'h2B00; end
					 
					 5: // Power control 5
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h1E; D2 <= 16'h00B0; end
					 
                6: // Driver output control, MUX = 319, <R><G><B>
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h01; D2 <= 16'h2B3F; end
					 
					 7: // LCD driving waveform control
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h02; D2 <= 16'h0600; end
					 
					 8: // Sleep mode, weak-up
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h10; D2 <= 16'h0000; end
					 
					 9: // Entry mode, 65k color, DM = 2'b00, AM = 0, ID = 2'b11
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h11; D2 <= 16'h6070; end
					 
					 10: // Compare register
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h05; D2 <= 16'h0000; end
				
				    11: // Compare register
				    if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h06; D2 <= 16'h0000; end
					 
					 12: // Horizontal porch, HBP = 30, XL = 240
				    if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h16; D2 <= 16'hEF1C; end
					 
					 13: // Vertical porch, VBP = 1, VBP = 4
				    if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h17; D2 <= 16'h0003; end
					 
					 14: // Display control, 8 color mode, display on, operation on
				    if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h07; D2 <= 16'h0233; end
					 
					 15: // Frame cycle control
				    if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h0B; D2 <= 16'h0000; end
					 
					 16: // Gate scan position, SCN = 0
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h0F; D2 <= 16'h0000; end
					 
					 17: // Vertical scroll control
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h41; D2 <= 16'h0000; end
					 
					 18: // Vertical scroll control
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h42; D2 <= 16'h0000; end
					 
					 19: // 1st screen driving position, G0~
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h48; D2 <= 16'h0000; end
					 
					 20: // 1st screen driving position, ~G319
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h49; D2 <= 16'h013F; end
					 
					 21: // 2nd screen driving position
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h4A; D2 <= 16'h0000; end
					 
					 22: // 2nd screen driving position
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h4B; D2 <= 16'h0000; end
					 
					 23: // Horizontal RAM address position, HSA = 0 HEA = 239
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h44; D2 <= 16'hEF00; end
					 
					 24: // Vertical RAM address position, VSA = 0 
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h45; D2 <= 16'h0000; end
					 
					 25: // Vertical RAM address position, VEA = 319 
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h46; D2 <= 16'h013F; end
					 
					 26: // Gamma control, PKP0~1
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h30; D2 <= 16'h0707; end
					 
					 27: // Gamma control, PKP2~3
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h31; D2 <= 16'h0204; end
					 
					 28: // Gamma control, PKP4~5
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h32; D2 <= 16'h0204; end
					 
					 29: // Gamma control, PRP0~1
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h33; D2 <= 16'h0502; end
					 
					 30: // Gamma control, PKN0~1
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h34; D2 <= 16'h0507; end
					 
					 31: // Gamma control, PKN2~3
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h35; D2 <= 16'h0204; end
					 
					 32: // Gamma control, PKN4~5
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h36; D2 <= 16'h0204; end
					 
					 33: // Gamma control, PRN0~1
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h37; D2 <= 16'h0502; end
					 
					 34: // Gamma control, VRP0~1
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h3A; D2 <= 16'h0302; end
					 
					 35: // Gamma control, VRN0~1
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h3B; D2 <= 16'h0302; end
					 
					 36: // RAM write data mask
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h23; D2 <= 16'h0000; end
					 
					 37: // RAM write data mask
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h24; D2 <= 16'h0000; end
					 
					 38: // Unknown
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h25; D2 <= 16'h8000; end
					 
					 39: // RAM address set, horizontal(X)
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h4E; D2 <= 16'h0000; end
					 
					 40: // RAM address set, vertical(Y)
					 if( iDone ) begin isCall[2] <= 1'b0; i <= i + 1'b1; end
					 else begin isCall[2] <= 1'b1; D1 <= 8'h4F; D2 <= 16'h0000; end
					 
					 41:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 42:
					 begin isDone <= 1'b0; i <= 6'd0; end

				endcase
				
		assign oCall = isCall;
		assign oDone = isDone;
		assign oAddr = D1;
		assign oData = D2;
				
endmodule
