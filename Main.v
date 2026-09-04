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
    
    D_Flip_Flop_main PC (
        .clk(clk),
        .reset(reset),
        .enable(incrementa_PC),
        .data(ALU_input_Y),
        .data_out(PC_out)
    );









endmodule