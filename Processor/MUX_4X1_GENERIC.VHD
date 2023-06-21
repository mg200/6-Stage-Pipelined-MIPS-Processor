Library ieee;
Use ieee.std_logic_1164.all;


--you need to realize that generics of size N work only by integrating together N of the 1-bit component


ENTITY MUX_4X1_GENERIC IS
GENERIC(N: INTEGER:=8);
PORT(
I0,I1,I2,I3: IN STD_LOGIC_VECTOR( N-1 DOWNTO 0);
Sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
Y: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END MUX_4X1_GENERIC;





ARCHITECTURE ARC OF MUX_4X1_GENERIC IS
COMPONENT  mux_4x1 is 
port(I0,I1,I2,I3:in std_logic;
SEL: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
Y:out std_logic);
end COMPONENT;

BEGIN 
MUX_4X1_LOOP: FOR i in 0 to N-1 
GENERATE 

CURRENT_4X1_MUX: mux_4x1 port map(I0(i),I1(i),I2(i),I3(i),Sel,Y(i)); 
--Y(I<=(I0 AND (NOT S)) OR (I1 AND S);

END GENERATE;
END ARC;


