library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity timer is
    port (
        clk   : in std_logic;
        reset : in std_logic;

        addr  : in std_logic_vector(31 downto 0);
        wdata : in std_logic_vector(31 downto 0);
        wstrb : in std_logic_vector(3 downto 0);
        sel   : in std_logic;
        eoi   : in std_logic;

        ready : out std_logic;
        rdata : out std_logic_vector(31 downto 0);
        irq   : out std_logic
    );
end;

architecture behav of timer is
    signal mtime    : unsigned(31 downto 0) := (others => '0');
    signal mtimecmp : unsigned(31 downto 0) := (others => '1'); -- On initialise haut pour éviter IRQ directe
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                mtime    <= (others => '0');
                mtimecmp <= (others => '1');
                ready    <= '0';
                irq <= '0';
            else
                mtime <= mtime + 1;

                if mtime >= mtimecmp and eoi = '0' then
                    irq <= '1'; -- Clear l'IRQ si le CPU a envoyé un EOI
                    mtimecmp <= (others => '1'); -- Désactive l'IRQ jusqu'à la prochaine écriture
                else
                    irq <= '0';
                end if;
                
                if sel = '1' then
                    ready <= '1';
                    if wstrb /= "0000" then 
                        if addr(2) = '0' then 
                            mtime <= unsigned(wdata);
                        else
                            mtimecmp <= unsigned(wdata);
                        end if;
                    end if;
                else
                    ready <= '0';
                end if;
            end if;
        end if;
    end process;

    rdata <= std_logic_vector(mtime) when addr(2) = '0' else std_logic_vector(mtimecmp);

end;