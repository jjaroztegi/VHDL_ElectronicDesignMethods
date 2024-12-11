library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decs2p is
end tb_decs2p;

architecture tb of tb_decs2p is
    -- Component declaration for the device under test (DUT)
    component decs2p
        port (
            clk     : in std_logic;
            reset_n : in std_logic;
            d_i     : in std_logic;
            en_o    : out std_logic;
            d_o     : out std_logic_vector(1 downto 0)
        );
    end component;

    -- Internal signals for simulation
    signal clk     : std_logic := '1';
    signal reset_n : std_logic := '0';
    signal d_i     : std_logic := '1';  -- Initial state of the line: high (idle)
    signal en_o    : std_logic;
    signal d_o     : std_logic_vector(1 downto 0);

    constant CLK_PERIOD : time := 20 ns;

begin
    -- Clock generation (system clock)
    clk <= not clk after CLK_PERIOD / 2;

    -- Reset signal configuration: starts low, then goes high after 10 cycles
    reset_n <= '0', '1' after 10 * CLK_PERIOD;

    -- Main test process
    process
    begin
        wait for 15 * CLK_PERIOD;  -- Stabilization time after reset

        -- First test word: data "01" with even parity
        d_i <= '0';                          -- Start bit
        wait for CLK_PERIOD;
        d_i <= '0';                          -- B0: first data bit
        wait for CLK_PERIOD;
        d_i <= '1';                          -- B1: second data bit
        wait for CLK_PERIOD;
        d_i <= '0';                          -- BP: parity bit (even)
        wait for CLK_PERIOD;
        d_i <= '1';                          -- Return to idle state

        -- Observation period
        wait for 5 * CLK_PERIOD;

        -- Second test word: data "11" with odd parity
        d_i <= '0';                          -- Start bit
        wait for CLK_PERIOD;
        d_i <= '1';                          -- B0: first data bit
        wait for CLK_PERIOD;
        d_i <= '1';                          -- B1: second data bit
        wait for CLK_PERIOD;
        d_i <= '1';                          -- BP: parity bit (odd)
        wait for CLK_PERIOD;
        d_i <= '1';                          -- Return to idle state

        -- Observation period
        wait for 5 * CLK_PERIOD;

         -- Third test word: data "10" with odd parity
         d_i <= '0';                          -- Start bit
         wait for CLK_PERIOD;
         d_i <= '1';                          -- B0: first data bit
         wait for CLK_PERIOD;
         d_i <= '0';                          -- B1: second data bit
         wait for CLK_PERIOD;
         d_i <= '1';                          -- BP: parity bit (odd)
         wait for CLK_PERIOD;
         d_i <= '1';                          -- Return to idle state
        
        -- Observation period
        wait for 5 * CLK_PERIOD;

        -- Fourth test word: data "00" with even parity
        d_i <= '0';                          -- Start bit
        wait for CLK_PERIOD;
        d_i <= '0';                          -- B0: first data bit
        wait for CLK_PERIOD;
        d_i <= '0';                          -- B1: second data bit
        wait for CLK_PERIOD;
        d_i <= '0';                          -- BP: parity bit (even)
        wait for CLK_PERIOD;
        d_i <= '1';                          -- Return to idle state

        -- Observation period
        wait for 5 * CLK_PERIOD;

        -- End of simulation
        wait;
    end process;

    -- DUT instantiation (Device Under Test)
    dut: decs2p
        port map (
            clk => clk,
            reset_n => reset_n,
            d_i => d_i,
            en_o => en_o,
            d_o => d_o
        );

end tb;
