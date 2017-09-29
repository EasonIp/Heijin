module ps2_init_funcmod
(
    input CLOCK, RESET,
	 inout PS2_CLK, 
	 inout PS2_DAT,
	 output EnSig
);  
    parameter T100US = 13'd5000;
	 parameter WRFUNC = 7'd48;

	 /*******************************/ // sub1
	 
    reg F2,F1; 
	 
    always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      { F2,F1 } <= 2'b11;
		  else 
		      { F2, F1 } <= { F1, PS2_CLK };

	 /*******************************/ // sub2
	 
	 wire isH2L = ( F2 == 1'b1 && F1 == 1'b0 );
	 reg [23:0]D;
	 reg [8:0]T;
	 reg [6:0]i,Go;
	 reg [12:0]C1;
	 reg rCLK,rDAT;
	 reg isQ1,isQ2,isDone;
	 
	 always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    D <= 24'd0;
					 T <= 8'd0;
					 C1 <= 13'd0;
					 { i,Go } <= { 7'd0,7'd0 };
					 { rCLK,rDAT } <= 2'b11;
					 { isQ1,isQ2,isDone } <= 3'b000;
				end
		   else
			    case( i )
				 
				     /***********/ // INIT Normal Mouse 
					  
					  0: // En
					  begin T <= { 1'b0, 8'hF4 }; i <= WRFUNC; Go <= i + 1'b1; end
					  
					  1:
					  isEn <= 1'b1;
					  
					  /****************/ // PS2 Write Function
					  
					  48: // Press low CLK 100us and realse CLK
					  if( C1 == 13'd256 -1 ) begin C1 <= 13'd0; i <= i + 1'b1; end
					  else begin isQ1 = 1'b1; rCLK <= 1'b0; C1 <= C1 + 1'b1; end
					  
					  49:
					  begin isQ1 <= 1'b0; rCLK <= 1'b1; isQ2 <= 1'b1; i <= i + 1'b1; end
					  
					  50: // Send bit[0] start bit
					  if( isH2L ) i <= i + 1'b1;
					  else rDAT <= 1'b0;
					  
					  51,52,53,54,55,56,57,58,59:  // Send bit[1:8] data bit
					  if( isH2L ) i <= i + 1'b1;
					  else rDAT <= T[ i-51 ];
					  
					  60: // // Send bit[10] stop bit
					  if( isH2L ) i <= i + 1'b1;
					  else rDAT <= 1'b1;
					  
					  61,62,63,64,65,66,67,68,69,70,71: // DAT IN and rec ack
					  if( isH2L ) begin i <= Go; end 
					  else isQ2 <= 1'b0; 
					  
					  72:
					  i <= Go;
					    
				 endcase
	 
	 assign PS2_CLK = isQ1 ? rCLK : 1'bz;
	 assign PS2_DAT = isQ2 ? rDAT : 1'bz;
	 assign EnSig = isEn;
  
endmodule
