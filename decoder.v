`timescale 1ns/1ns

module decoder (
    input wire [3:0] Op,
    // Alterado de 'output wire' para 'output reg'
    output reg nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt
);

    always @(Op) begin
        case(Op)
            4'b0000: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b1000000000000000; // NOP
            4'b0001: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0100000000000000; // STA
            4'b0010: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0010000000000000; // LDA
            4'b0011: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0001000000000000; // ADD
            4'b0100: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000100000000000; // OR
            4'b0101: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000010000000000; // AND
            4'b0110: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000001000000000; // NOT
            4'b0111: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000100000000; // unused
            4'b1000: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000010000000; // jmp
            4'b1001: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000001000000; // jn
            4'b1010: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000100000; // jz
            
            4'b1011: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000010000; // unused2
            4'b1100: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000001000; // unused3
            4'b1101: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000000100; // unused4
            4'b1110: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000000010; // unused5

            4'b1111: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000000001; // HLT
            default: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000000000; // default
             
        endcase
    end
endmodule