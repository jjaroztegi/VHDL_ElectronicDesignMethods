LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY tb_meter IS
END tb_meter;

ARCHITECTURE tb OF tb_meter IS
    -- Component declaration
    COMPONENT meter
        PORT (
            clk     : IN STD_LOGIC;
            reset_n : IN STD_LOGIC;
            d_i     : IN STD_LOGIC;
            en_o    : OUT STD_LOGIC;
            d_o     : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals to drive the DUT
    SIGNAL clk     : STD_LOGIC := '0';
    SIGNAL reset_n : STD_LOGIC := '0';
    SIGNAL d_i     : STD_LOGIC := '1';
    SIGNAL en_o    : STD_LOGIC;
    SIGNAL d_o     : STD_LOGIC_VECTOR(4 DOWNTO 0);

    CONSTANT clk_period : TIME := 20 ns;

BEGIN
    -- Clock generation
    clk_process : PROCESS
    BEGIN
        WHILE TRUE LOOP
            clk <= '1';
            WAIT FOR clk_period / 2;
            clk <= '0';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    -- DUT instantiation
    uut : meter
        PORT MAP (
            clk     => clk,
            reset_n => reset_n,
            d_i     => d_i,
            en_o    => en_o,
            d_o     => d_o
        );

    -- Test process
    test_process : PROCESS
    BEGIN
        -- Apply reset and wait for it to stabilize
        reset_n <= '0';
        WAIT FOR clk_period * 2;
        reset_n <= '1';
        WAIT FOR clk_period * 2;

        -- Test case 1: 
        d_i <= '0';
        WAIT FOR clk_period * 2;
        d_i <= '1';
        WAIT FOR clk_period * 1;
        d_i <= '0';
        WAIT FOR clk_period * 5;
        d_i <= '1';
        WAIT FOR clk_period * 2;

        -- Test case 2: 
        d_i <= '0';
        WAIT FOR clk_period * 1;
        d_i <= '1';
        WAIT FOR clk_period * 1;
        d_i <= '0';
        WAIT FOR clk_period * 3;
        d_i <= '1';
        WAIT FOR clk_period * 2;
        
        -- Test case 3:
        d_i <= '0';
        WAIT FOR clk_period * 2;
        d_i <= '1';
        WAIT FOR clk_period * 1;
        d_i <= '0';
        WAIT FOR clk_period * 1;
        d_i <= '1';
        WAIT FOR clk_period * 2;
        
        -- Test case 4:
        d_i <= '0';
        WAIT FOR clk_period * 2;
        d_i <= '1';
        WAIT FOR clk_period * 1;
        d_i <= '0';
        WAIT FOR clk_period * 20;
        d_i <= '1';
        WAIT FOR clk_period * 2;
        

        d_i <= '0';
        WAIT FOR clk_period * 2;
        d_i <= '1';
        WAIT FOR clk_period * 1;

        -- End simulation
        WAIT;
    END PROCESS;
END tb;
