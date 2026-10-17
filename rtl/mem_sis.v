`timescale 1ns/1ps

module mem_sis(
        input wire [7:0] rem_d, mux1,
        input wire r_z, write, read, clr, mux_sel1, rem_e, rdm_e,
        input wire clk,
        output wire [7:0] rdm_out, debug_output
    );

    //Conexoes entre blocos 
    wire [7:0] w_mem_data;

    //Registradores de Estado da Maquina
    reg [1:0] current_state, next_state;

    //Registradores de Endereço e de Dados da Memoria
    reg [7:0] rem, rdm, mux_output;

    //Memoria Ram - Vetor
    reg [7:0] mem [0:255];
    
    // RAM contents are loaded by the testbench using $readmemh.

    parameter wait_m = 2'b00,
        write_m = 2'b01,
        read_m = 2'b10,
        clear_m = 2'b11;

    //Logica Resgistrador de Estados
    always @ ( posedge clk or posedge r_z) begin
        if(r_z) begin
            current_state <= wait_m;
        end else begin
            current_state <= next_state;
        end
    end

    //Logica dos Registradores de dados, enderecos e memoria
    always @ ( posedge clk  or posedge r_z) begin
        if (r_z) begin
            rdm <= 8'h00;
            rem <= 8'h00;
        end else begin
            if (rdm_e) begin 
                rdm <= mux_output;
            end
            if (rem_e) begin
                rem <= rem_d;
            end
            case(current_state)
                wait_m: begin
                    //Estado de espera, nenhuma instrução é executada.
                end
                write_m: begin
                    mem[rem] <= rdm;
                end
                clear_m: begin
                    //Estado nao utilizado devido a complexidade de implementacao de limpeza de todos os endereços de memoria.
                end
            endcase
        end
    end

    // Logica dos Proximos Estados
    always @ (*) begin
        next_state = current_state;
        case(current_state)
            wait_m:  begin
                if (write & !read & !clr) begin
                    next_state = write_m;
                end else if (!write & read & !clr) begin
                    next_state = read_m;
                end else if (!write & !read & clr) begin
                    next_state = clear_m;
                end else begin
                    next_state = wait_m;
                end
            end
            write_m:
                next_state = wait_m;
            read_m:
                next_state = wait_m;
            clear_m:
                next_state = wait_m;
            default: 
                next_state = wait_m;
        endcase
    end

    //Logica Combinacional - Independente do Clock
    always @ (*) begin
        case(mux_sel1)
            1'b0: mux_output = mem[rem];
            1'b1: mux_output = mux1;
            default: mux_output = 8'h00;
        endcase
    end

    assign rdm_out = rdm;
    assign debug_output = mem[8];


endmodule
