library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ALU is
	 Port ( data1 : in  STD_LOGIC_VECTOR (31 downto 0);
           data2 : in  STD_LOGIC_VECTOR (31 downto 0);
           aluop : in  STD_LOGIC_VECTOR (3 downto 0);
           cin : in  STD_LOGIC;
           dataout : out  STD_LOGIC_VECTOR (31 downto 0);
           cflag : out  STD_LOGIC;
           zflag : out  STD_LOGIC;
           oflag : out  STD_LOGIC);
  	 end ALU;

architecture Behavioral of ALU is
SIGNAL TMP1 , TMP2 : STD_LOGIC_VECTOR(32 downto 0);
SIGNAL result : STD_LOGIC_VECTOR(31 downto 0);

begin
	
	process(data1, data2, aluop)
         begin
			
		case aluop is
			
			when "0000" =>		--AND
			result <= data1 and data2;
			
			when "0001" =>		--OR
			result <= data1 or data2;
			
			when "0010" =>		--add
			result <= std_logic_vector(unsigned(data1) + unsigned(data2));
			
			when "0110" =>		--sub
			result <= std_logic_vector(unsigned(data1) - unsigned(data2));
			
			when "0111" =>		--Set Less Than
				if (signed(data1) < signed(data2)) then
					result <= x"00000001";
				else
					result <= x"00000000";
				end if;
				
			when "1100" =>		--NOR
				result <= data1 nor data2;
			
			when others => null;	--Nop
				result <= x"00000000";
			
			end case;
		end process;
	-- concurrent code
	
	 dataout <= result ;
	zflag <= '1' when result = x"00000000" else '0'  ;
	-- you can also NOR all bits of the result
 
	cflag <= TMP1(32) when aluop ="0010" else
				TMP2(32) when aluop ="0110" else
				'Z' ;
       
	oflag <= (TMP1(32) XOR TMP1(31)) when aluop ="0010" else
				(TMP2(32) XOR TMP2(31)) when aluop ="0110" else
				'Z' ;
			     
end Behavioral ;