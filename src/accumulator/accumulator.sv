module accumulator #(
    parameter int DATA_WIDTH = 32
) (
    input var logic clk,
    input var logic rst_n,
    input var logic i_en,
    input var logic i_rdy,
    input var logic [DATA_WIDTH-1:0] data_in,
    input var logic i_val,
    output var logic [DATA_WIDTH-1:0] data_out
);

  handshake_if #(.DATA_WIDTH(DATA_WIDTH), .NUM_CHANNEL(1)) hs_rx_if;
  handshake_if #(.DATA_WIDTH(DATA_WIDTH), .NUM_CHANNEL(1)) hs_tx_if;

  assign hs_rx_if.ready = i_rdy;
  assign hs_tx_if.valid = i_val;

  assign hs_rx_if.data = data_in;
  assign data_out = hs_tx_if.data;

  assign hs_rx_if.valid = 1'b1;
  assign hs_tx_if.ready = 1'b1;

  accumulator_core #(
      .DATA_WIDTH(DATA_WIDTH)
  ) acc_core (
      .clk  (clk),
      .rst_n(rst_n),
      .i_en (i_en),
      .rx_if(hs_rx_if),
      .tx_if(hs_tx_if)
  );

endmodule
