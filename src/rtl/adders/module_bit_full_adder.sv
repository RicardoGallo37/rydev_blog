// Module to structurally design a 1-bit full adder.
module module_bit_full_adder 
(
    input logic  a_i,     // Input for the first 1-bit number.
    input logic  b_i,     // Input for the second 1-bit number.
    input logic  carry_i, // Input for the carry-in c_i
    output logic sum_o,   // Output for the result of the addition of a_i + b_i.
    output logic carry_o  // Output for the resulting carry of the addition a_i + b_i.
);

    // Declaration of internal signals
    logic c_1; // Input 1 to the OR gate generating carry_o
    logic c_2; // Input 2 to the OR gate generating carry_o
    logic c_3; // Input 3 to the OR gate generating carry_o
    
    // Structural modeling of the adder
    and and1 (c_1, a_i, b_i);       // c1 = a_i & b_i
    and and2 (c_2, b_i, carry_i);   // c2 = b_i & carry_i
    and and3 (c_3, a_i, carry_i);   // c3 = a_i & carry_i
    
    or  or1  (carry_o, c_1, c_2, c_3);   // carry_o = c_1 + c_2 + c_3
    xor xor1 (sum_o, a_i, b_i, carry_i); // sum_o   = a_i ^ b_i ^ carry_i
    
endmodule
