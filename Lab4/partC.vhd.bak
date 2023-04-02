Library ieee;
Use ieee.std_logic_1164.all;

entity partC is 
GENERIC(N:INTEGER:=8);
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
end partC;


architecture arc of partC is

begin


F<=A(N-2 downto 0)&'0' when sel="1000" else
   A(N-2 downto 0)&A(N-1) when sel="1001" else
   A(N-2 downto 0)&Cin when sel="1010" else
   x"00" ;--when sel="1011";

Cout<=A(N-1) when sel="1000" else
 A(N-1) when sel="1001" else
  A(N-1)  when sel="1010" else
   '0';-- when sel="1010";

end arc;

