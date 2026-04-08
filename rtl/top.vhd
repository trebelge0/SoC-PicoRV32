library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
    port (
        clk_i    : in  std_logic; 
        rst_i    : in  std_logic; 
        irq_i     : out std_logic;
        gpio_o   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture behav of top is

    -- PicoRV32 memory interface
    signal mem_valid : std_logic;
    signal mem_ready : std_logic;
    signal mem_addr  : std_logic_vector(31 downto 0);
    signal mem_wdata : std_logic_vector(31 downto 0);
    signal mem_rdata : std_logic_vector(31 downto 0);
    signal mem_wstrb : std_logic_vector(3 downto 0);

    signal ram_rdata  : std_logic_vector(31 downto 0);
    signal timer_rdata  : std_logic_vector(31 downto 0);
    signal gpio_rdata  : std_logic_vector(31 downto 0);

    signal gpio_ready : std_logic;
    signal ram_ready : std_logic;
    signal timer_ready : std_logic;

    signal gpio_sel : std_logic;
    signal ram_sel : std_logic;
    signal timer_sel : std_logic;

    signal resetn : std_logic;

    signal cpu_to_timer_eoi : std_logic_vector(31 downto 0);
    signal timer_to_cpu_irq : std_logic;

begin

    resetn <= not rst_i;

    -- CPU instance 
    cpu: entity work.picorv32
    port map (
        clk => clk_i,
        resetn => resetn,
        mem_valid => mem_valid,
        mem_ready => mem_ready,
        mem_addr  => mem_addr,
        mem_wdata => mem_wdata,
        mem_wstrb => mem_wstrb,
        mem_rdata => mem_rdata,
        pcpi_wr    => '0',
        pcpi_rd    => (others => '0'),
        pcpi_wait  => '0',
        pcpi_ready => '0',
        eoi        => cpu_to_timer_eoi,
        irq => (31 downto 1 => '0') & timer_to_cpu_irq
    );

    -- RAM : 0x00000000 - 0x0000FFFF
    ram_inst: entity work.ram
    port map (
        clk => clk_i,
        reset => rst_i,
        addr => mem_addr,
        wdata => mem_wdata,
        wstrb => mem_wstrb,
        ready => ram_ready,
        rdata => ram_rdata,
        sel => ram_sel
    );

    -- GPIO : 0x10000000
    gpio_inst: entity work.gpio
    port map (
        clk => clk_i,
        reset => rst_i,
        addr => mem_addr,
        wdata => mem_wdata,
        wstrb => mem_wstrb,
        rdata => gpio_rdata,
        ready => gpio_ready,
        sel => gpio_sel
    );

    -- Timer : 0x200000000 -> x20000004
    timer_inst: entity work.timer
        port map (
            clk => clk_i,
            reset => rst_i,
            addr => mem_addr,
            wdata => mem_wdata,
            wstrb => mem_wstrb,
            ready => timer_ready,
            rdata => timer_rdata,
            eoi => cpu_to_timer_eoi(0),
            irq => timer_to_cpu_irq,
            sel => timer_sel
        );

    -- IO
    irq_i <= timer_to_cpu_irq;
    gpio_o <= gpio_rdata;
    
    -- select logic
    ram_sel  <= '1' when (mem_addr(31 downto 28) = "0000" and mem_valid = '1') else '0';
    gpio_sel <= '1' when (mem_addr(31 downto 28) = "0001" and mem_valid = '1') else '0';
    timer_sel <= '1' when (mem_addr(31 downto 28) = "0010" and mem_valid = '1') else '0';

    -- mux mémoire
    mem_rdata <= ram_rdata when ram_sel = '1' else 
                 gpio_o when gpio_sel = '1' else 
                 timer_rdata when timer_sel = '1' else
                 (others => '0');

    -- ready logic
    mem_ready <= mem_valid and (ram_ready or gpio_ready or timer_ready);

end;