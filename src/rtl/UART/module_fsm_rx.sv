module module_fsm_rx(

    input logic  clk_i,
    input logic  reset_i,
    input logic  rx_data_rdy,

    output logic new_rx_clear,
    output logic we_control_rx_o

    );

    //states
    typedef enum logic [1 : 0] {

        STATE_0,
        STATE_1,
        STATE_2

    } states;
 
    states actual_state;
    states next_state;

    //mem
    always_ff @(posedge clk_i) begin

        if (!reset_i) begin

            actual_state <= STATE_0;
        end

        else begin

            actual_state <= next_state;
		end
	end
    
    //next_state logic
	always_comb  begin

        case(actual_state)

            STATE_0: begin	
                
           	    if(rx_data_rdy) 
           	        next_state = STATE_1;
				else 
					next_state = STATE_0; 

            end

            STATE_1: next_state = STATE_2;    

            STATE_2: next_state = STATE_0;
            
            default: next_state = STATE_0;      

        endcase
    end
    
    //output logic
    always_comb begin

        new_rx_clear = 0;
        we_control_rx_o = 0;

        case(actual_state)

            STATE_0: begin
                new_rx_clear = 0; 
                we_control_rx_o = 0;

            end

            STATE_1: begin
                new_rx_clear = 1; 
                we_control_rx_o = 1;

            end

            STATE_2: begin
                new_rx_clear = 1;
                we_control_rx_o = 0;

            end

            default: begin
                new_rx_clear = 0;
                we_control_rx_o = 0;

            end
        endcase
    end

endmodule