module module_input_deco_gray # (

    parameter WIDTH = 4,
    parameter INPUT_REFRESH = 2700000

)(
    input                  clk_i,
    input                  rst_i,
    input [WIDTH - 1 : 0]  gray_code_i,

    output reg [WIDTH - 1 : 0]  bin_code_o
);

    //parameters
    localparam WIDTH_INPUT_COUNTER = $clog2(INPUT_REFRESH);

    //Internal signals
    reg [WIDTH - 1 : 0]               gray_code_sync_r;
    reg [WIDTH_INPUT_COUNTER - 1 : 0] in_count;

    reg en_read;

    //Input refresh counter
    always @ (posedge clk_i) begin
        
        if(!rst_i) begin
        
            in_count <= INPUT_REFRESH - 1;
            en_read <= 0;
        end

        else begin 

            if (in_count == 0) begin
                
                in_count <= INPUT_REFRESH - 1;
                en_read <= 1;
            end

            else begin

                in_count <= in_count - 1'b1;
                en_read <= 0;
            end
        end
    end

    //Input sync
    always @(posedge clk_i) begin

        if(!rst_i) begin
        
            gray_code_sync_r <= 0;
        end

        else begin 

            if(en_read) begin

                gray_code_sync_r <= gray_code_i;
            end

            else begin
                
                gray_code_sync_r <= gray_code_sync_r;
            end
        end  
    end

    //Gray decoder
    always @(gray_code_sync_r) begin
        
        bin_code_o = 4'b0000;

        case (gray_code_sync_r) 

            4'b0000: bin_code_o = 4'b0000; //00
            4'b0001: bin_code_o = 4'b0001; //01
            4'b0011: bin_code_o = 4'b0010; //02
            4'b0010: bin_code_o = 4'b0011; //03
            4'b0110: bin_code_o = 4'b0100; //04
            4'b0111: bin_code_o = 4'b0101; //05
            4'b0101: bin_code_o = 4'b0110; //06
            4'b0100: bin_code_o = 4'b0111; //07
            4'b1100: bin_code_o = 4'b1000; //08
            4'b1101: bin_code_o = 4'b1001; //09
            4'b1111: bin_code_o = 4'b1010; //10
            4'b1110: bin_code_o = 4'b1011; //11
            4'b1010: bin_code_o = 4'b1100; //12
            4'b1011: bin_code_o = 4'b1101; //13
            4'b1001: bin_code_o = 4'b1110; //14
            4'b1000: bin_code_o = 4'b1111; //15
            
            default: bin_code_o = 4'b0000;
        endcase
    end
endmodule
