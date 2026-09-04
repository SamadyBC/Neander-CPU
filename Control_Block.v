module Control_Block (
    input wire NOP, STA, LDA, ADD, OR, AND, SUB, JMP, JN, JZ, N, SZ, clk, hlt, rst,
    output reg cargaRI, gotot0, selRDM, carga_AC, carga_NZ, carga_PC, incrementa_PC, carga_REM, sel, selREM, write, read, UALy, UALadd, UALor, UALand, UALnot, cargaRDM
);

    parameter [3:0] search1 = 4'b0000, search2 = 4'b0001;
    reg [3:0] state, next_state;

    
    always @ (posedge clk or posedge rst) begin
        if (rst) begin
            state <= search;
        end else begin
            state <= next_state;
        end
    end



endmodule