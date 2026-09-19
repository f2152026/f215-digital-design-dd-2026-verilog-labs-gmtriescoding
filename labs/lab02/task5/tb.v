// tb.v
module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  alu DUT (
    .a(t_a),
    .b(t_b),
    .op(t_op),
    .result(t_result)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // Test add
    t_a = 4'd5; t_b = 4'd3; t_op = 0;
    #5;
    // Change ONLY op, keep a/b fixed -- tests sensitivity list bug
    t_op = 1;
    #5;
    // Change a/b with op still 1 -- tests subtract path / blocking bug
    t_a = 4'd9; t_b = 4'd4;
    #5;
    $finish;
  end

  initial
    $monitor($time, " a=%d b=%d op=%b | result=%d", t_a, t_b, t_op, t_result);

endmodule