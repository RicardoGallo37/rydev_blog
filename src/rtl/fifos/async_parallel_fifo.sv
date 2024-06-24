module async_parallel_fifo #(
    parameter DATA_WIDTH     = 8,
              DEPTH          = 16,
              WR_PARALLELISM = 128,
              RD_PARALLELISM = 160
) (
    input  logic                                 clk_wr,
    input  logic                                 clk_rd,
    input  logic                                 rst_wr,
    input  logic                                 rst_rd,
    input  logic                                 wr_en,
    input  logic [WR_PARALLELISM*DATA_WIDTH-1:0] wr_data,
    input  logic                                 rd_en,
    output logic [RD_PARALLELISM*DATA_WIDTH-1:0] rd_data,
    output logic                                 empty,
    output logic                                 full,
    output logic [                 ADDR_WIDTH:0] fifo_level
);

  localparam ADDR_WIDTH = $clog2(DEPTH);

  logic [               ADDR_WIDTH-1:0] wr_ptr = 0;
  logic [               ADDR_WIDTH-1:0] rd_ptr = 0;
  logic [RD_PARALLELISM*DATA_WIDTH-1:0] mem        [0:DEPTH-1];

  // Instancias de flip-flops de sincronización
  sync_ff #(1) wr_en_sync (
      .clk(clk_wr),
      .rst(rst_wr),
      .d  (wr_en),
      .q  (wr_en_sync)
  );
  sync_ff #(1) rd_en_sync (
      .clk(clk_rd),
      .rst(rst_rd),
      .d  (rd_en),
      .q  (rd_en_sync)
  );

  // Conversión a código Gray
  logic [ADDR_WIDTH:0] wr_ptr_gray = 0;
  logic [ADDR_WIDTH:0] rd_ptr_gray = 0;

  always @(posedge clk_wr or posedge rst_wr) begin
    if (rst_wr) begin
      wr_ptr      <= 0;
      wr_ptr_gray <= 0;
    end
    else if (wr_en_sync && !full) begin
      wr_ptr      <= wr_ptr + 1;
      wr_ptr_gray <= wr_ptr ^ (wr_ptr >> 1);
    end
  end

  always @(posedge clk_rd or posedge rst_rd) begin
    if (rst_rd) begin
      rd_ptr      <= 0;
      rd_ptr_gray <= 0;
    end
    else if (rd_en_sync && !empty) begin
      rd_ptr      <= rd_ptr + 1;
      rd_ptr_gray <= rd_ptr ^ (rd_ptr >> 1);
    end
  end

  always @(posedge clk_wr) begin
    if (wr_en_sync && !full) begin
      mem[wr_ptr_gray][WR_PARALLELISM*DATA_WIDTH-1:0]                           <= wr_data;
      mem[wr_ptr_gray+1][RD_PARALLELISM*DATA_WIDTH-1:WR_PARALLELISM*DATA_WIDTH] <= wr_data[WR_PARALLELISM*DATA_WIDTH-1:0];
    end
  end

  assign rd_data    = mem[rd_ptr_gray];
  assign empty      = (wr_ptr_gray == rd_ptr_gray);
  assign full       = ((wr_ptr_gray + 2) == rd_ptr_gray);
  assign fifo_level = wr_ptr_gray - rd_ptr_gray;  // Calculamos el nivel de la FIFO

endmodule
