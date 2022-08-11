library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
use work.all;

entity MainModule is
    Port ( START : in  STD_LOGIC;
           mainCLK : in  STD_LOGIC;
           RegFileOut1 : out  STD_LOGIC_VECTOR (31 downto 0);
           RegFileOut2 : out  STD_LOGIC_VECTOR (31 downto 0);
           ALUOut : out  STD_LOGIC_VECTOR (31 downto 0);
           PCOut : out  STD_LOGIC_VECTOR (31 downto 0);
           DataMemOut : out  STD_LOGIC_VECTOR (31 downto 0);
			  mainRST : in  STD_LOGIC
			  );
end MainModule;

architecture Behavioral of MainModule is
	
	constant PC_inc : STD_LOGIC_VECTOR(31 downto 0) := x"00000004";
	SIGNAL PC_out: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL instruct: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL Add4_out: STD_LOGIC_VECTOR(31 downto 0);
	
	SIGNAL MuxS_out: STD_LOGIC_VECTOR(4 downto 0);
	SIGNAL SE_out: STD_LOGIC_VECTOR(31 downto 0);
	
	SIGNAL RegFile_out1: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL RegFile_out2: STD_LOGIC_VECTOR(31 downto 0);
	
	SIGNAL DataMemorytoMux2: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL Mux2toWriteData: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL ALUC_out: STD_LOGIC_VECTOR(3 downto 0);
	SIGNAL IncrementertoMux3: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL SLL2toMux4: STD_LOGIC_VECTOR(31 downto 0);
	
	SIGNAL Mux1_out: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL Mux2_out: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL Mux3_out: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL Mux4_out: STD_LOGIC_VECTOR(31 downto 0):= x"00000000";
	
	signal CURegDst :  STD_LOGIC;
	signal CUJump :  STD_LOGIC;
	signal CUBranch :  STD_LOGIC;
	signal CUMemRead :  STD_LOGIC;
	signal CUMemtoReg :  STD_LOGIC;
	signal CUALUOp :  STD_LOGIC_VECTOR(1 downto 0);
	signal CUMemWrite :  STD_LOGIC;
	signal CUALUSrc :  STD_LOGIC;
	signal CURegWrite :  STD_LOGIC;
	signal CUBranchNot :  STD_LOGIC;
	
	SIGNAL ALUResult: STD_LOGIC_VECTOR(31 downto 0);
	signal mainAluCF: std_logic;
	signal mainAluZF: std_logic;
	signal mainAluOF: std_logic;

	SIGNAL ANDbeq_out: STD_LOGIC;
	SIGNAL ANDbne_out: STD_LOGIC;
	SIGNAL OR_out: STD_LOGIC;
	
	SIGNAL sideAdder_out: STD_LOGIC_VECTOR(31 downto 0);
	
	SIGNAL SLL1_out: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL JumpFinal: STD_LOGIC_VECTOR(31 downto 0);
	SIGNAL load_it: STD_LOGIC;
begin
	
	PC: entity work.ProgramCounter(Behavioral)
	PORT MAP(
		CLK => mainCLK,
      rst => START,
      input => Mux4_out,
      output => PC_out
		);
	
	Add4: entity work.Adder(Behavioral)
	PORT MAP(
	operand_1 =>PC_out,
	operand_2 =>PC_inc,
	result => Add4_out
	);
	
	InsMem: entity work.InstructionMemory(Behavioral) 
	PORT MAP(
		ADDRESS =>PC_out,
		DATA =>instruct
	);
	
	DataMem: entity work.DataMemory(Behavioral)
	generic map(64, 32, 32) PORT MAP(
			LoadIt => START,
  			INPUT =>RegFile_out2,
			OUTPUT =>DataMemorytoMux2,
         MEM_READ =>CUMemRead,
			MEM_WRITE =>CUMemWrite,
			ADDRESS =>ALUResult,
			CLK => mainCLK
	);
	
	MuxS: entity work.mux2x1(Behavioral)
	generic map(5) PORT MAP(
	i0 => instruct(20 downto 16),
	i1 => instruct(15 downto 11),
	s0 => CURegDst,
	muxout => MuxS_out
	);
	
	
	SE: entity work.SignExtender(Behavioral)
	PORT MAP(
	se_in  => instruct(15 downto 0),
	se_out =>SE_out
	);
	
	RegFile: entity work.RegisterFile(Behavioral)
	PORT MAP(
	read_sel1 => instruct(25 downto 21),
	read_sel2 => instruct(20 downto 16),
	write_sel => MuxS_out,
	write_ena => CURegWrite,
	CLK => mainCLK,
	write_data => Mux2_out,
	data1 => RegFile_out1,
	data2 => RegFile_out2,
	rst => mainRST
	);
	
	Mux1: entity work.mux2x1(Behavioral)
	generic map(32) PORT MAP(
	i0 => RegFile_out2,
	i1 => SE_out,
	s0 => CUALUSrc,
	muxout => Mux1_out
	);
	
	ALUC: entity work.AluController(Behavioral)
	PORT MAP(
		funct => instruct(5 downto 0) ,
      ALUOP => CUALUOp,
      operation => ALUC_out
	);
	
	Mux2: entity work.mux2x1(Behavioral)
	generic map(32) PORT MAP(
	i0 => ALUResult,
	i1 => DataMemorytoMux2,
	s0 => CUMemtoReg,
	muxout => Mux2_out
	);
	
	MainALU: entity work.ALU(Behavioral)
	PORT MAP(
			data1 =>RegFile_out1,
         data2 =>Mux1_out,
         aluop =>ALUC_out,
         cin => '0',
         dataout =>ALUResult,
         cflag =>mainAluCF,
         zflag =>mainAluZF,
         oflag =>mainAluOF
	);
	
	MC: entity work.controller(Behavioral)
	PORT MAP(
		Opcode => instruct (31 downto 26),
		RegDst => CURegDst,
		Jump => CUJump,
		Branch => CUBranch,
		MemRead => CUMemRead,
		MemToReg => CUMemtoReg,
		ALUOP => CUALUOp,
		MemWrite => CUMemWrite,
		ALUSrc => CUALUSrc,
		RegWrite => CURegWrite,
		BranchNot => CUBranchNot
	);
	
	sideAdder: entity work.Adder(Behavioral)
	PORT MAP(
	operand_1 =>Add4_out,
	operand_2 =>SLL1_out,
	result => sideAdder_out
	);
	
	Mux3: entity work.mux2x1(Behavioral)
	generic map(32) PORT MAP(
	i0 => Add4_out,
	i1 => sideAdder_out,
	s0 => OR_out,
	muxout => Mux3_out
	);
	
	Mux4: entity work.mux2x1(Behavioral)
	generic map(32) PORT MAP(
	i0 => Mux3_out,
	i1 => JumpFinal,
	s0 => CUJump,
	muxout => Mux4_out
	);
	
	SLL1: entity work.ShiftLeft2(Behavioral)
	PORT MAP(
	input => SE_out,
	output =>SLL1_out
	);
	
	JumpFinal<= Add4_out (31 downto 28) &(instruct(25 downto 0)&"00");

	ANDbeq_out <= CUBranch and mainAluZF;
	ANDbne_out <= CUBranchNot and (not(mainAluZF));
	OR_out <= ANDbeq_out or ANDbne_out;
	
          RegFileOut1 <= RegFile_out1;
          RegFileOut2 <= RegFile_out2;
          ALUOut <= ALUResult;
          PCOut <= PC_out;
          DataMemOut <= DataMemorytoMux2; 
	
end Behavioral;