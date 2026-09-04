module Control_Block (
    input wire NOP, STA, LDA, ADD, OR, AND, SUB, JMP, JN, JZ, N, SZ, clk, hlt, rst,
    output reg cargaRI, gotot0, selRDM, carga_AC, carga_NZ, carga_PC, incrementa_PC, carga_REM, sel, selREM, write, read, UALy, UALadd, UALor, UALand, UALnot, cargaRDM
);

    parameter [3:0] search = 4'b0000, 
    reg [3:0] state, next_state;

    case(state)
        4'b0000: begin
            if (NOP) next_state <= 4'b0001;
            else if (STA) next_state <= 4'b0010;
            else if (LDA) next_state <= 4'b0011;
            else if (ADD) next_state <= 4'b0100;
            else if (OR) next_state <= 4'b0101;
            else if (AND) next_state <= 4'b0110;
            else if (SUB) next_state <= 4'b0111;
            else if (JMP) next_state <= 4'b1000;
            else if (JN) next_state <= 4'b1001;
            else if (JZ) next_state <= 4'b1010;
        end





    endcase



endmodule