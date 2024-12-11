LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY tb_wavegen IS
END tb_wavegen;

ARCHITECTURE tb OF tb_wavegen IS
    COMPONENT wavegen
        PORT (
            clk     : IN  STD_LOGIC;
            reset_n : IN  STD_LOGIC;
            mode_i  : IN  STD_LOGIC;
            wave_o  : OUT STD_LOGIC
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk     : STD_LOGIC := '0';
    SIGNAL reset_n : STD_LOGIC := '0';
    SIGNAL mode_i  : STD_LOGIC := '0';
    SIGNAL wave_o  : STD_LOGIC;

    -- Clock period constants
    CONSTANT clk_period : TIME := 200 ns;  -- 5MHz clock

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut: wavegen
        PORT MAP (
            clk     => clk,
            reset_n => reset_n,
            mode_i  => mode_i,
            wave_o  => wave_o
        );

    -- Clock process
    clk_process: PROCESS
    BEGIN
        WHILE NOW < 160 us LOOP
            clk <= '0';
            WAIT FOR clk_period/2;
            clk <= '1';
            WAIT FOR clk_period/2;
        END LOOP;
        WAIT;
    END PROCESS;

    stim_proc: PROCESS
    BEGIN
        -- Initial reset pulse
        WAIT FOR 1 * us;
        reset_n <= '0';  -- Assert reset
        WAIT FOR 0.5 * us;
        reset_n <= '1';  -- De-assert reset
        WAIT FOR 10 * us;

        -- First mode_i pulse - starts 5us-5us pattern
        mode_i <= '1';
        WAIT FOR 0.2 * us;
        mode_i <= '0';
        WAIT FOR 33 * us;

        -- Two consecutive mode_i pulses - changes to 10us-5us pattern
        mode_i <= '1';
        WAIT FOR 0.2 * us;
        mode_i <= '0';
        WAIT FOR 4 * us;
        mode_i <= '1';
        WAIT FOR 0.2 * us;
        mode_i <= '0';
        WAIT FOR 40 * us;

        -- Single mode_i pulse - returns to idle
        mode_i <= '1';
        WAIT FOR 0.2 * us;
        mode_i <= '0';
        WAIT FOR 35 * us;

        -- Final mode_i pulse - starts new 5us-5us pattern
        mode_i <= '1';
        WAIT FOR 0.2 * us;
        mode_i <= '0';
        WAIT FOR 30 * us;

        -- End simulation
        WAIT;
    END PROCESS;
END tb;
