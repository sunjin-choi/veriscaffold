// Simple handshake fan-in module
//
// Note: selecting element with i_sel doens't work in Verilator
// fanning-in output interface should have the same number of virtual channels as the
// input channels to get around the issue by design

module handshake_conn_fi #(
    parameter int DATA_WIDTH  = 32,
    parameter int NUM_CHANNEL = 2
) (
    input var logic [$clog2(NUM_CHANNEL)-1:0] i_sel,
    handshake_if.receiver rx_if[NUM_CHANNEL],
    handshake_if.sender tx_if
);

  // Note: Use packed array, unpacked are broken in verilator
  logic [NUM_CHANNEL-1:0] tx_ready_bus;
  logic [NUM_CHANNEL-1:0][DATA_WIDTH-1:0] tx_data_bus;

  generate
    for (genvar i = 0; i < NUM_CHANNEL; i++) begin : gen_hs_conn
      always_comb begin
        rx_if[i].valid  = (i_sel == i) ? tx_if.valid : '0;
        tx_ready_bus[i] = (i_sel == i) ? rx_if[i].ready : '0;
        tx_data_bus[i]  = (i_sel == i) ? rx_if[i].data : '0;
      end
    end
  endgenerate

  // OR to update tx_if.ready from tx_ready_bus
  assign tx_if.ready = |tx_ready_bus;
  // OR to update tx_if.data from tx_data_bus
  generate
    for (genvar bitIdx = 0; bitIdx < DATA_WIDTH; bitIdx++) begin : gen_or_data
      // Temporary wire to hold bits from all channels for specific bit position
      wire [NUM_CHANNEL-1:0] data_bits;

      // Populate data_bits with each channel's bit at bitIdx
      for (genvar chIdx = 0; chIdx < NUM_CHANNEL; chIdx++) begin : gen_extract_bits
        assign data_bits[chIdx] = tx_data_bus[chIdx][bitIdx];
      end

      // Perform OR operation across all extracted bits and assign to corresponding bit of tx_if.data
      assign tx_if.data[bitIdx] = |data_bits;
    end
  endgenerate

  /*  // Verilator does not allow this - recommend always_comb inside generate
 *  // https://github.com/verilator/verilator/issues/1418
 *  // https://github.com/verilator/verilator/issues/1454
 *
 *  assign tx_if.data = rx_if[i_sel].data;
 *  always_comb begin
 *    for (int i = 0; i < NUM_CHANNEL; i++) begin
 *      if (i_sel == i) begin
 *        rx_if[i].valid = tx_if.valid;
 *        tx_if.ready = rx_if[i].ready;
 *      end
 *      else begin
 *        rx_if[i].valid = '0;
 *        tx_if.ready = '0;
 *      end
 *    end
 *  end*/

endmodule

