module vga_control_module
(
    input CLK,
	 input RSTn,
	 input [10:0]qC1,
	 input [9:0]qC2,
	 output [2:0]RGB_Sig,
	 input [7:0]ROM_Data,
	 output [10:0]ROM_Addr
	 
);

    /**************************************/
	 
	 // Height , width, x-offset and y-offset
	 parameter _X = 8'd128, _Y = 8'd128, _XOFF = 10'd0, _YOFF = 10'd0; 
	 
	 /**************************************/
    
    reg [6:0]x,y;
    reg [2:0]n1,n2;
	 reg [10:0]rAddr;
	 reg [2:0]rRGB;

    always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
				    x <= 7'd0;
					 y <= 7'd0;
				    n1 <= 3'd0;
					 n2 <= 3'd0;
				    rAddr <= 11'd0;
				    rRGB <= 3'd0;
				end
			else
			   begin
				
				    // step 1 : compute data address and index-n
					 if( (qC1 > 128 + 88 + _XOFF && qC1 <= 128 + 88 + _XOFF +_X) && 
					     (qC2 > 4 + 23 + _YOFF && qC2 <= 4 + 23 + _YOFF + _Y) )
					     begin 
						      x = qC1 - _XOFF - 128 - 88 - 1; 
						      y = qC2 - _YOFF - 4 - 23 - 1;
					         rAddr <= (y << 4) + (x >> 3); 
						      n1 <= ( x - ( (x >> 3) << 3) ); // x & 0x07
					     end
					 else
					     begin n1 <= 3'd0; rAddr <= 11'd17; end
					 
					 // step 2 : reading data from rom
					 n2 <= n1;
					 
					 // step 3 : assign RGB_Sig
					 rRGB <= { ROM_Data[n2], ROM_Data[n2], ROM_Data[n2] };
					 
				end
				
	/****************************/
	
	assign RGB_Sig = rRGB;
	assign ROM_Addr = rAddr;
	
	/*****************************/

endmodule
