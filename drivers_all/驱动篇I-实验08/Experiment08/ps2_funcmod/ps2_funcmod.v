module ps2_funcmod
(
    input CLOCK, RESET,
	 input PS2_CLK, PS2_DAT,
	 output oTrig,
	 output [7:0]oData,
	 output [2:0]oTag
);

    parameter LSHIFT = 8'h12, LCTRL = 8'h14, LALT = 8'h11, BREAK = 8'hF0;
	 parameter FF_Read = 5'd5;

	 /*******************************/ // sub1
	 
    reg F2,F1; 
	 
    always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      { F2,F1 } <= 2'b11;
		  else
		      { F2, F1 } <= { F1, PS2_CLK };

	 /*******************************/ // core
	 
	 wire isH2L = ( F2 == 1'b1 && F1 == 1'b0 );
	 reg [7:0]D1;
	 reg [2:0]isTag;  // [2] isShift, [1] isCtrl, [0] isAlt
	 reg [4:0]i,Go;
	 reg isDone;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    D1 <= 8'd0;
					 isTag <= 3'd0;
					 i <= 5'd0;
					 Go <= 5'd0;
					 isDone <= 1'b0;
				end
		   else
			    case( i )
					  
					  0: // Read Make
					  begin i <= FF_Read; Go <= i + 1'b1; end
					  
					  1: // Set Flag
					  if( D1 == LSHIFT ) begin isTag[2] <= 1'b1; D1 <= 8'd0; i <= 5'd0;end
					  else if( D1 == LCTRL ) begin isTag[1] <= 1'b1; D1 <= 8'd0; i <= 5'd0; end
					  else if( D1 == LALT ) begin isTag[0] <= 1'b1; D1 <= 8'd0; i <= 5'd0; end
					  else if( D1 == BREAK ) begin i <= FF_Read; Go <= i + 5'd3; end
					  else begin i <= i + 1'b1; end
					  
					  2:
					  begin isDone <= 1'b1; i <= i + 1'b1; end
					  
					  3:
					  begin isDone <= 1'b0; i <= 5'd0; end
					  
					  4: // Clear Flag
					  if( D1 == LSHIFT  ) begin isTag[2] <= 1'b0; D1 <= 8'd0; i <= 5'd0;  end
					  else if( D1 == LCTRL ) begin isTag[1] <= 1'b0; D1 <= 8'd0; i <= 5'd0; end
					  else if( D1 == LALT ) begin isTag[0] <= 1'b0; D1 <= 8'd0; i <= 5'd0;  end
					  else begin D1 <= 8'd0; i <= 5'd0; end

					  /****************/ // PS2 Read Function
					  
					  5:  // Start bit
					  if( isH2L ) i <= i + 1'b1; 
					  
					  6,7,8,9,10,11,12,13:  // Data byte
					  if( isH2L ) begin i <= i + 1'b1; D1[ i-6 ] <= PS2_DAT; end
					  
					  14: // Parity bit
					  if( isH2L ) i <= i + 1'b1;
					  
					  15: // Stop bit
					  if( isH2L ) i <= Go;
					    
				 endcase
	 
	 assign oTrig = isDone;
	 assign oData = D1;
	 assign oTag = isTag;
	
endmodule
