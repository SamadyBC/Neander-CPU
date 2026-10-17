`timescale 1ns/1ps

module individual_programs_tb;
    reg clk;
    reg reset;
    wire [7:0] test;
    integer errors;

    neader_core dut (
        .clk(clk),
        .reset(reset),
        .test(test)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        errors = 0;
        $dumpfile("sim/build/individual_programs.vcd");
        $dumpvars(0, individual_programs_tb);

        // Each file supplies all 256 RAM bytes. Reset clears CPU registers,
        // but preserves RAM. The testbench supplies every program image.
        // Release reset on a falling edge, away from CPU register updates.

        // Test 1: A5 + 05 = AA; store the result at address 82.
        #1;
        $readmemh("mem/prog_sum1.mem", dut.mem_main.mem);
        repeat (3) @(negedge clk);
        reset = 0;
        // 100 clocks allow each short program to finish and remain halted.
        repeat (100) @(negedge clk);
        if (test === 8'hAA && dut.mem_main.mem[8'h82] === 8'hAA &&
            dut.PC_main.count === 8'h07 &&
            dut.n_to_cntrl === 1'b1 && dut.z_to_cntrl === 1'b0 &&
            dut.Control.state === dut.Control.state_HLT)
            $display("PASS: test 1 - addition A5 + 05 = AA");
        else begin
            $display("FAIL: test 1 - AC=%h PC=%h RAM[82]=%h",
                test, dut.PC_main.count, dut.mem_main.mem[8'h82]);
            errors = errors + 1;
        end

        // Test 2: F0 + 0F + 01 = 100h -> 00 (8-bit overflow), Z=1.
        // RAM[83] starts as EE, so the check proves STA wrote the 00.
        reset = 1;
        #1;
        $readmemh("mem/prog_sum2.mem", dut.mem_main.mem);
        repeat (3) @(negedge clk);
        reset = 0;
        repeat (100) @(negedge clk);
        if (test === 8'h00 && dut.mem_main.mem[8'h83] === 8'h00 &&
            dut.PC_main.count === 8'h09 &&
            dut.n_to_cntrl === 1'b0 && dut.z_to_cntrl === 1'b1 &&
            dut.Control.state === dut.Control.state_HLT)
            $display("PASS: test 2 - addition F0 + 0F + 01 = 00 (overflow, Z=1)");
        else begin
            $display("FAIL: test 2 - AC=%h PC=%h RAM[83]=%h",
                test, dut.PC_main.count, dut.mem_main.mem[8'h83]);
            errors = errors + 1;
        end

        // Test 3: (AA OR 0F) AND 3C = 2C; store at address 83.
        // Operands share bits, so a wrong OR (XOR/ADD) or a wrong AND
        // (pass-through) gives a different result.
        reset = 1;
        #1;
        $readmemh("mem/prog_logic1.mem", dut.mem_main.mem);
        repeat (3) @(negedge clk);
        reset = 0;
        repeat (100) @(negedge clk);
        if (test === 8'h2C && dut.mem_main.mem[8'h83] === 8'h2C &&
            dut.PC_main.count === 8'h09 &&
            dut.n_to_cntrl === 1'b0 && dut.z_to_cntrl === 1'b0 &&
            dut.Control.state === dut.Control.state_HLT)
            $display("PASS: test 3 - (AA OR 0F) AND 3C = 2C");
        else begin
            $display("FAIL: test 3 - AC=%h PC=%h RAM[83]=%h",
                test, dut.PC_main.count, dut.mem_main.mem[8'h83]);
            errors = errors + 1;
        end

        // Test 4: NOT 7F = 80; store at address 82.
        // 80 has only bit 7 set: checks that Z looks at all eight bits.
        reset = 1;
        #1;
        $readmemh("mem/prog_logic2.mem", dut.mem_main.mem);
        repeat (3) @(negedge clk);
        reset = 0;
        repeat (100) @(negedge clk);
        if (test === 8'h80 && dut.mem_main.mem[8'h82] === 8'h80 &&
            dut.PC_main.count === 8'h06 &&
            dut.n_to_cntrl === 1'b1 && dut.z_to_cntrl === 1'b0 &&
            dut.Control.state === dut.Control.state_HLT)
            $display("PASS: test 4 - NOT 7F = 80");
        else begin
            $display("FAIL: test 4 - AC=%h PC=%h RAM[82]=%h",
                test, dut.PC_main.count, dut.mem_main.mem[8'h82]);
            errors = errors + 1;
        end

        // Test 5: load zero; JZ skips an early HLT; load and store A5.
        reset = 1;
        #1;
        $readmemh("mem/prog_jump1.mem", dut.mem_main.mem);
        repeat (3) @(negedge clk);
        reset = 0;
        repeat (100) @(negedge clk);
        if (test === 8'hA5 && dut.mem_main.mem[8'h82] === 8'hA5 &&
            dut.PC_main.count === 8'h0A &&
            dut.n_to_cntrl === 1'b1 && dut.z_to_cntrl === 1'b0 &&
            dut.Control.state === dut.Control.state_HLT)
            $display("PASS: test 5 - conditional JZ, result = A5");
        else begin
            $display("FAIL: test 5 - AC=%h PC=%h RAM[82]=%h",
                test, dut.PC_main.count, dut.mem_main.mem[8'h82]);
            errors = errors + 1;
        end

        // Test 6: load A5; JN skips an early HLT; store A5.
        reset = 1;
        #1;
        $readmemh("mem/prog_jump2.mem", dut.mem_main.mem);
        repeat (3) @(negedge clk);
        reset = 0;
        repeat (100) @(negedge clk);
        if (test === 8'hA5 && dut.mem_main.mem[8'h82] === 8'hA5 &&
            dut.PC_main.count === 8'h08 &&
            dut.n_to_cntrl === 1'b1 && dut.z_to_cntrl === 1'b0 &&
            dut.Control.state === dut.Control.state_HLT)
            $display("PASS: test 6 - conditional JN, result = A5");
        else begin
            $display("FAIL: test 6 - AC=%h PC=%h RAM[82]=%h",
                test, dut.PC_main.count, dut.mem_main.mem[8'h82]);
            errors = errors + 1;
        end

        // Test 7: original complete program, including all operations.
        reset = 1;
        #1;
        $readmemh("mem/prog_original.mem", dut.mem_main.mem);
        repeat (3) @(negedge clk);
        reset = 0;
        // The original program needs 116 clocks; allow 150 clocks.
        repeat (150) @(negedge clk);
        if (test === 8'hAF && dut.mem_main.mem[8'h82] === 8'hAA &&
            dut.PC_main.count === 8'h21 &&
            dut.n_to_cntrl === 1'b1 && dut.z_to_cntrl === 1'b0 &&
            dut.Control.state === dut.Control.state_HLT)
            $display("PASS: test 7 - original program, AC=AF RAM[82]=AA");
        else begin
            $display("FAIL: test 7 - AC=%h PC=%h RAM[82]=%h",
                test, dut.PC_main.count, dut.mem_main.mem[8'h82]);
            errors = errors + 1;
        end

        if (errors == 0)
            $display("PASS: all seven programs");
        else
            $display("FAIL: %0d program(s) failed", errors);
        $finish;
    end
endmodule
