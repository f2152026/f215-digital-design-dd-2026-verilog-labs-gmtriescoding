// tb.v
// Self-checking testbench for comp2.
// Applies all 16 combinations of A, B and checks:
//   1) exactly one of GT, LT, EQ is 1
//   2) the one that's 1 is actually the correct one

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;

  integer i, j;
  integer errors = 0;

  comp2 DUT (
    .A(t_a),
    .B(t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;
        #5; // let outputs settle

        // Check exactly one of GT, LT, EQ is asserted
        if ((t_gt + t_lt + t_eq) !== 1) begin
          $display("ERROR: A=%0d B=%0d -> GT=%b LT=%b EQ=%b (expected exactly one high)",
                    t_a, t_b, t_gt, t_lt, t_eq);
          errors = errors + 1;
        end
        // Check correctness of whichever bit(s) are high
        else begin
          if (t_a > t_b && !t_gt) begin
            $display("ERROR: A=%0d B=%0d -> expected GT=1, got GT=%b", t_a, t_b, t_gt);
            errors = errors + 1;
          end
          if (t_a < t_b && !t_lt) begin
            $display("ERROR: A=%0d B=%0d -> expected LT=1, got LT=%b", t_a, t_b, t_lt);
            errors = errors + 1;
          end
          if (t_a == t_b && !t_eq) begin
            $display("ERROR: A=%0d B=%0d -> expected EQ=1, got EQ=%b", t_a, t_b, t_eq);
            errors = errors + 1;
          end
        end
      end
    end

    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("TOTAL ERRORS: %0d", errors);

    $finish;
  end

  initial
    $monitor($time, " A=%b B=%b | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule