module Main (
    input wire clk, reset,
    output reg [7:0] test
);

    wire incrementa_PC; 
    reg [7:0] ALU_input_Y, saida_AC;
    wire [7:0] PC_out;
    wire ALU_Y, ALU_NOT, ALU_OR, ALU_AND, ALU_ADD;
    wire [7:0] ALU_out_input_AC;
    wire ULA_n, ULA_z;
    wire carga_AC;
    wire carga_RI;
    wire [7:0] to_decoder;
    wire carga_NZ;
    wire n_to_cntrl, z_to_cntrl;


    wire nop, sta, lda, add, OR, AND, NOT, JMP, jn, jz, hlt;
    wire sel, to_rem, write, read, selRDM,cargaREM;
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
        .rdm_e(cargaRDM),
        .clk(clk),
        .rdm_out(ALU_input_Y),
    );

    Control_Block Control (
        .NOP(nop),
        .STA(sta),
        .LDA(lda),
        .ADD(add),
        .OR(OR),
        .AND(AND),
        .SUB(sub),
        .JMP(jmp),
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
        .carga_PC(carga_PC),
        .incrementa_PC(incrementa_PC),
        .cargaREM(cargaREM),
        .sel(sel),
        .selREM(unused),
        .write(write),
        .read(read),
        .UALy(UAL_Y),
        .UALadd(UAL_ADD),
        .UALor(UAL_OR),
        .UALand(UAL_AND),
        .UALnot(UAL_NOT),
        .cargaRDM(cargaRDM)
    );




    //Instanciação da ULA

    ALU ALU_main (
        .x(saida_AC),
        .y(ALU_input_Y),
        .op_alu({ALU_Y, ALU_NOT, ALU_OR, ALU_AND, ALU_ADD}),
        .out(ALU_out_input_AC),
        .n(ULA_n),
        .z(ULA_z)
    );




    // Area dos Registradores 
    //Aqui é um contador trocar
    PC PC_main (
        .clk(clk),
        .reset(reset),
        .enable(incrementa_PC),
        .load(carga_PC),
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
        .data(ula_n),
        .data_out(n_to_cntrl)
    );

    D_Flip_Flop_main #(
        .N(1)
    ) Z (
        .clk(clk),
        .reset(reset),
        .enable(carga_NZ),
        .data(ula_z),
        .data_out(z_to_cntrl)
    );

    //Área do MUX
    mux mux_main (
        .sel(sel),
        .in0(Saida_PC),
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
        .JMP(JMP),
        .jn(jn),
        .jz(jz),
        .hlt(hlt)
    );









endmodule