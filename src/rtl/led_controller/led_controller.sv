module led_controller (
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic        i_enable,
    input  logic [3:0]  i_blink_rate,
    output logic        o_led_out
);

    logic [31:0] counter;

    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            counter <= 0;
            o_led_out <= 0;
        end else if (i_enable) begin
            counter <= counter + 1;
            if (counter[i_blink_rate]) begin
                o_led_out <= ~o_led_out;
                counter <= 0;
            end
        end else begin
            o_led_out <= 0;
            counter <= 0;
        end
    end

endmodule
