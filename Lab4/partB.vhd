Library ieee;
Use ieee.std_logic_1164.all;

entity partB is 
GENERIC(N:INTEGER:=8); 
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
end partB;


architecture arc of partB is
begin
F<=A Xor B when sel="0100" else
   A and B when sel="0101" else
   A nor B when sel="0110" else
   not A ;--when sel="0111";

Cout<='0';

end arc;