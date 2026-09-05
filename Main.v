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
        .op_alu({ALU_Y, ALU_NOT, ALU_OR, ALU_AND, ALU_ADD}),
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