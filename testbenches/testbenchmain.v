`timescale 1ns/1ps

module tb_Main;

    // Entradas para o módulo (usamos reg para poder manipular no testbench)
    reg clk;
    reg reset;

    // Saídas do módulo (usamos wire)
    wire [7:0] test;

    // Instanciação do módulo Main (seu processador)
    Main uut (
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

        // Mantém o reset em nível alto por 15ns (passando da primeira borda de subida)
        #15;
        reset = 0;

        // Deixa a simulação rodar tempo suficiente para buscar e executar a instrução
        // Como o acesso e execução demoram alguns ciclos, 100ns deve ser suficiente para ver o teste
        #200;
        
        // Exibe o valor final no terminal
        $display("--- Fim da Simulacao ---");
        $display("Valor final da variavel test (AC): %h", test);
        
        // Encerra a simulação
        $finish;
    end

    // Monitora e imprime no terminal sempre que a variável 'test' mudar de valor
    always @(test) begin
        $display("Tempo: %0t ns | reset: %b | test: %h", $time, reset, test);
    end

endmodule