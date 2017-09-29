module fifo_savemod
(
    input CLOCK, RESET, 
	 input [1:0]iEn,
	 input [15:0]iData,
	 output [15:0]oData,
	 output [1:0]oTag
);
    initial begin
	     for( C1 = 0; C1 < 1024; C1 = C1 + 1'b1 )
		      begin  RAM[ C1 ] <= 16'd0; end	
	 end
    
    reg [15:0] RAM [1023:0]; 
    reg [10:0] C1 = 11'd0,C2 = 11'd0; // N+1
			  
   always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     begin
			      C1 <= 11'd0;
			  end
       else if( iEn[1] ) 
		     begin   
			    RAM[ C1[9:0] ] <= iData; 
				 C1 <= C1 + 1'b1; 
			  end
			  
	always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     begin
					C2 <= 11'd0;
			  end
		 else if( iEn[0] )
				begin 
				    //D1 <= RAM[ C2[9:0] ]; 
					 C2 <= C2 + 1'b1; 
				end
	
	  assign oData = RAM[ C2[9:0]];				
	  assign oTag[1] = ( C1[10]^C2[10] & C1[9:0] == C2[9:0] ); // Full Left
 	  assign oTag[0] = ( C1 == C2 ); // Empty Right

endmodule
