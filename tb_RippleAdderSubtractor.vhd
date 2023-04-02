Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY tb_RippleAdderSubtractor IS
GENERIC(N:INTEGER:=16);
END ENTITY;

architecture arch of tb_RippleAdderSubtractor is
    COMPONENT nFA  IS
    PORT(
    A,B: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    MODE: IN STD_LOGIC:='0';--DEFAULTED TO ZERO i.e. Addition
    S: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
    Cout: OUT STD_LOGIC;
    VF: OUT STD_LOGIC;
    SF: OUT STD_LOGIC;
    CF: OUT STD_LOGIC;
    ZF: OUT STD_LOGIC
    );
    END COMPONENT;
-- SIGNALS COME HERE
SIGNAL wireA,wireB: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL wireMODE: STD_LOGIC;
SIGNAL tVF,tSF,TCF,TZF,TCOUT: STD_LOGIC;
SIGNAL tS:  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
begin
    --PORT MAP HERE--
    RIPPLE: nFA GENERIC MAP(N) PORT MAP(wireA,wireB,wireMODE,tS,TCOUT,tVF,TSF,TCF,TZF);
    PROCESS 
  
    begin
--TESTCASES
-- FIRST
wireA<=x"0f0b";
wireB<=x"0f0b";
wireMode<='1';
wait for 10 ns;
assert (tS=x"0000") report "testcase1"
severity error;


-- second
wireA<=x"0f0c";
wireB<=x"0f0c";
wireMode<='1';
wait for 10 ns;
assert (tS=x"0000") report "testcase2"
severity error;

-- third
wireA<=x"0001";
wireB<=x"0f0c";
wireMode<='0';
wait for 10 ns;
assert (tS=x"0f0d") report "testcase3"
severity error;
-- 4
wireA<=x"ffb0";
wireB<=x"ff0c";
wireMode<='0';
wait for 10 ns;
assert (TCF='1') report "testcase4"
severity error;

        WAIT;
        END PROCESS;

end arch ; -- arch
