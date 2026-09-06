`timescale 1ns/1ns

module Main (
    input wire clk, reset,
    output wire [7:0] test
);

    wire incrementa_PC; 
    wire [7:0] w_mem_output, w_saida_ac; 
    wire [7:0] w_pc_to_mux;
    wire ALU_Y, ALU_NOT, ALU_OR, ALU_AND, ALU_ADD;
    wire [7:0] ALU_out_input_AC;
    wire [7:0] to_decoder;
    wire n_to_cntrl, z_to_cntrl;


    // Wires de transmissao de sinais do decodificador de instrucoes para bloco de controle
    wire w_nop, w_sta, w_lda, w_add, w_or, w_and, w_not, w_jmp, w_jn, w_jz, w_hlt;
    // Wires de transmissao de sinais de saida do bloco de controle para ULA, Registradores, Memoria
    wire w_carga_pc, w_ual_y, w_ual_add, w_ual_or, w_ual_and, w_ual_not, w_ula_n, w_ula_z;
    wire w_sel, w_write, w_read, w_sel_rdm, w_carga_rem, w_sub, w_carga_rdm, w_carga_ac, w_carga_ri, w_carga_nz;
    // Wire conexao saida multiplexador que encaminha dados para o registradore de enderecos da memoria
    wire [7:0] w_to_rem;

    wire unused;
    assign test = w_saida_ac;

// Memória


    mem_sis mem_main (
        .rem_d(w_to_rem),
        .mux1(w_saida_ac),
        .r_z(reset),
        .write(w_write),
        .read(w_read),
        .clr(1'b0),
        .mux_sel1(w_sel_rdm),
        .rem_e(w_carga_rem),
        .rdm_e(w_carga_rdm),
        .clk(clk),
        .rdm_out(w_mem_output)
    );

    Control_Block Control (
        .NOP(w_nop),
        .STA(w_sta),
        .LDA(w_lda),
        .ADD(w_add),
        .OR(w_or),
        .AND(w_and),
        .SUB(w_sub),
        .JMP(w_jmp),
        .JN(w_jn),
        .JZ(w_jz),
        .N(n_to_cntrl),
        .SZ(z_to_cntrl),
        .clk(clk),
        .hlt(w_hlt),
        .rst(reset),
        .cargaRI(w_carga_ri),
        .gotot0(unused),
        .selRDM(w_sel_rdm),
        .carga_AC(w_carga_ac),
        .carga_NZ(w_carga_nz),
        .carga_PC(w_carga_pc),
        .incrementa_PC(incrementa_PC),
        .cargaREM(w_carga_rem),
        .sel(w_sel),
        .selREM(unused),
        .write(w_write),
        .read(w_read),
        .UALy(w_ual_y),
        .UALadd(w_ual_add),
        .UALor(w_ual_or),
        .UALand(w_ual_and),
        .UALnot(w_ual_not),
        .cargaRDM(w_carga_rdm)
    );




    //Instanciação da ULA

    ALU ALU_main (
        .x(w_saida_ac),
        .y(w_mem_output),
        .op_alu({w_ual_y, w_ual_not, w_ual_or, w_ual_and, w_ual_add}), 
        .out(ALU_out_input_AC),
        .n(w_ula_n),
        .z(w_ula_z)
    );




    // Area dos Registradores 
    //Aqui é um contador trocar
    PC PC_main (
        .clk(clk),
        .reset(reset),
        .enable(incrementa_PC),
        .Load(w_carga_pc),
        .count_in(w_mem_output),
        .count(w_pc_to_mux)
    );

    D_Flip_Flop_main #(
        .N(8)
    ) AC (
        .clk(clk),
        .reset(reset),
        .enable(w_carga_ac),
        .data(ALU_out_input_AC),
        .data_out(w_saida_ac)
    );

    D_Flip_Flop_main #(
        .N(8)
    ) RI (
        .clk(clk),
        .reset(reset),
        .enable(w_carga_ri),
        .data(w_mem_output),
        .data_out(to_decoder)
    );



    D_Flip_Flop_main #(
        .N(1)
    ) N (
        .clk(clk),
        .reset(reset),
        .enable(w_carga_nz),
        .data(w_ula_n),
        .data_out(n_to_cntrl)
    );

    D_Flip_Flop_main #(
        .N(1)
    ) Z (
        .clk(clk),
        .reset(reset),
        .enable(w_carga_nz),
        .data(w_ula_z),
        .data_out(z_to_cntrl)
    );

    //Área do MUX
    Multiplexer_8bits mux_main (
        .sel(w_sel),
        .in0(w_mem_output),
        .in1(w_pc_to_mux), //Aqui seria o wire de conexao do PC para o mux
        .out(w_to_rem)
    );


    //Área do decoder

    decoder decoder_main (
        .Op(to_decoder[7:4]),
        .nop(w_nop),
        .sta(w_sta),
        .lda(w_lda),
        .add(w_add),
        .OR(w_or),
        .AND(w_and),
        .NOT(w_not),
        .JMP(w_jmp),
        .jn(w_jn),
        .jz(w_jz),
        .hlt(w_hlt)
    );









endmodule


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


module Control_Block (
    input wire NOP, STA, LDA, ADD, OR, AND, SUB, JMP, JN, JZ, N, SZ, clk, hlt, rst,
    output reg cargaRI, gotot0, selRDM, carga_AC, carga_NZ, carga_PC, incrementa_PC, cargaREM, sel, selREM, write, read, UALy, UALadd, UALor, UALand, UALnot, cargaRDM
);

    parameter [4:0] search1 = 4'b00000, 
                    search2 = 4'b00001, 
                    search3 = 4'b00010, 
                    decode_state = 4'b00011,
                    state_LDA = 4'b00100, 
                    state_LDA2 = 4'b00101, 
                    state_LDA3 = 4'b00110, 
                    state_LDA4 = 4'b00111, 
                    state_LDA5 = 4'b01000, 
                    state_ADD = 4'b01001,
                    state_ADD2 = 4'b01010,
                    state_ADD3 = 4'b01011,
                    state_ADD4 = 4'b01100,
                    state_ADD5 = 4'b01101, 
                    state_NOP = 4'b10001;
                    
    reg [4:0] state, next_state;

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
        UALy = 1'b1; // Padrão da ULA é apenas transitar o dado
        UALadd = 1'b0; UALor = 1'b0; UALand = 1'b0; UALnot = 1'b0; cargaRDM = 1'b0; 

        next_state = state; 

        case(state)
            search1: begin 
                cargaREM = 1'b1; 
                sel = 1'b1; 
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
                if(NOP) next_state = search1;
                else if(LDA) next_state = state_LDA;
                else if(ADD) next_state = state_ADD;
                else next_state = search1;
            end
            
            // --- INÍCIO DO CICLO LDA (5 Estados) ---
            state_LDA: begin 
                cargaREM = 1'b1; 
                sel = 1'b1; 
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
                sel = 1'b0;  
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
                UALy = 1'b1; 
                next_state = search1; 
            end

            state_ADD: begin 
                cargaREM = 1'b1;
                sel = 1'b1;
                next_state = state_ADD2;  
            end

            state_ADD2: begin 
                read = 1'b1;
                incrementa_PC = 1'b1;
                cargaRDM = 1'b1;
                UALy = 1'b1;
                next_state = state_ADD3;  
            end

            state_ADD3: begin 
                cargaREM = 1'b1;
                sel = 1'b0;
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
                next_state = search1;  
            end

            default: begin
                next_state = search1;
            end
        endcase
    end
endmodule

module Counter (
    output reg [2:0] Count,
    input wire Clock, Reset 
);
    always @ (posedge Clock or posedge Reset)
        begin
            if (Reset)
                Count <= 0;
            else
                Count <= Count + 1;
        end
endmodule

module D_Flip_Flop_main #(
    parameter N = 8
)(
    input wire clk, reset, enable,
    input wire [N-1:0] data,
    output reg [N-1:0] data_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= {N{1'b0}};
    end else if (enable) begin
        data_out <= data;
    end 
end
    
endmodule

module D_Flip_Flop (
    output reg Q,
    input wire clk, D
    );
        always @(posedge clk)
             begin
                Q <= D;
            end
endmodule

module decoder (
    input wire [3:0] Op,
    // Alterado de 'output wire' para 'output reg'
    output reg nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt
);

    always @(Op) begin
        case(Op)
            4'b0000: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b1000000000000000;
            4'b0001: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0100000000000000;
            4'b0010: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0010000000000000;
            4'b0011: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0001000000000000;
            4'b0100: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000100000000000;
            4'b0101: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000010000000000;
            4'b0110: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000001000000000;
            4'b0111: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000100000000;
            4'b1000: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000010000000;
            4'b1001: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000001000000;
            4'b1010: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000100000;
            default: {nop, sta, lda, add, OR, AND, NOT, unused1, JMP, jn, jz, unused2, unused3, unused4, unused5, hlt} = 16'b0000000000000000; 
        endcase
    end
endmodule


module mem_sis(
        input wire [7:0] rem_d, mux1,
        input wire r_z, write, read, clr, mux_sel1, rem_e, rdm_e,
        input wire clk,
        output wire [7:0] rdm_out
    );

    //Conexoes entre blocos 
    wire [7:0] w_mem_data;

    //Registradores de Estado da Maquina
    reg [1:0] current_state, next_state;

    //Registradores de Endereço e de Dados da Memoria
    reg [7:0] rem, rdm, mux_output;

    //Memoria Ram - Vetor
    reg [7:0] mem [0:255];
    
    initial mem [0] = 8'h20; 
    initial mem [1] = 8'h06;
  	initial mem [2] = 8'h30;
  	initial mem [3] = 8'h07;
  	initial mem [4] = 8'h30;
    initial mem [5] = 8'h08;
  	initial mem [6] = 8'h02;
  	initial mem [7] = 8'h03;
    initial mem [8] = 8'h0C;

    //Constantes para os estados 
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
                    //Nao faz nada
                end
                // read_m: begin     
                //     
                // end
                write_m: begin
                    mem[rem] <= rdm;
                end
                clear_m: begin
                    //mem = 0; - Ou nao limpar ou reset de todas as posicoes usando loop
                end

            endcase
        end
    end

    // Logica dos Proximos Estados
    always @ (*)begin
        next_state = current_state;
        case(current_state)
            wait_m:  begin
                if (write) begin
                    next_state = write_m;
                end else if (read) begin
                    next_state = read_m;
                end else if (clr) begin
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
            1'b0: mux_output = mem[rem];  // Lê DIRETO da matriz de RAM de forma instantânea
            1'b1: mux_output = mux1;
            default: mux_output = 8'h00;
        endcase
    end

    // REMOVA a linha "assign w_mem_data = mem[rem];" que estava solta aqui
    assign rdm_out = rdm;


endmodule

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

module PC (
    output reg [7:0] count,
    input wire clk, reset, enable, Load,
    input wire [7:0] count_in
);
    always @ (posedge clk or posedge reset)
    begin
        if (reset)
            count <= 0;
        else if (enable)
                if(Load)
                    count <= count_in;
                else
                    count <= count + 1;
                end
endmodule

module Temporization_architecture (
    input wire clk,
    input wire halt, goto_t0,
    output reg  t0, t1, t2, t3, t4, t5, t6, t7
);

    wire to_reg2, to_counter, hlt_to_dec;
    wire [2:0] to_dec; 

     D_Flip_Flop  u1(
        .Q(to_reg2),
        .clk(clk),
        .D(goto_t0)
    );

     D_Flip_Flop  u2(
        .Q(to_counter),
        .clk(clk),
        .D(to_reg2)
    );

     Counter  u3(
        .Count(to_dec),
        .Clock(clk),
        .Reset(to_counter)
    );

    always @ (posedge clk)
        case(to_dec)
            3'b000: begin
                t0 <= 1'b1;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b001: begin
                t0 <= 1'b0;t1 <= 1'b1;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b010: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b1;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b011: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b1;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b100: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b1;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b101: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b1;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b110: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b1;t7 <= 1'b0;
            end
            3'b111: begin
                t0 <= 1'b1;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b1;
            end

        endcase




endmodule