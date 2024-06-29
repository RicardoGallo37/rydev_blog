`timescale 1ns/1ps

module tb_bit_full_adder;

  // Testbench signals
  logic a_i;
  logic b_i;
  logic carry_i;
  logic sum_o;
  logic carry_o;

  // Expected outputs
  logic expected_sum_o;
  logic expected_carry_o;

  // Instantiate the full adder
  module_bit_full_adder DUT (
    .a_i     (a_i),
    .b_i     (b_i),
    .carry_i (carry_i),
    .sum_o   (sum_o),
    .carry_o (carry_o)
  );

  // Test vectors
  initial begin
    // Loop for 50 random test cases
    for (int i = 0; i < 10; i++) begin
      // Generate random inputs
      a_i     = $urandom % 2;
      b_i     = $urandom % 2;
      carry_i = $urandom % 2;

      // Calculate expected outputs
      {expected_carry_o, expected_sum_o} = a_i + b_i + carry_i;

      // Wait for a short time to simulate
      #10;

      // Check the outputs
      assert(sum_o == expected_sum_o && carry_o == expected_carry_o)
        else $fatal("Test %0d failed: a_i = %b, b_i = %b, carry_i = %b -> sum_o = %b, expected_sum_o = %b, carry_o = %b, expected_carry_o = %b",
                    i, a_i, b_i, carry_i, sum_o, expected_sum_o, carry_o, expected_carry_o);
    end

    // Finish simulation
    $finish;
  end

  initial begin
      $dumpfile("tb_bit_full_adder.vcd");
      $dumpvars(0, tb_bit_full_adder);
  end

endmodule

