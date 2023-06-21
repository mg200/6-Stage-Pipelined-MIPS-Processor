LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity HDU is
Port(
    CLK: in std_logic;
ID_EX_MemRead:in std_logic; --SIGNAL MEMREAD FROM ID/EX buffer
ID_EX_ALUOP: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
Dst_ID_EX:in std_logic_vector(2 downto 0); --register Rt from ID/EX buffer
Src1_IF_ID:in std_logic_vector(2 downto 0); --register Rt from IF/ID buffer --BITS FROM 7->5 of instruction
Src2_IF_ID:in std_logic_vector(2 downto 0);   --register RS from IF/ID buffer --BITS FROM 10->8 of instruction
EX_MEM_MemRead: IN STD_LOGIC;
EX_MEM_ALU_OPERATION: IN STD_LOGIC_VECTOR( 4 DOWNTO 0);
Dst_EX_MEM: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
PC_DISABLE:out std_logic;
IF_ID_DISABLE:out std_logic;  -- if 1 make enables =0
MUXSELECTOR:out std_logic    -- if 1 input to EX,MEM,WB SIGNALS IN ID/EX BUFFER = 0
);
end entity;


architecture DETECTION of HDU is
SIGNAL COUNTER: INTEGER:=0;
SIGNAL ONE_STALL_COUNTER, TWO_STALL_COUNTER: INTEGER:=0;
SIGNAL PC_DISABLE_LOAD_USE,IF_ID_DISABLE_LOAD_USE,MUX_SELECTOR_LOAD_USE,
PC_DISABLE_LOAD_DOUBLE_USE, IF_ID_DISABLE_LOAD_DOUBLE_USE, MUX_SELECTOR_LOAD_DOUBLE_USE:STD_LOGIC;


CONSTANT SIG:INTEGER:=10;

begin
PROCESS(ID_EX_MemRead,EX_MEM_MemRead,Dst_ID_EX,Src1_IF_ID,Src2_IF_ID,Dst_EX_MEM,CLK)
VARIABLE SKIP_SECOND_CHECK:INTEGER:=0;
BEGIN 
IF falling_EDGE(CLK) THEN 
PC_DISABLE<='0';
IF_ID_DISABLE<='0';
MUXSELECTOR<='0';

IF ((Dst_ID_EX=Src1_IF_ID) OR (Dst_ID_EX=Src2_IF_ID)) AND ID_EX_MemRead='1' AND COUNTER=0 
AND ID_EX_ALUOP/="01101" AND ID_EX_ALUOP/="01110" 
THEN 
SKIP_SECOND_CHECK:=1;
COUNTER<=1;
PC_DISABLE<='1';
IF_ID_DISABLE<='1';
MUXSELECTOR<='1';
END IF;

IF COUNTER>0 THEN 
COUNTER<=COUNTER-1;
PC_DISABLE<='1';
IF_ID_DISABLE<='1';
MUXSELECTOR<='1';
END IF;

IF SKIP_SECOND_CHECK=0 AND COUNTER=0 THEN 
IF ((Dst_EX_MEM=Src1_IF_ID) OR (Dst_EX_MEM=Src2_IF_ID)) AND EX_MEM_MemRead='1' AND 
EX_MEM_ALU_OPERATION/="01101" AND EX_MEM_ALU_OPERATION/="01110"
THEN --AND COUNTER=0 THEN 
PC_DISABLE<='1';
IF_ID_DISABLE<='1';
MUXSELECTOR<='1';
END IF;
END IF;

END IF;
END PROCESS;

-- process(ID_EX_MemRead,Dst_ID_EX,Src1_IF_ID,Src2_IF_ID,clk)
--  variable counter_int: integer;
-- begin

