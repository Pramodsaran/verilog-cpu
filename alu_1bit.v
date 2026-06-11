module alu_1bit(result, a, b, opcode);
input a, b;
input [1:0] opcode;
output reg result;

always @(*) begin
    case(opcode)
        2'b00: result = a + b;   // ADD
        2'b01: result = a & b;   // AND
        2'b10: result = a | b;   // OR
        default: result = 1'b0;  // safety default
    endcase
end

endmodule
