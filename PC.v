`timescale 1ns/1ns

module PC (
    output reg [7:0] count,
    input wire clk, reset, enable, Load,
    input wire [7:0] count_in
);
    always @ (posedge clk or posedge reset)
    begin
        if (reset)
            count <= 0;
        else if (enable)
                if(Load)
                    count <= count_in;
                else
                    count <= count + 1;
                end
endmodule


