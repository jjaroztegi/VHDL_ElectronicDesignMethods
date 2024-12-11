LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY div IS
  PORT (
    clk : IN STD_LOGIC;
    reset_n : IN STD_LOGIC;
    en_i : IN STD_LOGIC;
    div_o : OUT STD_LOGIC
  );
END div;

ARCHITECTURE rtl OF div IS
  SIGNAL div_q : STD_LOGIC;
  SIGNAL cnt_update : STD_LOGIC;
  SIGNAL cnt_clear : STD_LOGIC;

  COMPONENT cnt
    GENERIC (
      wl : INTEGER;
      max : INTEGER
    );
    PORT (
      clk : IN STD_LOGIC;
      reset_n : IN STD_LOGIC;
      en_i : IN STD_LOGIC;
      clear_i : IN STD_LOGIC;
      cnt_o : OUT STD_LOGIC_VECTOR((wl - 1) DOWNTO 0);
      en_o : OUT STD_LOGIC
    );
  END COMPONENT;

BEGIN
  p_update : PROCESS (clk, en_i, reset_n, cnt_update, div_q)
  BEGIN
    IF reset_n = '0' THEN
      -- Reset output to 0
      div_q <= '0';
    ELSIF rising_edge(clk) THEN
      -- Check if output needs to be flipped
      IF cnt_update = '1' THEN
        div_q <= NOT div_q;
      ELSIF en_i = '0' THEN
        div_q <= '0';
        cnt_clear <= '1';
      ELSE
        div_q <= div_q; -- Stays the same
        cnt_clear <= '0'; -- Counter clear is deactivated in any other cycle different from update
      END IF;
    END IF;
  END PROCESS p_update;

  -- Connect internal signal to output port
  div_o <= div_q;

  cnt_100ns : cnt
  GENERIC MAP(
    wl => 3,
    max => 5 - 1
  )
  PORT MAP(
    clk => clk,
    reset_n => reset_n,
    en_i => en_i,
    clear_i => cnt_clear,
    cnt_o => OPEN,
    en_o => cnt_update
  );
END rtl;