module accumulator_core #(
    parameter int DATA_WIDTH = 32
) (
    input var logic clk,
    input var logic rst_n,
    input var logic i_en,
    handshake_if.receiver rx_if,
    handshake_if.sender tx_if
);

  logic i_ack;
  logic o_ack;
  logic [DATA_WIDTH-1:0] data;
  logic [DATA_WIDTH-1:0] acc_data;

  assign i_ack = rx_if.get_ack();
  assign o_ack = tx_if.get_ack();

  assign data = (i_ack) ? rx_if.data : '0;
  assign tx_if.data = (o_ack) ? acc_data : '0;

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      acc_data <= 0;
    end
    else if (i_en) begin
      acc_data <= acc_data + data;
    end
    else begin
      acc_data <= acc_data;
    end
  end

  always_comb begin
    if (i_en) begin
      rx_if.valid = 1'b1;
      tx_if.ready = 1'b1;
    end
    else begin
      rx_if.valid = 1'b0;
      tx_if.ready = 1'b0;
    end
  end

endmodule

