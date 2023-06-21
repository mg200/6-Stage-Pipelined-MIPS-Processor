LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;



ENTITY SP_HandlingCircuit IS
PORT(Instruction: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
INTERRUPT_SIG: IN STD_LOGIC;
SP_Old: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
-- SP_Rdst: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
-- SP_DataMem_SP: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
SP_op: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
);
END ENTITY;


ARCHITECTURE ARC OF SP_HandlingCircuit IS 


BEGIN
SP_op<=STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(SP_OLD))+1,SP_OLD'LENGTH))
WHEN INSTRUCTION="01101" OR INSTRUCTION="01110" OR INSTRUCTION="01011"
ELSE 
STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(SP_OLD))-1,SP_OLD'LENGTH))
WHEN INSTRUCTION="01100" OR INSTRUCTION="01010" 
ELSE STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(SP_OLD))-1,SP_OLD'LENGTH)) WHEN INTERRUPT_SIG='1' 
--changed on 15/6/2023 from -2 to -1
ELSE
SP_Old;

-- SP_op<=STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(SP_OLD))+1,SP_OLD'LENGTH))
-- WHEN INSTRUCTION="01101" OR INSTRUCTION="01110" OR INSTRUCTION="01011"
-- ELSE 
-- STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(SP_OLD))-1,SP_OLD'LENGTH))
-- WHEN INSTRUCTION="01100" OR INSTRUCTION="01010" ELSE
--  STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(SP_OLD))-1,SP_OLD'LENGTH)) INTERRUPT_SIG='1' THEN
-- ELSE
-- SP_Old;





END ARC;
