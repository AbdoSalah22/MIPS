library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft2 is
  port( 
        input  : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(31 downto 0) );
end ShiftLeft2;

architecture Behavioral of ShiftLeft2 is
begin

  output <= std_logic_vector(unsigned(input) sll 2);

end Behavioral;