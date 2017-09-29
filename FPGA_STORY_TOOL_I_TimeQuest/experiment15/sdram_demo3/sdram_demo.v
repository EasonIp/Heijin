module sdram_demo
(
    input CLK,
    input RSTn,
    
    output SDRAM_CLK,
    output [4:0]SDRAM_CMD,
    output [13:0]SDRAM_BA,
    inout [15:0]SDRAM_DATA,
    
    output SDRAM_UDQM,
    output SDRAM_LDQM,
    
    output [3:0]LED
);

     /********************************/
	 
	 wire Done_Sig;
	 wire Busy_Sig;
	 wire [15:0]RdData;
	 
	 sdram_module U1
	 (
	     .CLK( CLK ),
	     .RSTn( RSTn ),
	     .WrEN_Sig( isWrite ),
	     .RdEN_Sig( isRead ),
	     .Done_Sig( Done_Sig ),
	     .Busy_Sig( Busy_Sig ),
	     .BRC_Addr( rBRC ),
	     .WrData( rData ),
	     .RdData( RdData ),
	     .SDRAM_CMD( SDRAM_CMD ),
	     .SDRAM_BA( SDRAM_BA ),
	     .SDRAM_DATA( SDRAM_DATA ),
	     .SDRAM_UDQM( SDRAM_UDQM ),
	     .SDRAM_LDQM( SDRAM_LDQM )
	 );
	 
	 /***********************************/
	 
	 parameter T3S = 26'd60000000, T1S = 26'd20000000;
	 
	 /***********************************/
	 
	 reg [5:0]i;
	 reg [25:0]C1;
	 reg [4:0]x;
	 reg [15:0]rData;
	 reg [21:0]rBRC;
	 reg [3:0]rLED;
	 reg isWrite;
	 reg isRead;
	 
	 always @ ( posedge CLK or negedge RSTn )
         if( !RSTn )
             begin
                 i <= 6'd0;
                 C1 <= 26'd0;
                 x <= 5'd0;
                 rData <= 16'd0;
                 rBRC <= 22'd0;
                 rLED <= 4'd0;
                 isWrite <= 1'b0;
                 isRead <= 1'b0;
             end
         else 
             case( i )

                 0: // waiting SDRAM initial
                 if( !Busy_Sig ) i <= i + 1'b1;
                 
                 1:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'h1248; rBRC <= 22'd0; end
                 
                 2:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else begin isRead <= 1'b1; rBRC <= 22'd0; end
                 
                 3:
                 begin rLED <= RdData[3:0]; i <= i + 1'b1; end 
           
                 4:
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 5:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else begin isRead <= 1'b1; rBRC <= 22'd0; end
                 
                 6:
                 begin rLED <= RdData[7:4]; i <= i + 1'b1; end
                 
                 7:
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 8:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else begin isRead <= 1'b1; rBRC <= 22'd0; end
                 
                 9:
                 begin rLED <= RdData[11:8]; i <= i + 1'b1; end
                 
                 10:
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 11:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else begin isRead <= 1'b1; rBRC <= 22'd0; end
                 
                 12:
                 begin rLED <= RdData[15:12]; i <= i + 1'b1;end
                
                /****************************************/
                 
                 13:
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                
                 14:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd1; rBRC <= 22'd1; end
                 
                 15:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd2; rBRC <= 22'd2; end
                 
                 16:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd3; rBRC <= 22'd3; end
                 
                 17:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd4; rBRC <= 22'd4; end
                 
                 18:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd5; rBRC <= 22'd5; end

                 19:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd6; rBRC <= 22'd6; end
                 
                 20:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd7; rBRC <= 22'd7; end
                 
                 21:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd8; rBRC <= 22'd8; end
                 
                 22:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd9; rBRC <= 22'd9; end
                 
                 23:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd10; rBRC <= 22'd10; end
                 
                 24:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd11; rBRC <= 22'd11; end
                 
                 25:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd12; rBRC <= 22'd12; end

                 26:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd13; rBRC <= 22'd13; end
                 
                 27:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd14; rBRC <= 22'd14; end
                 
                 28:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else begin isWrite <= 1'b1; rData <= 16'd31; rBRC <= 22'd15; end
                 
                 /*************************************/
                 
                 29:
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 30:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else begin isRead <= 1'b1; rBRC <= 22'd3; end
                 
                 31:
                 begin rLED <= RdData[3:0]; end
                 
                 /*****************/
                 /*
                 32:
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 33:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else begin isRead <= 1'b1; rBRC <= 22'd2; end
                 
                 34:
                 begin rLED <= RdData[3:0]; i <= i + 1'b1; end
                 
                 35:
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1;; end
                 else C1 <= C1 + 1'b1;
                 
                 36:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else begin isRead <= 1'b1; rBRC <= 22'd3; end
                 
                 37:
                 begin rLED <= RdData[3:0]; i <= i + 1'b1; end
                 
                 38:
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1;; end
                 else C1 <= C1 + 1'b1;
                 
                 39:
                 i <= i;
                 */
                 
                 /*
                 if( C1 == T1S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 */
                 /*
                 21:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else begin isRead <= 1'b1; rBRC <= 7; end
                 
                 22:
                 begin rLED <= RdData[3:0]; end
                 */
                 /*
                 
                 12:
                 if( C1 == T3S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 13:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else if( !Busy_Sig ) begin isRead <= 1'b1; rBRC <= 22'd1; end
                 
                 14:
                 begin rLED <= RdData[3:0]; i <= i + 1'b1; end 
                 
                 15:
                 if( C1 == T3S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 16:
                 if( Done_Sig ) begin isWrite <= 1'b0; i <= i + 1'b1; end
                 else if( !Busy_Sig ) begin isWrite <= 1'b1; rData <= 16'h1234; rBRC <= 22'd1; end
                 
                 17:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else if( !Busy_Sig ) begin isRead <= 1'b1; rBRC <= 22'd1; end
                 
                 18:
                 begin rLED <= RdData[3:0];  end 
           /*
                 7:
                 if( C1 == T3S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 8:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else if( !Busy_Sig ) begin isRead <= 1'b1; rBRC <= 22'd0; end
                 
                 9:
                 begin rLED <= RdData[11:8]; i <= i + 1'b1; end
                 
                 10:
                 if( C1 == T3S -1) begin C1 <= 26'd0; i <= i + 1'b1; end
                 else C1 <= C1 + 1'b1;
                 
                 11:
                 if( Done_Sig ) begin isRead <= 1'b0; i <= i + 1'b1; end
                 else if( !Busy_Sig )  begin isRead <= 1'b1; rBRC <= 22'd0; end
                 
                 12:
                 begin rLED <= RdData[15:12]; end
*/
             endcase
             
     /***************************/
     
     assign SDRAM_CLK = CLK;
     assign LED = rLED;
     
     /****************************/
     
endmodule
