library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gpio is
    port (
        clk        : in  std_logic;
        reset        : in  std_logic;
        addr       : in  std_logic_vector(31 downto 0);
        wdata      : in  std_logic_vector(31 downto 0);
        wstrb      : in  std_logic_vector(3 downto 0);
        sel   : in  std_logic;

        ready : out std_logic;
        rdata : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behav of gpio is
    
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                rdata <= (others => '0');
                ready <= '0';
            elsif sel = '1' then
                if wstrb /= "0000" then
                    rdata <= wdata;
                end if;
                ready <= '1';
            else
                ready <= '0';
            end if;
        end if;
    end process;

end architecture;