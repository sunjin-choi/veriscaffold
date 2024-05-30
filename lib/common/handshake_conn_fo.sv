// Simple handshake fan-out module
//
// Note: selecting element with i_sel doens't work in Verilator
// fanning-out glue logic should have the same number of virtual channels as the
// output channels to get around the issue by design

module handshake_conn_fo #(
    parameter int NUM_CHANNEL = 2
) (
    input var logic [$clog2(NUM_CHANNEL)-1:0] i_sel,
    handshake_if.receiver rx_if,
    handshake_if.sender tx_if[NUM_CHANNEL]
);

  // This is the only way to do it in Verilator... See above
  /*logic [NUM_CHANNEL-1:0] rx_if_valid_bus;*/
  generate
    for (genvar i = 0; i < NUM_CHANNEL; i++) begin : gen_hs_conn
      always_comb begin
        tx_if[i].ready = (i_sel == i) ? rx_if.ready : '0;
        tx_if[i].data  = (i_sel == i) ? rx_if.data : '0;
        /*rx_if_valid_bus[i] = (i_sel == i) ? tx_if[i].valid : '0;*/
      end
    end
  endgenerate

  selector_if #(
      .DATA_TYPE(logic),
      .ENTRIES  (NUM_CHANNEL)
  ) sel_if ();

  logic [NUM_CHANNEL-1:0] rx_if_valid_bus;
  generate
    for (genvar i = 0; i < NUM_CHANNEL; i++) begin : gen_valid_bus
      assign rx_if_valid_bus[i] = tx_if[i].valid;
    end
  endgenerate

  assign rx_if.valid = sel_if.mux(rx_if_valid_bus, i_sel);

  // CASE OF (VERILATOR) FAILURES...

  /*function automatic logic [NUM_CHANNEL-1:0] rx_if_valid_bus();
   *  logic [NUM_CHANNEL-1:0] rx_if_valid_bus;
   *  for (int i = 0; i < NUM_CHANNEL; i++) begin
   *    rx_if_valid_bus[i] = tx_if[i].valid;
   *  end
   *  return rx_if_valid_bus;
   *endfunction*/

  /*// This is also forbidden
   *generate
   *  always_comb begin
   *    for (int i = 0; i < NUM_CHANNEL; i++) begin
   *      tx_if[i].ready = (i_sel == i) ? rx_if.ready : '0;
   *      tx_if[i].data  = (i_sel == i) ? rx_if.data : '0;
   *    end
   *  end
   *endgenerate*/

  /*  // Verilator does not allow this - recommend always_comb inside generate
 *  // https://github.com/verilator/verilator/issues/1418
 *  // https://github.com/verilator/verilator/issues/1454
 *
 *  //always_comb begin
 *  //  for (int i = 0; i < NUM_CHANNEL; i++) begin
 *  //    tx_if[i].ready = '0;
 *  //    tx_if[i].data  = '0;
 *  //  end
 *  //end*/

endmodule

