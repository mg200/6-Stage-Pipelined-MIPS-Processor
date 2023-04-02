Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY n_AND is
GENERIC(N:INTEGER:=16);
PORT ( INPUT: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
OUTPUT: OUT STD_LOGIC);
END n_AND;


architecture arc of n_AND is

begin
process (input)
variable temp: STD_LOGIC;
BEGIN 
TEMP:='1';
G1: FOR i IN 0 TO N-1 LOOP
TEMP:=TEMP AND INPUT(i);
END LOOP G1;
OUTPUT<=temp;
end process;
end arc;
-- architecture ARC1 of n_AND is

-- signal tOUT: std_logic:='1';

-- begin
-- -- -- PROCESS
-- -- -- variable v: std_logic:='1';
-- -- -- BEGIN
-- --     m1: FOR I IN 0 TO N-1 generate 
-- --     tOUT<=tOut AND INPUT(I);

-- --     end generate;
-- -- -- tout<=v;
-- -- -- WAIT;
-- -- -- END PROCESS;
-- -- Output<=tout;
-- process 
-- variable i: integer:=0;
-- variable vOUT: std_logic:='1';
-- variable flag: integer:=0;
-- begin
-- while tOUT='1' or i=N-1 loop
-- vOuT:=vOUT and input(i);
-- i:=i+1;
-- if vOUT='0' then
-- flag:=1;
-- exit;
-- end if;
-- end loop;
-- wait until i=N-1 or flag=1;
-- tout<=vout;
-- end process;
-- output<=tout;
-- -- output<= INPUT(N-1 DOWNTO N/2) AND INPUT (((N/2)-1) DOWNTO 0);
-- end ARC1 ; 