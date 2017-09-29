module ps2_calc_funcmod
(
    input CLOCK, RESET,
	 input iTrig,
	 output oTrig,
	 input [23:0]iData,
	 output [19:0]oData
);  
	 wire [8:0]MX = { iData[4], iData[15:8] };
    wire [8:0]MY = { iData[5], iData[23:16] };	 
	 reg [11:0]X,Y; //[11:10] Sign [9:0] Value
	 reg [7:0]DX,DY;
	 reg [3:0]i;
	 reg isDone;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    X <= 12'd0;
					 Y <= 12'd0;
					 i <= 4'd0;
					 isDone <= 1'b0;
				end
		   else  
			    case( i )
				     
					  0:
					  if( iTrig ) i <= i + 1'b1; 
					  
					  
					  1:
					  begin 
					      X <= X + { MX[8],MX[8],MX[8],MX[8],MX[7:0] };
							Y <= Y + { MY[8],MY[8],MY[8],MY[8],MY[7:0] };					      
							i <= i + 1'b1;
					  end
					  
					  2:
					  begin
					      if( X[11:10] == 2'b01 ) X <= { 2'b00, 10'd999 };
							else if( X[11:10] == 2'b11 ) X <= { 2'b00, 10'd0 };
							else if( X[9:0] >= 10'd999 ) X <= { 2'b00, 10'd999 };
							
							if( Y[11:10] == 2'b01 ) Y <= { 2'b00, 10'd1023 };
							else if( Y[11:10] == 2'b11 ) Y <= { 2'b00, 10'd0 };
							else if( Y[9:0] >= 10'd999 ) Y <= { 2'b00, 10'd999 };
					      
							i <= i + 1'b1;
					  end
					  
					  3:
					  begin isDone <= 1'b1; i <= i + 1'b1; end
					  
					  4:
					  begin isDone <= 1'b0; i <= 4'd0; end
					
				 endcase
	 
    assign oData = { Y[9:0],X[9:0] };
	 assign oTrig = isDone;
  
endmodule

					  
					  
