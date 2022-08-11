library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AluController is
    Port ( funct : in  STD_LOGIC_VECTOR (5 downto 0);
           ALUOP : in  STD_LOGIC_VECTOR (1 downto 0);
           operation : out  STD_LOGIC_VECTOR (3 downto 0));
end AluController;

architecture Behavioral of AluController is

begin

operation <=
			"0010" WHEN ALUOp = "00" ELSE 
			"0110" WHEN ALUOp = "01" ELSE		  
						  
			"0010" WHEN ALUOp = "10" and funct = "100000" ELSE
			"0110" WHEN ALUOp = "10" and funct = "100010" ELSE			  
			"0000" WHEN ALUOp = "10" and funct = "100100" ELSE
			"0001" WHEN ALUOp = "10" and funct = "100101" ELSE
			"1100" WHEN ALUOp = "10" and funct = "100111" ELSE			  
			"0111" WHEN ALUOp = "10" and funct = "101010"
						  
			  ELSE "ZZZZ";

end Behavioral;
