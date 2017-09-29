module vga_ctrlmod
(
    input CLOCK, RESET,
	 output [15:0]VGAD,
	 output [13:0]oAddr,
	 input [15:0]iData,
	 input [20:0]iAddr  // [20:10]X ,[9:0]Y
);
	 parameter SA = 11'd136, SB = 11'd160, SC = 11'd1024, SD = 11'd24, SE = 11'd1344;
	 parameter SO = 11'd6, SP = 11'd29, SQ = 11'd768, SR = 11'd3, SS = 11'd806;
	 
	 // Height , width, x-offset and y-offset
	 parameter XSIZE = 8'd128, YSIZE = 8'd96, XOFF = 10'd0, YOFF = 10'd0; 
    
	 wire isX = ( (iAddr[20:10] >= SA + SB + XOFF -1 ) && ( iAddr[20:10] <= SA + SB + XOFF + XSIZE -1) );
	 wire isY = ( (iAddr[9:0] >= SO + SP + YOFF -1 ) && ( iAddr[9:0] <= SO + SP + YOFF + YSIZE -1) );
	 wire isReady = isX & isY;
	 
	 wire [31:0] x = iAddr[20:10] - XOFF - SA - SB -1; 
	 wire [31:0] y = iAddr[9:0] - YOFF - SO - SP -1;
	 
	 reg [31:0]D1;
	 reg [15:0]rVGAD;
	 
     always @ ( posedge CLOCK or negedge RESET )
	     if( !RESET )
		      begin
				    D1 <= 18'd0;
				    rVGAD <= 16'd0;
				end
			else
			   begin
				
				    // step 1 : compute data address and index-n
					 if( isReady )
					     D1 <= (y << 7) + x; 
					 else
					     D1 <= 14'd0;
					 
					 // step 2 : reading data from rom
					 // but do-nothing
					 
					 // step 3 : assign RGB_Sig
					 rVGAD <= isReady ? iData : 16'd0;
					 
				end
				
	assign VGAD = rVGAD;
	assign oAddr = D1[13:0];

endmodule
