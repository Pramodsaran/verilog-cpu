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
