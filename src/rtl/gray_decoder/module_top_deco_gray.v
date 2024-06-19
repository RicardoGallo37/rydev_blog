//last updated: 19_06_24 
//David Medina M.

//In this project, the user inputs a 4-bit Gray code to be decoded into binary on LEDs 
//and displayed in decimal on a multiplexed 7-segment display.

module module_top_deco_gray # (

     parameter INPUT_REFRESH = 2700000,
     parameter DISPLAY_REFRESH = 27000

)(
    
    input            clk_pi,
    input            rst_pi,
    input [3 : 0]    gray_code_pi,

    output  [1 : 0]  anode_po,
    output  [6 : 0]  cathode_po,              
    output  [3 : 0]  led_bin_code_po

);
    
    wire [3 : 0] bin_code;
    wire [7 : 0] bcd_code;

    module_input_deco_gray # (4,INPUT_REFRESH) SUBMODULE_INPUT (

        .clk_i       (clk_pi),
        .rst_i       (rst_pi),
        .gray_code_i (gray_code_pi),

        .bin_code_o  (bin_code)
    );

    assign led_bin_code_po = ~bin_code;

    module_bin_to_bcd # (4) SUBMODULE_BIN_BCD (

        .clk_i (clk_pi),
        .rst_i (rst_pi),
        .bin_i (bin_code),

        .bcd_o (bcd_code)
    );

    module_7_segments # (DISPLAY_REFRESH) SUBMODULE_DISPLAY (

        .clk_i     (clk_pi),
        .rst_i     (rst_pi),
        .bcd_i     (bcd_code),

        .anode_o   (anode_po),
        .cathode_o (cathode_po)    
    );

endmodule
