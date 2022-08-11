library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProgramCounter is
GENERIC (n : integer := 32);
port( -- input
      CLK        : in  std_logic;
      rst   	  : in  std_logic;
      input      : in  std_logic_vector(31 downto 0);

      -- output
      output : out std_logic_vector(31 downto 0) );
end ProgramCounter;

architecture Behavioral of ProgramCounter is

begin

  process(CLK)
  begin
    if rst = '0' then
      output <= (others => '0' );
    elsif rising_edge(CLK) then
      output <= input;
    end if;
  end process;

end Behavioral;