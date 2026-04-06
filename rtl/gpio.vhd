library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gpio is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        addr       : in  std_logic_vector(31 downto 0);
        wdata      : in  std_logic_vector(31 downto 0);
        wstrb      : in  std_logic_vector(3 downto 0);
        gpio_sel   : in  std_logic;
        gpio_ready : out std_logic;
        gpio_rdata : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behav of gpio is
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                gpio_rdata <= (others => '0');
                gpio_ready <= '0';
            elsif gpio_sel = '1' then
                if wstrb /= "0000" then
                    gpio_rdata <= wdata;
                end if;
                gpio_ready <= '1';
            else
                gpio_ready <= '0';
            end if;
        end if;
    end process;

end architecture;