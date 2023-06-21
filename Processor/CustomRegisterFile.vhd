Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity CustomRegisterFile is
    PORT(
        RESET : IN STD_LOGIC;
        CLK: IN STD_LOGIC;
        WRITE_ENABLE: IN STD_LOGIC;--_VECTOR(N-1 DOWNTO 0);
        READ_ADD1, READ_ADD2: IN STD_LOGIC_VECTOR(2 DOWNTO 0):="000";
        WRITE_ADD: IN  STD_LOGIC_VECTOR(2 DOWNTO 0):="000";
        READ_PORT1, READ_PORT2: OUT STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS=>'0');
        WRITE_PORT: IN STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
end CustomRegisterFile;

architecture arch of CustomRegisterFile is    
   
TYPE register_type IS ARRAY(0 TO 7) of STD_LOGIC_VECTOR (15 DOWNTO 0);
SIGNAL reg : register_type:=(others=>(others=>'0')) ;

BEGIN
--     REGpROCESS: PROCESS (CLK)
--     begin
--  IF rising_edge(clk) THEN

--  if WRITE_ENABLE='1'then
--  reg(to_integer(unsigned(WRITE_ADD))) <= WRITE_PORT;
--     end if;
-- IF RESET='1' THEN
--  reg(0 TO 7)<=(OTHERS=>(others=>'0')); --contest whether this should be '0' or "0"
-- END IF;
--     end if;
-- Read_PORT1<=
-- reg(to_integer(unsigned(READ_ADD1)));
-- Read_PORT2<=
-- reg(to_integer(unsigned(READ_ADD2)));
--         END PROCESS;
--FOLLOWING IS ADDED ON 21/4, POST PHASE-1
PROCESS (CLK)
BEGIN 
IF RISING_EDGE(CLK) THEN 
-- if falling_EDGE(clk) then 
IF RESET='1' THEN 
REG(0 TO 7)<=(OTHERS=>(OTHERS=>'0'));
ELSIF WRITE_ENABLE='1' THEN 
REG(TO_INTEGER(UNSIGNED(WRITE_ADD)))<=WRITE_PORT;
END IF;
END IF;

IF FALLING_EDGE(CLK) THEN 
-- IF RISING_EDGE(CLK) THEN
READ_PORT1<=REG(TO_INTEGER(UNSIGNED(READ_ADD1)));
READ_PORT2<=REG(TO_INTEGER(UNSIGNED(READ_ADD2)));
END IF;
END PROCESS;
-- READ_PORT1<=REG(TO_INTEGER(UNSIGNED(READ_ADD1)));
-- READ_PORT2<=REG(TO_INTEGER(UNSIGNED(READ_ADD2)));
end arch ; -- arch




