library ieee;
use ieee.std_logic_1164.all;

entity detector_paridad is
    port (
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        din     : in  std_logic;
        paridad : out std_logic;
        eno     : out std_logic
    );
end detector_paridad;

architecture rtl of detector_paridad is
    type t_state is (idle, odd, even, calc); 
    -- FSM states
    signal state_d, state_q : t_state;
    -- Output flip-flops
    signal parity_d, parity_q, eno_d, eno_q : std_logic;
begin -- rtl
    -- purpose      : Next state of the FSM
    -- type         : Combinational
    -- inputs       : en, din, state_q
    -- outputs      : state_d
    p_fsm_d: process(en, din, state_q)
    begin -- process p_fsm_d
        case state_q is
            when idle =>
                if (en = '1' and din = '1') then
                    state_d <= odd;
                elsif (en = '1' and din = '0') then
                    state_d <= even;
                else
                    state_d <= idle;
                end if;
            when odd =>
                if (en = '1' and din = '1') then
                    state_d <= even;
                elsif (en = '1' and din = '0') then
                    state_d <= odd;
                else
                    state_d <= calc;
                end if;
            when even =>
                if (en = '1' and din = '1') then
                    state_d <= odd;
                elsif (en = '1' and din = '0') then
                    state_d <= even;
                else
                    state_d <= calc;
                end if;
            when calc =>
                state_d <= idle;
            when others =>
                state_d <= idle;
        end case;
    end process p_fsm_d;

    -- purpose      : Register the FSM
    -- type         : Sequential
    -- inputs       : clk, reset_n, state_d
    -- outputs      : state_q
    p_fsm_q : process (clk, reset_n)
    begin -- process p_fsm_q
        if reset_n = '0' then -- asynchronous reset, active low.
            state_q <= idle;
        elsif clk'event and clk = '1' then -- rising clock edge
            state_q <= state_d;
        end if;
    end process p_fsm_q;

    -- purpose      : Generate input to the output registers
    -- type         : Combinational
    -- inputs       : state_d, parity_q
    -- outputs      : parity_d, eno_d
    p_outs_d: process (state_d, parity_q)
    begin -- process p_outs_d
        case state_d is
            when idle =>
                parity_d <= parity_q;
                eno_d <= '0';
            when odd =>
                parity_d <= '0';
                eno_d <= '0';
            when even =>
                parity_d <= '1';
                eno_d <= '0';
            when calc =>
                parity_d <= parity_q;
                eno_d <= '1';
            when others =>
                parity_d <= '0';
                eno_d <= '0';
        end case;
    end process p_outs_d;

    -- purpose      : Register the output signals
    -- type         : Sequential
    -- inputs       : clk, reset_n, parity_d, eno_d
    -- outputs      : parity_q, eno_q
    p_outs_q : process (clk, reset_n)
    begin -- process p_outs_q
        if reset_n = '0' then -- asynchronous reset, active low.
            parity_q <= '0';
            eno_q <= '0';
        elsif clk'event and clk = '1' then -- rising clock edge
            parity_q <= parity_d;
            eno_q <= eno_d;
        end if;
    end process p_outs_q;

    -- Connect internal signals to the output ports
    paridad <= parity_q;
    eno <= eno_q;
end rtl;
