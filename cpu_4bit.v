module register_4bit(
    clk, reset, write_enable,
    write_addr, write_data,
    read_addr_A, read_addr_B,
    read_data_A, read_data_B
);

input clk, reset, write_enable;
input [1:0] write_addr, read_addr_A, read_addr_B;
input [3:0] write_data;
output [3:0] read_data_A, read_data_B;

reg [3:0] registers [0:3];
integer i;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        for(i=0; i<4; i=i+1)
            registers[i] <= 4'b0000;
    end
    else if(write_enable)
        registers[write_addr] <= write_data;
end

assign read_data_A = registers[read_addr_A];
assign read_data_B = registers[read_addr_B];

endmodule

module alu_4bit(
    result, cout, zero,
    a, b, opcode
);

input [3:0] a, b;
input [2:0] opcode;
output reg [3:0] result;
output reg cout;
output zero;

assign zero = (result == 4'b0000);

always @(*) begin
    cout = 0;
    case(opcode)
        3'b000: {cout, result} = a + b;
        3'b001: {cout, result} = a - b;
        3'b010: result = a & b;
        3'b011: result = a | b;
        3'b100: result = a ^ b;
        3'b101: result = ~a;
        default: result = 4'b0000;
    endcase
end

endmodule

module cpu_data(
    clk, reset, write_enable,
    write_addr, read_addr_A, read_addr_B,
    opcode, immediate_data, load_select,
    cout, zero
);

input clk, reset, write_enable;
input [1:0] write_addr, read_addr_A, read_addr_B;
input [2:0] opcode;
input [3:0] immediate_data;
input load_select;
output cout, zero;

wire [3:0] result, operand_A, operand_B, write_data;

assign write_data = load_select ? immediate_data : result;

register_4bit RF(
    .clk(clk),
    .reset(reset),
    .write_enable(write_enable),
    .write_addr(write_addr),
    .write_data(write_data),
    .read_addr_A(read_addr_A),
    .read_addr_B(read_addr_B),
    .read_data_A(operand_A),
    .read_data_B(operand_B)
);

alu_4bit ALU(
    .a(operand_A),
    .b(operand_B),
    .opcode(opcode),
    .result(result),
    .zero(zero),
    .cout(cout)
);

endmodule