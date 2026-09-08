`timescale 1ns/1ns

module tb_Main;
    reg clk;
    reg reset;
    wire [7:0] test;

    
    Main uut (
        .clk(clk),
        .reset(reset),
        .test(test)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Estímulos
    initial begin
        reset = 1;
        #15;
        reset = 0;

        
        #1500;
        
        $display("deuuu.");
        $finish;
    end

    initial begin
        $monitor("Time=%0t | PC=%h | Instrucao=%h | AC=%h | Negativo(N)=%b | Zero(Z)=%b", 
                 $time, uut.PC_main.count, uut.to_decoder, test, uut.n_to_cntrl, uut.z_to_cntrl);
    end
endmodule