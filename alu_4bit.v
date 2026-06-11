module alu_4bit(result,cout,z,a,b,opcode);

input [3:0]a,b;
input [2:0]opcode;

output reg[3:0]result;
output reg cout;
output z;

assign z=(result==4'b0000);

always @(*) begin
	cout=0;
	case(opcode)
	3'b000: {cout, result} = a + b;  // ADD
        3'b001: {cout, result} = a - b;  // SUB
        3'b010: result = a & b;               // AND
        3'b011: result = a | b;               // OR
        3'b100: result = a ^ b;               // XOR
        3'b101: result = ~a;                  // NOT
        default: result = 4'b0000;
    endcase
end

endmodule
