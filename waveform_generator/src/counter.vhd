LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;

ENTITY counter IS
    GENERIC (
        wl : INTEGER;
        max : INTEGER);
    PORT (
        clk : IN STD_LOGIC;
        reset_n : IN STD_LOGIC;
        clear_i : IN STD_LOGIC;
        cnt_o : OUT STD_LOGIC_VECTOR((wl - 1) DOWNTO 0);
        en_o : OUT STD_LOGIC);
END counter;

ARCHITECTURE rtl OF counter IS
    SIGNAL cnt_d, cnt_q : unsigned((wl - 1) DOWNTO 0);
    SIGNAL en_o_q : STD_LOGIC;

BEGIN
    PROCESS (clk, reset_n) BEGIN
        IF reset_n = '0' THEN
            cnt_q <= (OTHERS => '0');
            en_o_q <= '0';
        ELSIF rising_edge(clk) THEN
            IF clear_i = '1' THEN
                cnt_q <= (OTHERS => '0');
                en_o_q <= '0';
            ELSE
                IF cnt_q = max THEN
                    cnt_q <= (OTHERS => '0');
                    en_o_q <= '0';
                ELSIF cnt_q = max - 1 THEN
                    cnt_q <= cnt_q + 1;
                    en_o_q <= '1';
                ELSE
                    cnt_q <= cnt_q + 1;
                    en_o_q <= '0';
                END IF;
            END IF;
        END IF;
    END PROCESS;

    cnt_o <= std_logic_vector(cnt_q);
    en_o <= en_o_q;
END rtl;
