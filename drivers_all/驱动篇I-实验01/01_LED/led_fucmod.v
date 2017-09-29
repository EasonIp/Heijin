module led_funcmod
(
    input CLOCK, RESET,
	 output [3:0]LED
);
    parameter T1S = 26'd50_000_000; //1Hz
	 parameter T100MS = 26'd5_000_000; //10Hz
	 parameter T10MS = 26'd500_000; //100Hz
	 parameter T1MS = 26'd50_000; //1000Hz
	 
    reg [3:0]i;
    reg [25:0]C1;
	 reg [3:0]D;
	 reg [25:0]T;
	 reg [3:0]S;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    i <= 4'd0;
				    C1 <= 26'd0;
					 D <= 4'b0001;
					 T <= T1S;
					 S <= 4'b0001;
				end
		  else
		    case( i )
		    
			     0:
				  if( C1 == T -1) begin C1 <= 26'd0; i <= i + 1'b1; end
				  else begin C1 <= C1 + 1'b1; D <= 4'b0001; end
				  
				  1:
				  if( C1 == T -1) begin C1 <= 26'd0; i <= i + 1'b1; end
				  else begin C1 <= C1 + 1'b1; D <= 4'b0010; end
				  
				  2:
				  if( C1 == T -1) begin C1 <= 26'd0; i <= i + 1'b1; end
				  else begin C1 <= C1 + 1'b1; D <= 4'b0100; end
				  
				  3:
				  if( C1 == T -1) begin C1 <= 26'd0; i <= i + 1'b1; end
				  else begin C1 <= C1 + 1'b1; D <= 4'b1000; end
				  
				  4:
				  begin S <= { S[2:0], S[3] }; i <= i + 1'b1; end
				  
				  5:
				  if( S[0] ) begin T <= T1S; i <= 4'd0; end
				  else if( S[1] ) begin T <= T100MS; i <= 4'd0; end
				  else if( S[2] ) begin T <= T10MS; i <= 4'd0; end
				  else if( S[3] ) begin T <= T1MS; i <= 4'd0; end 
				  
          endcase		
	
	assign LED = D;
		
endmodule
