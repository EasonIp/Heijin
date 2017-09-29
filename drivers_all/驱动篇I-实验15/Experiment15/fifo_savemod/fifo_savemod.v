module fifo_savemod
(
    input CLOCK, RESET, 
	 input [1:0]iEn,
	 input [7:0]iData,
	 output [7:0]oData,
	 output [1:0]oTag
);
    reg [7:0] RAM [15:0]; 
	 reg [7:0]D1;
    reg [4:0]C1,C2; // N+1
			  
   always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     begin
			      C1 <= 5'd0;
			  end
       else if( iEn[1] ) 
		     begin   
			    RAM[ C1[3:0] ] <= iData; 
				 C1 <= C1 + 1'b1; 
			  end
	
   always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     begin
			      D1 <= 8'd0;
					C2 <= 5'd0;
			  end
		 else if( iEn[0] )
				begin 
				    D1 <= RAM[ C2[3:0] ]; 
					 C2 <= C2 + 1'b1; 
				end

   assign oData = D1;				
	assign oTag[1] = ( C1[4]^C2[4] & C1[3:0] == C2[3:0] ); // Full
	assign oTag[0] = ( C1 == C2 ); // Empty
	
endmodule