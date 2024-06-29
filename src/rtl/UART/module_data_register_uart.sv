module module_data_register_uart

    import pkg_UART :: *;

(

    input logic clk_i,
    input logic rst_i,
    
    input logic addr_i,

    input logic wr_1_i,
    input logic wr_2_i,

    input data_UART_r data1_i,
    input data_UART_r data2_i,

    output data_UART_r data1_o,
    output data_UART_r data2_o
);

    typedef logic [31 : 0]  register;
    register      [1 : 0]   rf_r;

    always_ff@ (posedge clk_i) begin

        if (!rst_i) begin

            rf_r <= '0;
        end

        else begin
        
            if (wr_1_i)
                rf_r[0] <= data1_i.data;
            
            if (wr_2_i)
                rf_r[1] <= data2_i.data;

        end
    end
    
    assign data1_o.data = rf_r [0];
    assign data2_o.data = rf_r [addr_i];
    
    //to avoid warnings, "data.zero" is not used
    always_comb begin
        
        if (data1_i.zero == '0) 
            data1_o.zero = data1_i.zero;
            
        else  data1_o.zero = '0;
        
        if (data2_i.zero == '0) 
            data2_o.zero = data2_i.zero;
            
        else  data2_o.zero = '0;
    end      

endmodule


