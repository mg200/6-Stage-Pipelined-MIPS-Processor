LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;



ENTITY InterruptHandler IS
PORT (
CLK,INTERRUPT: IN STD_LOGIC;
-- PC_DISABLE: OUT STD_LOGIC;
-- IF_ID_BUFFER_SELECTOR: OUT STD_LOGIC;
PC_DISABLE,IF_ID_BUFFER_SELECTOR,INTERRUPT_IN_ACTION: OUT STD_LOGIC:='0'
);

END ENTITY;



ARCHITECTURE ARC OF InterruptHandler IS 
SIGNAL InterruptCounter:INTEGER:=0;
SIGNAL TEMP:INTEGER:=0;
BEGIN
-- PROCESS
-- BEGIN



-- END PROCESS;
--new interrupt stall process 
PROCESS(INTERRUPT,CLK)
VARIABLE InterruptCounter_VAR:INTEGER:=0;
BEGIN
IF RISING_EDGE(CLK) THEN
IF TEMP=1 THEN 
INTERRUPT_IN_ACTION<='1';
TEMP<=0;
ELSE 
INTERRUPT_IN_ACTION<='0';
END IF;
IF InterruptCounter>0 THEN 

InterruptCounter_VAR:=InterruptCounter;
IF InterruptCounter_VAR=1 THEN 
TEMP<=1;
END IF;

PC_DISABLE<='1';
IF_ID_BUFFER_SELECTOR<='1';
InterruptCounter<=InterruptCounter-1;

END IF;

--the intial trigger 
IF INTERRUPT='1' THEN 
InterruptCounter_VAR:=2;
InterruptCounter<=2;
PC_DISABLE<='1';
IF_ID_BUFFER_SELECTOR<='1';
END IF;

IF INTERRUPT='0' AND InterruptCounter=0 THEN 
PC_DISABLE<='0';
IF_ID_BUFFER_SELECTOR<='0';
END IF;


--the actual interrupt signal that will be fed into the other circuits after the stall cycles
-- IF InterruptCounter=1 THEN 
-- INTERRUPT_IN_ACTION<='1';
-- ELSE 
-- INTERRUPT_IN_ACTION<='0';
-- END IF;

END IF;
END PROCESS;

END ARC;