library ieee;
use ieee.std_logic_1164.all;

entity tb_detector_paridad is
end tb_detector_paridad;

architecture tb of tb_detector_paridad is
    -- Declaration of the component to be tested
    component detector_paridad
        port (
            clk     : in  std_logic;
            reset_n : in  std_logic;
            en      : in  std_logic;
            din     : in  std_logic;
            paridad : out std_logic;
            eno     : out std_logic
        );
    end component;

    -- Declaration of signals to connect to the component's ports
    -- to be tested
    signal tb_clk     : std_logic := '1';
    signal tb_reset_n : std_logic := '0';
    signal tb_en, tb_din : std_logic;
    signal tb_eno, tb_paridad : std_logic;

    -- Declaration of clock period and delay values
    constant CLK_PERIOD : time := 100 ns;
    constant DELAY      : time := 1 ns;

begin -- rtl
    -- Generation of the clock signal (pulse train)
    tb_clk <= not tb_clk after CLK_PERIOD/2;

    -- Generation of the reset signal (initial reset, duration
    -- approximately 10 clock cycles)
    tb_reset_n <= '0', '1' after 10*CLK_PERIOD + DELAY;

    -- Generation of the data input validation signal
    tb_en <= '0',
             '1' after 15*CLK_PERIOD + DELAY,
             '0' after 23*CLK_PERIOD + DELAY;

    -- Generation of the input data signal
    tb_din <= '0',
              '1' after 17*CLK_PERIOD + DELAY,
              '0' after 19*CLK_PERIOD + DELAY,
              '1' after 20*CLK_PERIOD + DELAY,
              '0' after 22*CLK_PERIOD + DELAY,
              '1' after 23*CLK_PERIOD + DELAY,
              '0' after 24*CLK_PERIOD + DELAY;

    -- Instantiation of the component to be tested (Design Under Test)
    dut : detector_paridad
        port map (
            clk     => tb_clk,
            reset_n => tb_reset_n,
            en      => tb_en,
            din     => tb_din,
            paridad => tb_paridad,
            eno     => tb_eno
        );
end tb;
