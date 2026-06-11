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
