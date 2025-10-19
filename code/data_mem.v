
// data_mem.v - data memory

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    input       [2:0] funct3,
    output reg     [DATA_WIDTH-1:0] rd_data_mem
);

// array of 64 32-bit words or data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];


// synchronous write logic
always @(posedge clk) begin
    if (wr_en) begin
        case (funct3)
            3'b000: // SB - store byte
                case (wr_addr[1:0])
                    2'b00: data_ram[wr_addr[DATA_WIDTH-1:2] % 64][7:0]   <= wr_data[7:0];
                    2'b01: data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15:8]  <= wr_data[7:0];
                    2'b10: data_ram[wr_addr[DATA_WIDTH-1:2] % 64][23:16] <= wr_data[7:0];
                    2'b11: data_ram[wr_addr[DATA_WIDTH-1:2] % 64][31:24] <= wr_data[7:0];
                endcase
            3'b001: // SH - store halfword
                case (wr_addr[1:0])
                    2'b00: data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15:0]  <= wr_data[15:0];
                    2'b10: data_ram[wr_addr[DATA_WIDTH-1:2] % 64][31:16] <= wr_data[15:0];
                    default: ; // do nothing for unaligned halfword stores
                endcase
            3'b010: // SW - store word
                data_ram[wr_addr[DATA_WIDTH-1:2] % 64] <= wr_data;
            default: ; // do nothing for other funct3 values
        endcase
        
    end
end

always @(*) begin
    case (funct3)
        3'b000:begin // LB
            case (wr_addr[1:0])
                2'b00: rd_data_mem = { {24{ data_ram[(wr_addr[DATA_WIDTH-1:2] % 64)][7] }}, 
                 data_ram[(wr_addr[DATA_WIDTH-1:2] % 64)] };
                2'b01: rd_data_mem = {{24{data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15]}},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15:8]};
                2'b10: rd_data_mem = {{24{data_ram[wr_addr[DATA_WIDTH-1:2] % 64][23]}},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][23:16]};
                2'b11: rd_data_mem = {{24{data_ram[wr_addr[DATA_WIDTH-1:2] % 64][31]}},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][31:24]};
                
            endcase
        end
        3'b001:begin // LH
            case (wr_addr[1:0])
                2'b00: rd_data_mem = {{16{data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15]}},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15:0]};
                2'b10: rd_data_mem = {{16{data_ram[wr_addr[DATA_WIDTH-1:2] % 64][31]}},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][31:16]};
                default: rd_data_mem = 32'bx; // undefined for unaligned halfword loads
            endcase
        end
        3'b010: begin // LW
            rd_data_mem = data_ram[wr_addr[DATA_WIDTH-1:2] % 64];
        end
        3'b100: begin // LBU
            case (wr_addr[1:0])
                2'b00: rd_data_mem = {{24'b0},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][7:0]};
                2'b01: rd_data_mem = {{24'b0},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15:8]};
                2'b10: rd_data_mem = {{24'b0},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][23:16]};
                2'b11: rd_data_mem = {{24'b0},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][31:24]};
                default: rd_data_mem = 32'bx; // undefined for unaligned byte loads
            endcase
        end
        3'b101: begin // LHU
            case (wr_addr[1:0])
                2'b00: rd_data_mem = {{16'b0},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][15:0]};
                2'b10: rd_data_mem = {{16'b0},data_ram[wr_addr[DATA_WIDTH-1:2] % 64][31:16]};
                default: rd_data_mem = 32'bx; // undefined for unaligned halfword loads
            endcase
        end
        default: rd_data_mem = 32'bx; // undefined for other funct3 values
    endcase
end

endmodule
