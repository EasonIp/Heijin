	module sdram_func_module
(
     input CLK,
	 input RSTn,
	 
	 input [2:0]Func_Start_Sig,
	 
	 input [21:0]BRC_Addr,
	 input [15:0]WrData,
	 output [15:0]RdData,
	 
	 output [4:0]SDRAM_CMD, // [4]CKE , [3]CSn, [2]RAS, [1]CASn, [0]WEn 
	 output [13:0]SDRAM_BA, // [13:12]BA , [11:0]Addr
	 inout [15:0]SDRAM_DATA,
	 
	 output SDRAM_LDQM,
	 output SDRAM_UDQM
	
);

    /*************************************/
	
	parameter _INIT = 5'b01111, _NOP = 5'b10111, _ACT = 5'b10011, _RD = 5'b10101, _WR = 5'b10100,
	          _BSTP = 5'b10110, _PR = 5'b10010, _AR = 5'b10001, _LMR = 5'b10000;
	
	/*********************************/
    
    reg [3:0]i;
    reg [9:0]C1;
	reg [4:0]rCMD;
	reg [13:0]rBA;
	reg [1:0]rDQM;
	reg [15:0]rData;
	reg isOut;

    always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
            begin
                i <= 4'd0;
                rCMD <= _NOP;
                rBA <= 14'h3fff;
                rDQM <= 2'b11;
                rData <= 16'd0;
                isOut <= 1'b1;
            end
        else if( Func_Start_Sig[2] )
            case( i )

                /*********************************/
                
                0: // Send Auto Refresh Command
                begin rCMD <= _AR; i <= i + 1'b1; end
                
                1,2,3,4,5,6,7: // Send 7 nop Clk for tRFC-63
                begin rCMD <= _NOP; i <= i + 1'b1; end
                
                /*********************************/
                
                8:  // return i to 0
                begin i <= 4'd0; end
                
                /*************************************/

            endcase
        else if( Func_Start_Sig[1] )
            case( i )

                0: // Set IO to input state
                begin isOut <= 1'b0; rData <= 16'd0; i <= i + 1'b1; end

                1: // Send Active command with Bank and Row address
                begin rCMD <= _ACT; rBA <= BRC_Addr[21:8]; i <= i + 1'b1; end
                
                2: // Send 1 nop Clk for tRCD-20ns
                begin rCMD <= _NOP; i <= i + 1'b1; end
            
                /***************************************/
                
                3: // Send Read command and column address, pull down DQM clock and pull up A10 to auto precharge.
                begin rCMD <= _RD; rBA <= { BRC_Addr[21:20], 4'b0100, BRC_Addr[7:0]}; rDQM <= 2'b00; i <= i + 1'b1; end
                
                4,5: // Send 2 nop Clk for CAS Latency
                begin rCMD <= _NOP; rDQM <= 2'b11; i <= i + 1'b1; end
                                   
                /******************************************/ 
                
                6: // Read Data
                begin rData <= SDRAM_DATA; i <= i + 1'b1; end
                
                /******************************************/
                
                7: // return i to 0
                begin i <= 4'd0; end
                
                /*******************************************/

            endcase
        else if( Func_Start_Sig[0] )
            case( i )
                
                /***************************************/
                
                0: // Set IO to output State
                begin isOut <= 1'b1; i <= i + 1'b1; end
                   
                1: // Send Active Command with Bank and Row address
                begin rCMD <= _ACT; rBA <= BRC_Addr[21:8]; i <= i + 1'b1; end
                
                2: // Send 1 nop Clk for tRCD-20ns
                begin rCMD <= _NOP; i <= i + 1'b1; end                
                
                /*********************************************/
                
                3: // Send Write command with row address, pull down DQM 1 clk and pull up A10 1 clk to Auto Precharge
                begin rCMD <= _WR; rBA <= { BRC_Addr[21:20], 4'b0100, BRC_Addr[7:0] }; rDQM <= 2'b00; i <= i + 1'b1; end
                
                4,5,6,7: // Send 4 nop clk for tDPL/tWR and tRP
                begin rCMD <= _NOP; rDQM <= 2'b11; i <= i + 1'b1; end            
                
                /**********************************************/
                
                8: // return i to 0
                begin i <= 4'd0; end
                
                /*********************************************/
                
            endcase
            
    /************************************/
  
     assign SDRAM_CMD = rCMD;
	 assign SDRAM_BA = rBA;
	 assign SDRAM_DATA = isOut ? WrData : 16'hzzzz;
	 assign { SDRAM_LDQM, SDRAM_UDQM } = rDQM;
	 assign RdData = rData;

    /*************************************/

endmodule
