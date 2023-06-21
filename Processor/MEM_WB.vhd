--THE REAL_DEAL FOR THE PROJECT

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY MEM_WB IS 
PORT(
    --WB SIGNALS, MemtoReg AND RegWrite
MemtoReg: IN STD_LOGIC;
RegWrite: IN STD_LOGIC;

-- addresses WB_ADDRESS (the value multiplexed from rt and rd(rdst) in the Execution stage)
WB_ADDRESS: IN STD_LOGIC_VECTOR(2 DOWNTO 0);

--propagated data 

ALU_OUPUT: IN STD_LOGIC_VECTOR(15 DOWNTO 0); --double propagated now
ReadData: IN STD_LOGIC_VECTOR(15 DOWNTO 0); --data read from memory for Load instruction
--NOTE: data read from the data cache
-- For phase-2 this might be 32-bits to allow for accessing two consecutive words

CLK,EN,RST: IN STD_LOGIC;

-------------------OUTPUTS--------------------------note X_op means output
MemtoReg_op: OUT STD_LOGIC;
RegWrite_op: OUT STD_LOGIC;

-- addresses rt and rd(rdst)
WB_ADDRESS_op:OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

ALU_OUPUT_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
ReadData_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
--data read from memory for Load instruction
-- For phase-2 this might be 32-bits to allow for accessing two consecutive words
);
END ENTITY;

ARCHITECTURE ARC OF MEM_WB IS

BEGIN
PROCESS(CLK)
BEGIN
IF RISING_EDGE(CLK) AND EN='1' THEN 
IF RST='1' THEN 
MemtoReg_op<='0';
RegWrite_op<='0';

WB_ADDRESS_op<="000";

ALU_OUPUT_op<=(OTHERS=>'0');
ReadData_op<=(OTHERS=>'0');
ELSE 
MemtoReg_op<=MemtoReg;
RegWrite_op<=RegWrite;

WB_ADDRESS_op<=WB_ADDRESS;

ALU_OUPUT_op<=ALU_OUPUT;
ReadData_op<=ReadData;

END IF;
END IF;
END PROCESS;
END ARC;

