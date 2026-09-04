module D_Flip_Flop (
    output reg Q,
    input wire clk, D
    );
        always @(posedge clk)
             begin
                Q <= D;
            end
endmodule
