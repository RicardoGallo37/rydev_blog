module hamming_code_64 #(
    parameter DATA_WIDTH = 64,
    parameter CODE_WIDTH = 72
) (
    input  logic [DATA_WIDTH-1:0] data_in,
    output logic [CODE_WIDTH-1:0] code_out,
    input  logic [CODE_WIDTH-1:0] code_in,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic                  single_error_detected,
    output logic                  multi_error_detected,
    output logic                  error_corrected
);

  // Calcula los bits de paridad para la codificación
  assign code_out[DATA_WIDTH-1:0] = data_in;
  assign code_out[DATA_WIDTH] = ^data_in[6:0] ^ data_in[9:7] ^ data_in[11:10] ^ data_in[15:12] ^ data_in[19:16] ^ data_in[23:20] ^ data_in[27:24] ^ data_in[31:28] ^ data_in[35:32] ^ data_in[39:36] ^ data_in[43:40] ^ data_in[47:44] ^ data_in[51:48] ^ data_in[55:52] ^ data_in[59:56] ^ data_in[63:60];
  assign code_out[DATA_WIDTH+1] = ^data_in[13:0] ^ data_in[15:14] ^ data_in[19:16] ^ data_in[23:20] ^ data_in[27:24] ^ data_in[31:28] ^ data_in[35:32] ^ data_in[39:36] ^ data_in[43:40] ^ data_in[47:44] ^ data_in[51:48] ^ data_in[55:52] ^ data_in[59:56] ^ data_in[63:60];
  assign code_out[DATA_WIDTH+2] = ^data_in[15:0] ^ data_in[19:16] ^ data_in[23:20] ^ data_in[27:24] ^ data_in[31:28] ^ data_in[35:32] ^ data_in[39:36] ^ data_in[43:40] ^ data_in[47:44] ^ data_in[51:48] ^ data_in[55:52] ^ data_in[59:56] ^ data_in[63:60];
  assign code_out[DATA_WIDTH+3] = ^data_in[19:0] ^ data_in[23:20] ^ data_in[27:24] ^ data_in[31:28] ^ data_in[35:32] ^ data_in[39:36] ^ data_in[43:40] ^ data_in[47:44] ^ data_in[51:48] ^ data_in[55:52] ^ data_in[59:56] ^ data_in[63:60];
  assign code_out[DATA_WIDTH+4] = ^data_in[23:0] ^ data_in[27:24] ^ data_in[31:28] ^ data_in[35:32] ^ data_in[39:36] ^ data_in[43:40] ^ data_in[47:44] ^ data_in[51:48] ^ data_in[55:52] ^ data_in[59:56] ^ data_in[63:60];
  assign code_out[DATA_WIDTH+5] = ^data_in[27:0] ^ data_in[31:28] ^ data_in[35:32] ^ data_in[39:36] ^ data_in[43:40] ^ data_in[47:44] ^ data_in[51:48] ^ data_in[55:52] ^ data_in[59:56] ^ data_in[63:60];
  assign code_out[DATA_WIDTH+6] = ^data_in[31:0] ^ data_in[35:32] ^ data_in[39:36] ^ data_in[43:40] ^ data_in[47:44] ^ data_in[51:48] ^ data_in[55:52] ^ data_in[59:56] ^ data_in[63:60];
  assign code_out[DATA_WIDTH+7] = ^data_in[63:0];

  // Calcula los bits de paridad para la decodificación y detección de errores
  logic [CODE_WIDTH-1:0] parity;
  assign parity[DATA_WIDTH-1:0] = code_in[DATA_WIDTH-1:0];
  assign parity[DATA_WIDTH] = ^code_in[6:0] ^ code_in[9:7] ^ code_in[11:10] ^ code_in[15:12] ^ code_in[19:16] ^ code_in[23:20] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[35:32] ^ code_in[39:36] ^ code_in[43:40] ^ code_in[47:44] ^ code_in[51:48] ^ code_in[55:52] ^ code_in[59:56] ^ code_in[63:60] ^ code_in[64];
  assign parity[DATA_WIDTH+1] = ^code_in[13:0] ^ code_in[15:14] ^ code_in[19:16] ^ code_in[23:20] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[35:32] ^ code_in[39:36] ^ code_in[43:40] ^ code_in[47:44] ^ code_in[51:48] ^ code_in[55:52] ^ code_in[59:56] ^ code_in[63:60] ^ code_in[65];
  assign parity[DATA_WIDTH+2] = ^code_in[15:0] ^ code_in[19:16] ^ code_in[23:20] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[35:32] ^ code_in[39:36] ^ code_in[43:40] ^ code_in[47:44] ^ code_in[51:48] ^ code_in[55:52] ^ code_in[59:56] ^ code_in[63:60] ^ code_in[66];
  assign parity[DATA_WIDTH+3] = ^code_in[19:0] ^ code_in[23:20] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[35:32] ^ code_in[39:36] ^ code_in[43:40] ^ code_in[47:44] ^ code_in[51:48] ^ code_in[55:52] ^ code_in[59:56] ^ code_in[63:60] ^ code_in[67];
  assign parity[DATA_WIDTH+4] = ^code_in[23:0] ^ code_in[27:24] ^ code_in[31:28] ^ code_in[35:32] ^ code_in[39:36] ^ code_in[43:40] ^ code_in[47:44] ^ code_in[51:48] ^ code_in[55:52] ^ code_in[59:56] ^ code_in[63:60] ^ code_in[68];
  assign parity[DATA_WIDTH+5] = ^code_in[27:0] ^ code_in[31:28] ^ code_in[35:32] ^ code_in[39:36] ^ code_in[43:40] ^ code_in[47:44] ^ code_in[51:48] ^ code_in[55:52] ^ code_in[59:56] ^ code_in[63:60] ^ code_in[69];
  assign parity[DATA_WIDTH+6] = ^code_in[31:0] ^ code_in[35:32] ^ code_in[39:36] ^ code_in[43:40] ^ code_in[47:44] ^ code_in[51:48] ^ code_in[55:52] ^ code_in[59:56] ^ code_in[63:60] ^ code_in[70];
  assign parity[DATA_WIDTH+7] = ^code_in[63:0] ^ code_in[71];

  // Detecta y corrige errores
  logic [7:0] error_location = parity[CODE_WIDTH:DATA_WIDTH];
  assign single_error_detected = error_location != 0 && error_location != 1;
  assign multi_error_detected  = error_location == 1;
  assign error_corrected       = single_error_detected;
  assign data_out              = code_in[DATA_WIDTH-1:0] ^ (error_corrected ? 1 << (error_location - 1) : 0);

endmodule
