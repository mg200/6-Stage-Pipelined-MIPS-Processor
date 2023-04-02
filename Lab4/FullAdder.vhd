Library ieee;
Use ieee.std_logic_1164.all;

--a Full Adder that sums two four bit numbers
entity FullAdder is 
port(
A,B: in std_logic;
Cin: in std_logic;
Sum: out std_logic;
Cout: out std_logic);
end FullAdder;


--dataflow architecture of full adder
architecture arc1 of FullAdder is 

begin
Sum<=A xor B xor Cin;
Cout<=(A and B) or ((A xor B) and Cin);
end arc1;