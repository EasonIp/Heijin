module divider_module
(
    input CLK_Sig,
	 output Q_Sig
);
    
	 /*********************/
	 
	 reg [2:0]C1;
	 
	 always @ ( posedge CLK_Sig ) C1 <= C1 + 1'b1; 
				
	/***********************/
	
   assign Q_Sig = C1[2];
	
	/***********************/

endmodule
