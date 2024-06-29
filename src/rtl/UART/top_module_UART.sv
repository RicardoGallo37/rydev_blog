module top_module_UART

    import pkg_UART ::*;
   
    (
    
    input logic clk_10MHz,
    input logic rst,
    
    //Control
    input logic wr_pi, 
    input logic reg_sel_pi,
    input logic addr_pi,

    //Data 
    input logic  [31 : 0] input_pi,
    output logic [31 : 0] output_po, 

    //Serial ports
    input  logic rx,
    output logic tx  
);
    
    logic wr_control;
    logic wr_data;
    logic wr_rx_clear;

    logic [31 : 0] data_out_control;
    logic [31 : 0] data_register;

    logic          tx_start;
    logic          tx_rdy;
    logic [31 : 0] data_in_UART;
    logic [31 : 0] data_out_UART;
    logic          rx_data_rdy; 
    
    logic new_rx_clear;
    logic send_clear;
    logic wr_fsm;
        

    module_dmux_1_2 DMUX (

        .wr_i           (wr_pi),
        .reg_sel_i      (reg_sel_pi),
        .wr1_control_o  (wr_control),
        .wr1_data_o     (wr_data)
    );
   
    module_mux_2_1 MUX (

        .reg_sel_i  (reg_sel_pi),
        .data_1_i   (data_out_control),
        .data_2_i   (data_register),
        .data_o     (output_po)
    );

    UART UART( 

        .clk            (clk_10MHz),
        .reset          (~rst),
        .tx_start       (tx_start),
        .tx_rdy         (tx_rdy),
        .data_out       (data_out_UART [7 : 0]),
        .data_in        (data_in_UART  [7 : 0]),
        .rx_data_rdy    (rx_data_rdy),
        .rx             (rx),
        .tx             (tx)
    );

    assign data_out_UART [31 : 8] = '0;
    
    module_fsm_rx RX (

        .clk_i           (clk_10MHz),
        .reset_i         (rst),
        .rx_data_rdy     (rx_data_rdy),
        .new_rx_clear    (new_rx_clear),
        .we_control_rx_o (wr_rx_clear)
    );

    module_fsm_tx TX (

        .clk_i          (clk_10MHz),
        .reset_i        (rst),
        .tx_rdy         (tx_rdy), 
        .control_tx_i   (data_out_control [0]),
        .tx_start       (tx_start),
        .send_clear_o   (send_clear),
        .wr             (wr_fsm)
    );

    module_control_register_uart CTRL_REG (

        .clk_i          (clk_10MHz),
        .rst_i          (rst),
        .send_clear_i   (send_clear),
        .new_rx_clear_i (new_rx_clear),
        .wr_1_i         (wr_control),
        .wr_2_i         (wr_fsm),
        .wr_3_i         (wr_rx_clear),
        .data1_cr_i     (input_pi),
        .data_control_o (data_out_control)
    );

    module_data_register_uart DATA_REG (

        .clk_i      (clk_10MHz),
        .rst_i      (rst),
        .addr_i     (addr_pi),
        .wr_1_i     (wr_data),
        .wr_2_i     (rx_data_rdy),
        .data1_i    (input_pi),
        .data2_i    (data_out_UART),
        .data1_o    (data_in_UART),
        .data2_o    (data_register)
    );
    
endmodule