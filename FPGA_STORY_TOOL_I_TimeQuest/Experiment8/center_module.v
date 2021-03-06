module center_module
(
	input CLK,
	input RSTn,
    input [3:0]Din,
    output [3:0]Dout
);
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
    
    /********************************************/
    
endmodule
