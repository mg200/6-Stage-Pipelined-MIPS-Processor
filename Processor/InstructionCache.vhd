LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY InstructionCache IS
	PORT(
		datain  : IN  std_logic_vector(15 DOWNTO 0):=(OTHERS=>'0');--initialization done 6:17 19/4
		dataout : OUT std_logic_vector(15 DOWNTO 0);
		dataout_forImmediate: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		InstMem_M0: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		InstMem_M1: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
END ENTITY  InstructionCache; 

ARCHITECTURE syncrama OF  InstructionCache IS

	TYPE ram_type IS ARRAY(0 TO 1023) OF std_logic_vector(15 DOWNTO 0);
	SIGNAL ram : ram_type:=(others=>(others=>'0'));
	BEGIN

		-- dataout <= ram(to_integer(unsigned(datain)));--commented on 19/5 11:12 AM
		dataout <= ram(to_integer(unsigned(datain(9 DOWNTO 0))));
		dataout_forImmediate<=RAM(TO_INTEGER(UNSIGNED(datain))+1);
		InstMem_M0<=RAM(0);
		InstMem_M1<=RAM(1);
END syncrama;

