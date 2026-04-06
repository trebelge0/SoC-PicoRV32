`timescale 1ns / 1ps

module tb_top;
    reg clk;
    reg resetn;
    wire [7:0] leds;

    // 1. Génération de l'horloge (100 MHz -> période de 10ns)
    always #5 clk = ~clk;

    // 2. Instanciation de ton SoC (Le Top que nous avons écrit)
    top uut (
        .clk(clk),
        .resetn(resetn),
        .leds(leds)
    );

    // 3. Scénario de test
    initial begin
        // Initialisation
        clk = 0;
        resetn = 0; // Reset actif
        
        // On attend un peu et on relâche le reset
        #100;
        resetn = 1;
        
        // On laisse la simulation tourner assez longtemps pour voir le CPU bosser
        #10000;
        
        $display("Fin de la simulation. LEDs = %b", leds);
        $stop; // Arrête ModelSim
    end

    // 4. Monitoring (Optionnel : affiche les écritures dans la console)
    always @(posedge clk) begin
        if (uut.cpu_inst.mem_valid && uut.cpu_inst.mem_ready && uut.cpu_inst.mem_wstrb) begin
            $display("CPU Write: Addr=0x%h, Data=0x%h", uut.cpu_inst.mem_addr, uut.cpu_inst.mem_wdata);
        end
    end
endmodule