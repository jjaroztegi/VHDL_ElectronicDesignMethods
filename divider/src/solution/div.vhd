library ieee;
use ieee.std_logic_1164.all;

entity div is
  port (
    clk : in std_logic;
    reset_n : in std_logic;
    en_i : in std_logic;
    div_o : out std_logic);
end div;

architecture rtl of div is
  type t_state is (idle, duty_on, duty_off);
  signal state_d, state_q : t_state;
  signal en_cnt100ns, clear_cnt100ns, flag_100ns : std_logic;
  signal div_d, div_q : std_logic;

  component cnt
    generic (
      wl: integer;
      max: integer);
    port (
      clk : in std_logic;
      reset_n: in std_logic;
      en_i : in std_logic;
      clear_i: in std_logic;
      cnt_o : out std_logic_vector((wl-1)downto 0);
      en_o : out std_logic);
  end component;

begin --rtl
  -- purpose: generate next state
  -- type: combinational
  -- inputs: en_i, flag_100ns, state_q
  -- outputs: state_d
  p_fsm_d: process(en_i, flag_100ns, state_q)
  begin --p_fsm_d
    case state_q is
      when idle =>
        if (en_i = '1') then
          state_d <= duty_on;
        else
          state_d <= state_q;
        end if;
      when duty_on =>
        if (en_i = '0') then
          state_d <= idle;
        elsif (en_i= '1' and flag_100ns = '1') then
          state_d <= duty_off;
        else
          state_d <= state_q;
        end if;
      when duty_off =>
        if (en_i = '0') then
          state_d <= idle;
        elsif (en_i= '1' and flag_100ns = '1') then
          state_d <= duty_on;
        else
          state_d <= state_q;
        end if;
      when others =>
        state_d <= idle;
    end case;
  end process p_fsm_d;

  -- purpose: generate current state
  -- type:sequential
  -- inputs:state_d, clk, reset_n
  -- outputs:state_q
  p_fsm_q: process(clk, reset_n)
  begin --p_fsm_q
    if reset_n = '0' then
      state_q <= idle;
    elsif clk'event and clk = '1' then
      state_q <= state_d;
    end if;
  end process p_fsm_q;

  -- purpose: generate fsm outputs
  -- type: combinational 
  -- inputs: state_q
  -- outputs: en_cnt100ns, clear_cnt100ns, div_d
  p_fsm_out_d: process(state_q)
  begin --p_fsm_out_d
    case state_q is
      when idle =>
        en_cnt100ns <= '0';
        clear_cnt100ns <= '1';
        div_d <= '0';
      when duty_on =>
        en_cnt100ns <= '1';
        clear_cnt100ns <= '0';
        div_d <= '1';
      when duty_off =>
        en_cnt100ns <= '1';
        clear_cnt100ns <= '0';
        div_d <= '0';
      when others =>
        en_cnt100ns <= '0';
        clear_cnt100ns <= '0';
        div_d <= '0';
    end case;
  end process p_fsm_out_d;

  --purpose: registers output of div
  --type:sequential
  --inputs:div_d, clk, reset_n
  --outputs:div_q
  p_fsm_out_q: process(clk, reset_n)
  begin --p_fsm_out_q
    if reset_n = '0' then
      div_q <= '0';
    elsif clk'event and clk = '1' then
      div_q <= div_d;
    end if;
  end process p_fsm_out_q;

  -- Connect internal signal to output port.
  div_o <= div_q;

  cnt_100ns : cnt
    generic map(
      wl => 3,
      max => 5-1
    )
    port map(
      clk => clk,
      reset_n => reset_n,
      en_i => en_cnt100ns,
      clear_i => clear_cnt100ns,
      cnt_o => open,
      en_o => flag_100ns
    );
end rtl;