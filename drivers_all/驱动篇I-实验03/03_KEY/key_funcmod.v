module key_funcmod
(
    input CLOCK, RESET,
	 input KEY,
	 output [1:0]LED
);
    parameter T10MS = 26'd500_000;   // Deboucing time
	 parameter T3S = 28'd150_000_000; // Long press time
	 
	 /*****************************************/ //sub
	 
	 reg F2,F1; 
		 
	 always @ ( posedge CLOCK or negedge RESET ) 
	     if( !RESET ) 
		      { F2, F1 } <= 2'b11;
		  else 
		      { F2, F1 } <= { F1, KEY };
				
	 /*****************************************/ //core
	
	 wire isH2L = ( F2 == 1 && F1 == 0 ); 
	 wire isL2H = ( F2 == 0 && F1 == 1 );
	 reg [3:0]i;
	 reg isLClick,isSClick;
	 reg [1:0]isTag;
	 reg [27:0]C1;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		       begin
				    i <= 4'd0;
					 isLClick <= 1'd0;
					 isSClick <= 1'b0;
					 isTag <= 2'd0;
					 C1 <= 28'd0;
				 end
		  else
		      case(i)
					 
					 0: // Wait H2L
					 if( isH2L ) i <= i + 1'b1; 
					 
					 1: // H2L debouce
					 if( C1 == T10MS -1 ) begin C1 <= 28'd0; i <= i + 1'b1; end
					 else C1 <= C1 + 1'b1;
					 
					 2: // Key Tag Check 	 
					 if( isL2H ) begin isTag <= 2'd1; C1 <= 28'd0; i <= i + 1'b1; end
					 else if( {F2,F1} == 2'b00 && C1 >= T3S -1 ) begin isTag <= 2'd2; C1 <= 28'd0; i <= i + 1'd1; end
					 else C1 <= C1 + 1'b1;	
					 
					 3: // Tag Trigger (pree up)
					 if( isTag == 2'd1 ) begin isSClick <= 1'b1; i <= i + 1'b1; end
					 else if( isTag == 2'd2 ) begin isLClick <= 1'b1; i <= i + 1'b1; end
					 
					 4: // Tag Trigger (pree down)
					 begin { isLClick,isSClick } <= 2'b00; i <= i + 1'b1; end
					 
					 5: // L2H deboce check
					 if( isTag == 2'd1 ) begin isTag <= 2'd0; i <= i + 2'd2; end
					 else if( isTag == 2'd2 ) begin isTag <= 2'd0; i <= i + 1'b1; end
					 
					 6: // Wait L2H
					 if( isL2H )i <= i + 1'b1; 
					 
					 7: // L2H debonce
					 if( C1 == T10MS -1 ) begin C1 <= 28'd0; i <= 4'd0; end
					 else C1 <= C1 + 1'b1;
					 
				endcase
				
	/*************************/ // sub demo		
	
	reg [1:0]D1;
	
	always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     D1 <= 2'b00;
		 else if( isLClick )
		     D1[1] <= ~D1[1];
	    else if( isSClick )		 
		     D1[0] <= ~D1[0]; 
			  
	/***************************/
		 
	assign LED = D1;

endmodule
