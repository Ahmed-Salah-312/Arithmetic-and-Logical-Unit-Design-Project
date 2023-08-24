module ALU(a, b, sel, y);
  input signed [3:0] a, b;
  input [3:0] sel;

  reg signed [3:0] Ra, Rb;
  reg [3:0] Rsel;
  output reg [5:0] y;

  reg signed [5:0] Arithmetic;
  reg [3:0] Logic;

  always @(*) begin
    Ra <= a;
    Rb <= b;
    Rsel <= sel;

    case (Rsel[2:0])
      3'b000 : begin
        Arithmetic = Ra + 1;
        Logic = ~Ra;
      end
      3'b001 : begin
        Arithmetic = Ra - 1;
        Logic = ~Rb;
      end
      3'b010 : begin
        Arithmetic = Ra << 1;
        Logic = Ra & Rb;
      end
      3'b011 : begin
        Arithmetic = Rb + 1;
        Logic = Ra | Rb;
      end
      3'b100 : begin
        Arithmetic = Rb - 1;
        Logic = Ra ^ Rb;
      end
      3'b101 : begin
        Arithmetic = Rb << 1;
        Logic = Ra ~^ Rb;
      end
      3'b110 : begin
        Arithmetic = Ra + Rb;
        Logic = ~(Ra & Rb);
      end
      3'b111 : begin
        Arithmetic = Ra << 2;
        Logic = ~(Ra | Rb);
      end
    endcase

    if (Rsel[3] == 0) begin
      y = Arithmetic;
    end
    else begin
      y = {2'b00, Logic};
    end
  end
endmodule

module testbench();
  reg signed [3:0] a, b;
  reg [3:0] sel;
  wire signed [5:0] y;

  integer i, j, k;

  initial begin
    $display("a b sel output");
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        for (k = 0; k < 16; k = k + 1) begin
          #10 a = i;
          #10 b = j;
          #10 sel = k;
          #100
          if (sel[3] == 0) begin
            $display("%b %b %b %b", a, b, sel, y);
          end
          else begin
            $display("%b %b %b %b", a, b, sel, y[3:0]);
          end
        end
      end
    end
  end

  ALU G(a, b, sel, y);
endmodule



