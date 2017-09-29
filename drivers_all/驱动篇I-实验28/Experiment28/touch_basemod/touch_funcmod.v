module touch_funcmod
(
    input CLOCK,RESET,
	 output TP_CS_N,
	 output TP_CLK,
	 output TP_DI,
	 input TP_DO,
	 
	 input [1:0]iCall,
	 output oDone,
	 output [7:0]oData
);
     parameter FCLK = 8'd20, FHALF = 8'd10; // 2.5Mhz 
	 parameter WRFUNC = 6'd16, RDFUNC = 6'd32;

    reg [5:0]i,Go;
	 reg [11:0]D1;
	 reg [7:0]C1;
	 reg rCS,rCLK,rDI;
	 reg isDone;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     begin
			      { i,Go } <= { 6'd0, 6'd0 };
					D1 <= 12'd0;
					C1 <= 8'd0;
					{ rCS,rCLK,rDI } <= 3'b111;
					isDone <= 1'b0;
			  end
		 else if( iCall )
		     case( i )
			  
			      0: // [1] Read 12bit X, [0],Read 12 bit Y
					if( iCall[1] ) begin D1[7:0] <= 8'h90; i <= i + 1'b1; end
					else if( iCall[0] ) begin D1[7:0] <= 8'hd0; i <= i + 1'b1; end
					
					1: // Write byte
					begin rCS <= 1'b0; i <= WRFUNC; Go <= i + 1'b1; end
					
					2:  // Wait Busy 
					begin
						 if( C1 == 0 ) rCLK <= 1'b0;
						 else if( C1 == FHALF ) rCLK <= 1'b1;
					    
					    if( C1 == FCLK -1) begin C1 <= 8'd0; i <= i + 1'b1; end
						 else begin C1 <= C1 + 1'b1; end
					end
					
					3: // Read 12 bit
					begin i <= RDFUNC; Go <= i + 1'b1; end
					
					4:
					begin rCS <= 1'b1; i <= i + 1'b1; end
					
					5:
					begin isDone <= 1'b1; i <= i + 1'b1; end
					
					6:
					begin isDone <= 1'b0; i <= 6'd0; end
			      
					/********************/
					
			      16,17,18,19,20,21,22,23:
					begin
					    rDI <= D1[23-i];
						 
					    if( C1 == 0 ) rCLK <= 1'b0;
						 else if( C1 == FHALF ) rCLK <= 1'b1;
					    
					    if( C1 == FCLK -1) begin C1 <= 8'd0; i <= i + 1'b1; end
						 else begin C1 <= C1 + 1'b1; end
					end
					
					24:
					i <= Go;
					
					/********************/
					
					32,33,34,35,36,37,38,39,40,41,42,43:
					begin 
					    if( C1 == FHALF ) D1[43-i] <= TP_DO;
						 
						 if( C1 == 0 ) rCLK <= 1'b0;
						 else if( C1 == FHALF ) rCLK <= 1'b1;
					    
					    if( C1 == FCLK -1) begin C1 <= 8'd0; i <= i + 1'b1; end
						 else begin C1 <= C1 + 1'b1; end
					end
					
					44:
					i <= Go;
			  
			  endcase
			  
		assign TP_CS_N = rCS;
		assign TP_CLK = rCLK;
		assign TP_DI = rDI;
		assign oDone = isDone;
		assign oData = D1[11:4];

endmodule
