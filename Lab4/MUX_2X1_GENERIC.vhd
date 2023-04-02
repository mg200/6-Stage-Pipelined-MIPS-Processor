Library ieee;
Use ieee.std_logic_1164.all;


--you need to realize that generics of size N work only by integrating together N of the 1-bit component


ENTITY MUX_2X1_GENERIC IS
GENERIC(N: INTEGER:=8);
PORT(
I0,I1: IN STD_LOGIC_VECTOR( N-1 DOWNTO 0);
S: IN STD_LOGIC;
Y: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END MUX_2X1_GENERIC;





ARCHITECTURE ARC OF MUX_2X1_GENERIC IS
COMPONENT mux_2x1 is 
port(I0,I1,S:in std_logic;
Y:out std_logic);
end COMPONENT;

BEGIN 
MUX_2X1_LOOP: FOR i in 0 to N-1 
GENERATE 

CURRENT_2X1_MUX: mux_2x1 port map(I0(i),I1(i),S,Y(i)); 
--Y(I<=(I0 AND (NOT S)) OR (I1 AND S);

END GENERATE;
END ARC;


