Library ieee;
Use ieee.std_logic_1164.all;

entity mux_2x1 is 
port(I0,I1,S:in std_logic;
Y:out std_logic);
end entity mux_2x1;

architecture myImp of mux_2x1 is
signal w1,w2: std_logic;
begin
Y<=(I0 AND (NOT S)) OR (I1 AND S);
end myImp;
