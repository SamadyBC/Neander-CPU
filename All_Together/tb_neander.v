`timescale 1ns/1ns

module tb_neander;

    reg clk = 1'b0;
    reg reset = 1'b1;
    wire [7:0] test;

    Main dut (
        .clk(clk),
        .reset(reset),
        .test(test)
    );

    always #5 clk = ~clk;

    initial begin
        #22 reset = 1'b0;
        #1000;

        $display("=====================================");
        $display("AC final (test) = 0x%02h", test);
        $display("estado do controle = %0d", dut.Control.state);
        $display("PC = %0d", dut.PC_main.count);
        $display("N = %b   Z = %b", dut.n_to_cntrl, dut.z_to_cntrl);
        $display("=====================================");
        $finish;
    end

endmodule