library ieee;
use ieee.std_logic_1164.all;

entity tb_div is
end tb_div;

architecture tb of tb_div is
  signal tb_clk : std_logic:='0';
  signal tb_reset_n: std_logic;
  signal tb_en_i : std_logic;
  signal tb_div_o : std_logic;
  constant c_clk_period : time := 20 ns;

  component div
    port (
      clk : in std_logic;
      reset_n: in std_logic;
      en_i : in std_logic;
      div_o : out std_logic);
  end component;

begin --tb
  tb_clk <= not tb_clk after c_clk_period/2.0;

  process
  begin
    -- Reset the design and check that the output is always 0
    tb_reset_n <= '0';
    tb_en_i <= '0';
    wait for 200 ns;

    -- While in reset, en_i='1', and check that the output is always 0
    tb_en_i <= '1';
    wait for 3*200 ns;
    tb_en_i <= '0';
    wait for 100 ns;

    --Check that after the reset the output is always 0 if en_i = 0
    tb_reset_n <= '1';
    wait for 400 ns;

    -- Activate en_i during 3 periods
    tb_en_i <= '1';
    wait for 3*200 ns;

    -- Set en_i='0' when div_o = '1':
    wait for 40 ns;
    tb_en_i <= '0';
    wait for 2*200 ns;

    -- en_i ='1' , after en_i='0' when div_o = '1' (four periods)
    tb_en_i <= '1';
    wait for 3*200 ns;

    -- Set en_i='0' when div_o = '0' during div_o='0'
    wait for 160 ns;
    tb_en_i <= '0';
    wait for 2*200 ns;

    -- Reset the system when en_i=0
    tb_reset_n <= '0';
    wait for 2*200 ns;
    tb_reset_n <= '1';
    wait for 2*200 ns;

    -- Reset the system when en_i=1 and div_o=1
    tb_en_i <= '1';
    wait for 40 ns;
    tb_reset_n <= '0';
    wait for 2*200 ns;

    -- Reset the system when en_i=1 and div_o=0
    tb_reset_n <= '1';
    wait for 140 ns;
    tb_reset_n <= '0';
    wait for 2*200 ns;

    -- Enable system during 10 periods
    tb_reset_n <= '1';
    wait for 10*200 ns;

    -- Disable system during 10 periods
    tb_en_i <= '0';
    wait for 10*200 ns;

    -- End of simulation
    assert false report "End of simulation." severity error;
    wait;
  end process;

  dut: div
    port map(
      clk => tb_clk,
      reset_n => tb_reset_n,
      en_i => tb_en_i,
      div_o => tb_div_o);
end tb;
