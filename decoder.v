module D_Flip_Flop_main (
    input wire [3:0] Op,
    output wire nop, sta, lda, add, OR, AND, NOT, unused, JMP, jn, jz, unused, unused, unused, unused, hlt
);

    always @(Op) begin
        case(Op)
            4'b0000: {nop, sta, lda, add, OR, AND, NOT, unused, JMP, jn, jz, unused, unused, unused, unused, hlt} = 16'b1000000000000000;
            4'b0001: {nop, sta, lda, add, OR, AND, NOT, unused, JMP, jn, jz, unused, unused, unused, unused, hlt} = 16'b0100000000000000;
            4'b0010: {nop, sta, lda, add, OR, AND, NOT, unused, JMP, jn, jz, unused, unused, unused, unused, hlt} = 16'b0010000000000000;
            4'b0011: {nop, sta, lda, add, OR, AND, NOT, unused, JMP, jn, jz, unused, unused, unused, unused, hlt} = 16'b0001000000000000;
            4'b0100: {nop, sta, lda, add, OR, AND, NOT, unused, JMP, jn, jz, unused, unused, unused, unused,hlt} = 16'b0000100000000000;
            4'b0101: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000010000000000;
            4'b0110: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000001000000000;
            4'b0111: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000100000000;
            4'b1000: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000010000000;
            4'b1001: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000001000000;
            4'b1010: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000000100000;
            4'b1011: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000000010000;
            4'b1100: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000000001000;
            4'b1101: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000000000100;
            4'b1110: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000000000010;
            4'b1111: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000000000001;
            default: {nop ,sta ,lda ,add ,OR ,AND ,NOT ,unused ,JMP ,jn ,jz ,unused ,unused ,unused ,unused,hlt} = 16'b0000000000000000;
        endcase
endmodule