Library ieee;
Use ieee.std_logic_1164.all;


entity partD is
GENERIC(N:INTEGER:=8); 
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
end partD;

architecture arc of partD is 
begin
F<='0'&A(N-1 downto 1)   when sel="1100" 
else  A(0)&A(N-1 downto 1) when sel="1101" 
else  Cin&A(N-1 downto 1)   when sel="1110"
else     A(N-1)&A(N-1 downto 1) ;-- when sel="1111";



Cout<= A(0)  when sel ="1100"
else  A(0) when sel="1101" 
else   A(0)  when sel="1110"
else   '0'  ;-- when sel="1111";
end arc;