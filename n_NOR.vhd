Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY n_NOR is
GENERIC(N:INTEGER:=24);
PORT ( INPUT: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
OUTPUT: OUT STD_LOGIC);
END n_NOR;


architecture arc of n_NOR is
begin
process (input)
variable temp: STD_LOGIC;
BEGIN 
TEMP:='0';
G1: FOR i IN 0 TO N-1 LOOP
TEMP:=TEMP or INPUT(i);
--NEWLY ADDED--
IF TEMP='1' THEN
EXIT;
END IF;
--END OF NEWLY ADDED
END LOOP G1;
OUTPUT<= not temp;
end process;
end arc;

