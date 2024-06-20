module module_fsm_tx 

    import pkg_UART :: *;

(

    input logic clk_i,
    input logic reset_i,
    input logic tx_rdy,

    input logic  [31 : 0] control_tx_i,
    
    output logic tx_start,
    output logic send_clear_o,
    output logic wr

);
   
    //states
    typedef enum logic [1:0] {
        
        STATE_0,
        STATE_1,
        STATE_2,
        STATE_3 

    } states;

    states actual_state; 
    states next_state;

    //mem
    always_ff @ (posedge clk_i) begin

        if (!reset_i) begin

            actual_state <= STATE_0;
        end

        else begin

            actual_state <= next_state;
		end
	end

    //next state logic	
	always_comb  begin

        case(actual_state)
        
            STATE_0: begin	
           	    if(control_tx_i[0] == 1)
           	     
           	        next_state = STATE_1;
				else 
				
					next_state = STATE_0; 
            end
            
            STATE_1: next_state = STATE_2; 
               
            STATE_2: begin
                 
                if(tx_rdy == 1)
                
                    next_state = STATE_3;
                    
                else 
                
					next_state = STATE_2; 
            end
            
            STATE_3: next_state = STATE_0;
            
            default: next_state = STATE_0;
                     
        endcase
    end

    //output logic
    always_comb begin
    
        case(actual_state)
        
            STATE_1: begin
                tx_start     = 1;
                send_clear_o = 0;
                wr           = 0;
            end
            
            STATE_3: begin 
                tx_start     = 0;
                send_clear_o = 1;
                wr           = 1;

            end
            
            default: begin
                tx_start     = 0;
                send_clear_o = 0;
                wr           = 0;
 
            end
        endcase 
    end    
endmodule

