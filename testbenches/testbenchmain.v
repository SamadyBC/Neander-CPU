`timescale 1ns/1ps

module tb_Main;

    // Entradas para o módulo (usamos reg para poder manipular no testbench)
    reg clk;
    reg reset;

    // Saídas do módulo (usamos wire)
    wire [7:0] test;

    // Instanciação do módulo Main (seu processador)
    neader_core uut (
        .clk(clk),
        .reset(reset),
        .test(test)
    );

    // Geração do Clock (período de 10ns)
    always #5 clk = ~clk;

    initial begin
        // Bloco obrigatório para gerar os gráficos (EPWave) no EDA Playground
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_Main);

        // Inicialização dos sinais
        clk = 0;
        reset = 1;

        // Load RAM while reset is asserted; release on a falling edge.
        #1;
        $readmemh("mem/prog_original.mem", uut.mem_main.mem);
        repeat (3) @(negedge clk);
        reset = 0;

        // Allow 120 clocks for the original program (116 clocks to HLT).
        #1200;
        
        // Exibe o valor final no terminal
        $display("--- Fim da Simulacao ---");
        $display("Valor final da variavel test (AC): %h", test);
        
        // Encerra a simulação
        $finish;
    end

    // Monitora e imprime no terminal sempre que a variável 'test' mudar de valor
    always @(test) begin
        // $time is in this module's unit (1 ns); %0t would print picoseconds.
        $display("Tempo: %0d ns | reset: %b | test: %h", $time, reset, test);
    end

endmodule