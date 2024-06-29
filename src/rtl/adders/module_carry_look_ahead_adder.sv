module module_carry_look_ahead_adder # (

    parameter CLA_WIDTH = 8   // Width of the CLA adder
    
)(

    input logic  [CLA_WIDTH - 1 : 0] a_i,     // Input a_i with width CLA_WIDTH bits
    input logic  [CLA_WIDTH - 1 : 0] b_i,     // Input b_i with width CLA_WIDTH bits
    input logic                      carry_i, // Input carry for the addition
    output logic                     carry_o, // Output carry from the addition a_i + b_i
    output logic [CLA_WIDTH - 1 : 0] sum_o    // Result of the addition a_i + b_i 
   
);

    integer int_j;

    // Declaration of internal signals    
    logic [CLA_WIDTH - 1 : 0] f_p;
    logic [CLA_WIDTH - 1 : 0] f_g;
    logic [CLA_WIDTH  : 0]    c;
    logic [CLA_WIDTH  : 0]    s;
  
    always @ (a_i, b_i) begin

        for (int_j = 0; int_j < CLA_WIDTH + 1; int_j = (int_j + 1)) begin
    
            c[0] = carry_i; // Input carry
        
            f_p[int_j] = a_i[int_j] ^ b_i[int_j]; // Carry Generate Function
            f_g[int_j] = a_i[int_j] & b_i[int_j]; // Carry Propagate Function
        
            s[int_j]   = f_p[int_j] ^ c[int_j];                // Result of the addition of each a_i[j] + b_i[j]
            c[int_j+1] = f_g[int_j] | (f_p[int_j] & c[int_j]); // Carry output of each a_i[j] + b_i[j]
        
        end
    end
  
    assign sum_o   = s [CLA_WIDTH - 1 : 0] ;  // Total output sum
    assign carry_o = c [CLA_WIDTH];           // Output carry 

endmodule
