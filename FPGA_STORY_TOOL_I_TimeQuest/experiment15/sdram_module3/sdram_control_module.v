module sdram_control_module
(
	input CLK,
	input RSTn,
	
	input WrEN_Sig,
	input RdEN_Sig,
	output Done_Sig,
	output Busy_Sig,
	
	input Init_Done_Sig,
	output Init_Start_Sig,

	output [2:0]Func_Start_Sig
	
);

   /*********************************/
    	
	parameter T15US = 11'd1500;
	
	/*********************************/
	
	reg [2:0]i;
	reg [10:0]C1;
	reg [4:0]C2;
	reg [4:0]Used;
    reg [2:0]rStart;
	reg [2:0]isStart; //[2] Auto Refresh , [1] Read Action, [0] Write Action
	reg isInit;
	reg isBusy;
	reg isDone;
	
	always @ ( posedge CLK or negedge RSTn )
	    if( !RSTn )
		     begin
		            i <= 3'd6;          // Initial SDRam at first 
		            C1 <= 11'd0;
		            C2 <= 5'd0;
		            Used <= 5'd0;
		            rStart <= 3'b000;
					isStart <= 3'b000;
					isInit <= 1'b0;
					isBusy <= 1'b1;
					isDone <= 1'b0;
			  end
		 else 
		     case( i )
			  
					0: // IDLE state
					if( C1 >= T15US ) begin C1 <= 11'd0; Used <= 5'd9; rStart <= 3'b100; i <= 3'd1; end
				    else if( RdEN_Sig ) begin C1 <= C1 + 1'b1; Used <= 5'd8; rStart <= 3'b010;i <= 3'd3; end 
					else if( WrEN_Sig ) begin C1 <= C1 + 1'b1; Used <= 5'd9; rStart <= 3'b001;i <= 3'd3; end 
                    else begin C1 <= C1 + 1'b1; end

                    /***************************/

					1: // Auto Refresh Done , 9 clock on this step
					if( C2 == Used -1 ) begin C2 <= 5'd0; i <= i + 1'b1; end
				    else begin isStart <= rStart; C2 <= C2 + 1'b1; end
				    
				    2: // 1 clock one this step			
				    begin isStart <= 3'd0; C1 <= C1 + 1'b1; i <= 3'd0; end
				    
				    /***************************/
				    
				    3: // Read and Write Done
					if( C2 == Used -1) begin C2 <= 5'd0; C1 <= C1 + Used; i <= i + 1'b1; end
					else begin isStart <= rStart; C2 <= C2 + 1'b1; end
					
					/***************************************/
					
					4: // Generate Done Signal
					begin isStart <= 3'd0; isDone <= 1'b1; C1 <= C1 + 1'b1; i <= i + 1'b1; end
					
					5: 
					begin isDone <= 1'b0; C1 <= C1 + 1'b1; i <= 3'd0; end
					
					/******************************************/
					
					6: // Initial SDRam using 21 clock
					if( Init_Done_Sig ) begin isBusy <= 1'b0; isInit <= 1'b0; C1 <= C1 + 1'b1; i <= 3'd0; end
				    else begin isBusy <= 1'b1; isInit <= 1'b1; end
					
					/******************************************/
					
			  endcase
			  
	/***************************************/
	
	assign Init_Start_Sig = isInit;
	assign Func_Start_Sig = isStart;
	assign Done_Sig = isDone;
	assign Busy_Sig = isBusy;
	
	/***************************************/
	
endmodule
