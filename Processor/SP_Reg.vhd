LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY SP_Reg IS 
PORT(CLK,EN,RST: IN STD_LOGIC;
SP_INPUT: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
SP_OUTPUT: OUT STD_LOGIC_VECTOR(9 DOWNTO 0):=(OTHERS=>'1')
);
END SP_Reg;


ARCHITECTURE ARC OF SP_Reg IS 

BEGIN
PROCESS(CLK)
BEGIN
IF EN='1' THEN
IF RISING_EDGE(CLK) THEN
IF RST='1' THEN
SP_OUTPUT<=(OTHERS=>'0');
ELSE
SP_OUTPUT<=SP_INPUT;
END IF;
END IF;
END IF;
END PROCESS;
END ARC;


