module ram (
    input  wire clk,
    input  wire reset,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire [3:0]  wstrb,
    input  wire        sel,
    output reg         ready,
    output reg  [31:0] rdata
);
    reg [31:0] mem [0:1023];

    integer f, i, status;
reg [31:0] dummy; // Pour stocker la ligne de taille inutile

initial begin
    f = $fopen("../../sw/firmware.hex", "r");
    if (f == 0) begin
        $display("ERROR: Could not open firmware.hex");
        $finish;
    end

    status = $fscanf(f, "%x\n", dummy); 

    i = 0;
    while (!$feof(f) && i < 1024) begin
        status = $fscanf(f, "%x\n", mem[i]);
        i = i + 1;
    end
    
    $fclose(f);
    $display("Loaded %d words into memory (skipped header).", i);
end

    always @(posedge clk) begin
        if (reset) begin
            ready <= 0; 
        end else if (sel) begin
            rdata <= mem[addr[11:2]];
            ready <= 1'b1;
            if (wstrb[0]) mem[addr[11:2]][ 7:0]   <= wdata[ 7:0];
            if (wstrb[1]) mem[addr[11:2]][15:8]   <= wdata[15:8];
            if (wstrb[2]) mem[addr[11:2]][23:16]  <= wdata[23:16];
            if (wstrb[3]) mem[addr[11:2]][31:24]  <= wdata[31:24];
            
        end
        else begin
            ready <= 1'b0;
        end
    end
endmodule