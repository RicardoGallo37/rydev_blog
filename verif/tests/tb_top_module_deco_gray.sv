`timescale 1ns/1ps

module tb_top_module_deco_gray;

    // Input stimulus
    reg          clk_i = 0;
    reg          rst_i;
    reg [3 : 0]  gray_code_i;

    // Output stimulus
    wire [1 : 0] anode_o;
    wire [6 : 0] cathode_o;
    wire [3 : 0] led_bin_code_o; 

    // Instance of the gray decoder
    top_module_deco_gray #(6, 5) DUT (
    
        .clk_pi          (clk_i),
        .rst_pi          (rst_i),
        .gray_code_pi    (gray_code_i),
        .anode_po        (anode_o),
        .cathode_po      (cathode_o),
        .led_bin_code_po (led_bin_code_o)
    );

    // Clock generation
    always begin
        clk_i = ~clk_i;
        #5;
    end

    // Array of Gray code inputs
    reg [3 : 0] gray_code_inputs [0 : 15] = {
        4'b0000, 4'b0001, 4'b0011, 4'b0010, 
        4'b0110, 4'b0111, 4'b0101, 4'b0100,
        4'b1100, 4'b1101, 4'b1111, 4'b1110,
        4'b1010, 4'b1011, 4'b1001, 4'b1000
    };

    // Expected binary outputs
    reg [3 : 0] expected_binary_outputs [0 : 15] = {
        4'b0000, 4'b0001, 4'b0010, 4'b0011,
        4'b0100, 4'b0101, 4'b0110, 4'b0111,
        4'b1000, 4'b1001, 4'b1010, 4'b1011,
        4'b1100, 4'b1101, 4'b1110, 4'b1111
    };
    
    reg [7 : 0] expected_units_cathode_outputs [0 : 15] = {
        7'b1000000, 7'b1111001, 7'b0100100, 7'b0110000,
        7'b0011001, 7'b0010010, 7'b0000010, 7'b1111000,
        7'b0000000, 7'b0010000, 7'b1000000, 7'b1111001,
        7'b0100100, 7'b0110000, 7'b0011001, 7'b0010010
    };
    
    reg [7 : 0] expected_tens_cathode_outputs [0 : 15] = {
        7'b1000000, 7'b1000000, 7'b1000000, 7'b1000000,
        7'b1000000, 7'b1000000, 7'b1000000, 7'b1000000,
        7'b1000000, 7'b1000000, 7'b1111001, 7'b1111001,
        7'b1111001, 7'b1111001, 7'b1111001, 7'b1111001
    };

    // Tests
    initial begin

        $monitor("Time: %t, gray_code_i: %b, anode_o: %b, cathode_o: %b, led_bin_code: %b", 
                 $time, gray_code_i, anode_o, cathode_o, DUT.bin_code);
        // Initial values
        rst_i = 0;
        gray_code_i = 4'b0000;

        #30;
        rst_i = 1;
        
        #100;
        // Apply Gray code inputs and check outputs
        for (integer i = 0; i < 16; i = i + 1) begin
            gray_code_i = gray_code_inputs[i];
            #65;
            if (DUT.bin_code  !== expected_binary_outputs[i]) begin
                $display("Error at time %t: for gray_code_i = %b, expected led_bin_code_o = %b, but got %b",
                         $time, gray_code_i, expected_binary_outputs[i], DUT.bin_code);
            end
            
            #100;
        end
        
        // End of test
        $finish;
    end

    initial begin
        $dumpfile("tb_top_module_deco_gray.vcd");
        $dumpvars(0, tb_top_module_deco_gray);
    end

endmodule
