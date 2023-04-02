Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;
use IEEE.math_real.all;

ENTITY Sign_Extension_Unit IS
GENERIC(N:INTEGER:=16;
M:INTEGER:=32);
PORT(INPUT: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
OUTPUT: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
);
END Sign_Extension_Unit;


ARCHITECTURE ARC OF Sign_Extension_Unit IS
SIGNAL OUTERMOST_BIT: STD_LOGIC;
BEGIN
PROCESS(INPUT)
VARIABLE OUTERMOST: STD_LOGIC;
BEGIN
OUTERMOST:=INPUT(N-1);
OUTERMOST_BIT<=OUTERMOST;
OUTPUT(M-1 DOWNTO M-N)<=(OTHERS=>OUTERMOST);
OUTPUT(N-1 DOWNTO 0)<=INPUT(N-1 DOWNTO 0);
-- IF INPUT(N-1)='1' THEN
-- OUTPUT(M-1 DOWNTO M-N)<=(OTHERS=>'1');
-- OUTPUT(N-1 DOWNTO 0)<=INPUT(N-1 DOWNTO 0);
-- ELSE 
-- OUTPUT(M-1 DOWNTO M-N)<=(OTHERS=>'0');
-- OUTPUT(N-1 DOWNTO 0)<=INPUT(N-1 DOWNTO 0);
-- END IF;
END PROCESS;
END ARC;
