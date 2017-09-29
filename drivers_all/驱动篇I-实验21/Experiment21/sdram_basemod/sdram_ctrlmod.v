module sdram_ctrlmod
(
	input CLOCK,
	input RESET,
	input [1:0]iCall, // [1]Write, [0]Read
	output [1:0]oDone,
	output [3:0]oCall,
	input iDone
);
   parameter WRITE = 4'd1, READ = 4'd4, REFRESH = 4'd7, INITIAL = 4'd8;
	parameter TREF = 11'd1040;
	
	reg [3:0]i;
	reg [10:0]C1;
	reg [3:0]isCall; //[3]Write [2]Read [1]A.Refresh [0]Initial
	reg [1:0]isDone;
	
	always @ ( posedge CLOCK or negedge RESET )
	    if( !RESET )
		     begin
		         i <= INITIAL;          // Initial SDRam at first 
		         C1 <= 11'd0;
					isCall <= 4'b0000;
					isDone <= 2'b00;
			  end
		 else 
		     case( i )
			  
					0: // IDLE
					if( C1 >= TREF ) begin C1 <= 11'd0;  i <= REFRESH; end
					else if( iCall[1] ) begin C1 <= C1 + 1'b1; i <= WRITE; end 
				   else if( iCall[0] ) begin C1 <= C1 + 1'b1; i <= READ; end 
               else begin C1 <= C1 + 1'b1; end

               /***********************/
				    
				   1: //Write 
					if( iDone ) begin isCall[3] <= 1'b0; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					else begin isCall[3] <= 1'b1; C1 <= C1 + 1'b1; end
					
					2:
					begin isDone[1] <= 1'b1; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					
					3:
					begin isDone[1] <= 1'b0; C1 <= C1 + 1'b1; i <= 4'd0; end
					
					/***********************/
				    
				   4: // Read
					if( iDone ) begin isCall[2] <= 1'b0; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					else begin isCall[2] <= 1'b1; C1 <= C1 + 1'b1; end
					
					5:
					begin isDone[0] <= 1'b1; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					
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
					
					/***********************/
					
			  endcase
			  
	/***************************************/
	
	assign oDone = isDone;
	assign oCall = isCall;
	
	/***************************************/
	
endmodule
