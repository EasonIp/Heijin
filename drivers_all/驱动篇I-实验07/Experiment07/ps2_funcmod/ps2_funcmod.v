module ps2_funcmod
(
    input CLOCK, RESET,
	 input PS2_CLK, PS2_DAT,
	 output oTrig,
	 output [7:0]oData
);
    parameter BREAK = 8'hF0;
	 parameter FF_Read = 5'd4;
	 
	 /******************/ // sub

    reg F2,F1;
	 
    always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      { F2,F1 } <= 2'b11;
		  else
		      { F2, F1 } <= { F1, PS2_CLK };

	 /******************/ // core
	 
	 wire isH2L = ( F2 == 1'b1 && F1 == 1'b0 );
	 reg [7:0]D1;
	 reg [4:0]i,Go;
	 reg isDone;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    D1 <= 8'd0;
					 i <= 5'd0;
					 Go <= 5'd0;
					 isDone <= 1'b0;
				end
		   else
			    case( i )
				 
				     0:
					  begin i <= FF_Read; Go <= i + 1'b1; end
				  
				     1:
					  if( D1 == BREAK ) begin i <= FF_Read; Go <= 5'd0; end
					  else i <= i + 1'b1;
					  
					  2:
					  begin isDone <= 1'b1; i <= i + 1'b1; end
					  
					  3:
					  begin isDone <= 1'b0; i <= 5'd0; end
					  
					  /*************/ // PS2 read function
					  
					  4:  // Start bit
					  if( isH2L ) i <= i + 1'b1; 
					  
					  5,6,7,8,9,10,11,12:  // Data byte
					  if( isH2L ) begin D1[ i-5 ] <= PS2_DAT; i <= i + 1'b1; end
					  
					  13: // Parity bit
					  if( isH2L ) i <= i + 1'b1;
					  
					  14: // Stop bit
					  if( isH2L ) i <= Go;

				 endcase
				 
    /************************************/
	 
	 assign oTrig = isDone;
	 assign oData = D1;
	 
	 /*************************************/
  
endmodule
