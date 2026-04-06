module ram (
    input  wire clk,
    input  wire rst,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire [3:0]  wstrb,
    input  wire        ram_sel,
    output reg         ram_ready, // Déclaré comme reg pour être utilisé dans le always
    output reg  [31:0] ram_rdata
);
    reg [31:0] mem [0:1023];

    initial $readmemh("../../sw/firmware.hex", mem);

    always @(posedge clk) begin
        if (rst) begin
            ram_ready <= 0; 
        end else if (ram_sel) begin
            ram_rdata <= mem[addr[11:2]];
            ram_ready <= 1'b1;
            if (wstrb[0]) mem[addr[11:2]][ 7:0]   <= wdata[ 7:0];
            if (wstrb[1]) mem[addr[11:2]][15:8]   <= wdata[15:8];
            if (wstrb[2]) mem[addr[11:2]][23:16]  <= wdata[23:16];
            if (wstrb[3]) mem[addr[11:2]][31:24]  <= wdata[31:24];
            
        end
        else begin
            ram_ready <= 1'b0;
        end
    end
endmodule