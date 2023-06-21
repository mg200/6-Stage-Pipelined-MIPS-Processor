LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY EX_MEM IS 
PORT(
    --WB SIGNALS, MemtoReg AND RegWrite
MemtoReg: IN STD_LOGIC;
RegWrite: IN STD_LOGIC;
--M SIGNALS MemRead, MemWrite
MemRead: IN STD_LOGIC;
MemWrite: IN STD_LOGIC;

-- addresses WB_ADDRESS (the value multiplexed from rt and rd(rdst) in the Execution stage)
WB_ADDRESS: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
---propagated data
ALU_OUPUT: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
ReadData2: IN STD_LOGIC_VECTOR(15 DOWNTO 0);--this will be the Write_Data for the next stage,it's now double propagated


--note, VVI: In phase-2, we would need to propagate the zero flag to check for branching instructions
--the shifted PC address for branch instructions
CLK,EN,RST: IN STD_LOGIC;
i_ALU_OPERATION: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
i_PC: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
-------------------OUTPUTS------------------note X_op means output
--WB SIGNALS, MemtoReg AND RegWrite
MemtoReg_op: OUT STD_LOGIC;
RegWrite_op: OUT STD_LOGIC;
--M SIGNALS MemRead, MemWrite
MemRead_op: OUT STD_LOGIC;
MemWrite_op: OUT STD_LOGIC;

-- addresses rt and rd(rdst)
WB_ADDRESS_op:OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

--propagated data 
ALU_OUPUT_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
ReadData2_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
ALU_OPERATION: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
O_PC: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END ENTITY;

ARCHITECTURE ARC OF EX_MEM IS

BEGIN
PROCESS(CLK)
BEGIN
IF RISING_EDGE(CLK) AND EN='1' THEN 
IF RST='1' THEN 
MemtoReg_op<='0';
RegWrite_op<='0';

MemRead_op<='0';
MemWrite_op<='0';

WB_ADDRESS_op<="000";

ALU_OUPUT_op<=(OTHERS=>'0');
ReadData2_op<=(OTHERS=>'0');
ALU_OPERATION<=(OTHERS=>'0');
O_PC<=(OTHERS=>'0');
ELSE 
MemtoReg_op<=MemtoReg;
RegWrite_op<=RegWrite;

MemRead_op<=MemRead;
MemWrite_op<=MemWrite;

WB_ADDRESS_op<=WB_ADDRESS;

ALU_OUPUT_op<=ALU_OUPUT; 
ReadData2_op<=ReadData2;
ALU_OPERATION<=i_ALU_OPERATION;
O_PC<=i_PC;
END IF;
END IF;
END PROCESS;
END ARC;
