module center_module
(
	input CLK,
	input RSTn,
    input [3:0]Din,
    output [3:0]Dout,
    output ext1_clk,ext2_clk
);
    /********************************************/
    
    reg ext_div2;
    
    always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
            begin
                ext_div2 <= 1'b0;
            end
        else 
            begin
                ext_div2 <= ~ext_div2;
            end

    /********************************************/
    
    reg [3:0]rData;
    
    always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
            begin
                rData <= 4'd0;
            end
        else 
            begin
                rData <= Din;
            end
    
    /********************************************/
            
    assign Dout = rData;
    assign ext1_clk = ext_div2;
    assign ext2_clk = ext_div2;
    
    /********************************************/
    
endmodule
