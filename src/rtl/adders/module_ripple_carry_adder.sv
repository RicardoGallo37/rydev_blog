// Module to structurally design a ripple carry adder (RCA) 
// using 1-bit full adders (fa).

module module_ripple_carry_adder # (

    parameter RCAWIDE = 8         // Bit width of the RCA adder

)(

    input  logic [RCAWIDE - 1 : 0] a_i,     // Input a_i with width RCAWIDE bits
    input  logic [RCAWIDE - 1 : 0] b_i,     // Input b_i with width RCAWIDE bits
    input  logic                   carry_i, // Input carry for the addition
    output logic [RCAWIDE - 1 : 0] sum_o,   // Result of the addition a_i + b_i
    output logic                   carry_o  // Output carry from the addition a_i + b_i
    
);

    // Declaration of internal signals
    logic [RCAWIDE - 1 : 0] c_in;          // Input carries of the intermediate stages
    logic [RCAWIDE - 1 : 0] c_out;         // Output carries of the intermediate stages
    
    // Block to replicate the structure of the 1-bit full adder
    generate 
    
        genvar j; // Auxiliary variable for iteration
        
        assign c_in[0] = carry_i;  // Assign the input carry to the first stage
        
        // For block to replicate and interconnect the full adders
        for (j = 0; j < (RCAWIDE - 1); j++) begin
            
            // Generate from the first stage to the second last, interconnecting the carries
            module_bit_full_adder etapa_fa (.a_i(a_i[j]), .b_i(b_i[j]), .carry_i(c_in[j]), 
                                            .sum_o(sum_o[j]), .carry_o(c_in[j + 1]));             
       
        end
        
    endgenerate   
     
    // Generate the final stage
    module_bit_full_adder etapa_final_fa (.a_i(a_i[RCAWIDE - 1]), .b_i(b_i[RCAWIDE - 1]), 
                                          .carry_i(c_in[RCAWIDE - 1]), .sum_o(sum_o[RCAWIDE - 1]),
                                          .carry_o(carry_o));  
                                   
endmodule 
