module ALU (
    input wire [7:0] x, y,
    input wire [2:0] op_alu,
    output reg [7:0] out,
    output wire n, z
);

    reg [7:0] sig1, sig2, sig3, sig4, sig5;

    always @ (*) begin
        case(op_alu)
            3'b000: out = sig1;
            3'b001: out = sig2;
            3'b010: out = sig3;
            3'b011: out = sig4;
            3'b100: out = sig5;
            default: out = sig5;
        endcase
    end

    always @ (*) begin
        sig1 = x + y;
        sig2 = x | y;
        sig3 = x & y;
        sig4 = ~x;
        sig5 = y;
    end

    assign z = ~(out[7] | out[6] | out[5] | out[4] | out[3] | out[2] | out[1] | out[0]); 
    assign n = out[7];  

endmodule