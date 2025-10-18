
// data_mem.v - data memory

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output      [DATA_WIDTH-1:0] rd_data_mem
);

// array of 64 32-bit words or data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

wire [ADDR_WIDTH-1:0] word_addr = wr_addr[DATA_WIDTH-1:2] % 64;

// combinational read logic
// word-aligned memory access
assign rd_data_mem = data_ram[wr_addr[DATA_WIDTH-1:2] % 64];

// synchronous write logic
always @(posedge clk) begin
    if (wr_en) begin
        case(func3)
            3'b000: data_ram[wr_addr[DATA_WIDTH-1:2] % 64][7:0]   <= wr_data[7:0];   // SB
            3'b001: data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15:0]  <= wr_data[15:0];  // SH
            3'b010: data_ram[wr_addr[DATA_WIDTH-1:2] % 64]        <= wr_data;        // SW
            default: ; // do nothing
        data_ram[wr_addr[DATA_WIDTH-1:2] % 64] <= wr_data;
end

endmodule

