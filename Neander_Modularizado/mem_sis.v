module mem_sis(
        input wire [7:0] rem_d, mux1,
        input wire r_z, write, read, clr, mux_sel1, rem_e, rdm_e,
        input wire clk,
        output wire [7:0] rdm_out, debug_output
    );

    //Conexoes entre blocos 
    wire [7:0] w_mem_data;

    //Registradores de Estado da Maquina
    reg [1:0] current_state, next_state;

    //Registradores de Endereço e de Dados da Memoria
    reg [7:0] rem, rdm, mux_output;

    //Memoria Ram - Vetor
    reg [7:0] mem [0:255];
    
    initial begin
        // teste
        // ---- programa de teste: todas as instrucoes ----
        mem[8'h00] = 8'h20; // LDA 80
        mem[8'h01] = 8'h80;
        mem[8'h02] = 8'h30; // ADD 81
        mem[8'h03] = 8'h81;
        mem[8'h04] = 8'h10; // STA 82
        mem[8'h05] = 8'h82;
        mem[8'h06] = 8'h40; // OR  83
        mem[8'h07] = 8'h83;
        mem[8'h08] = 8'h50; // AND 84
        mem[8'h09] = 8'h84;
        mem[8'h0A] = 8'h60; // NOT
        mem[8'h0B] = 8'hA0; // JZ  21   (Z=0, segue reto)
        mem[8'h0C] = 8'h21;
        mem[8'h0D] = 8'h90; // JN  10   (N=1, desvia)
        mem[8'h0E] = 8'h10;
        mem[8'h0F] = 8'hF0; // HLT      armadilha

        mem[8'h10] = 8'h20; // LDA 85
        mem[8'h11] = 8'h85;
        mem[8'h12] = 8'h90; // JN  21   (N=0, segue reto)
        mem[8'h13] = 8'h21;
        mem[8'h14] = 8'hA0; // JZ  18   (Z=1, desvia)
        mem[8'h15] = 8'h18;
        mem[8'h16] = 8'hF0; // HLT      armadilha

        mem[8'h17] = 8'h00;
        mem[8'h18] = 8'h00; // NOP
        mem[8'h19] = 8'h80; // JMP 1C
        mem[8'h1A] = 8'h1C;
        mem[8'h1B] = 8'hF0; // HLT      armadilha

        mem[8'h1C] = 8'h20; // LDA 82   (prova o STA)
        mem[8'h1D] = 8'h82;
        mem[8'h1E] = 8'h30; // ADD
        mem[8'h1F] = 8'h81; // Address 81
        mem[8'h20] = 8'hF0; // HLT      fim esperado

        mem[8'h21] = 8'h20; // LDA 86   armadilha
        mem[8'h22] = 8'h86;
        mem[8'h23] = 8'hF0; // HLT

        // ---- dados ----
        mem[8'h80] = 8'hA5;
        mem[8'h81] = 8'h05;
        mem[8'h82] = 8'h00; // destino do STA
        mem[8'h83] = 8'h55;
        mem[8'h84] = 8'h0F;
        mem[8'h85] = 8'h00;
        mem[8'h86] = 8'hEE; // sentinela da armadilha
    end

    parameter wait_m = 2'b00,
        write_m = 2'b01,
        read_m = 2'b10,
        clear_m = 2'b11;

    //Logica Resgistrador de Estados
    always @ ( posedge clk or posedge r_z) begin
        if(r_z) begin
            current_state <= wait_m;
        end else begin
            current_state <= next_state;
        end
    end

    //Logica dos Registradores de dados, enderecos e memoria
    always @ ( posedge clk  or posedge r_z) begin
        if (r_z) begin
            rdm <= 8'h00;
            rem <= 8'h00;
        end else begin
            if (rdm_e) begin 
                rdm <= mux_output;
            end
            if (rem_e) begin
                rem <= rem_d;
            end
            case(current_state)
                wait_m: begin
                    //Estado de espera, nenhuma instrução é executada.
                end
                write_m: begin
                    mem[rem] <= rdm;
                end
                clear_m: begin
                    //Estado nao utilizado devido a complexidade de implementacao de limpeza de todos os endereços de memoria.
                end
            endcase
        end
    end

    // Logica dos Proximos Estados
    always @ (*) begin
        next_state = current_state;
        case(current_state)
            wait_m:  begin
                if (write & !read & !clr) begin
                    next_state = write_m;
                end else if (!write & read & !clr) begin
                    next_state = read_m;
                end else if (!write & !read & clr) begin
                    next_state = clear_m;
                end else begin
                    next_state = wait_m;
                end
            end
            write_m:
                next_state = wait_m;
            read_m:
                next_state = wait_m;
            clear_m:
                next_state = wait_m;
            default: 
                next_state = wait_m;
        endcase
    end

    //Logica Combinacional - Independente do Clock
    always @ (*) begin
        case(mux_sel1)
            1'b0: mux_output = mem[rem];
            1'b1: mux_output = mux1;
            default: mux_output = 8'h00;
        endcase
    end

    assign rdm_out = rdm;
    assign debug_output = mem[8];


endmodule
