// Simple ready-valid based handshake interface
//

`ifndef HANDSHAKE_IF_SV
`define HANDSHAKE_IF_SV

interface handshake_if #(
    parameter int DATA_WIDTH = 32
);

  logic [DATA_WIDTH-1:0] data;
  logic valid;
  logic ready;

  // acknowledge
  function automatic logic get_ack();
    return valid && ready;
  endfunction

  // modport
  modport receiver(input data, output valid, input ready, import get_ack);
  modport sender(output data, input valid, output ready, import get_ack);

endinterface

`endif
