module register_4bit(
    read_data,
    write_data,
    write_addr,
    read_addr,
    write_enable,
    clk,
    reset
);

// Port declarations
input clk, reset, write_enable;
input [1:0] write_addr, read_addr;
input [3:0] write_data;
output [3:0] read_data;

// The actual storage ? 4 registers each 4 bits wide
reg [3:0] registers [0:3];

integer i;

// WRITE operation
always @(posedge clk or posedge reset) begin
    if(reset) begin
        for(i = 0; i < 4; i = i + 1)
            registers[i] <= 4'b0000;
    end
    else if(write_enable) begin
        registers[write_addr] <= write_data;
    end
end

// READ operation
assign read_data = registers[read_addr];

endmodule
