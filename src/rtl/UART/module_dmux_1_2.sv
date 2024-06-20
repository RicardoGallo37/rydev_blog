module module_dmux_1_2 (
    
  input logic  wr_i,
  input logic  reg_sel_i,

  output logic wr1_control_o,
  output logic wr1_data_o

);
  
  //dmux
  always_comb begin 
    
    case (reg_sel_i) 

      1'b0: begin

        wr1_control_o = wr_i;
        wr1_data_o   = 1'b0;
      end
    
      1'b1: begin

        wr1_control_o = 1'b0;
        wr1_data_o   = wr_i;
      end
    
    endcase
        
  end
    
endmodule