
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;



ENTITY  mux_4x1 is 
port(I0,I1,I2,I3:in std_logic;
SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
Y:out std_logic);
end ENTITY;



ARCHITECTURE ARC OF mux_4x1 IS 
SIGNAL S1,S0: STD_LOGIC;
BEGIN
S1<=SEL(1);
S0<=SEL(0);
Y<=(S1 AND S0 AND I3) OR (S1 AND (NOT S0) AND I2) 
OR ((NOT S1) AND S0 AND I1) OR ((NOT S1) AND (NOT S0) AND I0);
END ARC;






