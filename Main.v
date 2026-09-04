module Main (
    input wire clk, reset,
    output reg [7:0] test
);

    wire incrementa_PC, 
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

    D_Flip_Flop_main AC #(
        .N(8)
    ) (
        .clk(clk),
        .reset(reset),
        .enable(carga_AC),
        .data(ALU_out_input_AC),
        .data_out(saida_AC)
    );

    D_Flip_Flop_main RI #(
        .N(8)
    ) (
        .clk(clk),
        .reset(reset),
        .enable(carga_RI),
        .data(ALU_input_Y),
        .data_out(to_decoder)
    );



    D_Flip_Flop_main N #(
        .N(1)
    ) (
        .clk(clk),
        .reset(reset),
        .enable(carga_NZ),
        .data(ula_n),
        .data_out(n_to_cntrl)
    );

    D_Flip_Flop_main Z #(
        .N(1)
    ) (
        .clk(clk),
        .reset(reset),
        .enable(carga_NZ),
        .data(ula_z),
        .data_out(z_to_cntrl)
    );

    //Área do MUX



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