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
