module d_flip_flop (
    output reg Q,
    input wire clk, D
    );
        always @(posedge clk)
             begin
                Q <= D;
            end
endmodule