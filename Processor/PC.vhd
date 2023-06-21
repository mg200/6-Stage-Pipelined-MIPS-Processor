LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

ENTITY PC IS
	PORT(
		en ,clk ,reset  : IN  std_logic ;
		dataout : OUT std_logic_vector(15 DOWNTO 0));
END ENTITY  PC; 

ARCHITECTURE mypc OF  PC IS
	
begin 
PROCESS(clk,reset,en)
	variable counter : std_logic_vector(15 downto 0 ) := "0000000000000000"; 

	BEGIN
	IF(reset = '1') THEN
		counter := (others => '0');
	ELSIF rising_edge(clk) THEN
		if(en ='1') THEN 	
			
counter :=  std_logic_vector (to_unsigned( to_integer(unsigned(counter)) + 1 ,16))  ; 
		END IF;
	END IF;

	dataout <= counter ; 
END PROCESS;



END mypc; 