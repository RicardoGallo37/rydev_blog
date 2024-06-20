
module module_control_register_uart

    import pkg_UART :: *;

#(

    parameter DATA_WIDTH = 32

)(   

    input logic clk_i,
    input logic rst_i,
    input logic send_clear_i,
    input logic new_rx_clear_i,
    input logic wr_1_i,
    input logic wr_2_i,
    input logic wr_3_i,

    input logic [DATA_WIDTH - 1 : 0] data1_cr_i,

    output logic [DATA_WIDTH - 1 : 0] data_control_o

);

    control_UART_r control;

    always_ff @ (posedge clk_i) begin

        if (!rst_i)
            control <= '0;
        
        else if (wr_1_i)
            control <= data1_cr_i;
           
        else if (wr_2_i && send_clear_i)
            control.send <= 0;

        else if (wr_3_i)
            control.new_rx <= new_rx_clear_i; 
           
        else control <= control;

    end 
    
    assign data_control_o = control; 
        
endmodule

