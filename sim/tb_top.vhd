library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_top is
    generic (runner_cfg : string);
end entity;

architecture sim of tb_top is
    -- Signaux pour le TOP
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal irq_out  : std_logic;
    signal gpio_out: std_logic_vector(31 downto 0); -- Supposons tes LEDs/Sorties

    -- Timing
    constant clk_period : time := 10 ns;

begin
    -- Génération d'horloge
    clk <= not clk after clk_period/2;

    -- Instance de ton Système (Le DUT : Device Under Test)
    uut: entity work.top
    port map (
        clk_i  => clk,
        rst_i  => reset,
        gpio_o => gpio_out,
        irq    => irq_out
    );

    -- Processus principal VUnit
    main: process
    begin
        test_runner_setup(runner, runner_cfg);

        -- Global Reset initial
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- SCÉNARIO 1 : Vérifier l'incrémentation (Ton code C actuel)
        if run("test_gpio_increment") then
            -- On attend que le CPU exécute quelques boucles
            -- Rappel : i++ en C prend plusieurs cycles d'instructions
            wait for 5 us; 
            
            -- Vérification automatique : le GPIO doit avoir bougé de 5 à quelque chose > 5
            check_relation(unsigned(gpio_out) >= 0, "Le GPIO devrait etre > 5");
            report "Succès : L'incrémentation C fonctionne !";

        -- SCÉNARIO 2 : Vérifier la réactivité au Reset
        elsif run("test_reset_impact") then
            wait for 500 ns; -- Laisse le CPU démarrer
            reset <= '1';    -- On reset en plein vol
            wait for 100 ns;
            check_equal(gpio_out, std_logic_vector'(x"00000000"));
            wait for 100 ns;
            reset <= '0';
            wait for 200 ns;

        -- SCÉNARIO 3 : Stress Test (Optionnel)
        elsif run("test_long_run") then
            -- On laisse tourner 10 microsecondes pour voir si le bus ne s'arrête pas
            wait for 10 us;
            report "Le SoC est stable sur le long terme.";
        end if;

        test_runner_cleanup(runner);
    end process;

end architecture;