library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cnt is
end tb_cnt;

architecture tb of tb_cnt is
    -- Constants
    constant CLK_PERIOD : time := 10 ns;
    constant WIDTH     : integer := 6;  -- 4-bit counter for this test
    
    -- Signals for connecting to the DUT
    signal clk     : std_logic := '0';
    signal reset_n : std_logic := '1';
    signal en_i    : std_logic := '0';
    signal clear_i : std_logic := '0';
    signal cnt_o   : std_logic_vector(WIDTH-1 downto 0);
    
    -- Component declaration
    component cnt is
        generic (
            wl : integer
        );
        port (
            clk     : in std_logic;
            reset_n : in std_logic;
            en_i    : in std_logic;
            clear_i : in std_logic;
            cnt_o   : out std_logic_vector(wl-1 downto 0)
        );
    end component;
    
begin
    -- Clock generation process
    clk_gen: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Device Under Test (DUT) instantiation
    DUT: cnt 
    generic map (
        wl => WIDTH
    )
    port map (
        clk     => clk,
        reset_n => reset_n,
        en_i    => en_i,
        clear_i => clear_i,
        cnt_o   => cnt_o
    );
    
    -- Stimulus process
    stim_proc: process
    begin
        -- Initial state
        reset_n <= '1';
        en_i    <= '0';
        clear_i <= '0';
        wait for CLK_PERIOD * 2;
        
        -- Test reset
        reset_n <= '0';
        wait for CLK_PERIOD * 2;
        reset_n <= '1';
        wait for CLK_PERIOD * 2;
        
        -- Test counting
        en_i <= '1';
        wait for CLK_PERIOD * 20;  -- Count for several cycles
        
        -- Test disable
        en_i <= '0';
        wait for CLK_PERIOD * 5;   -- Should hold value
        
        -- Test clear while disabled
        clear_i <= '1';
        wait for CLK_PERIOD * 2;
        clear_i <= '0';
        wait for CLK_PERIOD * 2;
        
        -- Test counting again
        en_i <= '1';
        wait for CLK_PERIOD * 10;
        
        -- Test clear while enabled
        clear_i <= '1';
        wait for CLK_PERIOD * 2;
        clear_i <= '0';
        wait for CLK_PERIOD * 10;
        
        -- Test wraparound (let it count up to max value)
        wait for CLK_PERIOD * 20;
        
        -- End simulation
        wait for CLK_PERIOD * 5;
        assert false report "Simulation completed successfully" severity note;
        wait;
    end process;
    
    -- Monitor process (optional but helpful for debugging)
    monitor: process(clk)
    begin
        if rising_edge(clk) then
            report "Counter value: " & integer'image(to_integer(unsigned(cnt_o)));
        end if;
    end process;
    
end tb;