module control_block (
    input wire NOP, STA, LDA, ADD, OR, AND, SUB, NOT, JMP, JN, JZ, N, SZ, clk, hlt, rst,
    output reg cargaRI, gotot0, selRDM, carga_AC, carga_NZ, carga_PC, incrementa_PC, cargaREM, sel, selREM, write, read, UALy, UALadd, UALor, UALand, UALnot, cargaRDM
);

    parameter [5:0]
                    search1 = 6'd0,
                    search2 = 6'd1,
                    search3 = 6'd2, 
                    decode_state = 6'd3,
                    state_LDA = 6'd4,
                    state_LDA2 = 6'd5, 
                    state_LDA3 = 6'd6, 
                    state_LDA4 = 6'd7, 
                    state_LDA5 = 6'd8,
                    state_ADD = 6'd9, 
                    state_ADD2 = 6'd10, 
                    state_ADD3 = 6'd11, 
                    state_ADD4 = 6'd12, 
                    state_ADD5 = 6'd13,
                    state_STA = 6'd14, 
                    state_STA2 = 6'd15, 
                    state_STA3 = 6'd16, 
                    state_STA4 = 6'd17, 
                    state_STA5 = 6'd18,
                    state_OR = 6'd19, 
                    state_OR2 = 6'd20, 
                    state_OR3 = 6'd21, 
                    state_OR4 = 6'd22, 
                    state_OR5 = 6'd23,
                    state_AND = 6'd24, 
                    state_AND2 = 6'd25, 
                    state_AND3 = 6'd26, 
                    state_AND4 = 6'd27, 
                    state_AND5 = 6'd28,
                    state_NOT = 6'd29,
                    state_JMP = 6'd30, 
                    state_JMP2 = 6'd31, 
                    state_JMP3 = 6'd32,
                    state_JN = 6'd33, 
                    state_JN2 = 6'd34, 
                    state_JN3 = 6'd35,
                    state_JZ = 6'd36,
                    state_JZ2 = 6'd37,
                    state_JZ3 = 6'd38,
                    state_HLT = 6'd39;
                    
    reg [5:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= search1;
        end else begin
            state <= next_state;
        end
    end
    
    always @ (*) begin
        cargaREM = 1'b0; cargaRI = 1'b0; gotot0 = 1'b0; selRDM = 1'b0; 
        carga_AC = 1'b0; carga_NZ = 1'b0; carga_PC = 1'b0; incrementa_PC = 1'b0; 
        sel = 1'b0; selREM = 1'b0; write = 1'b0; read = 1'b0; 
        UALy = 1'b1;
        UALadd = 1'b0; UALor = 1'b0; UALand = 1'b0; UALnot = 1'b0; cargaRDM = 1'b0; 

        next_state = state; 

        case(state)
            search1: begin 
                cargaREM = 1'b1; 
                sel = 1'b0; 
                next_state = search2;
            end
            
            search2: begin 
                read = 1'b1; 
                cargaRDM = 1'b1; 
                incrementa_PC = 1'b1; 
                next_state = search3; 
            end
            
            search3: begin 
                cargaRI = 1'b1; 
                next_state = decode_state; 
            end

            decode_state: begin 
                if(hlt) next_state = state_HLT;
                else if(NOP) next_state = search1;
                else if(LDA) next_state = state_LDA;
                else if(ADD) next_state = state_ADD;
                else if(STA) next_state = state_STA;
                else if(OR)  next_state = state_OR;
                else if(AND) next_state = state_AND;
                else if(NOT) next_state = state_NOT;
                else if(JMP) next_state = state_JMP;
                else if(JN) next_state = state_JN;
                else if(JZ) next_state = state_JZ;
                else next_state = search1;
            end
            
            state_LDA: begin 
                cargaREM = 1'b1; 
                sel = 1'b0;
                next_state = state_LDA2;
            end
            
            state_LDA2: begin 
                read = 1'b1; 
                cargaRDM = 1'b1; 
                incrementa_PC = 1'b1; 
                next_state = state_LDA3;                
            end

            state_LDA3: begin 
                cargaREM = 1'b1; 
                sel = 1'b1;  
                next_state = state_LDA4;                
            end
            
            state_LDA4: begin 
                read = 1'b1; 
                cargaRDM = 1'b1; 
                next_state = state_LDA5;                
            end

            state_LDA5: begin 
                carga_AC = 1'b1;
                carga_NZ = 1'b1;  
                next_state = search1; 
            end

            state_ADD: begin 
                cargaREM = 1'b1;
                sel = 1'b0; 
                next_state = state_ADD2;  
            end

            state_ADD2: begin 
                read = 1'b1;
                incrementa_PC = 1'b1;
                cargaRDM = 1'b1;
                next_state = state_ADD3;  
            end

            state_ADD3: begin 
                cargaREM = 1'b1;
                sel = 1'b1;
                next_state = state_ADD4;  
            end

            state_ADD4: begin 
                read = 1'b1; 
                cargaRDM = 1'b1;
                next_state = state_ADD5;  
            end

            state_ADD5: begin 
                carga_AC = 1'b1;
                carga_NZ = 1'b1;
                UALy = 1'b0;
                UALadd = 1'b1;
                gotot0 = 1'b1;
                next_state = search1;  
            end

            state_STA: begin
                cargaREM = 1'b1;
                sel = 1'b0;
                next_state = state_STA2;  
            end

            state_STA2: begin
                read = 1'b1; 
                cargaRDM = 1'b1; 
                incrementa_PC = 1'b1; 
                next_state = state_STA3;  
            end

            state_STA3: begin
                cargaREM = 1'b1;
                sel = 1'b1; 
                next_state = state_STA4; 
            end

            state_STA4: begin
                cargaRDM = 1'b1; 
                selRDM = 1'b1; 
                next_state = state_STA5; 
            end

            state_STA5: begin
                write = 1'b1;
                gotot0 = 1'b1;
                next_state = search1;
            end

            state_OR: begin
                cargaREM = 1'b1;
                sel = 1'b0;
                next_state = state_OR2;
            end

            state_OR2: begin
                read = 1'b1; 
                cargaRDM = 1'b1; 
                incrementa_PC = 1'b1;
                next_state = state_OR3;
            end

            state_OR3: begin
                cargaREM = 1'b1;
                sel = 1'b1;        
                next_state = state_OR4;
            end

            state_OR4: begin
                read = 1'b1; 
                cargaRDM = 1'b1; 
                next_state = state_OR5;
            end

            state_OR5: begin
                carga_AC = 1'b1;
                carga_NZ = 1'b1;
                UALy = 1'b0;
                UALor = 1'b1;
                gotot0 = 1'b1;
                next_state = search1;
            end

            state_AND: begin
                cargaREM = 1'b1;
                sel = 1'b0;
                next_state = state_AND2;
            end

            state_AND2: begin
                read = 1'b1; 
                cargaRDM = 1'b1; 
                incrementa_PC = 1'b1;
                next_state = state_AND3;
            end

            state_AND3: begin
                cargaREM = 1'b1;
                sel = 1'b1;        
                next_state = state_AND4;
            end

            state_AND4: begin
                read = 1'b1; 
                cargaRDM = 1'b1; 
                next_state = state_AND5;
            end

            state_AND5: begin
                carga_AC = 1'b1;
                carga_NZ = 1'b1;
                UALy = 1'b0;
                UALand = 1'b1;
                gotot0 = 1'b1;
                next_state = search1;
            end

            state_NOT: begin
                carga_AC = 1'b1;
                carga_NZ = 1'b1;
                UALy = 1'b0;
                UALnot = 1'b1;
                gotot0 = 1'b1;
                next_state = search1;
            end

            state_JMP: begin 
                cargaREM = 1'b1;
                sel = 1'b0;
                next_state = state_JMP2;
            end
            state_JMP2: begin 
                read = 1'b1; 
                cargaRDM = 1'b1; 
                next_state = state_JMP3;
            end
            state_JMP3: begin 
                carga_PC = 1'b1;
                incrementa_PC = 1'b1;
                gotot0 = 1'b1;
                next_state = search1;
            end

            state_JN: begin 
                if (N) begin
                    cargaREM = 1'b1;
                    sel = 1'b0;
                    next_state = state_JN2;
                end else begin
                    incrementa_PC = 1'b1;
                    gotot0 = 1'b1;
                    next_state = search1;
                end
            end

            state_JN2: begin 
                read = 1'b1; 
                cargaRDM = 1'b1; 
                next_state = state_JN3;
            end

            state_JN3: begin 
                carga_PC = 1'b1;
                incrementa_PC = 1'b1;
                gotot0 = 1'b1;
                next_state = search1;
            end
        
            state_JZ: begin 
                if (SZ) begin
                    cargaREM = 1'b1;
                    sel = 1'b0;
                    next_state = state_JZ2;
                end else begin
                    incrementa_PC = 1'b1;
                    gotot0 = 1'b1;
                    next_state = search1;
                end
            end

            state_JZ2: begin 
                read = 1'b1; 
                cargaRDM = 1'b1; 
                next_state = state_JZ3;
            end

            state_JZ3: begin 
                carga_PC = 1'b1;
                incrementa_PC = 1'b1;
                gotot0 = 1'b1;
                next_state = search1;
            end

            state_HLT: begin
                next_state = state_HLT;
            end

            default: begin
                next_state = search1;
            end
        endcase
    end
endmodule
