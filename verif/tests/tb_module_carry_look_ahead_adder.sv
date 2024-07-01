`timescale 1ns/1ps

module tb_module_carry_look_ahead_adder;

  // Parameter for the CLA adder width
  parameter CLA_WIDTH = 16;

  // Testbench signals
  logic [CLA_WIDTH - 1 : 0] a_i;
  logic [CLA_WIDTH - 1 : 0] b_i;
  logic [CLA_WIDTH - 1 : 0] sum_o;

  logic carry_i;
  logic carry_o;

  // Expected outputs
  logic [CLA_WIDTH - 1 : 0] expected_sum_o;
  logic                     expected_carry_o;

  // Instantiate the carry look-ahead adder
  module_carry_look_ahead_adder #(.CLA_WIDTH(CLA_WIDTH)) DUT (
    .a_i     (a_i),
    .b_i     (b_i),
    .carry_i (carry_i),
    .carry_o (carry_o),
    .sum_o   (sum_o)
  );

  // Test vectors
  initial begin
    // Loop for 50 random test cases
    for (int i = 0; i < 50; i++) begin
      // Generate random inputs
      a_i     = $urandom % (1 << CLA_WIDTH);
      b_i     = $urandom % (1 << CLA_WIDTH);
      carry_i = $urandom % 2;

      // Calculate expected outputs
      {expected_carry_o, expected_sum_o} = a_i + b_i + carry_i;

      // Wait for a short time to simulate
      #30;

      // Check the outputs
      assert(sum_o == expected_sum_o && carry_o == expected_carry_o)
        else $fatal("Test %0d failed: a_i = %b, b_i = %b, carry_i = %b -> sum_o = %b, expected_sum_o = %b, carry_o = %b, expected_carry_o = %b",
                    i, a_i, b_i, carry_i, sum_o, expected_sum_o, carry_o, expected_carry_o);
    end

    // Finish simulation
    $finish;
  end

  initial begin
      $dumpfile("tb_module_carry_look_ahead_adder.vcd");
      $dumpvars(0, tb_module_carry_look_ahead_adder);
  end

endmodule

