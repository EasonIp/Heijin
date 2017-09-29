module key_funcmod
(
    input CLOCK, RESET,
	 input KEY,
	 output [1:0]LED
);
    parameter T10MS = 19'd500_000;
	 
	 /***************************/ //sub
	 
	 reg F2,F1; 
		 
	 always @ ( posedge CLOCK or negedge RESET ) 
	     if( !RESET ) 
		      { F2, F1 } <= 2'b11;
		  else 
		      { F2, F1 } <= { F1, KEY };
				
	 /***************************/ //core			
	
    wire isH2L = ( F2 == 1 && F1 == 0 );
	 wire isL2H = ( F2 == 0 && F1 == 1 );
	 reg [3:0]i;		 
	 reg isPress, isRelease;
	 reg [18:0]C1;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		       begin
				    i <= 4'd0;
					 { isPress,isRelease } <= 2'b00;
					 C1 <= 19'd0;
				 end
		  else
		      case(i)
					 
					 0: // H2L check 
				     if( isH2L ) i <= i + 1'b1;
					 
					 1: // H2L debounce
					 if( C1 == T10MS -1 ) begin C1 <= 19'd0; i <= i + 1'b1; end
					 else C1 <= C1 + 1'b1;
					 
					 2: // Key trigger prees up
					 begin isPress <= 1'b1; i <= i + 1'b1; end
			       
			         3: // Key trigger prees down
					 begin isPress <= 1'b0; i <= i + 1'b1;	end	 
			 	
					 4: // L2H check 
					 if( isL2H ) i <= i + 1'b1;
					 
					 5: // L2H debounce
					 if( C1 == T10MS -1 ) begin C1 <= 19'd0; i <= i + 1'b1; end
					 else C1 <= C1 + 1'b1;		
					 
					 6: // Key trigger prees up
					 begin isRelease <= 1'b1; i <= i + 1'b1; end
			       
			         7: // Key trigger prees down
					 begin isRelease <= 1'b0; i <= 4'd0; end
				
				endcase
				
	/***********************/ // sub-demo
	
	reg [1:0]D1;
	
	always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     D1 <= 2'b00;
		 else if( isPress )
		     D1[1] <= ~D1[1];
		 else if( isRelease )
		     D1[0] <= ~D1[0];
				
	assign LED = D1;

endmodule
