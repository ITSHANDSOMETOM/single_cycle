module Reg_file32(
  input  logic            reset_i,
  input  logic            clk_i,
  input  logic            Regwrite_i,
  input  logic  [4:0]     rd_i, rs1_i, rs2_i,
  input  logic  [31:0]    wd_i,
  output logic  [31:0]    rs1_o, rs2_o
);
  wire [31:0]	decoder_rd_out;
  wire [31:0]	we_en;  
  reg  [31:0] pipo_bus [31:0];

  decoder5_32 dec (
    .i(rd_i) ,
    .y(decoder_rd_out), 
    .en(1'b1)
  );

  assign we_en = decoder_rd_out & {32{Regwrite_i}};
  
  pipo_32bit pipo0(
    .reset_i    (reset_i),
    .clk_i      (clk_i),
    .d_i        (32'b0),
    .q_o        (pipo_bus[0]),
    .en_i       (1'b0)
  );

  genvar i;
  generate 
  for (i = 1; i < 32 ; i = i + 1) begin: pipos
    pipo_32bit reg_inst(
    .reset_i    (reset_i),
    .clk_i      (clk_i),
    .d_i        (wd_i),
    .q_o        (pipo_bus[i]),
    .en_i       (we_en[i])
    );
  end
  endgenerate

  mux_32_1_32bit muxrs1(
    .sel(rs1_i), 
    .d(pipo_bus), 
    .y(rs1_o), 
    .en(1'b1)
    );

  mux_32_1_32bit muxrs2(
    .sel(rs2_i), 
    .d(pipo_bus), 
    .y(rs2_o), 
    .en(1'b1)
  );
endmodule