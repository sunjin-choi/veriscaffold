module accumulator_core #(
    parameter int DATA_WIDTH = 32
) (
    input var logic clk,
    input var logic rst_n,
    handshake_if.receiver tx_if,
    handshake_if.sender rx_if
);

  logic i_ack;
  logic o_ack;
  logic [DATA_WIDTH-1:0] acc_data;

  assign i_ack = tx_if.get_ack();
  assign o_ack = rx_if.get_ack();
  /*assign i_ack = '1;*/
  /*always_comb begin
   *  [>i_ack = tx_if.get_ack();<]
   *  i_ack = 1'b1;
   *end*/

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      acc_data <= 0;
    end
    else if (i_ack) begin
      acc_data <= acc_data + tx_if.data;
    end
  end

  always_comb begin
    if (o_ack) begin
      rx_if.data = acc_data;
    end
    else begin
      rx_if.data = 0;
    end
  end

  /*always_ff @(posedge clk or negedge rst_n) begin
   *  if (!rst_n) begin
   *    rx_if.data <= 0;
   *  end
   *  else if (o_ack) begin
   *    rx_if.data <= acc_data;
   *  end
   *end*/


endmodule

