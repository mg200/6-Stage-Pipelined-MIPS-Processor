
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;


ENTITY dataMemory IS
PORT (
		CLK             : IN std_logic;
        i_writeEnable   : IN std_logic; -- from control unit
        i_readEnable    : IN std_logic; -- from control unit
        i_address       : IN std_logic_vector(15 DOWNTO 0); -- from mux2x1 (32 to read two consecutive word)
        i_writeData     : IN std_logic_vector(15 DOWNTO 0); -- Size of register from the mux2x1
        i_SP            : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		o_dataout       : OUT std_logic_vector(15 DOWNTO 0); -- Size of Register (output of the memory)
    DataMem_SP: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DataMem_SPPLUS1: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    FLAG_WRITE_ENABLE: IN STD_LOGIC;
    i_FLAGS: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    FLAGS: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY dataMemory;

ARCHITECTURE dataMemory_a OF dataMemory IS 
	TYPE dataMemory_type IS ARRAY(0 TO 1023) of std_logic_vector(15 DOWNTO 0); 
	SIGNAL dataMemory : dataMemory_type ;
BEGIN
    
    -- process( CLK,i_address,i_writeEnable,i_writeData )
    -- begin
    --     if falling_edge(CLK) and i_writeEnable ='1' then   --little endian
    --         dataMemory(to_integer(unsigned(( i_address(9 downto 0) )))) <= i_writeData(7 downto 0);
    --         dataMemory(to_integer(unsigned(( i_address(9 downto 0) )))+1) <= i_writeData(15 downto 8);
    --     elsif i_readEnable='1' then -- since we read async 
    --     o_dataout(7 downto 0) <= dataMemory(to_integer(unsigned((i_address (9 downto 0) ))));
    --     o_dataout(15 downto 8) <= dataMemory(to_integer(unsigned((i_address (9 downto 0) )))+1 );
    --     end if;
    -- end process ;
PROCESS(CLK)
VARIABLE SP_PLUS1: INTEGER:=0;
BEGIN 
IF RISING_EDGE(CLK) THEN 
IF i_writeEnable='1' THEN 
-- dataMemory(TO_INTEGER(UNSIGNED(i_address)))<=i_writeData;
dataMemory(TO_INTEGER(UNSIGNED(i_address(9 DOWNTO 0))))<=i_writeData;

-- IF FLAG_WRITE_ENABLE='1' THEN dataMemory(TO_INTEGER(UNSIGNED(i_SP(9 DOWNTO 0)))-1)<="0000000000000"&i_FLAGS;
--changed on 15/6/2023 from -2 to -1

-- END IF;
ELSIF i_readEnable='1' THEN 
-- o_dataout<=dataMemory(TO_INTEGER(UNSIGNED(i_address))); --original
o_dataout<=dataMemory(TO_INTEGER(UNSIGNED(i_address(9 DOWNTO 0))));

-- IF FLAG_WRITE_ENABLE='1' THEN FLAGS<=dataMemory(TO_INTEGER(UNSIGNED(i_SP(9 DOWNTO 0)))-1);
--changed on 15/6/2023 from -2 to -1
-- END IF;


END IF;
END IF;
-- InsMem_M0<=dataMemory(0);
-- InsMem_M1<=dataMemory(1);
-- DataMem_SP<=dataMemory(TO_INTEGER(UNSIGNED(i_SP)));
DataMem_SP<=dataMemory(TO_INTEGER(UNSIGNED(i_SP(9 DOWNTO 0))));
SP_PLUS1:=TO_INTEGER(UNSIGNED(i_SP(9 DOWNTO 0)))+1;
IF SP_PLUS1>1023 THEN
SP_PLUS1:=1023;
END IF;
DataMem_SPPLUS1<=dataMemory(SP_PLUS1);
END PROCESS;
--alternative added on 19/4/2023
-- PROCESS--(CLK)
-- BEGIN 
-- -- IF RISING_EDGE(CLK) THEN 
-- IF i_writeEnable='1' THEN 
-- dataMemory(TO_INTEGER(UNSIGNED(i_address)))<=i_writeData;
-- ELSIF i_readEnable='1' THEN 
-- o_dataout<=dataMemory(TO_INTEGER(UNSIGNED(i_address)));
-- END IF;
-- -- END IF;
-- wait for 1 ps;
-- END PROCESS;

END dataMemory_a;