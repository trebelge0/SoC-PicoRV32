library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sensor_peripheral is
    Port (
        clk      : in  std_logic;
        resetn   : in  std_logic;
        
        -- Interface Bus (Mapping PicoRV32)
        addr     : in  std_logic_vector(31 downto 0);
        wdata    : in  std_logic_vector(31 downto 0);
        wstrb    : in  std_logic_vector(3 downto 0); -- Byte enable
        sel      : in  std_logic;                    -- Chip Select
        
        -- Données vers le CPU
        rdata    : out std_logic_vector(31 downto 0);
        
        -- Sortie physique pour ton DE0-Nano
        leds     : out std_logic_vector(7 downto 0)
    );
end sensor_peripheral;

architecture Behavioral of sensor_peripheral is

    -- Registres internes (Accessibles par le CPU)
    -- Adresse 0x40000000 : Control Register (LEDs)
    signal reg_leds    : std_logic_vector(7 downto 0) := (others => '0');
    -- Adresse 0x40000004 : Sensor Data Register (Read Only)
    signal reg_sensor  : std_logic_vector(31 downto 0) := x"0000002A"; -- Valeur 42 par défaut

begin

    -- Processus d'ÉCRITURE (CPU -> FPGA)
    process(clk)
    begin
        if rising_edge(clk) then
            if resetn = '0' then
                reg_leds <= (others => '0');
            else
                -- Si le CPU écrit à l'adresse 0x00 (offset)
                if sel = '1' and addr(2) = '0' and wstrb /= "0000" then
                    reg_leds <= wdata(7 downto 0);
                end if;
            end if;
        end if;
    end process;

    -- Processus de LECTURE (FPGA -> CPU)
    process(addr, reg_leds, reg_sensor)
    begin
        if addr(2) = '0' then
            -- Lecture de l'état des LEDs
            rdata <= x"000000" & reg_leds;
        else
            -- Lecture de la valeur du capteur
            rdata <= reg_sensor;
        end if;
    end process;

    -- Branchement physique
    leds <= reg_leds;

end Behavioral;