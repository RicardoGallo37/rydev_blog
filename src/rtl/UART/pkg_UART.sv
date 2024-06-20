package pkg_UART;    

    typedef struct packed {
        logic [29 : 0]  zero;
        logic           new_rx;
        logic           send;
    } control_UART_r;
    
    typedef struct packed {
        logic [23 : 0]  zero;
        logic [7  : 0]  data;
    } data_UART_r;

endpackage

