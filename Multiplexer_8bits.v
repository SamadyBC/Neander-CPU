module Multiplexer_8bits (
    input wire       sel,
    input wire [7:0] in0, in1,
    output reg [7:0] out
);

    always @(*) begin
        if (sel)
            out = in1;
        else
            out = in0;
    end

endmodule