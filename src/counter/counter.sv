// Simple counter
//

module counter (
    input var logic clk,
    input var logic rst_n,
    input var logic en,
    output var logic [7:0] count
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      count <= 8'b0;
    end
    else if (en) begin
      count <= count + 1;
    end
  end

  /*initial begin
   *  $display("Hello from counter");
   *  $finish;
   *end*/

endmodule
