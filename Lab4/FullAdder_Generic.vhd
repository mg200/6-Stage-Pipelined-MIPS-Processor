Library ieee;
Use ieee.std_logic_1164.all;




ENTITY FullAdder_Generic IS
GENERIC(N:INTEGER:=16);
PORT(
A,B:IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
CIN: IN STD_LOGIC;
S:OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
COUT: OUT STD_LOGIC
);
END ENTITY;

ARCHITECTURE ARC_BY_FULL_ADDER OF FullAdder_Generic IS
COMPONENT FullAdder is 
port(
A,B: in std_logic;
Cin: in std_logic;
Sum: out std_logic;
Cout: out std_logic);
end COMPONENT;
SIGNAL WIRE: STD_LOGIC_VECTOR(N DOWNTO 0); --THIS IS N DOWNTO 0 NOT N-1 DOWNTO 0
BEGIN
WIRE(0)<=CIN;
FORLOOP: FOR i IN 0 TO N-1
GENERATE 
FULLADDER_I: FullAdder PORT MAP(A(i),B(i),Wire(i),S(i),Wire(i+1));
END GENERATE;
COUT<=WIRE(N);
END ARC_BY_FULL_ADDER;
