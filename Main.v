module Main (
    input wire clk, reset,
    output reg [7:0] test
);

    wire incrementa_PC, 
    wire [7:0] ALU_output_Y;
    wire [7:0] PC_out;

    // Area dos Registradores 
    
    D_Flip_Flop_main PC (
        .clk(clk),
        .reset(reset),
        .enable(incrementa_PC),
        .data(ALU_output_Y),
        .data_out(PC_out)
    );









endmodule