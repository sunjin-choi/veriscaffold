// Simple ready-valid based handshake interface

`ifndef HANDSHAKE_IF_SV
`define HANDSHAKE_IF_SV

interface handshake_if #(
    parameter int DATA_WIDTH  = 32,
    parameter int NUM_CHANNEL = 1
);

  localparam int ChannelWidth = (NUM_CHANNEL >= 2) ? $clog2(NUM_CHANNEL) : 1;

  logic [ DATA_WIDTH-1:0] data;
  logic [NUM_CHANNEL-1:0] valid;
  logic [NUM_CHANNEL-1:0] ready;

  // acknowledge
  function automatic logic [NUM_CHANNEL-1:0] get_ack();
    return valid & ready;
  endfunction

  function automatic logic get_channel_ack(logic [ChannelWidth-1:0] channel);
    return valid[channel] & ready[channel];
  endfunction

  // modport
  modport receiver(input data, output valid, input ready, import get_ack, import get_channel_ack);
  modport sender(output data, input valid, output ready, import get_ack, import get_channel_ack);

endinterface

`endif
