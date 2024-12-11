library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity cnt is
  generic (
    wl : integer; -- Bitwidth.
    max: integer); -- Maximum value of count
  port (
    clk : in std_logic; -- Clock signal.
    reset_n : in std_logic; -- Asynchronous reset, active in low.
    clear_i : in std_logic; -- Synchronous clear, active in high.
    en_i : in std_logic; -- Enable count, active in high.
    cnt_o : out std_logic_vector((wl - 1) downto 0); -- Count value.
    en_o : out std_logic); -- High when end of count.
end cnt;

architecture rtl of cnt is
  signal cnt_d, cnt_q : unsigned((wl - 1) downto 0);
  signal en_o_d, en_o_q : std_logic;
begin -- rtl

  -- Next value of the counter.
  -- Salida: cnt_d
  p_cnt_d: process (cnt_q, clear_i, en_i)
  begin -- process p_cnt_d
    if (clear_i = '1') then
      cnt_d <= (others => '0');
    elsif (en_i = '1') then
      if (cnt_q = max) then
        cnt_d <= (others => '0');
      else
        cnt_d <= cnt_q + 1;
      end if;
    else
      cnt_d <= cnt_q;
    end if;
  end process p_cnt_d;

  -- Counter register.
  p_cnt_q: process (clk, reset_n)
  begin -- process p_cnt_q
    if reset_n = '0' then -- asynchronous reset (active low)
      cnt_q <= (others => '0');
    elsif clk'event and clk = '1' then -- rising clock edge
      cnt_q <= cnt_d;
    end if;
  end process p_cnt_q;

  -- Next value of the enable.
  -- Output: en_q
  p_en_o_d: process (clear_i, cnt_d)
  begin -- process p_en_o_d
    if (clear_i = '1') then
      en_o_d <= '0';
    elsif (cnt_d = max) then
      en_o_d <= '1';
    else
      en_o_d <= '0';
    end if;
  end process p_en_o_d;

  -- FF for enable.
  p_en_o_q: process (clk, reset_n)
  begin -- process p_en_q
    if reset_n = '0' then -- asynchronous reset (active low)
      en_o_q <= '0';
    elsif clk'event and clk = '1' then -- rising clock edge
      en_o_q <= en_o_d;
    end if;
  end process p_en_o_q;

  -- Connections.
  en_o <= en_o_q;
  cnt_o <= std_logic_vector(cnt_q);
end rtl;