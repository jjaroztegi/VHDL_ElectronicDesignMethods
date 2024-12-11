library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity cnt is
	generic (wl: integer;
		max: integer);
	port(clk : in std_logic;
		reset_n : in std_logic;
		en_i : in std_logic;
		clear_i : in std_logic;
		cnt_o : out std_logic_vector((wl-1) downto 0);
		en_o : out std_logic);
end cnt;

architecture rtl of cnt is
	signal cnt_d , cnt_q : unsigned((wl-1) downto 0);
	signal en_o_d, en_o_q : std_logic;

	begin
	-- Counting process
	p_cnt_d : process(cnt_q, clear_i,en_i) begin
        if clear_i = '1' then -- If clear is pressed, do not count and reset
			cnt_d <= (others => '0');
        elsif en_i = '1' then
            if cnt_d = max then
				cnt_d <= (others => '0');
			else -- Continue counting
				cnt_d <= cnt_q + 1;
			end if;
		else -- Do nothing
			cnt_d <= cnt_q;
		end if;
	end process p_cnt_d;

	-- Cnt output buffer
	p_cnt_q : process(clk,reset_n,cnt_d) begin
		if reset_n = '0' then
			cnt_q <= (others => '0');
		elsif rising_edge(clk) then
			cnt_q <= cnt_d;
		end if;

	end process p_cnt_q;

	-- Enable output management
	p_en_o_d : process(clear_i,cnt_d) begin
		if clear_i = '1' then
			en_o_d <= '0';
		elsif cnt_d = max then
			en_o_d <= '1';
		else
			en_o_d <= '0';
		end if;
	end process p_en_o_d; 

	--  Assignment of the enable signal
	p_en_o_q : process(clk,reset_n, en_o_d) begin
		if reset_n = '0' then
			en_o_q <= '0';
		elsif rising_edge(clk) then
			en_o_q <= en_o_d;
		end if;

	end process p_en_o_q; 

-- Connect the signals
cnt_o <= std_logic_vector(cnt_q);
en_o <= en_o_q;

end architecture rtl;
