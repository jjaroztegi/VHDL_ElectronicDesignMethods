LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY decs2p IS
	PORT (
		-- Inputs
		clk 	: IN STD_LOGIC; -- Clock signal.
		reset_n : IN STD_LOGIC; -- Asynchronous reset, active in low.
		d_i 	: IN STD_LOGIC; -- Input data.
		-- Outputs
		en_o 	: OUT STD_LOGIC; -- Validation signal.
		d_o 	: OUT STD_LOGIC_VECTOR(1 DOWNTO 0) -- Received word.
	);
END decs2p;

ARCHITECTURE rtl OF decs2p IS
	TYPE state_t IS (IDLE, SB0, SB1, SBP, OUTPUT);
	SIGNAL State : state_t;
	SIGNAL b0, b1, bp, en : STD_LOGIC;

BEGIN
	PROCESS (clk, reset_n)
	BEGIN
		IF reset_n = '0' THEN -- Handle reset
			State <= IDLE;
			en <= '0';
			b0 <= '0';
			b1 <= '0';
			bp <= '0';
			en_o <= '0';
			d_o <= "00";
		ELSIF rising_edge(clk) THEN
			CASE State IS
					--IDLE STATE
				WHEN IDLE =>
					en_o <= '0';
					IF d_i = '0' THEN -- Bitstart to LOW
						State <= SB0;
					ELSE
						State <= IDLE;
					END IF;
					--B0  STATE
				WHEN SB0 =>
					b0 <= d_i;
					State <= SB1;
					-- B1 STATE
				WHEN SB1 =>
					b1 <= d_i;
					State <= SBP;
					-- BP STATE
				WHEN SBP =>
					bp <= d_i;
					State <= OUTPUT;
				WHEN OUTPUT =>
					-- Compute transmision state
					IF (b0 XOR b1) = bp THEN
						en_o <= '1';
						d_o(0) <= b0;
						d_o(1) <= b1;
					ELSE
						en <= '0';
					END IF;
					State <= IDLE;
			END CASE;
		END IF;
	END PROCESS;
END ARCHITECTURE rtl;
