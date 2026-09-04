module Temporization_architecture (
    input wire clk,
    input wire halt, goto_t0
    output reg  t0, t1, t2, t3, t4, t5, t6, t7
);

    wire to_reg2, to_counter, hlt_to_dec;
    wire [2:0] to_dec; 

    u1 D_Flip_Flop dff_1 (
        .Q(to_reg2),
        .clk(clk),
        .D(goto_t0)
    );

    u2 D_Flip_Flop dff_2 (
        .Q(to_counter),
        .clk(clk),
        .D(to_reg2)
    );

    u3 Counter counter_1 (
        .Count(to_dec),
        .Clock(clk),
        .Reset(to_counter)
    );

    always @ (hlt or to_dec or posedge clk)
        case(to_dec)
            3'b000: begin
                t0 <= 1'b1;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b001: begin
                t0 <= 1'b0;t1 <= 1'b1;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b010: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b1;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b011: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b1;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b100: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b1;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b101: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b1;t6 <= 1'b0;t7 <= 1'b0;
            end
            3'b110: begin
                t0 <= 1'b0;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b1;t7 <= 1'b0;
            end
            3'b111: begin
                t0 <= 1'b1;t1 <= 1'b0;t2 <= 1'b0;t3 <= 1'b0;t4 <= 1'b0;t5 <= 1'b0;t6 <= 1'b0;t7 <= 1'b1;
            end

        endcase




endmodule