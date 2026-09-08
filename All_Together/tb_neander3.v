`timescale 1ns/1ns

//=====================================================================
//  Testbench completo do Neander
//
//  Cobre: NOP, LDA, ADD, STA, OR, AND, NOT, JMP, JN (tomado e nao
//  tomado), JZ (tomado e nao tomado) e HLT.
//
//  Alem de conferir o resultado final, registra quais caminhos da
//  maquina de estados foram realmente percorridos - assim um teste
//  que passa "por acaso" nao passa despercebido.
//
//  O programa e carregado a partir DAQUI, por referencia hierarquica,
//  entao o All_Together.v nao precisa ser alterado.
//
//  Como rodar:
//      iverilog -Wall -g2005 -o neander.vvp tb_neander_full.v All_Together.v
//      vvp neander.vvp
//=====================================================================

module tb_neander_full;

    reg clk   = 1'b0;
    reg reset = 1'b1;
    wire [7:0] test;

    integer erros = 0;
    integer i;

    // Codigos dos estados do Control_Block
    localparam S_DECODE = 6'd3;
    localparam S_LDA    = 6'd4;
    localparam S_ADD    = 6'd9;
    localparam S_STA    = 6'd14;
    localparam S_OR     = 6'd19;
    localparam S_AND    = 6'd24;
    localparam S_NOT    = 6'd29;
    localparam S_JMP    = 6'd30;
    localparam S_JN     = 6'd33;
    localparam S_JZ     = 6'd36;
    localparam S_HLT    = 6'd39;

    // Ponha em 0 para desligar o trace instrucao a instrucao
    localparam TRACE = 1;

    // Marcadores de cobertura
    reg viu_nop        = 1'b0;
    reg viu_lda        = 1'b0;
    reg viu_add        = 1'b0;
    reg viu_sta        = 1'b0;
    reg viu_or         = 1'b0;
    reg viu_and        = 1'b0;
    reg viu_not        = 1'b0;
    reg viu_jmp        = 1'b0;
    reg viu_jn_tomado  = 1'b0;
    reg viu_jn_reto    = 1'b0;
    reg viu_jz_tomado  = 1'b0;
    reg viu_jz_reto    = 1'b0;
    reg viu_hlt        = 1'b0;

    Main dut (
        .clk(clk),
        .reset(reset),
        .test(test)
    );

    always #5 clk = ~clk;

    //-----------------------------------------------------------------
    //  Programa de teste
    //
    //  end.  bytes    instrucao      efeito esperado
    //  ----  -------  -------------  --------------------------------
    //  00    00       NOP            nada
    //  01    20 40    LDA 40         AC <- 0F
    //  03    30 41    ADD 41         AC <- 0F + 11 = 20
    //  05    10 50    STA 50         mem[50] <- 20
    //  07    40 42    OR  42         AC <- 20 | F0 = F0   (N=1)
    //  09    50 40    AND 40         AC <- F0 & 0F = 00   (Z=1)
    //  0B    A0 10    JZ  10         Z=1  -> DESVIA
    //  0D    80 38    JMP 38         armadilha
    //
    //  10    60       NOT            AC <- FF             (N=1)
    //  11    A0 38    JZ  38         Z=0  -> NAO desvia
    //  13    90 18    JN  18         N=1  -> DESVIA
    //  15    80 38    JMP 38         armadilha
    //
    //  18    20 40    LDA 40         AC <- 0F             (N=0)
    //  1A    90 38    JN  38         N=0  -> NAO desvia
    //  1C    00       NOP
    //  1D    80 20    JMP 20         DESVIA sempre
    //
    //  20    20 50    LDA 50         AC <- mem[50] = 20  (prova o STA)
    //  22    F0       HLT
    //
    //  38    20 44    LDA 44         AC <- EE  (armadilha)
    //  3A    F0       HLT
    //
    //  Dados: 40=0F  41=11  42=F0  44=EE  50=00
    //
    //  Esperado: AC = 0x20, mem[50] = 0x20, PC = 0x23, N=0, Z=0
    //  Qualquer desvio errado termina com AC = 0xEE.
    //-----------------------------------------------------------------
    task carrega_programa;
        begin
            for (i = 0; i < 256; i = i + 1)
                dut.mem_main.mem[i] = 8'h00;

            dut.mem_main.mem[8'h00] = 8'h00;
            dut.mem_main.mem[8'h01] = 8'h20;
            dut.mem_main.mem[8'h02] = 8'h40;
            dut.mem_main.mem[8'h03] = 8'h30;
            dut.mem_main.mem[8'h04] = 8'h41;
            dut.mem_main.mem[8'h05] = 8'h10;
            dut.mem_main.mem[8'h06] = 8'h50;
            dut.mem_main.mem[8'h07] = 8'h40;
            dut.mem_main.mem[8'h08] = 8'h42;
            dut.mem_main.mem[8'h09] = 8'h50;
            dut.mem_main.mem[8'h0A] = 8'h40;
            dut.mem_main.mem[8'h0B] = 8'hA0;
            dut.mem_main.mem[8'h0C] = 8'h10;
            dut.mem_main.mem[8'h0D] = 8'h80;
            dut.mem_main.mem[8'h0E] = 8'h38;

            dut.mem_main.mem[8'h10] = 8'h60;
            dut.mem_main.mem[8'h11] = 8'hA0;
            dut.mem_main.mem[8'h12] = 8'h38;
            dut.mem_main.mem[8'h13] = 8'h90;
            dut.mem_main.mem[8'h14] = 8'h18;
            dut.mem_main.mem[8'h15] = 8'h80;
            dut.mem_main.mem[8'h16] = 8'h38;

            dut.mem_main.mem[8'h18] = 8'h20;
            dut.mem_main.mem[8'h19] = 8'h40;
            dut.mem_main.mem[8'h1A] = 8'h90;
            dut.mem_main.mem[8'h1B] = 8'h38;
            dut.mem_main.mem[8'h1C] = 8'h00;
            dut.mem_main.mem[8'h1D] = 8'h80;
            dut.mem_main.mem[8'h1E] = 8'h20;

            dut.mem_main.mem[8'h20] = 8'h20;
            dut.mem_main.mem[8'h21] = 8'h50;
            dut.mem_main.mem[8'h22] = 8'hF0;

            dut.mem_main.mem[8'h38] = 8'h20;
            dut.mem_main.mem[8'h39] = 8'h44;
            dut.mem_main.mem[8'h3A] = 8'hF0;

            dut.mem_main.mem[8'h40] = 8'h0F;
            dut.mem_main.mem[8'h41] = 8'h11;
            dut.mem_main.mem[8'h42] = 8'hF0;
            dut.mem_main.mem[8'h44] = 8'hEE;
            dut.mem_main.mem[8'h50] = 8'h00;
        end
    endtask

    //-----------------------------------------------------------------
    //  Verificacoes
    //-----------------------------------------------------------------
    task confere;
        input [8*26:1] nome;
        input [7:0]    obtido;
        input [7:0]    esperado;
        begin
            if (obtido === esperado)
                $display("  [ OK  ] %0s = 0x%02h", nome, obtido);
            else begin
                $display("  [FALHA] %0s = 0x%02h   esperado 0x%02h",
                         nome, obtido, esperado);
                erros = erros + 1;
            end
        end
    endtask

    task confere_bit;
        input [8*26:1] nome;
        input          obtido;
        input          esperado;
        begin
            if (obtido === esperado)
                $display("  [ OK  ] %0s = %b", nome, obtido);
            else begin
                $display("  [FALHA] %0s = %b   esperado %b",
                         nome, obtido, esperado);
                erros = erros + 1;
            end
        end
    endtask

    task cobertura;
        input [8*26:1] nome;
        input          visitado;
        begin
            if (visitado === 1'b1)
                $display("  [ OK  ] %0s", nome);
            else begin
                $display("  [FALHA] %0s - caminho nao percorrido", nome);
                erros = erros + 1;
            end
        end
    endtask

    //-----------------------------------------------------------------
    //  Registro de cobertura e trace
    //-----------------------------------------------------------------
    always @(posedge clk) begin
        if (!reset) begin
            case (dut.Control.state)
                S_DECODE: if (dut.w_nop) viu_nop = 1'b1;
                S_LDA:    viu_lda = 1'b1;
                S_ADD:    viu_add = 1'b1;
                S_STA:    viu_sta = 1'b1;
                S_OR:     viu_or  = 1'b1;
                S_AND:    viu_and = 1'b1;
                S_NOT:    viu_not = 1'b1;
                S_JMP:    viu_jmp = 1'b1;
                S_JN:     if (dut.n_to_cntrl) viu_jn_tomado = 1'b1;
                          else                viu_jn_reto   = 1'b1;
                S_JZ:     if (dut.z_to_cntrl) viu_jz_tomado = 1'b1;
                          else                viu_jz_reto   = 1'b1;
                S_HLT:    viu_hlt = 1'b1;
            endcase

            if (TRACE && dut.Control.state == S_DECODE)
                $display("    PC=%02h  RI=%02h  AC=%02h  N=%b Z=%b",
                         dut.PC_main.count, dut.to_decoder, test,
                         dut.n_to_cntrl, dut.z_to_cntrl);
        end
    end

    //-----------------------------------------------------------------
    //  Sequencia principal
    //-----------------------------------------------------------------
    initial begin
        $dumpfile("neander.vcd");
        $dumpvars(0, tb_neander_full);

        #1 carrega_programa;

        $display("");
        $display("=== execucao ===");

        #21 reset = 1'b0;

        while (dut.Control.state !== S_HLT && $time < 20000)
            @(posedge clk);

        @(posedge clk);

        $display("");
        $display("=== estado final ===");

        if ($time >= 20000) begin
            $display("  [FALHA] a maquina nunca chegou no HLT (timeout)");
            erros = erros + 1;
        end

        confere    ("AC final",        test,                     8'h20);
        confere    ("mem[50] (STA)",   dut.mem_main.mem[8'h50],  8'h20);
        confere    ("PC final",        dut.PC_main.count,        8'h23);
        confere_bit("flag N",          dut.n_to_cntrl,           1'b0);
        confere_bit("flag Z",          dut.z_to_cntrl,           1'b0);

        $display("");
        $display("=== cobertura das instrucoes ===");

        cobertura("NOP",              viu_nop);
        cobertura("LDA",              viu_lda);
        cobertura("ADD",              viu_add);
        cobertura("STA",              viu_sta);
        cobertura("OR",               viu_or);
        cobertura("AND",              viu_and);
        cobertura("NOT",              viu_not);
        cobertura("JMP",              viu_jmp);
        cobertura("JN  desviando",    viu_jn_tomado);
        cobertura("JN  seguindo reto", viu_jn_reto);
        cobertura("JZ  desviando",    viu_jz_tomado);
        cobertura("JZ  seguindo reto", viu_jz_reto);
        cobertura("HLT",              viu_hlt);

        $display("");
        if (erros == 0)
            $display("  TODOS OS TESTES PASSARAM");
        else begin
            $display("  %0d FALHA(S)", erros);
            if (test === 8'hEE)
                $display("  AC = EE indica que um desvio foi para a armadilha.");
        end
        $display("");

        $finish;
    end

endmodule