library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity RegisterFile is	  
	 
	 Port (
	read_sel1 : in STD_LOGIC_VECTOR(4 downto 0);
	read_sel2 : in STD_LOGIC_VECTOR(4 downto 0);
	write_sel : in STD_LOGIC_VECTOR(4 downto 0);
	write_ena : in STD_LOGIC;
	CLK : in STD_LOGIC;
	write_data : in STD_LOGIC_VECTOR(31 downto 0);
	data1 : out STD_LOGIC_VECTOR(31 downto 0);
	data2 : out STD_LOGIC_VECTOR(31 downto 0);
	rst : in STD_LOGIC ); 
	  
end RegisterFile;

architecture Behavioral of RegisterFile is

	type   RegBank is array (0 to 31) of std_logic_vector(31 downto 0);
	signal reg : RegBank := (
	 --x"00000000",	-- $zero
	 --x"11111111",	-- $at
	 --x"22222222",	-- $v0
	 --x"33333333",	-- $v1...if you want to initialize registers
	others => (others => '0'));

begin

  process(CLK)
  begin
    if rst = '1' then -- reset
		reg(to_integer(unsigned(write_sel))) <= (others => '0');
		
    else if rising_edge(CLK) and write_ena = '1' then
      reg(to_integer(unsigned(write_sel))) <= write_data;
      end if;
    end if;
  end process;

  data1 <= reg(to_integer(unsigned(read_sel1)));  -- read in address 1
  data2 <= reg(to_integer(unsigned(read_sel2)));  -- read in address 2

end Behavioral;
