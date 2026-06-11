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

initial begin
	registers[0]=4'b0001;
	registers[1]=4'b0010;
	registers[2]=4'b0011;
	registers[3]=4'b0100;
end

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

module controlunit(
clk,reset,instr,cout,zero
);

input clk,reset;
input [8:0] instr;

output cout,zero;

wire [2:0] opcode;
wire [1:0] s1;
wire [1:0] s2;
wire [1:0] dest;
wire [3:0] alu_input;
wire [3:0] data_A,data_B;

assign opcode=instr[8:6];
assign s1=instr[5:4];
assign s2=instr[3:2];
assign dest=instr[1:0];


register_4bit RF(
.clk(clk),
.reset(reset),
.write_enable(1'b1),
.write_addr(dest),
.read_addr_A(s1),
.read_addr_B(s2),
.write_data(alu_input),
.read_data_A(data_A),
.read_data_B(data_B)
);

alu_4bit ALU(
.a(data_A),
.b(data_B),
.opcode(opcode),
.result(alu_input),
.cout(cout),
.zero(zero)
);

endmodule
