Library ieee;
Use ieee.std_logic_1164.all;

entity partA is
GENERIC(N:INTEGER:=8); --useless in this code since we define each of them to be 16 bits 
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
end partA;

architecture arc of partA is 

COMPONENT FullAdder_Generic IS
GENERIC(N:INTEGER:=16);
PORT(
A,B:IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
CIN: IN STD_LOGIC;
S:OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
COUT: OUT STD_LOGIC
);
END COMPONENT;


Signal tX,tY: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
Signal tCin: Std_logic; -- case insensitive
begin
FA4bits_1: FullAdder_Generic generic map(N)  port map(A=>tX,B=>tY,Cin=>tCin,S=>F,Cout=>COUT);
--FA4bits_1: FullAdder_Generic  port map(A,B,Cin,F,Cout);
INPUTS: process(sel,A,B,Cin)  --this line is very important to update the signals each time the input is changed
begin
if sel="0000" then
tX<=A;
tY<=(others=>'0'); --or alternatively    tY <= (others => '0');
tCin<=Cin;
elsif sel="0001" then
tX<=A;
tY<=B;
tCin<=Cin;
elsif sel="0010" then
tX<=A;
tY<=(not B); --2's complement of B +1
tCin<=Cin;
elsif sel="0011" and Cin='0' then
tX<=A;
tY<=(others=>'1'); --  -1 is equivalent to adding 1111...
-- the advantage of others is that it PROBABLY  can be used for generics 
tCin<=Cin;
ELSE --it is important to make the last one ELSE not ELSEIF for the synthesis in Quartus to avoid having latches
--elsif sel="0011" and Cin='1' then
tX<=(others=>'0');
tY<=B; -- the advantage of others is that it PROBABLY  can be used for generics 
tCin<='0';
end if;
--wait;
end process;
end arc;

