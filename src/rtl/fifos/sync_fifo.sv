module sync_fifo #(
    parameter DEPTH = 16,
              BITS  = 32
) (
    input  logic            clk,
    input  logic            rst,
    input  logic            push,
    input  logic [BITS-1:0] Din,
    output logic [BITS-1:0] Dout,
    input  logic            pop,
    output logic            pndng,
    output logic            empty,
    output logic            full
);

  logic [BITS-1:0] mem[0:DEPTH-1];
  logic [$clog2(DEPTH)-1:0] wr_ptr, rd_ptr;
  logic [$clog2(DEPTH)-1:0] next_wr_ptr, next_rd_ptr;

  assign next_wr_ptr = wr_ptr + 1;
  assign next_rd_ptr = rd_ptr + 1;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      wr_ptr <= 0;
      rd_ptr <= 0;
    end
    else begin
      if (push && !full) wr_ptr <= next_wr_ptr;
      if (pop && !empty) rd_ptr <= next_rd_ptr;
    end
  end

  always @(posedge clk) begin
    if (push && !full) mem[wr_ptr] <= Din;
  end

  assign Dout  = mem[rd_ptr];
  assign empty = (wr_ptr == rd_ptr);
  assign pndng = ~empty;
  assign full  = (next_wr_ptr == rd_ptr);

endmodule
