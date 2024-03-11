module accumulator #(
    parameter int DATA_WIDTH = 32
) (
    input var logic clk,
    input var logic rst_n,
    input var logic i_en,
    input var logic [DATA_WIDTH-1:0] data_in,
    output var logic [DATA_WIDTH-1:0] data_out
);

  handshake_if #(.DATA_WIDTH(DATA_WIDTH)) hs_tx_if;
  handshake_if #(.DATA_WIDTH(DATA_WIDTH)) hs_rx_if;

  assign hs_tx_if.ready = i_en;
  assign hs_tx_if.data = data_in;
  assign hs_rx_if.valid = i_en;
  assign data_out = hs_rx_if.data;

  assign hs_tx_if.valid = 1'b1;
  assign hs_rx_if.ready = 1'b1;

  accumulator_core #(
      .DATA_WIDTH(DATA_WIDTH)
  ) acc_core (
      .clk  (clk),
      .rst_n(rst_n),
      .tx_if(hs_tx_if),
      .rx_if(hs_rx_if)
  );

endmodule
