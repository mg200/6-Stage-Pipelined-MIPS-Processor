library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
port (opcode: IN STD_LOGIC_VECTOR(4 downto 0);
funct: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
ZF: IN STD_LOGIC;
CF: IN STD_LOGIC;
INTERRUPT: IN STD_LOGIC;
ALUOperation: OUT STD_LOGIC_VECTOR(4 downto 0); 
RegDst,ALUSrc, 
Branch, MemRead, MemWrite, 
RegWrite, MemtoReg,
Read_another_segment,
InputPortCheck
,OutputPortCheck: OUT STD_LOGIC;
AluorSP: OUT STD_LOGIC;
ZeroSet: OUT STD_LOGIC;
CarrySet: OUT STD_LOGIC
-- funct_OP: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);

end entity ControlUnit;
architecture a_controlUnit of ControlUnit is 

begin
-- funct_OP<=funct;
-- for precaution, think about taking ZF and CF out into a different process
process (opcode,ZF,CF)
begin
ZeroSet<=ZF;
CarrySet<=CF;
-- AluorSP<='0';
	
	-- IF INTERRUPT='1' THEN
	-- MEMWRITE<='1';
	-- END;
	
	if (opcode = "10000") then  --ADD
		ALUOperation <= "10000";	-- A+B
	InputPortCheck<='0';
OutputPortCheck<='0';
AluorSP<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';

	elsif (opcode = "10001") then --SUB
		ALUOperation <= "10001";	-- A-B
        InputPortCheck<='0';
OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';

	elsif (opcode = "10011") then --AND
		ALUOperation <= "10011";	-- A AND B
		-- ALU_Cin <= '0';
		InputPortCheck<='0';
OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';

	elsif (opcode = "10100") then --OR
		ALUOperation <= "10100";	-- A OR B
		-- ALU_Cin <= '0';
		InputPortCheck<='0';
OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';

	elsif (opcode = "10101") then --NOT
		ALUOperation <= "10101";	-- A NOT B
		-- ALU_Cin <= '0';
		InputPortCheck<='0';
OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';

	elsif (opcode = "11110") then --SETC  --flags to be agree on
		ALUOperation <= "11110";
		-- ALU_Cin <= '0';
		InputPortCheck<='0';
OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';

	elsif (opcode = "00100") then --CLRC	--flags to be agree on
		ALUOperation <= "00100";
		-- ALU_Cin <= '0';
OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
InputPortCheck<='0';
	elsif (opcode = "01000") then --IN

	--IN R4-- INPUT.PORT=0F01, R4=0F01 
		ALUOperation <= "01000";	--out from alu "0000" like NOP
OutputPortCheck<='0';
		RegDst <= '1';--changed from 0
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';	--not sure
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';--this must be 0, was '1' initially 19/4/2023
		Read_another_segment <= '0';
        InputPortCheck<='1';
		

		--this was 00111
	elsif (opcode = "10111") then --OUT
		ALUOperation <= "10111";	--out from alu "0000" like NOP
		-- ALU_Cin <= '0';
OutputPortCheck<='1';
		RegDst <= '0';
		ALUSrc <= '1';
		Branch <= '0';
		MemRead <= '0';	--not sure
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
        InputPortCheck<='0';
	elsif (opcode = "01111") then --MOV
		ALUOperation <= "01111";	--out from alu "0000" like NOP
		-- ALU_Cin <= '0';
OutputPortCheck<='0';
		RegDst <= '0';
		-- ALUSrc <= '1';
		ALUSrc<='0';
		Branch <= '0';
		-- MemRead <= '0';
		-- MemRead<='1';	
		MemRead<='0';
		MemWrite <= '0';
		RegWrite <= '1';
		-- MemtoReg <= '1';
		MemtoReg<='0';
		InputPortCheck<='0';
		Read_another_segment <= '0';
InputPortCheck<='0';

	elsif (opcode = "10010") then --IADD
		ALUOperation <= "10010";	-- A+B
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '0';
		ALUSrc <= '1';
		Branch <= '0';
		MemRead <= '0';	
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '1';	-- here we will need another 16-bit
InputPortCheck<='0';
	elsif (opcode = "00001") then --INC
	-- INC R5,R1 
		ALUOperation <= "00001";	-- A+1
		OutputPortCheck<='0';
		RegDst <= '0';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';	-- 8albn heia '0'	
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';--THIS WAS 1
		Read_another_segment <= '0';
        InputPortCheck<='0';
	elsif (opcode = "00010") then --CMP 
		ALUOperation <= "00010";
		OutputPortCheck<='0';
		RegDst <= '0';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';	
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';--THIS WAS 1
		Read_another_segment <= '0';
        InputPortCheck<='0';
	elsif (opcode = "00011") then --DEC
		ALUOperation <= "00011";	-- A-1
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '0';
		-- ALUSrc <= '1';
		ALUSrc<='0'; --EDITED ON 20/5/2023
		Branch <= '0';
		MemRead <= '0';	-- 8albn heia '0'	
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';

	elsif (opcode = "00110") then --LDD
		ALUOperation <= "00110";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '0';
		-- ALUSrc <= '1';--dah kan 1 bs 7ykoun 0 34an el sign extend daymn ignored--NOTE BS HYA SH8ALA B 1 AW HYA 8LBN MSH FAR2A
		ALUSrc<='0';
		Branch <= '0';
		MemRead <= '1';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '1';
		Read_another_segment <= '0';
