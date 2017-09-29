module sdram_funcmod
(
    input CLOCK,
	 input RESET,
	 
	 output S_CKE, S_NCS, S_NRAS, S_NCAS, S_NWE,
	 output [1:0]S_BA,  //2
	 output [12:0]S_A,  //12, CA0~CA8, RA0~RA12, BA0~BA1, 9+13+2 = 24;
	 output [1:0]S_DQM,
	 inout [15:0]S_DQ,
	 
	 input [3:0]iCall,
	 output oDone,
	 input [23:0]iAddr,  // [23:22]BA,[21:9]Row,[8:0]Column
	 input [63:0]iData,
	 output [63:0]oData
);
	parameter T100US = 14'd13300;
	// tRP 20ns, tRRC 63ns, tRCD 20ns, tMRD 2CLK, tWR/tDPL 2CLK, CAS Latency 3CLK
	parameter TRP = 14'd3, TRRC = 14'd9, TMRD = 14'd2, TRCD = 14'd3, TWR = 14'd2, CL = 14'd3;
	parameter _INIT = 5'b01111, _NOP = 5'b10111, _ACT = 5'b10011, _RD = 5'b10101, _WR = 5'b10100,
	          _BSTP = 5'b10110, _PR = 5'b10010, _AR = 5'b10001, _LMR = 5'b10000;
    
   reg [4:0]i;
   reg [13:0]C1;
	reg [15:0]D1;
	reg [63:0]T;
	reg [4:0]rCMD;
	reg [1:0]rBA;
	reg [12:0]rA;
	reg [1:0]rDQM;
	reg isOut;
	reg isDone;

    always @ ( posedge CLOCK or negedge RESET )
        if( !RESET )
            begin
                i <= 4'd0;
					 C1 <= 14'd0;
					 D1 <= 16'd0;
					 T <= 64'd0;
                rCMD <= _NOP;
                rBA <= 2'b11;
					 rA <= 13'h1fff;
                rDQM <= 2'b00;
                isOut <= 1'b1;
					 isDone <= 1'b0;
            end
		  else if( iCall[3] )
            case( i )
                
                0: // Set IO to output State
                begin isOut <= 1'b1; i <= i + 1'b1; end
                   
                1: // Send Active Command with Bank and Row address
                begin rCMD <= _ACT; rBA <= iAddr[23:22]; rA <= iAddr[21:9]; i <= i + 1'b1; end
					 
					 2: // wait TRCD 20ns
					 if( C1 == TRCD -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
                else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end             
                
                /*********************************************/
                
                3: // Send Write command with row address, pull up A10 1 to Auto Precharge
                begin rCMD <= _WR; rBA <= iAddr[23:22]; rA <= { 4'b0010, iAddr[8:0] }; D1 <= iData[63:48]; i <= i + 1'b1; end
					 
                4:  
					 begin rCMD <= _NOP; D1 <= iData[47:32]; i <= i + 1'b1; end
					 
					 5:
					 begin rCMD <= _NOP; D1 <= iData[31:16]; i <= i + 1'b1; end
					 
					 6:
					 begin rCMD <= _NOP; D1 <= iData[15:0]; i <= i + 1'b1; end
                 
                /**********************************************/
					 
					 7: // wait TWR 2 clock
					 if( C1 == TWR -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
                else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end  
					 
					 8: // wait TRP 20ns
					 if( C1 == TRP -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
                else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end        
					 
                /*******************/
					 
                9: // Generate done signal
                begin isDone <= 1'b1; i <= i + 1'b1; end
					
					 10:
					 begin isDone <= 1'b0; i <= 4'd0; end

            endcase
        else if( iCall[2] )
            case( i )
				
				    0:
					 begin isOut <= 1'b0; D1 <= 16'd0; i <= i + 1'b1; end

                1: // Send Active command with Bank and Row address
                begin rCMD <= _ACT; rBA <= iAddr[23:22]; rA <= iAddr[21:9]; i <= i + 1'b1; end
					 
					 2: // wait TRCD 20ns
					 if( C1 == TRCD -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
                else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end 
            
                /********************/
                
                3: // Send Read command and column address, pull up A10 to Auto Precharge.
                begin rCMD <= _RD; rBA <= iAddr[23:22]; rA <= { 4'b0010, iAddr[8:0]}; i <= i + 1'b1; end

                4: // wait CL 3 clock
                if( C1 == CL -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
                else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end 
                                   
                /********************/ 
                
                5: // Read Data
                begin T[63:48] <= S_DQ; i <= i + 1'b1; end
                
					 6: // Read Data
                begin T[47:32] <= S_DQ; i <= i + 1'b1; end
					 
					 7: // Read Data
                begin T[31:16] <= S_DQ; i <= i + 1'b1; end
					 
					 8: // Read Data
                begin T[15:0] <= S_DQ; i <= i + 1'b1; end
					 
                /********************/
            
                9: // Generate done signal
                begin rCMD <= _NOP; isDone <= 1'b1; i <= i + 1'b1; end
					
					 10:
					 begin isDone <= 1'b0; i <= 4'd0; end

            endcase
		  else if( iCall[1] )
            case( i )
                
					 0: // Send Precharge Command
					 begin rCMD <= _PR; i <= i + 1'b1; end
					 
					 1: // wait TRP 20ns
					 if( C1 == TRP -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
                else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end
					 
                2: // Send Auto Refresh Command
                begin rCMD <= _AR; i <= i + 1'b1; end
               
                3: // wait TRRC 63ns
					 if( C1 == TRRC -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
                else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end
					 
					 4: // Send Auto Refresh Command
                begin rCMD <= _AR; i <= i + 1'b1; end
               
                5: // wait TRRC 63ns
					 if( C1 == TRRC -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
                else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end
                
                /********************/
                
                6: // Generate done signal
                begin isDone <= 1'b1; i <= i + 1'b1; end
					
					 7:
					 begin isDone <= 1'b0; i <= 4'd0; end

            endcase
		  else if( iCall[0] )
			   case( i )
                
               0:  // delay 100us
               if( C1 == T100US -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
               else begin C1 <= C1 + 1'b1; end 
               
               /********************/
               
               1: // Send Precharge Command
               begin rCMD <= _PR; { rBA, rA } <= 15'h3fff; i <= i + 1'b1; end
					
               2: // wait TRP 20ns
					if( C1 == TRP -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
               else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end
               
               3: // Send Auto Refresh Command
               begin rCMD <= _AR; i <= i + 1'b1; end
               
               4: // wait TRRC 63ns
					if( C1 == TRRC -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
               else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end
					
               5: // Send Auto Refresh Command
               begin rCMD <= _AR; i <= i + 1'b1; end
               
               6: // wait TRRC 63ns
					if( C1 == TRRC -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
               else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end
            
               /********************/
               
               7: // Send LMR Cmd. Burst Read & Write,  3'b011 mean CAS latecy = 3, Sequentia 4 burst length
               begin rCMD <= _LMR; rBA <= 2'b11; rA <= { 3'd0, 1'b0, 2'd0, 3'b011, 1'b0, 3'b010 }; i <= i + 1'b1; end
					
					8: // Send 2 nop CLK for tMRD
					if( C1 == TMRD -1 ) begin C1 <= 14'd0; i <= i + 1'b1; end
               else begin rCMD <= _NOP; C1 <= C1 + 1'b1; end
               
               /********************/
               
               9: // Generate done signal
               begin isDone <= 1'b1; i <= i + 1'b1; end
					
					10:
					begin isDone <= 1'b0; i <= 4'd0; end
               
            endcase
  
    assign { S_CKE, S_NCS, S_NRAS, S_NCAS, S_NWE } = rCMD;
	 assign { S_BA, S_A } = { rBA, rA };
	 assign S_DQM = rDQM;
	 assign S_DQ  = isOut ? D1 : 16'hzzzz;
	 assign oDone = isDone;
	 assign oData = T;

endmodule
