
module MEM(
        input wire [7:0] rem_d, mux1,
        input wire r_z, write, read, clr, mux_sel1, rem_e, rdm_e,
        input wire clk,
        output reg [7:0] rdm_out
    );

    reg current_state, next_state;

    //Registradores de Endereço e de Dados da Memoria
    reg [7:0] rem, rdm;


    parameter wait_m = 2'b00,
        write_m = 2'b01,
        read_m = 2'b10,
        clear_m = 2'b11;

    //Logica Resgistrador de Estados
    always @ ( posedge clk or posedge r_z) begin
        if( r_z == 1'b0) begin
            current_state = next_state;
        end else if (r_z == 1'b1) begin
            current_state = wait_m;
            //zera os registradores de endereco e dados aqui? Ou no always abaixo
        end
    end

    //Logica dos Registradores de dados, enderecos e memoria
    always @ ( posedge clk  or posedge r_z) begin
        if (rem_e) begin
            rem = rem_d;
        end
        case(current_state)
            read_m: begin     
                if (read && rdm_e) begin //mux sel entra aqui? NAO PRECISA mais da flag "read" aqui ne?
                    //rdm = mem[rem];
                end
            end
            write_m: begin
                //mem[rem] = rdm;
            end
            clear_m: begin
                //mem = 0;
            end

        endcase
    end

    // Logica dos Proximos Estados
    always @ (write or read or clr or mux_sel1 or rem_e or rdm_e)begin //avaliar sinais necessarios nessa lista de sensibilidade, clk nao eh necessario mas e o "mux_sel1"?
        case(current_state)
            wait_m:  begin
                if (write == 1) begin
                    next_state = write_m;
                end else if (read == 1) begin
                    next_state = read_m;
                end else if (clr == 1) begin
                    next_state = clear_m;
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

endmodule