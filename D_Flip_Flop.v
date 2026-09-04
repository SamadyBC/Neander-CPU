module D_Flip_Flop (
    output reg Q,
    input wire Clock, D
    );
        always @(posedge Clock)
            if (Reset) begin
                Q <= 1'b0;
            end
            else begin
                Q <= D;
            end
endmodule
