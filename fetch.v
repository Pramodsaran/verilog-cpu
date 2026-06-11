module pc(
clk,reset,pc_in,pc_out,pc_en
);

input clk,reset,pc_en;
input [3:0] pc_in;
output reg [3:0] pc_out;

always @(posedge clk or posedge reset) begin
	if(reset)
		pc_out<=4'b0000;
	else if(pc_en)
		pc_out<=pc_in;
end

endmodule

module memory(
addr,instr
);

input [3:0] addr;
output [8:0] instr;

reg [8:0] memory [0:15];

initial begin
    memory[0] = 9'b000_00_01_10;
    memory[1] = 9'b001_00_01_11;
    memory[2] = 9'b010_00_01_11;
    memory[3] = 9'b011_00_01_10;
    memory[4] = 9'b100_00_00_11;
    memory[5] = 9'b000_10_11_00;
    memory[6] = 9'b000_00_00_00;
    memory[7] = 9'b000_00_00_00;
end

assign instr=memory[addr];

endmodule

module instr_reg(
clk,reset,in,out
);

input clk,reset;
input [8:0] in;
output reg [8:0] out;

always @(posedge clk or posedge reset) begin
	if(reset)
		out<=9'b000000000;
	else
		out<=in;
end

endmodule

module fetch(
clk,
reset,
pc_enable,
out
);

input clk,reset,pc_enable;
output [8:0] out;

wire [3:0] pc_next;
wire [3:0] pc_out;
wire [8:0] instr_out;

assign pc_next=pc_out+1;

pc PC(
.clk(clk),
.reset(reset),
.pc_en(pc_enable),
.pc_in(pc_next),
.pc_out(pc_out)
);

memory MEM(
.addr(pc_out),
.instr(instr_out)
);

instr_reg INSREG(
.clk(clk),
.reset(reset),
.in(instr_out),
.out(out)
);

endmodule
