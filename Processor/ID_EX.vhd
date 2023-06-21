LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ID_EX IS 
PORT(
    --WB SIGNALS, MemtoReg AND RegWrite
MemtoReg: IN STD_LOGIC;
RegWrite: IN STD_LOGIC;
--M SIGNALS MemRead, MemWrite
MemRead: IN STD_LOGIC;
MemWrite: IN STD_LOGIC;
-- EX SIGNALS ALUSrc, RegDst
ALUSrc: IN STD_LOGIC;
RegDst: IN STD_LOGIC;

--and an extra signal that is the selector of the multiplexer that will choose the value for the 
--first operand of the ALU, only when instruction IN is provoked to read what's on the input port
InputPortCheck: IN STD_LOGIC;--this signal will be raised by the control unit only for instruction IN
ALUOP: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
-- addresses rt and rd(rdst)
rs: IN STD_LOGIC_VECTOR(2 DOWNTO 0);--ADDED ON 20/5/2023
rt: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
rd: IN STd_LOGIC_VECTOR(2 DOWNTO 0);
--propagated data
ReadData1: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
ReadData2: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
SignExtend: IN STD_LOGIC_VECTOR(15 DOWNTO 0);--MLOUSH LAZMA
i_PC: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
Function_field: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
CLK,EN,RST: IN STD_LOGIC;

-------------------OUTPUTS-----------------------------------note X_op means output
MemtoReg_op: OUT STD_LOGIC;
RegWrite_op: OUT STD_LOGIC;
--M SIGNALS MemRead, MemWrite
MemRead_op: OUT STD_LOGIC;
MemWrite_op: OUT STD_LOGIC;
-- EX SIGNALS ALUSrc, RegDst
ALUSrc_op: OUT STD_LOGIC;
RegDst_op: OUT STD_LOGIC;
InputPortCheck_op: OUT STD_LOGIC;
ALUOP_op: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
-- addresses rt and rd(rdst)
rs_op: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);--ADDED ON 20/5/2023
rt_op: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
rd_op: OUT STd_LOGIC_VECTOR(2 DOWNTO 0);

--propagated data
ReadData1_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
ReadData2_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
SignExtend_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
o_PC: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
Function_field_OP: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE ARC OF ID_EX IS

BEGIN
PROCESS(CLK)
BEGIN
IF RISING_EDGE(CLK) AND EN='1' THEN 
-- IF(falling_EDGE(CLK)) and en='1' then
IF RST='1' THEN 
MemtoReg_op<='0';
RegWrite_op<='0';

MemRead_op<='0';
MemWrite_op<='0';

ALUSrc_op<='0';
RegDst_op<='0';
InputPortCheck_op<='0';

ALUOP_op<="00000";

rs_op<="000";

rt_op<="000";
rd_op<="000";

ReadData1_op<=(OTHERS=>'0');
ReadData2_op<=(OTHERS=>'0');
SignExtend_op<=(OTHERS=>'0');
o_PC<=(OTHERS=>'0');
Function_field_OP<=(OTHERS=>'0');
ELSE 
MemtoReg_op<=MemtoReg;
RegWrite_op<=RegWrite;

MemRead_op<=MemRead;
MemWrite_op<=MemWrite;

ALUSrc_op<=ALUSrc;
RegDst_op<=RegDst;
InputPortCheck_op<=InputPortCheck;
ALUOP_op<=ALUOP;


rs_op<=rs;
rt_op<=rt;
rd_op<=rd;

ReadData1_op<=ReadData1;
ReadData2_op<=ReadData2;
SignExtend_op<=SignExtend;
o_PC<=i_PC;
Function_field_OP<=Function_field;

END IF;
END IF;
END PROCESS;
END ARC;

