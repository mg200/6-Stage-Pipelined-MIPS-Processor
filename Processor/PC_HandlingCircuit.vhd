LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;



ENTITY PC_HandlingCircuit IS
PORT(
Instruction: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
funct: IN STD_LOGIC_VECTOR(2 DOWNTO 0);--Function_field
JustFetchedInstruction: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
EX_MEM_INST: IN STD_LOGIC_VECTOR(4 DOWNTO 0);--ADDED ON 17/6/2023 (NOT ACTUALLY 17/6/2023 IT'S 20/6/2023)
M2_Inst: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
ZeroTrue: IN STD_LOGIC;
CarryTrue: IN STD_LOGIC;
SignTrue: IN STD_LOGIC;
INTERRUPT_SIG: IN STD_LOGIC;
RST_SIG: IN STD_LOGIC;
PC_Old: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
PC_Rdst: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
PC_DataMem_SP: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
PC_InstMEM_M0: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
PC_InstMEM_M1: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
PC_FOR_CALL: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
PC_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END ENTITY;


ARCHITECTURE ARC OF PC_HandlingCircuit IS 
BEGIN

PC_op<=PC_Rdst WHEN INSTRUCTION="11011" AND funct="000" ELSE --JMP --ADDED OR INSTRUCTION="01100" 19/5 1:55AM
PC_Rdst WHEN INSTRUCTION="11011" AND funct="001" AND SignTrue='0' ELSE --JGE
PC_Rdst WHEN INSTRUCTION="11011" AND funct="010" AND (ZeroTrue='1' OR SignTrue/='0') ELSE --JLE
PC_Rdst WHEN INSTRUCTION="11011" AND funct="011" AND SignTrue='0' AND ZeroTrue='0' ELSE --JG
PC_Rdst WHEN INSTRUCTION="11011" AND funct="100" AND SignTrue/='0' ELSE --JL
PC_FOR_CALL WHEN INSTRUCTION="01100" ELSE --CALL
PC_Rdst WHEN INSTRUCTION="11000" AND funct="000" AND ZeroTrue='1' ELSE --JZ
PC_Rdst WHEN INSTRUCTION="11001" AND funct="000" AND CarryTrue='1' ELSE --JC
PC_Rdst WHEN INSTRUCTION="11000" AND funct="011" AND ZeroTrue='0' ELSE --JNZ
PC_Rdst WHEN INSTRUCTION="11001" AND funct="011" AND CarryTrue='0' ELSE --JNC



--ADDED ON 15/6/2023
-- "000000"&PC_DataMem_SP(9 DOWNTO 0) WHEN INSTRUCTION="01101" ELSE --RET
-- "000000"&PC_DataMem_SP(9 DOWNTO 0) WHEN  INSTRUCTION="01110" ELSE --RTI 

-- "000000"&PC_DataMem_SP(9 DOWNTO 0) WHEN EX_MEM_INST="01101" ELSE --RET
-- "000000"&PC_DataMem_SP(9 DOWNTO 0) WHEN  EX_MEM_INST="01110" ELSE --RTI 
"000000"&PC_DataMem_SP(9 DOWNTO 0) WHEN M2_Inst="01101" ELSE --RET
"000000"&PC_DataMem_SP(9 DOWNTO 0) WHEN  M2_Inst="01110" ELSE --RTI 



PC_InstMEM_M0 WHEN RST_SIG='1' ELSE --RESET SIGNAL
PC_InstMEM_M1 WHEN INTERRUPT_SIG='1' ELSE --INTERRUPT SIGNAL
STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(PC_OLD))+1,PC_OLD'LENGTH)) 
WHEN INSTRUCTION="00111" OR INSTRUCTION="10010" ELSE -- dah ely kan 3aml mo4klt el LDM wel IADD
-- WHEN JustFetchedInstruction="00111" OR JustFetchedInstruction="10010" ELSE 
STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(PC_OLD))+1,PC_OLD'LENGTH));


--NOTE ADDED ON 17/6/2023: to increment the PC by 2 at LDM and IADD you would need to take the fetched instruction
--i.e. the instruction that has just been fetched and if it's a LDM/IADD you increment the PC by 2 for next clock cycle
--note interrupt handler would need to be
END ARC;
