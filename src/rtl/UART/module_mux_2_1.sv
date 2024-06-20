module module_mux_2_1

    import pkg_UART ::*;(

    input reg_sel_i,

    input data_UART_r data_1_i,
    input data_UART_r data_2_i,

    output data_UART_r data_o

);

    always_comb begin

        case (reg_sel_i) 

            1'b0: data_o = data_1_i;
            1'b1: data_o = data_2_i;

            default: data_o = '0;

        endcase
    end
endmodule