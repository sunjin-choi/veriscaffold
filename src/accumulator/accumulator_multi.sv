// Simple multi-channel accumulator module 

module accumulator_multi #(
    parameter int DATA_WIDTH  = 32,
    parameter int NUM_CHANNEL = 2
) (
    input var logic clk,
    input var logic rst_n,
    input var logic i_en,
    input var logic i_rdy,
    input var logic [DATA_WIDTH-1:0] data_in,
    input var logic [$clog2(NUM_CHANNEL)-1:0] i_sel,
    input var logic i_val,
    output var logic [DATA_WIDTH-1:0] data_out
);

  // Connection from top level to BFM interface
  handshake_if #(.DATA_WIDTH(DATA_WIDTH), .NUM_CHANNEL(1)) hs_rx_if;

  handshake_if #(.DATA_WIDTH(DATA_WIDTH), .NUM_CHANNEL(1)) hs_tx_if;

  assign hs_rx_if.ready = i_rdy;
  assign hs_tx_if.valid = i_val;

  assign hs_rx_if.data = data_in;
  assign data_out = hs_tx_if.data;

  // Connection to the accumulator core
  // Fan-in/fan-out module to connect multiple channels
  handshake_if #(.DATA_WIDTH(DATA_WIDTH), .NUM_CHANNEL(1)) hs_rx_core_if[NUM_CHANNEL];

  handshake_if #(.DATA_WIDTH(DATA_WIDTH), .NUM_CHANNEL(1)) hs_tx_core_if[NUM_CHANNEL];

  /*  logic [NUM_CHANNEL-1:0] channel_sel;
 *
 *  assign channel_sel = 2'b01;*/

  handshake_conn_fo #(
      .NUM_CHANNEL(NUM_CHANNEL)
  ) hs_conn_fo (
      .i_sel(i_sel),
      .rx_if(hs_rx_if),
      .tx_if(hs_rx_core_if)
  );

  handshake_conn_fi #(
      .DATA_WIDTH (DATA_WIDTH),
      .NUM_CHANNEL(NUM_CHANNEL)
  ) hs_conn_fi (
      .i_sel(i_sel),
      .rx_if(hs_tx_core_if),
      .tx_if(hs_tx_if)
  );

  generate
    for (genvar i = 0; i < NUM_CHANNEL; i++) begin : gen_acc
      accumulator_core #(
          .DATA_WIDTH(DATA_WIDTH)
      ) acc_core (
          .clk  (clk),
          .rst_n(rst_n),
          .i_en (i_en),
          .rx_if(hs_rx_core_if[i]),
          .tx_if(hs_tx_core_if[i])
      );
    end
  endgenerate

endmodule
