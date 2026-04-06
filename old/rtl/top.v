module top (
    input clk,
    input resetn,
    output [7:0] leds
);

    // --- Signaux du Bus PicoRV32 ---
    wire        mem_valid;
    wire        mem_instr;
    wire        mem_ready;
    wire [31:0] mem_addr;
    wire [31:0] mem_wdata;
    wire [3:0]  mem_wstrb;
    wire [31:0] mem_rdata;

    // --- Logique de décodage d'adresse ---
    // On active le périphérique si l'adresse commence par 0x4000_0000
    wire sel_periph = mem_valid && (mem_addr[31:24] == 8'h40);
    
    // Le PicoRV32 attend que mem_ready soit à 1 pour terminer son cycle.
    // On lui répond "OK" immédiatement quand on touche le périphérique.
    assign mem_ready = sel_periph; 

    // --- 1. Instanciation du CPU PicoRV32 (Verilog) ---
    picorv32 #(
        .ENABLE_COUNTERS(1),
        .ENABLE_REGS_16_31(1),
        .STACKADDR(32'h 0000_0800) // Petit stack pour la simulation
    ) cpu_inst (
        .clk         (clk),
        .resetn      (resetn),
        .mem_valid   (mem_valid),
        .mem_instr   (mem_instr),
        .mem_ready   (mem_ready),
        .mem_addr    (mem_addr),
        .mem_wdata   (mem_wdata),
        .mem_wstrb   (mem_wstrb),
        .mem_rdata   (mem_rdata)
    );

    // --- 2. Instanciation de ton Périphérique (VHDL) ---
    // Note : On utilise les noms exacts des ports de ton fichier VHDL
    sensor_peripheral periph_inst (
        .clk    (clk),
        .resetn (resetn),
        .addr   (mem_addr),
        .wdata  (mem_wdata),
        .wstrb  (mem_wstrb),
        .sel    (sel_periph),
        .rdata  (mem_rdata),
        .leds   (leds)
    );

endmodule