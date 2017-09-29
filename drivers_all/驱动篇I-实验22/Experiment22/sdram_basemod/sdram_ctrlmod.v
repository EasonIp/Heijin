module sdram_ctrlmod
(
	input CLOCK,
	input RESET,
	input [1:0]iCall, // [1]Write, [0]Read
	output [1:0]oDone,
	output [3:0]oCall,
	input iDone,
	output [23:0]oAddr,
	output [1:0]oTag
);
    parameter WRITE = 4'd1, READ = 4'd4, REFRESH = 4'd7, INITIAL = 4'd8;
	 parameter TREF = 11'd1040;
	
	 reg [1:0]C7;
	 reg [1:0]isDo;
	 
	 always @ ( posedge CLOCK or negedge RESET ) // sub
	     if( !RESET )
		      begin
				     C7 <= 2'b10;
					 isDo <= 2'b00;
				end
		  else
		      begin
				
				    if( iCall[1] & C7[1] ) isDo[1] <= 1'b1;
				    else if( iCall[0] & C7[0] ) isDo[0] <= 1'b1;
					 
					 if( isDo[1] & isDone[1] ) isDo[1] <= 1'b0;
					 else if( isDo[0] & isDone[0] ) isDo[0] <= 1'b0;
				
				    if( isDone ) C7 <= {isDo[0],isDo[1]};
				    else if( iCall ) C7 <= { C7[0], C7[1] };
				
				end
	
	reg [3:0]i;
	reg [10:0]C1;
	reg [3:0]isCall; //[3]Write [2]Read [1]A.Refresh [0]Initial
	reg [1:0]isDone;
	reg [23:0]D;
	reg [24:0]C2,C3;  // N + 1
	
	always @ ( posedge CLOCK or negedge RESET ) // core
	    if( !RESET )
		     begin
		         i <= INITIAL;          // Initial SDRam at first 
		         C1 <= 11'd0;
					isCall <= 4'b0000;
					isDone <= 2'b00;
					D <= 24'd0;
					C2 <= 25'd0;
					C3 <= 25'd0;
			  end
		 else 
		     case( i )
			  
					0: // IDLE
					if( C1 >= TREF ) begin C1 <= 11'd0;  i <= REFRESH; end
					else if( isDo[1] ) begin C1 <= C1 + 1'b1; i <= WRITE; end 
				   else if( isDo[0] ) begin C1 <= C1 + 1'b1; i <= READ; end 
               else begin C1 <= C1 + 1'b1; end

               /***********************/
				    
				   1: //Write 
					if( iDone ) begin isCall[3] <= 1'b0; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					else begin isCall[3] <= 1'b1; D <= C2[23:0]; C1 <= C1 + 1'b1; end
					
					2:
					begin C2 <= C2 + 1'b1; isDone[1] <= 1'b1; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					
					3:
					begin isDone[1] <= 1'b0; C1 <= C1 + 1'b1; i <= 4'd0; end
					
					/***********************/
				    
				   4: // Read
					if( iDone ) begin isCall[2] <= 1'b0; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					else begin isCall[2] <= 1'b1; D <= C3[23:0]; C1 <= C1 + 1'b1; end
					
					5:
					begin C3 <= C3 + 1'b1; isDone[0] <= 1'b1; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					
					6:
					begin isDone[0] <= 1'b0; C1 <= C1 + 1'b1; i <= 4'd0; end
					
					/***********************/
					
					7: // Auto Refresh 
					if( iDone ) begin isCall[1] <= 1'b0; i <= 4'd0; end
				   else begin isCall[1] <= 1'b1; end
					
					/***********************/
					
					8: // Initial 
					if( iDone ) begin isCall[0] <= 1'b0; i <= 4'd0; end
				   else begin isCall[0] <= 1'b1; end
					
			  endcase
	
	assign oDone = isDone;
	assign oCall = isCall;
	assign oAddr = D;
	assign oTag[1] = ( C2[24]^C3[24] & C2[23:0] == C3[23:0] ); 
 	assign oTag[0] = ( C2 == C3 ); 
	
endmodule
