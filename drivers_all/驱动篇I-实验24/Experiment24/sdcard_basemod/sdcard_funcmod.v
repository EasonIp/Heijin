module sdcard_funcmod
(
    input CLOCK, RESET,
	 input SD_DOUT,
	 output SD_CLK,
	 output SD_DI,
	 
	 input [1:0]iCall,
	 output oDone,
	 input [47:0]iAddr,
	 input [7:0]iData,
	 output [7:0]oData
);
    parameter FLCLK = 10'd500, FLHALF = 10'd250, FLQUARTER = 10'd125; //T20US = 100Khz
	 parameter FHCLK = 10'd5, FHHALF = 10'd1, FHQUARTER = 10'd2; // T1us = 10Mhz
	 
	 reg [9:0]isFull,isHalf,isQuarter;
	 
    always @ (  posedge CLOCK or negedge RESET )
	    if( !RESET )
		    begin 
				  isFull <= FLCLK;
				  isHalf <= FLHALF;
				  isQuarter <= FLQUARTER;
		    end	
		 else if( iAddr[47:40] == 8'h41 && isDone )
		    begin
			     isFull <= FHCLK;
				  isHalf <= FHHALF;
				  isQuarter <= FHQUARTER;
			 end
	
	 parameter WRFUNC = 5'd12, RDFUNC = 5'd12;
	
    reg [5:0]i,Go;
	 reg [9:0]C1,C2;
	 reg [7:0]T,D1;
	 reg [47:0]rCMD;
	 reg rSCLK,rDI;
	 reg isDone;
	 
    always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    { i,Go } <= { 6'd0,6'd0};
					 { C1,C2 } <= { 10'd0, 10'd0 };
					 { T,D1 } <= { 8'd0,8'd0 };
					 rCMD <= 48'd0;
					 { rSCLK,rDI } <= 2'b11;
					 isDone <= 1'b0;
				end
		  else if( iCall[1] ) // Write Cmd [5] High [4] Low 
		      case( i )
		
					 0:
					 begin rCMD <= iAddr; i <= i + 1'b1; end 
					 
					 1,2,3,4,5,6:
					 begin T <= rCMD[47:40]; rCMD <= rCMD << 8; i <= WRFUNC; Go <= i + 1'b1; end
					 
					 7:
					 begin i <= RDFUNC; Go <= i + 1'b1; end
					 
					 8:
					 if( C2 == 100 ) begin C2 <= 10'd0; i <= i + 1'b1; end
					 else if( D1 != 8'hff ) begin C2 <= 10'd0; i <= i + 1'b1; end
					 else begin C2 <= C2 + 1'b1; i <= RDFUNC; Go <= i; end
					 
					 9:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 10:
					 begin isDone <= 1'b0; i <= 6'd0; end
					 
					 /******************************/ 
					 
					 12,13,14,15,16,17,18,19: 
					 begin
					      rDI <= T[ 19-i ];
							
					      if( C1 == 0 ) rSCLK <= 1'b0;
							else if( C1 == isHalf ) rSCLK <= 1'b1;
							
							if( C1 == isQuarter ) D1[ 19-i ] <= SD_DOUT;
						  
						   if( C1 == isFull -1 ) begin C1 <= 10'd0; i <= i + 1'b1; end
					      else begin C1 <= C1 + 1'b1; end
					 end
					 
					 20: 
					 begin i <= Go; end
		
            endcase		
		  else if( iCall[0] ) // Write Function [3]HighSpeed [2]LowSpeed
		      case( i )
				    
					 0,1,2,3,4,5,6,7:
					 begin
					      rDI <= iData[ 7-i ];
							
					      if( C1 == 0 ) rSCLK <= 1'b0;
							else if( C1 == isHalf ) rSCLK <= 1'b1;
							
							if( C1 == isQuarter ) D1[ 7-i ] <= SD_DOUT;
							
						   if( C1 == isFull -1 ) begin C1 <= 10'd0; i <= i + 1'b1; end
					      else begin C1 <= C1 + 1'b1; end
					 end
					 
					 8:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 9:
					 begin isDone <= 1'b0; i <= 6'd0; end
				
				endcase    
	
	 assign SD_CLK = rSCLK;	 
	 assign SD_DI = rDI;	 
	 assign oDone = isDone;
	 assign oData = D1;

endmodule
