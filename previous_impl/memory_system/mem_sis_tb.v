`timescale 1ns/1ns

module mem_sis_tb;

    reg [7:0] rem_d, mux1;
    reg r_z, write, read, clr, mux_sel1, rem_e, rdm_e;
    reg clk = 1'b0;
    wire [7:0] rdm_out;
    mem_sis DUT01 (
        .rem_d(rem_d),
        .mux1(mux1),
        .r_z(r_z),
        .write(write),
        .read(read),
        .clr(clr),
        .mux_sel1(mux_sel1),
        .rem_e(rem_e),
        .rdm_e(rdm_e),
        .clk(clk),
        .rdm_out(rdm_out),
        .debug_output()
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("mem_sis.vcd");
        $dumpvars(0, mem_sis_tb);
        $display("Time (ns)   | rem_d    | mux1     | r_z | write | read | clr | mux_sel1 | rem_e | rdm_e | clk");
        $monitor("%9t   | %8b | %8b | %3b | %5b | %4b | %3b | %8b | %5b | %5b | %3b", 
         $time, rem_d, mux1, r_z, write, read, clr, mux_sel1, rem_e, rdm_e, clk);

        rem_d = 8'b00000000;
        mux1 = 8'b00000000;
        r_z = 1'b0;
        write = 1'b0;
        read = 1'b0;
        clr = 1'b0;
        mux_sel1 = 1'b0;
        rem_e = 1'b0;
        rdm_e = 1'b0;
        #10; //10
        r_z = 1'b1;
        #10; //20
        r_z = 1'b0;
        mux1 = 8'b00000001;
        mux_sel1 = 1'b1;
        rdm_e = 1'b1;
        #10; //30
        rdm_e = 1'b0;
        write = 1'b1;
        #10; //40
        write = 1'b0;
        #10;
        r_z = 1'b1;
        #10; //60
        r_z = 1'b0;
        #10;
        rem_d = 8'b00000000;
        #10;
        rem_e = 1'b1;
        mux_sel1 = 1'b0;
        #10;
        rem_e = 1'b0;
        read = 1'b1;
        rdm_e = 1'b1;
        #10;
        read = 1'b0;
        #10;
        
        // The sequence writes 01 to address 00, resets the registers,
        // then reads the same address. Reset must preserve RAM contents.
        if (DUT01.mem[0] !== 8'h01 || rdm_out !== 8'h01)
            $fatal(1, "Memory test failed: mem[0]=%h rdm_out=%h",
                   DUT01.mem[0], rdm_out);
        $display("PASS: wrote and read 01 at address 00 across register reset");
        $finish;
    end



endmodule