`timescale 1ns/1ps

module tb_top_module_deco_gray;

    //input stimulus
    reg clk_i = 0;
    reg rst_i;
    reg [3 : 0] gray_code_i;

    //output stimulus
    wire [1 : 0] anode_o;
    wire [6 : 0] cathode_o;
    wire [3 : 0] led_bin_code_o;
    
    //gray decoder instance
    top_module_deco_gray # (6, 5) DUT (
    
        .clk_pi          (clk_i),
        .rst_pi          (rst_i),
        .gray_code_pi    (gray_code_i),

        .anode_po        (anode_o),
        .cathode_po      (cathode_o),              
        .led_bin_code_po (led_bin_code_o)
    );

    //clk stimulus
    always begin
        
        clk_i = ~clk_i;
        #10;
    end
    
    //tests
    initial begin
        
        rst_i = 0;
        gray_code_i = 4'b0000;

        #30;

        rst_i = 1;

        #100;
        
        gray_code_i = 4'b0001;

        #100;
        gray_code_i = 4'b0011;

        #100;
        gray_code_i = 4'b0010;

        #100;
        gray_code_i = 4'b0110;

        #100;
        gray_code_i = 4'b0111;

        #100;
        gray_code_i = 4'b0101;

        #100;
        gray_code_i = 4'b0100;

        #100;
        gray_code_i = 4'b1100;

        #100;
        gray_code_i = 4'b1101;

        #100;
        gray_code_i = 4'b1111;

        #100;
        gray_code_i = 4'b1110;

        #100;
        gray_code_i = 4'b1010;

        #100;
        gray_code_i = 4'b1011;

        #100;
        gray_code_i = 4'b1001;

        #100;
        gray_code_i = 4'b1000;

        #1000;
        
        $monitor(anode_o);
        $finish;
    end


    initial begin
        $dumpfile("tb_top_module_deco_gray.vcd");
        $dumpvars(0, tb_top_module_deco_gray);
    end

endmodule
