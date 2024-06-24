module async_fifo #(
    parameter DATA_WIDTH = 8,
              DEPTH      = 16
) (
    input  logic                  clk_wr,
    input  logic                  clk_rd,
    input  logic                  rst_wr,
    input  logic                  rst_rd,
    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  empty,
    output logic                  full
);

  localparam ADDR_WIDTH = $clog2(DEPTH);

  logic [ADDR_WIDTH-1:0] wr_ptr = 0;
  logic [ADDR_WIDTH-1:0] rd_ptr = 0;
  logic [DATA_WIDTH-1:0] mem        [0:DEPTH-1];

  always @(posedge clk_wr or posedge rst_wr) begin
    if (rst_wr) wr_ptr <= 0;
    else if (wr_en && !full) wr_ptr <= wr_ptr + 1;
  end

  always @(posedge clk_rd or posedge rst_rd) begin
    if (rst_rd) rd_ptr <= 0;
    else if (rd_en && !empty) rd_ptr <= rd_ptr + 1;
  end

  always @(posedge clk_wr) begin
    if (wr_en && !full) mem[wr_ptr] <= wr_data;
  end

  assign rd_data = mem[rd_ptr];
  assign empty   = (wr_ptr == rd_ptr);
  assign full    = ((wr_ptr + 1) == rd_ptr);

endmodule
