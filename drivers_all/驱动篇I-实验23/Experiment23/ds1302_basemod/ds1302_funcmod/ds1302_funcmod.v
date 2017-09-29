  module ds1302_funcmod
(
    input CLOCK, RESET,
	 output RTC_NRST,RTC_SCLK,
	 inout RTC_DATA,
	 input [1:0]iCall,
	 output oDone,
	 input [7:0]iAddr,iData,
	 output [7:0]oData
);	 
	 parameter FCLK = 6'd25, FHALF = 6'd12; // 2Mhz,(1/2Mhz)/(1/50Mhz)
	 parameter FF_Write = 6'd16, FF_Read = 6'd32;
	 
	 reg [5:0]C1;
    reg [5:0]i,Go;
	 reg [7:0]D1,T;
	 reg rRST, rSCLK, rSIO;
	 reg isQ,isDone;
	 
    always @ ( posedge CLOCK or negedge RESET )	
	     if( !RESET )
		      begin
				    C1 <= 6'd0;
				    { i,Go } <= { 6'd0,6'd0 };
					 { D1,T } <= { 8'd0,8'd0 };
					 { rRST, rSCLK, rSIO } <= 3'b000;
					 { isQ, isDone } <= 2'b00;
				end
		   else if( iCall[1] )
			    case( i )
				     
					  0:
					  begin { rRST,rSCLK } <= 2'b10; T <= iAddr; i <= FF_Write; Go <= i + 1'b1; end
					  
					  1:
					  begin T <= iData; i <= FF_Write; Go <= i + 1'b1; end
					  
					  2:
					  begin { rRST,rSCLK } <= 2'b00; i <= i + 1'b1; end
					  
					  3:
					  begin isDone <= 1'b1; i <= i + 1'b1; end
					  
					  4:
					  begin isDone <= 1'b0; i <= 6'd0; end
					  
					  /******************/
					  
					  16,17,18,19,20,21,22,23:
					  begin
					      isQ = 1'b1;
					      rSIO <= T[i-16];
							
							if( C1 == 0 ) rSCLK <= 1'b0;
 					      else if( C1 == FHALF ) rSCLK <= 1'b1;
					  
					      if( C1 == FCLK -1) begin C1 <= 6'd0; i <= i + 1'b1; end
							else C1 <= C1 + 1'b1;
					  end
					  
					  24:
					  i <= Go;
					  
				 endcase
        else if( iCall[0] )
			    case( i )
				 
				     0 :
					  begin { rRST,rSCLK } <= 2'b10; T <= iAddr; i <= FF_Write; Go <= i + 1'b1; end
					  
					  1:
				     begin i <= FF_Read; Go <= i + 1'b1; end
					  
					  2:
					  begin { rRST,rSCLK } <= 2'b00; D1 <= T; i <= i + 1'b1; end
					  
					  3:
					  begin isDone <= 1'b1; i <= i + 1'b1; end
					  
					  4:
					  begin isDone <= 1'b0; i <= 6'd0; end
					  
					  /*********************/
					  
					  16,17,18,19,20,21,22,23:
					  begin
					      isQ = 1'b1;
					      rSIO <= T[i-16];
							
							if( C1 == 0 ) rSCLK <= 1'b0;
 					      else if( C1 == FHALF ) rSCLK <= 1'b1;
					  
					      if( C1 == FCLK -1) begin C1 <= 6'd0; i <= i + 1'b1; end
							else C1 <= C1 + 1'b1;
					  end
					  
					  24:
					  i <= Go;
					  
					  /*********************/
						
					  32,33,34,35,36,37,38,39:
					  begin
					      isQ = 1'b0;
							
							if( C1 == 0 ) rSCLK <= 1'b0;
 					      else if( C1 == FHALF ) begin rSCLK <= 1'b1; T[i-32] <= RTC_DATA; end
					  
					      if( C1 == FCLK -1) begin C1 <= 6'd0; i <= i + 1'b1; end
							else C1 <= C1 + 1'b1;
					  end
					  
					  40:
					  i <= Go;
					  
				 endcase
		
		assign { RTC_NRST,RTC_SCLK } = { rRST,rSCLK };
		assign RTC_DATA = isQ ? rSIO : 1'bz;
		assign oDone = isDone;
		assign oData = D1;

endmodule