InputPortCheck<='0';
	elsif (opcode = "00111") then --LDM
		ALUOperation <= "00111";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '0';
		ALUSrc <= '1';--Dah el mkan ely f3ln lazm tkoun el ALUSrc b 1 34an 7read el immediate value
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';
InputPortCheck<='0';
	elsif (opcode = "00101") then --STD
		ALUOperation <= "00101";
		-- ALU_Cin <= '0';
		AluorSP<='0';
		OutputPortCheck<='0';
		RegDst <= '0';
		-- ALUSrc <= '1';-- deh lazm tb2a 0 8lbn 20/5
		ALUSrc<='0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '1';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
	InputPortCheck<='0';
	elsif (opcode = "01010") then --PUSH
		ALUOperation <= "01010";
		-- ALU_Cin <= '0';
		AluorSP<='1';
		OutputPortCheck<='0';
		-- RegDst <= '1';
		RegDst <= '0';--34an tb2a zy el store regdst bt3ha b zero
		ALUSrc <= '0'; --el original commented on 18/5/2023
		-- ALUSrc<='1';
		Branch <= '0';
		MemRead <= '0';
		-- MemWrite <= '0';
		MemWrite<='1';
		-- RegWrite <= '1';
		RegWrite<='0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
	InputPortCheck<='0';
	elsif (opcode = "01011") then --POP
		ALUOperation <= "01011";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '0';
		ALUSrc <= '1';
		Branch <= '0';
		-- MemRead <= '0';
		MemRead<='1';
		MemWrite <= '0';
		RegWrite <= '1';
		-- MemtoReg <= '0';
		MemtoReg <= '1';
		Read_another_segment <= '0';
	InputPortCheck<='0';
	elsif (opcode = "01100") then --CALL
		ALUOperation <= "01100";
		-- ALU_Cin <= '0';
		AluorSP<='0';
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0'; --19/5 dah b zero bs momkn yb2a b 1 34an yb2a zy el push
		Branch <= '0';
		MemRead <= '0';
		-- MemWrite <= '0';
		MemWrite<='1';
		-- RegWrite <= '1';
		REGWRITE<='0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
	InputPortCheck<='0';
	elsif (opcode = "01101") then --RET
		ALUOperation <= "01101";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '1';
		MemWrite <= '0';
		-- RegWrite <= '1';
		RegWrite<='0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
	InputPortCheck<='0';
	elsif (opcode = "01110") then --RTI
		ALUOperation <= "01110";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite<='0';--edited on 17/6/2023
		-- RegWrite <= '1';		
		MemtoReg <= '0';
		Read_another_segment <= '0';
	InputPortCheck<='0';
	elsif (opcode = "11000") AND funct="000" then --JZ
		ALUOperation <= "11000";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		-- RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';
		InputPortCheck<='0';
	elsif (opcode = "11001") AND funct="000" then --JC
		ALUOperation <= "11001";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		-- RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';
		InputPortCheck<='0';
	elsif (opcode = "11011") then --JMP
		ALUOperation <= "11011";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		-- RegWrite <= '1';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
	InputPortCheck<='0';
	--ADDED ON 21/6/2023
	elsif (opcode = "11000") AND funct="011" then --JNZ
		ALUOperation <= "11000";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		-- RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';
		InputPortCheck<='0';
	elsif (opcode = "11001") AND funct="011" then --JNC
		ALUOperation <= "11001";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		-- RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';
		InputPortCheck<='0';
	elsif (opcode = "11011") AND funct="001" then --JGE
		ALUOperation <= "11011";
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
		InputPortCheck<='0';
		elsif (opcode = "11011") AND funct="010" then --JLE
		ALUOperation <= "11011";
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
		InputPortCheck<='0';
			elsif (opcode = "11011") AND funct="011" then --JG
		ALUOperation <= "11011";
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
		InputPortCheck<='0';
			elsif (opcode = "11011") AND funct="100" then --JL
		ALUOperation <= "11011";
		OutputPortCheck<='0';
		RegDst <= '1';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
		InputPortCheck<='0';
	elsif (opcode = "11101") then --SHL
		ALUOperation <= "11101";	-- SHL R1,R2 --SRC AND DST 
		InputPortCheck<='0';
        OutputPortCheck<='0';
		RegDst <= '0';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';

	elsif (opcode = "11111") then --SHR
		ALUOperation <= "11111";	-- SHR R1,R2 --SRC AND DST 
		InputPortCheck<='0';
        OutputPortCheck<='0';
		RegDst <= '0';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '1';
		MemtoReg <= '0';
		Read_another_segment <= '0';


	else				--NOP
		ALUOperation <= "00000";
		-- ALU_Cin <= '0';
		OutputPortCheck<='0';
		RegDst <= '0';
		ALUSrc <= '0';
		Branch <= '0';
		MemRead <= '0';
		MemWrite <= '0';
		RegWrite <= '0';
		MemtoReg <= '0';
		Read_another_segment <= '0';
InputPortCheck<='0';
	end if;
end process;
end a_controlUnit;
