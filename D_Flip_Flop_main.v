module D_Flip_Flop_main (
    input wire clk, reset, enable,
    input wire [7:0] data,
    output reg [7:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 8'b0;
    end else if (enable) begin
        data_out <= data;
    end 
end
    
endmodule