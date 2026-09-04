module D_Flip_Flop_main #(
    parameter N = 8
)(
    input wire clk, reset, enable,
    input wire [N-1:0] data,
    output reg [N-1:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= {N{1'b0}};
    end else if (enable) begin
        data_out <= data;
    end 
end
    
endmodule