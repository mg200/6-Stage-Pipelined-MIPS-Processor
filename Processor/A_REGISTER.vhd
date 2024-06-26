Library ieee;
Use ieee.std_logic_1164.all;

ENTITY A_REGISTER IS
GENERIC(N: INTEGER:=16);
PORT( 
D: IN STd_LOGIC_VECTOR(N-1 DOWNTO 0);--input
CLK,EN,RST: IN STD_LOGIC;
Q: OUT  STd_LOGIC_VECTOR(N-1 DOWNTO 0));--output
END A_REGISTER;


-- ARCHITECTURE ARC_SYNCHRONOUS OF A_REGISTER IS
-- BEGIN
-- PROCESS(CLK)
-- BEGIN
-- IF RISING_EDGE (CLK) AND EN='1' THEN
-- IF RST='1' THEN
-- q<=(OTHERS=>'0');
-- else
-- Q<=D;
-- END IF;
-- END IF;
-- END PROCESS;
-- END ARC_SYNCHRONOUS;


ARCHITECTURE ARC_SYNCHRONOUS OF A_REGISTER IS
BEGIN
PROCESS(CLK)
BEGIN
IF RISING_EDGE (CLK) AND EN='1' THEN
Q<=D;
IF RST='1' THEN
q<=(OTHERS=>'0');
END IF;
END IF;
END PROCESS;
END ARC_SYNCHRONOUS;










