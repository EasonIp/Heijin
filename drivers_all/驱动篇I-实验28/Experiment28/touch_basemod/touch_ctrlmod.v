module touch_ctrlmod
(
     input CLOCK,RESET,
	  input TP_IRQ,
	  output oDone,
	  output [15:0]oData,
	  
	  output [1:0]oCall,
	  input iDone,
	  input [7:0]iData
);
    reg [5:0]i;
	 reg [7:0]D1,D2;
	 reg [1:0]isCall;
	 reg isDone;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    i <= 6'd0;
					 { D1,D2 } <= { 8'd0,8'd0 };
					 isCall <= 2'd0;
					 isDone <= 1'b0;
				end
		  else
		      case( i )
				
				    0:
					 if( !TP_IRQ ) i <= i + 1'b1; 
					 
					 1:
					 if( iDone ) begin isCall[1] <= 1'b0; D1 <= iData; i <= i + 1'b1; end
					 else begin  isCall[1] <= 1'b1; end
					 
					 2:
					 if( iDone ) begin isCall[0] <= 1'b0; D2 <= iData; i <= i + 1'b1; end
					 else begin  isCall[0] <= 1'b1; end
					 
					 3:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 4:
					 begin isDone <= 1'b0; i <= 6'd0; end
				
				endcase

    assign oDone = isDone;
	 assign oData = {D1,D2};
	 assign oCall = isCall;
				
endmodule

