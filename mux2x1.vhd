library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2x1 is
	generic ( N: integer := 32);
    Port ( i0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           i1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
           s0 : in  STD_LOGIC;
           muxout : out  STD_LOGIC_VECTOR (N-1 downto 0));
end mux2x1;

architecture Behavioral of mux2x1 is

begin
	muxout <= 
		i0 when s0 = '0' ELSE
		i1 when s0 = '1' ELSE
		(OTHERS => 'Z');

end Behavioral;