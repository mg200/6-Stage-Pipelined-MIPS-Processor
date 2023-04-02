Library ieee;
Use ieee.std_logic_1164.all;

ENTITY tb_partA IS
GENERIC(N:INTEGER:=8);
END tb_partA;

ARCHITECTURE ARC OF tb_partA IS 
COMPONENT partA IS
--GENERIC(N:INTEGER:=8); --useless in this code since we define each of them to be 16 bits 
port(sel: in std_logic_vector(3 downto 0);
Cin: in std_logic;
A: in std_logic_vector(N-1 downto 0);
B: in std_logic_vector(N-1 downto 0);
F: out std_logic_vector(N-1 downto 0);
Cout: out std_logic);
END COMPONENT;

--SIGNALS COME HERE
SIGNAL tS: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL tCin: STD_LOGIC; 
SIGNAL tA, tB,tF: STD_LOGIC_VECTOR (N-1 DOWNTO 0);
SIGNAL tCout: STD_LOGIC;

--clock signal and clock_period constant
SIGNAL TCLK: STD_LOGIC:='0';
CONSTANT CLOCK_PERIOD: time:=100 ps;

BEGIN
--PORT MAP---

PORTMAPHERE: partA generic map(N) PORT MAP(tS,tCin,tA,tB,tF,tCout);

--The Clock Process: a process used for the testbench to not even have to enter this
tCLK<=NOT tCLK AFTER CLOCK_PERIOD/2;
--PORT MAP HERE--
--MAP1: MOD10_COUNTER PORT MAP(TCLK,TCOUNT);
PROCESS(Tclk)
BEGIN
tCLK<=NOT tCLK AFTER CLOCK_PERIOD/2;
END PROCESS;

PROCESS --(tclk)
BEGIN
------TESTBENCH------

--TESTCASE 1--

tA<=X"F0";
tB<=X"B0";
tCin<='0';
tS<="0000";
WAIT FOR 2 NS;
ASSERT(tF=X"F0" AND tCout='0') report "Testcase 1"
SEVERITY ERROR;


--TESTCASE 2--

tA<=X"F0";
tB<=X"B0";
tCin<='0';
tS<="0001";
WAIT FOR 2 NS;
ASSERT(tF=X"A0" AND tCout='1') report "Testcase 2"
SEVERITY ERROR;


--TESTCASE 3--

tA<=X"F0";
tB<=X"B0";
tCin<='0';
tS<="0010";
WAIT FOR 2 NS;
ASSERT(tF=X"3F" AND tCout='1') report "Testcase 3"
SEVERITY ERROR;


--TESTCASE 4--

tA<=X"F0";
tB<=X"B0";
tCin<='0';
tS<="0011";
WAIT FOR 2 NS;
ASSERT(tF=X"EF" AND tCout='1') report "Testcase 4"
SEVERITY ERROR;


--WAIT;
END PROCESS;
END ARC;
