// and_df.v
module and_df (
  input  a, b,
  output y
);
  assign #5 y = a & b;
endmodule