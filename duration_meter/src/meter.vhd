LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY meter IS
    PORT (
        clk : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        d_i : IN STD_LOGIC;
        en_o : OUT STD_LOGIC;
        d_o : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
    );
END meter;

ARCHITECTURE rtl OF meter IS
    COMPONENT cnt
        GENERIC (
            wl : INTEGER);
        PORT (
            clk : IN STD_LOGIC;
            reset_n : IN STD_LOGIC;
            en_i : IN STD_LOGIC;
            clear_i : IN STD_LOGIC;
            cnt_o : OUT STD_LOGIC_VECTOR((wl - 1) DOWNTO 0)
        );
    END COMPONENT;

    -- FSM states
    TYPE state_t IS (IDLE, LOW_2, HIGH_1, LOW_1, COUNT);
    SIGNAL state, next_state : state_t;

    -- Control signals
    SIGNAL d_o_d, d_o_q        : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL cnt_clear  : STD_LOGIC;
    SIGNAL cnt_en     : STD_LOGIC;
    SIGNAL en_d, en_q       : STD_LOGIC;
    SIGNAL cnt_value  : STD_LOGIC_VECTOR(4 DOWNTO 0);

BEGIN
    -- Main FSM sequential process
    fsm_seq : PROCESS (clk, reset_n)
    BEGIN
        IF reset_n = '0' THEN
            state <= IDLE;
            d_o_q <= (OTHERS => '0');
            en_q <= '0';
        ELSIF rising_edge(clk) THEN
            state <= next_state;
            d_o_q <= d_o_d;
            en_q <= en_d;
        END IF;
    END PROCESS;

    -- FSM combinational process
    fsm_comb : PROCESS (state, d_i, cnt_value)
    BEGIN
        cnt_clear <= '0';
        cnt_en <= '0';
        en_d <= '0';
        next_state <= state;
        d_o_d <= d_o_q;

        CASE state IS
            WHEN IDLE =>
                IF d_i = '0' THEN
                    next_state <= LOW_2;
                ELSE
                    next_state <= IDLE;
                END IF;

            WHEN LOW_2 =>
                IF d_i = '0' THEN
                    next_state <= HIGH_1;
                ELSE
                    next_state <= IDLE;
                END IF;

            WHEN HIGH_1 =>
                IF d_i = '1' THEN
                    next_state <= LOW_1;
                ELSE
                    next_state <= IDLE;
                END IF;

            WHEN LOW_1 =>
                IF d_i = '0' THEN
                    cnt_clear <= '1';
                    cnt_en <= '1';
                    next_state <= COUNT;
                ELSIF d_i = '1' THEN
                    en_d <= '1';
                    d_o_d <= (OTHERS => '0');
                    next_state <= IDLE;
                ELSE
                    next_state <= IDLE;
                END IF;

            WHEN COUNT =>
                cnt_en <= '1';
                IF d_i = '1' THEN
                    next_state <= IDLE;
                    en_d <= '1';
                    d_o_d <= unsigned(cnt_value) + 1;
                ELSE
                    next_state <= COUNT;
                END IF;

            WHEN OTHERS =>
                next_state <= IDLE;
        END CASE;
    END PROCESS;

    d_o <= d_o_q;
    en_o <= en_q;

    -- Counter instance
    cnt_inst : cnt
    GENERIC MAP(
        wl => 5
    )
    PORT MAP(
        clk => clk,
        reset_n => reset_n,
        en_i => cnt_en,
        clear_i => cnt_clear,
        cnt_o => cnt_value
    );
END rtl;
