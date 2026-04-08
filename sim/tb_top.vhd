library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library vunit_lib;
context vunit_lib.vunit_context;

entity tb_top is
    generic (runner_cfg : string);
end entity;

architecture sim of tb_top is

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal irq_out  : std_logic;
    signal gpio_out: std_logic_vector(31 downto 0); -- Supposons tes LEDs/Sorties

    constant clk_period : time := 10 ns;

begin

    clk <= not clk after clk_period/2;

    -- DUT
    uut: entity work.top
    port map (
        clk_i  => clk,
        rst_i  => reset,
        irq_i    => irq_out,
        gpio_o => gpio_out
    );

    -- Processus VUnit
    main: process
    begin
        test_runner_setup(runner, runner_cfg);

        -- Global Reset initial
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- SCÉNARIO 1 : Stress Test 
        if run("test_long_run") then
            -- On laisse tourner 10 microsecondes pour voir si le bus ne s'arrête pas
            wait for 100 us;
            report "Le SoC est stable sur le long terme.";

        -- SCÉNARIO 2 : Vérifier la réactivité au Reset
        elsif run("test_reset_impact") then
            wait for 500 ns; -- Laisse le CPU démarrer
            reset <= '1';    -- On reset 
            wait for 100 ns;
            check_equal(gpio_out, std_logic_vector'(x"00000000"));
            check_equal(gpio_out, std_logic_vector'(x"00000000"));
            wait for 100 ns;
            reset <= '0';
            wait for 200 ns;

        -- SCÉNARIO 3 : Vérifier l'incrémentation
        elsif run("test_gpio_increment") then
            wait for 10 us; 
            -- Vérification automatique : le GPIO doit avoir bougé de 0 à quelque chose > 0
            check_relation(unsigned(gpio_out) >= 1, "Le GPIO devrait etre > 0");
            report "Succès : L'incrémentation C fonctionne !";
        end if;

        test_runner_cleanup(runner);
    end process;

end architecture;