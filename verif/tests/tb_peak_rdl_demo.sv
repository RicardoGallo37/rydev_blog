`timescale 1ns/1ps

module tb_peak_rdl_demo;

    // Clock and reset signals
    logic clk = 0;
    logic rst = 1; // Active high

    // Simple CSR signals
    logic [31:0] csr_addr;
    logic [31:0] csr_wdata;
    logic        csr_write;
    logic [31:0] csr_rdata;

    // LED output
    logic led_out;

    // Clock generation
    always #5 clk = ~clk;

    // DUT: top module connecting registers and functional block
    led_top dut (
        .clk       (clk),
        .rst       (rst),
        .csr_addr  (csr_addr),
        .csr_wdata (csr_wdata),
        .csr_write (csr_write),
        .csr_rdata (csr_rdata),
        .led_out   (led_out)
    );

    // Task to write to a register
    task csr_write_task(input [31:0] addr, input [31:0] data);
        csr_addr  = addr;
        csr_wdata = data;
        csr_write = 1;
        @(posedge clk);
        csr_write = 0;
        @(posedge clk);
    endtask

    // Task to read from a register
    task csr_read_task(input [31:0] addr);
        csr_addr  = addr;
        csr_write = 0;
        @(posedge clk);
        $display("[%0t] Read @0x%0h = 0x%0h", $time, addr, csr_rdata);
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_peak_rdl_demo);

        // Apply reset
        rst = 1;
        csr_addr  = '0;
        csr_wdata = '0;
        csr_write = 0;
        repeat (2) @(posedge clk);
        rst = 0;

        // Write ENABLE = 1 and BLINK_RATE = 2 (bits [4:1])
        csr_write_task(32'h0000_0000, 32'h0000_0005); // ENABLE=1, BLINK_RATE=2

        // Read CONTROL register
        csr_read_task(32'h0000_0000);

        // Wait some time to observe LED blinking
        repeat (50) @(posedge clk);

        // Change BLINK_RATE to 1 (faster)
        csr_write_task(32'h0000_0000, 32'h0000_0003);

        // Read CONTROL register
        csr_read_task(32'h0000_0000);

        repeat (50) @(posedge clk);

        $finish;
    end

endmodule
