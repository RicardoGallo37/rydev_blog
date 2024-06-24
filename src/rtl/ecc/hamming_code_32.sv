module hamming_code_32 #(
    parameter DATA_WIDTH = 32,
    parameter CODE_WIDTH = 39
) (
    input  wire [DATA_WIDTH-1:0] data_in,
    output wire [CODE_WIDTH-1:0] code_out,
    input  wire [CODE_WIDTH-1:0] code_in,
    output wire [DATA_WIDTH-1:0] data_out,
    output wire                  single_error_detected,
    output wire                  multi_error_detected,
    output wire                  error_corrected
);

  // Calcula los bits de paridad para la codificación
  assign code_out[DATA_WIDTH-1:0] = data_in;
  assign code_out[DATA_WIDTH]     = ^data_in[6:0] ^ data_in[9:7] ^ data_in[11:10] ^ data_in[15:12] ^ data_in[19:16] ^ data_in[23:20] ^ data_in[27:24] ^ data_in[31:28];
  assign code_out[DATA_WIDTH+1]   = ^data_in[13:0] ^ data_in[15:14] ^ data_in[19:16] ^ data_in[23:20] ^ data_in[27:24] ^ data_in[31:28];
  assign code_out[DATA_WIDTH+2]   = ^data_in[15:0] ^ data_in[19:16] ^ data_in[23:20] ^ data_in[27:24] ^ data_in[31:28];
  assign code_out[DATA_WIDTH+3]   = ^data_in[19:0] ^ data_in[23:20] ^ data_in[27:24] ^ data_in[31:28];
  assign code_out[DATA_WIDTH+4]   = ^data_in[23:0] ^ data_in[27:24] ^ data_in[31:28];
  assign code_out[DATA_WIDTH+5]   = ^data_in[27:0] ^ data_in[31:28];
  assign code_out[DATA_WIDTH+6]   = ^data_in[31:0];

  // Calcula los bits de paridad para la decodificación y detección de errores
  wire [CODE_WIDTH-1:0] parity;
  assign parity[DATA_WIDTH-1:0] = code_in[DATA_WIDTH-1:0];
  assign parity[DATA_WIDTH]     = ^code_in[6:0] ^ code_in[9:7] ^ code_in[11:10] ^ code_in[15:12] ^ code_in[19:16] ^ code_in[23:20] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[32];
  assign parity[DATA_WIDTH+1]   = ^code_in[13:0] ^ code_in[15:14] ^ code_in[19:16] ^ code_in[23:20] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[33];
  assign parity[DATA_WIDTH+2]   = ^code_in[15:0] ^ code_in[19:16] ^ code_in[23:20] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[34];
  assign parity[DATA_WIDTH+3]   = ^code_in[19:0] ^ code_in[23:20] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[35];
  assign parity[DATA_WIDTH+4]   = ^code_in[23:0] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[36];
  assign parity[DATA_WIDTH+5]   = ^code_in[27:0] ^ code_in[31:28] ^ code_in[37];
  assign parity[DATA_WIDTH+6]   = ^code_in[31:0] ^ code_in[38];

  // Detecta y corrige errores
  wire [6:0] error_location = parity[CODE_WIDTH:DATA_WIDTH];
  assign single_error_detected = error_location != 0 && error_location != 1;
  assign multi_error_detected  = error_location == 1;
  assign error_corrected       = single_error_detected;
  assign data_out              = code_in[DATA_WIDTH-1:0] ^ (error_corrected ? 1 << (error_location - 1) : 0);

endmodule
