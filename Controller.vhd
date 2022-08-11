library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    Port ( 
		Opcode : in STD_LOGIC_VECTOR (5 downto 0 );   
		RegDst : out STD_LOGIC;
		Jump :out STD_LOGIC;
		Branch :out STD_LOGIC; 
		MemRead :out STD_LOGIC ;
		MemToReg: out STD_LOGIC; 
		ALUOP: out STD_LOGIC_VECTOR (1 downto 0) ; 
		MemWrite: out STD_LOGIC;
		ALUSrc: out STD_LOGIC;
		RegWrite: out STD_LOGIC;
		BranchNot: out STD_LOGIC
 );
end controller;

architecture Behavioral of controller is

begin

	Process(OpCode) 

		begin 
			RegWrite <= '0'; --Dessert for next command

			Case opcode is 

		when "000000" => -- and ,or , add , sub ,slt :0x00
			RegDst <= '1';
			Jump <= '0' ;
			Branch <= '0' ;
			MemRead <= '0' ;
			MemToReg <= '0' ;
			ALUOp <= "10" ;
			MemWrite <= '0' ;
			ALUSrc <='0' ; 
			RegWrite <= '1' after 10 ns ;
			BranchNot <= '0';

		when "100011" => -- load word (lw) : 0x23 
			RegDst <= '0';
			Jump <= '0';
			Branch <= '0';
			MemRead <= '1';
			MemToReg <= '1';
			ALUOp <= "00";
			MemWrite <= '0';
			ALUSrC <= '1';
			RegWrite <= '1' after 10 ns ;
			BranchNot <= '0';

		when "101011" =>     -- store word (sw) : 0x2B 
			RegDst <= '0';
			Jump <= '0';
			Branch <= '0';
			MemRead <= '0';
			MemToReg <= '0';
			ALUOp <= "00";
			MemWrite <= '1';
			ALUSrc <= '1';
			RegWrite <= '0';
			BranchNot <= '0';

		when "000100" =>   --branch equal(beq): 0x04 
			RegDst <= '0'; 
			Jump <= '0';
			Branch <= '1' after 2 ns ;
			MemRead <= '0';
			MemToReg <= '0';
			ALUOp <= "01";
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '0';
			BranchNot <= '0';
			
		when "000101" =>   --branch NOT equal(beq): 0x04 
			RegDst <= '0'; 
			Jump <= '0';
			Branch <= '0';
			MemRead <= '0';
			MemToReg <= '0';
			ALUOp <= "01";
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '0';
			BranchNot <= '1' after 2 ns ;

		when "000010" => --Jump(j) : 0x02
			RegDst <= '0'; --dont care
			 Jump <= '1';
			Branch <= '0';
			MemRead <= '0';
			MemToReg <= '0';
			ALUOP <= "00"; 
			MemWrite <= '0';
			ALUSrc<= '0'; 
			RegWrite <= '0';
			BranchNot <= '0';

		when others => null ; --implement other commands down here 
			RegDst <= '0';
			Jump <= '0'; 
			Branch<= '0';
			MemRead <= '0';
			MemToReg <= '0'; 
			ALUOp <= "00";
			MemWrite <= '0';
			ALUSrc <= '0';
			RegWrite <= '0';
			BranchNot <= '0';
		end case ;
		
end process ;
end Behavioral;