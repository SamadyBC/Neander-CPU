`timescale 1ns/1ns
module mem_sis(
        input wire [7:0] rem_d, mux1,
        input wire r_z, write, read, clr, mux_sel1, rem_e, rdm_e,
        input wire clk,
        output wire [7:0] rdm_out,
        output wire [7:0] test_ram0, test_ram1, test_ram2, test_ram3, test_ram4, test_ram5, test_ram6, test_ram7
    );

    //Conexoes entre blocos 
    wire [7:0] w_mem_data;

    //Registradores de Estado da Maquina
    reg [1:0] current_state, next_state;

    //Registradores de Endereço e de Dados da Memoria
    reg [7:0] rem, rdm, mux_output;

    //Memoria Ram - Vetor
    reg [7:0] mem [0:255];

    //Constantes para os estados 
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
                    //Nao faz nada
                end
                // read_m: begin     
                //     
                // end
                write_m: begin
                    mem[rem] <= rdm;
                end
                clear_m: begin
                    //mem = 0; - Ou nao limpar ou reset de todas as posicoes usando loop
                end

            endcase
        end
    end

    // Logica dos Proximos Estados
    always @ (*)begin
        next_state = current_state;
        case(current_state)
            wait_m:  begin
                if (write) begin
                    next_state = write_m;
                end else if (read) begin
                    next_state = read_m;
                end else if (clr) begin
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
            1'b0: mux_output = w_mem_data;
            1'b1: mux_output = mux1;
            default: mux_output = 8'h00;
        endcase
    end

    assign w_mem_data = current_state  == read_m ? mem[rem] : 8'h00;

    assign rdm_out = rdm;

    assign test_ram0 = mem[0];
    assign test_ram1 = mem[1];
    assign test_ram2 = mem[2];
    assign test_ram3 = mem[3];
    assign test_ram4 = mem[4];
    assign test_ram5 = mem[5];
    assign test_ram6 = mem[6];
    assign test_ram7 = mem[7];

endmodule