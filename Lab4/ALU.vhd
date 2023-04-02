Library ieee;
Use ieee.std_logic_1164.all;

ENTITY ALU IS
GENERIC(N:INTEGER:=8);
PORT(A,B: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SELECTION: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
CIN: IN STD_LOGIC;
F: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
COUT: OUT STD_LOGIC
);

END ALU;


ARCHITECTURE ARC OF ALU IS 


COMPONENT partA is
GENERIC(N:INTEGER:=16); --useless in this code since we define each of them to be 16 bits 
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
end COMPONENT;

COMPONENT partB is 
GENERIC(N:INTEGER:=16);
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
end COMPONENT;


COMPONENT partC is 
GENERIC(N:INTEGER:=16);
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
end COMPONENT;

COMPONENT partD is
GENERIC(N:INTEGER:=16);
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
end COMPONENT;

COMPONENT mux_4x1 IS
GENERIC(N:INTEGER:=16);
PORT(
I0,I1,I2,I3: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
S: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
Y:OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END COMPONENT;

SIGNAL tA,tB: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL tCIN: STD_LOGIC;
SIGNAL tS: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL tFA,tFB,tFC,tFD:STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL tCOUTA,tCOUTB,tCOUTC,tCOUTD: STD_LOGIC;

BEGIN
circuitA: partA GENERIC MAP(N) PORT MAP(sel=>SELECTION,Cin=>CIN,A=>A,B=>B,F=>tFA,COUT=>tCOUTA);
--sel is of part A, B,C,D and SELECTION is the variable defined for the ALU
circuitB: partB  GENERIC MAP(N) PORT MAP(sel=>SELECTION,CIN=>CIN,A=>A,B=>B,F=>tFB,COUT=>tCOUTB);
circuitC: partC  GENERIC MAP(N) PORT MAP(sel=>SELECTION,CIN=>CIN,A=>A,B=>B,F=>tFC,COUT=>tCOUTC);
circuitD: partD  GENERIC MAP(N) PORT MAP(sel=>SELECTION,CIN=>CIN,A=>A,B=>B,F=>tFD,COUT=>tCOUTD);
--FMUX: mux_4x1 GENERIC MAP(N) PORT MAP(tFA,tFB,tFC,tFD,SELECTION(3 DOWNTO 2),Y=>F);
--COUTMUX: mux_4x1 GENERIC MAP (2) PORT MAP(tCOUTA,tCOUTB,tCOUTC,tCOUTD,SELECTION(3 DOWNTO 2),Y=>COUT_ALU);

--WITH SELECTION_ALU(3 DOWNTO 2) SELECT
F<=
tFA WHEN SELECTION(3 DOWNTO 2)= "00" ELSE
tFB WHEN SELECTION(3 DOWNTO 2)="01" ELSE
tFC WHEN  SELECTION(3 DOWNTO 2)="10" ELSE
tFD ;--WHEN  SELECTION(3 DOWNTO 2)="11";

COUT<=
tCOUTA WHEN SELECTION(3 DOWNTO 2)= "00" ELSE
tCOUTB WHEN SELECTION(3 DOWNTO 2)="01" ELSE
tCOUTC WHEN  SELECTION(3 DOWNTO 2)="10" ELSE
tCOUTD ;--WHEN  SELECTION(3 DOWNTO 2)="11";


END ARC;