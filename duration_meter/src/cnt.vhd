library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt is
    generic (
        wl : integer -- Width of the counter in bits
    );
    port (
        clk     : in std_logic;                                    -- Clock input
        reset_n : in std_logic;                                    -- Active low reset
        en_i    : in std_logic;                                    -- Counter enable
        clear_i : in std_logic;                                    -- Synchronous clear
        cnt_o   : out std_logic_vector((wl-1) downto 0)           -- Counter output
    );
end cnt;

architecture rtl of cnt is
    -- Internal counter signal
    signal count_reg : unsigned((wl-1) downto 0);
    
begin
    -- Counter process
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            -- Asynchronous reset
            count_reg <= (others => '0');
        elsif rising_edge(clk) then
            if clear_i = '1' then
                -- Synchronous clear
                count_reg <= (others => '0');
            elsif en_i = '1' then
                -- Increment counter when enabled
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process;
    
    -- Output assignment
    cnt_o <= std_logic_vector(count_reg);
    
end rtl;