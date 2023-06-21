LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY DcacheAddSelector IS 

PORT
(
    OPCODE:IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    ALU_COMPUTED_ADDRESS: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    SP: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    INTERRUPT: IN STD_LOGIC;
    ALuOutputorSP: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);

END ENTITY;


ARCHITECTURE ARC OF DcacheAddSelector IS 
BEGIN 
-- push call interrupt  in order, then pop ret rti
ALuOutputorSP<=SP WHEN  OPCODE="01010" 
OR OPCODE="01100" OR INTERRUPT='1' ELSE
STD_LOGIC_VECTOR(TO_UNSIGNED(TO_INTEGER(UNSIGNED(SP))+1,ALuOutputorSP'LENGTH))
WHEN OPCODE="01011" OR OPCODE="01110" OR OPCODE="01101" --POP or RET or RTI
ELSE
ALU_COMPUTED_ADDRESS;

END ARC;