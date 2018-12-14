import silica as si


def test_basic():
    @si.function
    def basic_if(I: si.Bits(2), S: si.Bit) -> si.Bit:
        if S:
            x = I[0]
        else:
            x = I[1]
        return x

    si.compile_function(basic_if, file_name="tests/build/basic_if.v")
    with open("tests/build/basic_if.v", "r") as f:
        result = f.read()
        print(result)
        assert result == """\


module basic_if
(
  output O,
  input return,
  input [2-1:0] I,
  input S
);

  wire x;

  always @(*) begin
    if(S) begin
      x = I[0];
    end else begin
      x = I[1];
    end
    O = x;
  end


endmodule

"""
