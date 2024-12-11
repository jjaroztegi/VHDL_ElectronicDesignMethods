LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY wavegen IS
    PORT (
        clk : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        mode_i : IN STD_LOGIC;
        wave_o : OUT STD_LOGIC
    );
END wavegen;

ARCHITECTURE rtl OF wavegen IS
    COMPONENT counter
        GENERIC (
            wl : INTEGER;
            max : INTEGER
        );
        PORT (
            clk : IN STD_LOGIC;
            reset_n : IN STD_LOGIC;
            clear_i : IN STD_LOGIC;
            cnt_o : OUT STD_LOGIC_VECTOR((wl - 1) DOWNTO 0);
            en_o : OUT STD_LOGIC
        );
    END COMPONENT;

    -- FSM states
    TYPE state_t IS (IDLE, PUL5_HIGH, PUL5_LOW, PUL10_HIGH, PUL10_LOW);
    SIGNAL state, next_state : state_t;

    -- Control signals
    SIGNAL cnt_clear5 : STD_LOGIC;
    SIGNAL cnt_clear10 : STD_LOGIC;
    SIGNAL cnt_update5 : STD_LOGIC;
    SIGNAL cnt_update10 : STD_LOGIC;
    SIGNAL mode_change : STD_LOGIC;
    SIGNAL next_mode_change : STD_LOGIC;

BEGIN
    -- Main FSM sequential process with mode_change register
    fsm_seq : PROCESS (clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            state <= IDLE;
            mode_change <= '0';
        ELSIF rising_edge(clk) THEN
            state <= next_state;
            mode_change <= next_mode_change;
        END IF;
    END PROCESS;

    -- FSM combinational process
    fsm_comb : PROCESS (state, mode_i, cnt_update5, cnt_update10, mode_change)
    BEGIN
        wave_o <= '0';
        cnt_clear5 <= '0';
        cnt_clear10 <= '0';
        next_mode_change <= mode_change; -- Hold current value by default
        next_state <= state; -- Default to current state

        CASE state IS
            WHEN IDLE =>
                IF mode_i = '1' THEN
                    next_state <= PUL5_HIGH;
                    cnt_clear5 <= '1';
                    next_mode_change <= '0';
                ELSE
                    next_state <= IDLE;
                END IF;

            WHEN PUL5_HIGH =>
                wave_o <= '1';
                IF cnt_update5 = '1' THEN
                    next_state <= PUL5_LOW;
                    cnt_clear5 <= '1';
                    IF mode_i = '1' THEN
                        next_mode_change <= '1';
                    END IF;
                ELSIF mode_i = '1' THEN
                    next_mode_change <= '1';
                END IF;

            WHEN PUL5_LOW =>
                wave_o <= '0';
                IF cnt_update5 = '1' THEN
                    IF mode_change = '1' OR mode_i = '1' THEN
                        next_state <= PUL10_HIGH;
                        cnt_clear10 <= '1';
                        next_mode_change <= '0';
                    ELSE
                        next_state <= PUL5_HIGH;
                        cnt_clear5 <= '1';
                    END IF;
                END IF;

            WHEN PUL10_HIGH =>
                wave_o <= '1';
                IF cnt_update10 = '1' THEN
                    next_state <= PUL10_LOW;
                    cnt_clear5 <= '1';
                    IF mode_i = '1' THEN
                        next_mode_change <= '1';
                    END IF;
                ELSIF mode_i = '1' THEN
                    next_mode_change <= '1';
                END IF;

            WHEN PUL10_LOW =>
                wave_o <= '0';
                IF cnt_update5 = '1' THEN
                    IF mode_change = '1' OR mode_i = '1' THEN
                        next_state <= IDLE;
                        next_mode_change <= '0';
                    ELSE
                        next_state <= PUL10_HIGH;
                        cnt_clear10 <= '1';
                    END IF;
                END IF;

            WHEN OTHERS =>
                next_state <= IDLE;
                next_mode_change <= '0';
        END CASE;
    END PROCESS;

    -- Counter instance for timing (5us = 25 counts at 5MHz)
    cnt_5ns : counter
    GENERIC MAP(
        wl => 5, --5 bits to count up to 25
        max => 24
    )
    PORT MAP(
        clk => clk,
        reset_n => reset_n,
        clear_i => cnt_clear5,
        cnt_o => OPEN,
        en_o => cnt_update5
    );

    -- Counter instance for timing (10us = 50 counts at 5MHz)
    cnt_10ns : counter
    GENERIC MAP(
        wl => 6, -- 6 bits to count up to 50
        max => 49
    )
    PORT MAP(
        clk => clk,
        reset_n => reset_n,
        clear_i => cnt_clear10,
        cnt_o => OPEN,
        en_o => cnt_update10
    );
END rtl;