-- --LOAD USE ON ITS OWN 
-- IF falling_EDGE(CLK) THEN 
-- -- if 1<SIG THEN
-- PC_DISABLE<='0';
-- IF_ID_DISABLE<='0';
-- MUXSELECTOR<='0';
-- IF (ID_EX_MemRead='1' and ((Dst_ID_EX=Src1_IF_ID) or (Dst_ID_EX=Src2_IF_ID)) and counter=0) THEN 
-- COUNTER<=1;--ORIGINAL IS DEFINITELY ONE, WE MAKE IT TWO TO STALL THREE CYCLES AT ANY LOAD USE/LOAD DOUBLE USE 
-- PC_DISABLE<='1';
-- IF_ID_DISABLE<='1';
-- MUXSELECTOR<='1';
-- END IF;
-- IF COUNTER>0 THEN 
-- COUNTER<=COUNTER-1;
-- PC_DISABLE<='1';
-- IF_ID_DISABLE<='1';
-- MUXSELECTOR<='1';
-- END IF;
-- END IF;
-- END PROCESS;

-- single Load Use solved by two stalls  
-- D E 
-- D _ M1 
-- D _ _ M2
-- X E _ _ W --normal WB to EX forwarding will work 

-- double load use solved by one stall 
-- D X M1    --X stands for some instruction that doesn't matter 
-- D _ X M2 
-- X E _ X W 

--LOAD DOUBLE USE ON ITS OWN
--process(EX_MEM_MemRead,Dst_EX_MEM,Src1_IF_ID,Src2_IF_ID,clk)
--begin
--if(falling_EDGE(CLK)) THEN
--if(EX_MEM_MemRead='1' and ((Dst_EX_MEM=Src1_IF_ID) or (Dst_EX_MEM=Src2_IF_ID))) then
--PC_DISABLE<='1';
--IF_ID_DISABLE<='1';
--MUXSELECTOR<='1';
--else
--PC_DISABLE<='0';
--IF_ID_DISABLE<='0';
--MUXSELECTOR<='0';
--end if;
--end if;
--end process;




-- process(EX_MEM_MemRead,Dst_EX_MEM,Src1_IF_ID,Src2_IF_ID,clk)
-- begin
-- if falling_EDGE(CLK)
-- if(EX_MEM_MemRead='1' and ((Dst_EX_MEM=Src1_IF_ID) or (Dst_EX_MEM=Src2_IF_ID))) then
-- IF (memreadIn='1' and ((Dst_ID_EX=Src1_IF_ID) or (Dst_ID_EX=Src2_IF_ID)) and counter=0) THEN 



end DETECTION;



-- IF COUNTER>0 THEN 
-- PC_DISABLE<='1';
-- IF_ID_DISABLE<='1';
-- MUXSELECTOR<='1';
-- COUNTER<=COUNTER-1;
-- END IF;
-- if(memreadIn='1' and ((Dst_ID_EX=Src1_IF_ID) or (Dst_ID_EX=Src2_IF_ID))) then
-- PC_DISABLE<='1';
-- IF_ID_DISABLE<='1';
-- MUXSELECTOR<='1';
-- COUNTER<=2;
-- else
-- PC_DISABLE<='0';
-- IF_ID_DISABLE<='0';
-- MUXSELECTOR<='0';
-- end if;
-- counter_int:=counter;
-- if(memreadIn='1' and ((Dst_ID_EX=Src1_IF_ID) or (Dst_ID_EX=Src2_IF_ID)) and counter_int=0) then
-- PC_DISABLE<='1';
-- IF_ID_DISABLE<='1';
-- MUXSELECTOR<='1';
-- -- COUNTER<=3;
-- COUNTER_int:=2;
-- elsif counter_int>0 then
-- counter_int:=counter_int-1;
-- PC_DISABLE<='1';
-- IF_ID_DISABLE<='1';
-- MUXSELECTOR<='1';
-- elsif counter_int=0 then 
-- PC_DISABLE<='0';
-- IF_ID_DISABLE<='0';
-- MUXSELECTOR<='0';
-- end if;
-- counter<=counter_int;
-- end process;





