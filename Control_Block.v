`timescale 1ns/1ns

module Control_Block (
    input wire NOP, STA, LDA, ADD, OR, AND, SUB, JMP, JN, JZ, N, SZ, clk, hlt, rst,
    output reg cargaRI, gotot0, selRDM, carga_AC, carga_NZ, carga_PC, incrementa_PC, cargaREM, sel, selREM, write, read, UALy, UALadd, UALor, UALand, UALnot, cargaRDM
);

    parameter [3:0] search1 = 4'b0000, search2 = 4'b0001, search3 = 4'b0010, state_LDA = 4'b0100, state_LDA2 = 4'b0101, state_LDA3 = 4'b0110, state_ADD = 4'b0111, state_NOP = 4'b1111;
    reg [3:0] state, next_state;


    always @(posedge clk) begin
        if (rst) begin
            state <= search1;
        end else begin
            state <= next_state;
        end
    end

    
    always @ (posedge clk) begin
        case(state)
            search1: begin cargaREM <= 1'b1;
            cargaRI <= 1'b0; gotot0 <= 1'b0; selRDM <= 1'b0; carga_AC <= 1'b0; carga_NZ <= 1'b0; carga_PC <= 1'b0; incrementa_PC <= 1'b0; sel <= 1'b0; selREM <= 1'b0; 
            write <= 1'b0; read <= 1'b0; UALy <= 1'b0; UALadd <= 1'b0; UALor <= 1'b0; UALand <= 1'b0; UALnot <= 1'b0; cargaRDM <= 1'b0; 
            next_state <= search2;
            end
            search2:begin cargaREM <= 1'b0;
            cargaRI <= 1'b0; gotot0 <= 1'b0; selRDM <= 1'b0; carga_AC <= 1'b0; carga_NZ <= 1'b0; carga_PC <= 1'b0; incrementa_PC <= 1'b1; sel <= 1'b0; selREM <= 1'b0; 
            write <= 1'b0; read <= 1'b1; UALy <= 1'b0; UALadd <= 1'b0; UALor <= 1'b0; UALand <= 1'b0; UALnot <= 1'b0; cargaRDM <= 1'b1; 
                if(NOP)
                 next_state <= search1;
                else if(LDA)
                        next_state <= state_LDA;
                    else if(ADD)
                        next_state <= state_ADD;
            end
            search3:begin cargaREM <= 1'b0;
                cargaRI <= 1'b1; gotot0 <= 1'b0; selRDM <= 1'b0; carga_AC <= 1'b0; carga_NZ <= 1'b0; carga_PC <= 1'b0; incrementa_PC <= 1'b0; sel <= 1'b0; selREM <= 1'b0;
                write <= 1'b0; read <= 1'b0; UALy <= 1'b0; UALadd <= 1'b0; UALor <= 1'b0; UALand <= 1'b0; UALnot <= 1'b0; cargaRDM <= 1'b0;
                next_state <= search1;
            end
            
            state_LDA: begin cargaREM <= 1'b1;
                cargaRI <= 1'b0; gotot0 <= 1'b0; selRDM <= 1'b0; carga_AC <= 1'b0; carga_NZ <= 1'b0; carga_PC <= 1'b0; incrementa_PC <= 1'b0; sel <= 1'b1; selREM <= 1'b0; 
                write <= 1'b0; read <= 1'b0; UALy <= 1'b0; UALadd <= 1'b0; UALor <= 1'b0; UALand <= 1'b0; UALnot <= 1'b0; cargaRDM <= 1'b0; 
                next_state <= state_LDA2;
            end
            
            state_LDA2: begin cargaREM <= 1'b0;
            cargaRI <= 1'b0; gotot0 <= 1'b0; selRDM <= 1'b0; carga_AC <= 1'b0; carga_NZ <= 1'b0; carga_PC <= 1'b0; incrementa_PC <= 1'b0; sel <= 1'b0; selREM <= 1'b0; 
            write <= 1'b0; read <= 1'b1; UALy <= 1'b0; UALadd <= 1'b0; UALor <= 1'b0; UALand <= 1'b0; UALnot <= 1'b0; cargaRDM <= 1'b1; 
            next_state <= state_LDA3;               
            end

            state_LDA3: begin cargaREM <= 1'b0;
            cargaRI <= 1'b0; gotot0 <= 1'b0; selRDM <= 1'b0; carga_AC <= 1'b1; carga_NZ <= 1'b1; carga_PC <= 1'b0; incrementa_PC <= 1'b0; sel <= 1'b0; selREM <= 1'b0; 
            write <= 1'b0; read <= 1'b0; UALy <= 1'b1; UALadd <= 1'b0; UALor <= 1'b0; UALand <= 1'b0; UALnot <= 1'b0; cargaRDM <= 1'b0; 
            next_state <= search1;               
            end

            state_ADD: begin cargaREM <= 1'b0;
            cargaRI <= 1'b0; gotot0 <= 1'b0; selRDM <= 1'b0; carga_AC <= 1'b1; carga_NZ <= 1'b0; carga_PC <= 1'b0; incrementa_PC <= 1'b0; sel <= 1'b0; selREM <= 1'b0; 
            write <= 1'b0; read <= 1'b0; UALy <= 1'b0; UALadd <= 1'b0; UALor <= 1'b0; UALand <= 1'b0; UALnot <= 1'b0; cargaRDM <= 1'b0; 
            next_state <= search1;  
            end

            

        endcase


    end



endmodule