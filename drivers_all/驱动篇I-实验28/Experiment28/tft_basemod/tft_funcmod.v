module tft_funcmod
(
    input CLOCK, RESET,
	 output TFT_RS,     // 1 = Data, 0 = Command(Register)
	 output TFT_CS_N,  
	 output TFT_WR_N,
	 output TFT_RD_N,
	 output [15:0]TFT_DB,
	 input [2:0]iCall,  // 1 = Command, 0 = Data
	 output oDone,
	 input [7:0]iAddr,
	 input [15:0]iData
);
	 parameter TCSL = 3, TCSH = 25; // tCSL = 50ns, tCSH = 500ns;
	 
	 reg [3:0]i;
	 reg [4:0]C1;
	 reg [15:0]D1;
	 reg rRS,rCS,rWR,rRD;
	 reg isDone;
	 
    always @ ( posedge CLOCK or negedge RESET )
        if( !RESET )
		      begin
				    i <= 4'd0;
					 C1 <= 5'd0;
					 D1 <= 16'd0;
					 { rRS, rCS, rWR, rRD } <= 4'b1101;
					 isDone <= 1'b0;
				end
		  else if( iCall[2] ) // Write command and data
		      case( i )
				    
					 0:
                if( C1 == TCSL -1 ) begin C1 <= 5'd0; i <= i + 1'b1; end
					 else begin { rRS,rCS } <= 2'b00; D1 <= { 8'd0, iAddr }; C1 <= C1 + 1'b1; end
					 
					 1:
                if( C1 == TCSH -1 ) begin C1 <= 5'd0; i <= i + 1'b1; end
					 else begin { rRS,rCS } <= 2'b01; C1 <= C1 + 1'b1; end
					 
					 2:
                if( C1 == TCSL -1 ) begin C1 <= 5'd0; i <= i + 1'b1; end
					 else begin { rRS,rCS } <= 2'b10; D1 <= iData; C1 <= C1 + 1'b1; end
					 
					 3:
                if( C1 == TCSH -1 ) begin C1 <= 5'd0; i <= i + 1'b1; end
					 else begin { rRS,rCS } <= 2'b11; C1 <= C1 + 1'b1; end
					 
					 4:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 5:
					 begin isDone <= 1'b0; i <= 4'd0; end
				    
				endcase
		  else if( iCall[1] ) // Write command 
		      case( i )
				    
					 0:
                if( C1 == TCSL -1 ) begin C1 <= 5'd0; i <= i + 1'b1; end
					 else begin { rRS,rCS } <= 2'b00; D1 <= { 8'd0, iAddr }; C1 <= C1 + 1'b1; end
					 
					 1:
                if( C1 == TCSH -1 ) begin C1 <= 5'd0; i <= i + 1'b1; end
					 else begin { rRS,rCS } <= 2'b01; C1 <= C1 + 1'b1; end
					 
					 2:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 3:
					 begin isDone <= 1'b0; i <= 4'd0; end
				    
				endcase
		 else if( iCall[0] ) // Write data
		      case( i )
				    
					 0:
                if( C1 == TCSL -1 ) begin C1 <= 5'd0; i <= i + 1'b1; end
					 else begin { rRS,rCS } <= 2'b10; D1 <= iData; C1 <= C1 + 1'b1; end
					 
					 1:
                if( C1 == TCSH -1 ) begin C1 <= 5'd0; i <= i + 1'b1; end
					 else begin { rRS,rCS } <= 2'b11; C1 <= C1 + 1'b1; end
					 
					 2:
					 begin isDone <= 1'b1; i <= i + 1'b1; end
					 
					 3:
					 begin isDone <= 1'b0; i <= 4'd0; end
				    
				endcase
				
    assign TFT_DB = D1;
	 assign TFT_RS = rRS;
	 assign TFT_CS_N = rCS;
	 assign TFT_WR_N = rWR;
	 assign TFT_RD_N = rRD;
	 assign oDone = isDone;
		
endmodule
