module center_module
(
	input CLK,
	input RSTn,
    inout [3:0]Data,
    output ext_clk
);
    /********************************************/

    reg [3:0]rData;
    reg isOut;
    reg i;
    
    always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
            begin
                rData <= 4'd0;
                isOut <= 1'b0;
                i <= 1'b0;
            end
        else 
            case( i )
                
                0:
                begin isOut = 1'b0; rData <= Data; i <= 1'b1; end
                
                1:
                begin isOut = 1'b1; i <= 1'b0; end
                
            endcase
    
    /********************************************/
            
    assign Data = isOut ? rData : 4'dz;
    assign ext_clk = CLK;
    
    /********************************************/
    
endmodule
