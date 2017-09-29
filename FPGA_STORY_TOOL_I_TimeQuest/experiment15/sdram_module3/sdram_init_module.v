module sdram_init_module
(
     input CLK,
	 input RSTn,
	 
	 input Init_Start_Sig,
	 output Init_Done_Sig,
	 
	 output [4:0]SDRAM_CMD, // [4]CKE , [3]CSn, [2]RAS, [1]CASn, [0]WEn 
	 output [13:0]SDRAM_BA // [13:12]BA , [11:0]Addr
	 
);

    /****************************************/
    
    parameter T200US = 15'd20000;
    
    /*********************************/
	
	parameter _INIT = 5'b01111, _NOP = 5'b10111, _ACT = 5'b10011, _RD = 5'b10101, _WR = 5'b10100,
	          _BSTP = 5'b10110, _PR = 5'b10010, _AR = 5'b10001, _LMR = 5'b10000;
	
	/*********************************/
    
    reg [4:0]i;
    reg [14:0]C1;
    reg [4:0]rCMD;
    reg [13:0]rBA;
    reg isDone;
	
    always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
            begin
                i <= 5'd0;
                C1 <= 15'd0;
                rCMD <= _NOP;
                rBA <= 14'h3fff; // rAddr[13:12] = BA, rAddr[11:0] = Addr, all reset by 1
                isDone <= 1'b0;
            end
        else if( Init_Start_Sig )     
            case( i )

               /*********************************************/
                
               0:  // delay 100~200us
               if( C1 == T200US -1 ) begin C1 <= 15'd0; i <= i + 1'b1; end
               else begin C1 <= C1 + 1'b1; end 
               
               /*******************************************/
               
               1: // Send Precharge Command
               begin rCMD <= _PR; rBA <= 14'h3fff; i <= i + 1'b1; end
               
               2: // Send 1 nop clock for tRP-20ns
               begin rCMD <= _NOP; i <= i + 1'b1; end
               
               3: // Send Auto Refresh Command
               begin rCMD <= _AR; i <= i + 1'b1; end
               
               4,5,6,7,8,9: // Send 6 nop clock for tRFC - 63ns
               begin rCMD <= _NOP; i <= i + 1'b1; end
            
               /**********************************************/
               
               10: // Send Auto Refresh Command
               begin rCMD <= _AR; i <= i + 1'b1; end
               
               11,12,13,14,15,16: // Send 6 nop clock for tRFC - 63ns
               begin rCMD <= _NOP; i <= i + 1'b1; end
               
               17: // Send LMR Cmd. Burst Read & Write,  3'b010 mean CAS latecy = 2, Sequential, 8 burst length
               begin rCMD <= _LMR; rBA <={ 4'd0, 1'b0, 2'd0, 3'b010, 1'b0, 3'b011 }; i <= i + 1'b1; end
               
               18,19: // Send 2 nop CLK for tMRD
               begin rCMD <= _NOP; i <= i + 1'b1; end
               
               /********************************************/
               
               20: // Generate done signal
               begin isDone <= 1'b1; i <= i + 1'b1; end
               
               21:
               begin isDone <= 1'b0; i <= 5'd0; end
               
               /********************************************/
               
            endcase
            
     /*********************************/
    
     assign SDRAM_CMD = rCMD;
	 assign SDRAM_BA = rBA;
	 assign Init_Done_Sig = isDone;
    
    /**********************************/
    
endmodule
