module ALU (
    input wire [7:0] x, y,
    input wire [4:0] op_alu,
    output reg [7:0] out,
    output wire n, z
);

    reg [7:0] sig1, sig2, sig3, sig4, sig5;
//    OPULA foi colocado como 5 bits, sendo do mais significativo até o menos significativo a ordem: Y, NOT, OR, AND, ADD
    always @ (*) begin
        case(op_alu)
            5'b00001: out = sig1;
            5'b00100: out = sig2;
            5'b00010: out = sig3;
            5'b01000: out = sig4;
            5'b10000: out = sig5;
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