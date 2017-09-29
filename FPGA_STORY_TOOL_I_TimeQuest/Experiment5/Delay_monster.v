module Delay_monster
(
    input CLK,
    input RSTn,
    input [7:0]A,
    input [7:0]B,
    output [15:0]Result
);

    /****************************/
     
   wire [15:0]Result_U1; 
   immediate_booth_multiplier_module U1( rA, rB, Result_U1 );
   
   /****************************/
   
    reg [7:0]rA,rB;
    reg [15:0]rProduct;
    reg [3:0]i;
    
    always @ ( posedge CLK or negedge RSTn )
        if( !RSTn )
            begin
                rA <= 8'd0;
                rB <= 8'd0;
                i <= 4'd0;
                rProduct <= 16'd0;
            end
        else 
			case( i )
				
				0:
				begin rA <= A; rB <= B; rProduct <= 16'd0; i <= i + 1'b1; end
				
				1,2,3:
				i <= i + 1'b1;
				
				4:
				begin rProduct <= Result_U1; i <= 4'd0; end
				
			endcase

        
   /*****************************/
   
   assign Result = rProduct;
   
   /*****************************/
        
endmodule
