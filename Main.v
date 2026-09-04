`timescale 1ns/1ns

module Main (
    input wire clk, reset,
    output wire [7:0] test
);

    wire incrementa_PC; 
    wire [7:0] ALU_input_Y, saida_AC;
    wire [7:0] PC_out;
    wire ALU_Y, ALU_NOT, ALU_OR, ALU_AND, ALU_ADD;
    wire [7:0] ALU_out_input_AC;
    wire carga_AC;
    wire carga_RI;
    wire [7:0] to_decoder;
    wire carga_NZ;
    wire n_to_cntrl, z_to_cntrl;


    wire nop, sta, lda, add, OR, AND, NOT, w_jmp, jn, jz, hlt, w_carga_pc, w_ual_y, w_ual_add, w_ual_or, w_ual_and, w_ual_not, w_ula_n, w_ula_z;
    wire sel, write, read, selRDM, w_saida_ac, w_sub;
    wire [7:0] to_rem;
    wire [7:0] w_carga_rdm;
    wire unused;
    assign test = saida_AC;

// Memória


    mem_sis mem_main (
        .rem_d(to_rem),
        .mux1(saida_AC),
        .r_z(reset),
        .write(write),
        .read(read),
        .clr(1'b0),
        .mux_sel1(selRDM),
        .rem_e(cargaREM),
        .rdm_e(w_carga_rdm),
        .clk(clk),
        .rdm_out(ALU_input_Y)
    );

    Control_Block Control (
        .NOP(nop),
        .STA(sta),
        .LDA(lda),
        .ADD(add),
        .OR(OR),
        .AND(AND),
        .SUB(w_sub),
        .JMP(w_jmp),
        .JN(jn),
        .JZ(jz),
        .N(n_to_cntrl),
        .SZ(z_to_cntrl),
        .clk(clk),
        .hlt(hlt),
        .rst(reset),
        .cargaRI(carga_RI),
        .gotot0(unused),
        .selRDM(selRDM),
        .carga_AC(carga_AC),
        .carga_NZ(carga_NZ),
        .carga_PC(w_carga_pc),
        .incrementa_PC(incrementa_PC),
        .cargaREM(cargaREM),
        .sel(sel),
        .selREM(unused),
        .write(write),
        .read(read),
        .UALy(w_ual_y),
        .UALadd(w_ual_add),
        .UALor(w_ual_or),
        .UALand(w_ual_and),
        .UALnot(w_ual_not),
        .cargaRDM(w_carga_rdm)
    );




    //Instanciação da ULA

    ALU ALU_main (
        .x(saida_AC),
        .y(ALU_input_Y),
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
        .count_in(ALU_input_Y),
        .count(PC_out)
    );

    D_Flip_Flop_main #(
        .N(8)
    ) AC (
        .clk(clk),
        .reset(reset),
        .enable(carga_AC),
        .data(ALU_out_input_AC),
        .data_out(saida_AC)
    );

    D_Flip_Flop_main #(
        .N(8)
    ) RI (
        .clk(clk),
        .reset(reset),
        .enable(carga_RI),
        .data(ALU_input_Y),
        .data_out(to_decoder)
    );



    D_Flip_Flop_main #(
        .N(1)
    ) N (
        .clk(clk),
        .reset(reset),
        .enable(carga_NZ),
        .data(w_ula_n),
        .data_out(n_to_cntrl)
    );

    D_Flip_Flop_main #(
        .N(1)
    ) Z (
        .clk(clk),
        .reset(reset),
        .enable(carga_NZ),
        .data(w_ula_z),
        .data_out(z_to_cntrl)
    );

    //Área do MUX
    Multiplexer_8bits mux_main (
        .sel(sel),
        .in0(w_saida_ac),
        .in1(ALU_out_input_AC),
        .out(to_rem)
    );


    //Área do decoder

    decoder decoder_main (
        .Op(to_decoder[7:4]),
        .nop(nop),
        .sta(sta),
        .lda(lda),
        .add(add),
        .OR(OR),
        .AND(AND),
        .NOT(NOT),
        .JMP(w_jmp),
        .jn(jn),
        .jz(jz),
        .hlt(hlt)
    );









endmodule