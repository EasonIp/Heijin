module immediate_booth_multiplier_module
(
     input [7:0]A,
	 input [7:0]B,
	 output [15:0]Product
);
    /*********************/
    
    wire [7:0]A_Out,S_Out;
    wire [16:0]P_Out_T0;
    
    Task_PreConfig T0( A,B, A_Out, S_Out, P_Out_T0 );
    
    wire [16:0]P_Out_T1;
    Task_Booth T1( P_Out_T0, A_Out, S_Out, P_Out_T1 );
    
    wire [16:0]P_Out_T2;
    Task_Booth T2( P_Out_T1, A_Out, S_Out, P_Out_T2 );
    
    wire [16:0]P_Out_T3;
    Task_Booth T3( P_Out_T2, A_Out, S_Out, P_Out_T3 );
    
    wire [16:0]P_Out_T4;
    Task_Booth T4( P_Out_T3, A_Out, S_Out, P_Out_T4 );
    
    wire [16:0]P_Out_T5;
    Task_Booth T5( P_Out_T4, A_Out, S_Out, P_Out_T5 );
    
    wire [16:0]P_Out_T6;
    Task_Booth T6( P_Out_T5, A_Out, S_Out, P_Out_T6 );
    
    wire [16:0]P_Out_T7;
    Task_Booth T7( P_Out_T6, A_Out, S_Out, P_Out_T7 );
    
    wire [16:0]P_Out_T8;
    Task_Booth T8( P_Out_T7, A_Out, S_Out, P_Out_T8 );
	 
	assign Product = P_Out_T8[16:1];
	
endmodule

module Task_PreConfig
(
    input [7:0]A,B,
    output [7:0]A_Out,S_Out,
    output [16:0]P
);

    assign A_Out = A;
    assign S_Out = ( ~A + 1'b1 );
    assign P = { 8'd0 , B , 1'b0 };

endmodule

module Task_Booth
(
    input [16:0]P_In,
    input [7:0]A_In,S_In,
    
    output [16:0]P_Out
);
   /***************/
   
   	wire [7:0]Diff1 = P_In[16:9] + A_In;
    wire [7:0]Diff2 = P_In[16:9] + S_In;
    
    reg [16:0]P;
    
    always @ (*)
        if( P_In[1:0] == 2'b01 ) P <= { Diff1[7] , Diff1 , P_In[8:1] };
		else if( P_In[1:0] == 2'b10 ) P <= { Diff2[7] , Diff2 , P_In[8:1] };
	    else P <= { P_In[16] , P_In[16:1] };
    
   assign P_Out = P;

endmodule

