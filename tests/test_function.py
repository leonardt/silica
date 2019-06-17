import silica as si


# TODO: These were adapted from magma's SSA tests, perhaps we can find a nice
# way to reuse test functions?
def test_basic():
    @si.function
    def basic_if(I: si.Bits[2], S: si.Bit) -> si.Bit:
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


def test_default():
    @si.function
    def default(I: si.Bits[2], S: si.Bit) -> si.Bit:
        x = I[1]
        if S:
            x = I[0]
        return x

    si.compile_function(default, file_name="tests/build/default.v")
    with open("tests/build/default.v", "r") as f:
        result = f.read()
        print(result)
        assert result == """\


module default
(
  output O,
  input return,
  input [2-1:0] I,
  input S
);

  wire x;

  always @(*) begin
    x = I[1];
    if(S) begin
      x = I[0];
    end 
    O = x;
  end


endmodule

"""


def test_nested():
    @si.function
    def nested(I: si.Bits[4], S: si.Bits[2]) -> si.Bit:
        if S[0]:
            if S[1]:
                x = I[0]
            else:
                x = I[1]
        else:
            if S[1]:
                x = I[2]
            else:
                x = I[3]
        return x

    si.compile_function(nested, file_name="tests/build/nested.v")
    with open("tests/build/nested.v", "r") as f:
        result = f.read()
        print(result)
        assert result == """\


module nested
(
  output O,
  input return,
  input [4-1:0] I,
  input [2-1:0] S
);

  wire x;

  always @(*) begin
    if(S[0]) begin
      if(S[1]) begin
        x = I[0];
      end else begin
        x = I[1];
      end
    end else if(S[1]) begin
      x = I[2];
    end else begin
      x = I[3];
    end
    O = x;
  end


endmodule

"""
