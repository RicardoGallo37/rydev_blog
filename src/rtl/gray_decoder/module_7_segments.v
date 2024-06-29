module module_7_segments # (

    parameter DISPLAY_REFRESH = 27000
)(

    input clk_i,
    input rst_i,

    input [7 : 0] bcd_i,

    output reg [1 : 0] anode_o,
    output reg [6 : 0] cathode_o
);

    localparam WIDTH_DISPLAY_COUNTER = $clog2(DISPLAY_REFRESH);
    reg [WIDTH_DISPLAY_COUNTER - 1 : 0] out_count;

    reg [3 : 0] digit_o;

    reg en_conmutator;
    reg ten_unit;

    //Output refresh counter
    always @ (posedge clk_i) begin
        
        if(!rst_i) begin
        
            out_count <= DISPLAY_REFRESH - 1;
            en_conmutator <= 0;
        end

        else begin 

            if(out_count == 0) begin
                
                out_count <= DISPLAY_REFRESH - 1;
                en_conmutator <= 1;
            end

            else begin

                out_count <= out_count - 1'b1;
                en_conmutator <= 0;
            end
        end
    end

    //1 bit counter
    always @ (posedge clk_i) begin
        
        if(!rst_i) begin
        
            ten_unit <= 0;
        end

        else begin 

            if (en_conmutator == 1'b1) begin
                
                ten_unit <= ten_unit + 1'b1;
            end

            else begin

                ten_unit <= ten_unit;
            end
        end
    end


    //Time Multiplexed Digits
    
    always @(ten_unit, bcd_i) begin

        digit_o = 0;
        anode_o = 2'b11;
        
        case(ten_unit) 
            
            1'b0 : begin
                
                anode_o  = 2'b10;
                digit_o = bcd_i [3 : 0];
            end

            1'b1 : begin
                
                anode_o  = 2'b01;
                digit_o = bcd_i [7 : 4]; 
            end

            default: begin
                
                anode_o  = 2'b11;
                digit_o = 0;
            end
        endcase
    end

    //BCD to 7 segments
    always @ (digit_o) begin

        cathode_o  = 7'b1111111;
            
        case(digit_o)

                4'd0: cathode_o = 7'b1000000;
                4'd1: cathode_o = 7'b1111001;
                4'd2: cathode_o = 7'b0100100;
                4'd3: cathode_o = 7'b0110000;
                4'd4: cathode_o = 7'b0011001;
                4'd5: cathode_o = 7'b0010010;
                4'd6: cathode_o = 7'b0000010;
                4'd7: cathode_o = 7'b1111000;
                4'd8: cathode_o = 7'b0000000;
                4'd9: cathode_o = 7'b0010000;
                
                default: cathode_o = 7'b1111111;

        endcase
    end
endmodule
