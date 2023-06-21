LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;


ENTITY Processor IS 
PORT(
CLK: IN STD_LOGIC;
RESET: IN STD_LOGIC:='0';
INTERRUPT: IN STD_LOGIC:='0';
InputPort: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
OutputPort: INOUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END ENTITY;
------------------------------------------------------------------------------------------------------------

ARCHITECTURE ARC OF Processor IS
SIGNAL X: INTEGER;
SIGNAL DECODE_ALUOP: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL Function_field: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL OUTP_SIGNAL: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL RTI_RET_EXTRAFLUSH: STD_LOGIC;
------------------------------------------------------COMPONENTS---------------------------------------------------------

--\*--------------------------------------------Fetch Stage COMPONENTS---------------------------------------------------*/
------------------------------------------------PC and PC_HandlingCircuit------------------------------------
COMPONENT PC_Reg IS 
PORT(CLK,EN,RST: IN STD_LOGIC;
PC_INPUT: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
PC_OUTPUT: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END COMPONENT;

COMPONENT InstructionCache IS
	PORT(
		datain  : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		dataout_forImmediate: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    InstMem_M0: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		InstMem_M1: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT; 




-- COMPONENT PC IS
-- 	PORT(
-- 		en ,clk ,reset  : IN  STD_LOGIC ;
-- 		dataout : OUT STD_LOGIC_VECTOR(9 DOWNTO 0));
-- END COMPONENT; 
------------------------------------------------------------------------------------------------------------



--\*--------------------------------------------Decode Stage COMPONENTS---------------------------------------------------*/



COMPONENT A_REGISTER IS
GENERIC(N: INTEGER:=16);
PORT( 
D: IN STd_LOGIC_VECTOR(N-1 DOWNTO 0);--input
CLK,EN,RST: IN STD_LOGIC;
Q: OUT  STd_LOGIC_VECTOR(N-1 DOWNTO 0));--output
END COMPONENT;
COMPONENT WB_DEC_UNIT is
Port(
destination :in std_logic_vector(2 downto 0); --register Rd from WB buffer
WB_WRITE_SIG: IN STD_LOGIC;
rt_in:in std_logic_vector(2 downto 0); --register Rt from IF/ID buffer --BITS FROM 7->5 of instruction
rs_in:in std_logic_vector(2 downto 0);   --register RS from IF/ID buffer --BITS FROM 10->8 of instruction
rs_Selector: out std_logic; -- if rs and destination are equal each other then =1
rt_Selector: out std_logic  -- if rt and destination are equal each other then =1
);
end COMPONENT;



COMPONENT CustomRegisterFile is
       PORT(
        RESET : IN STD_LOGIC;
        CLK: IN STD_LOGIC;
        WRITE_ENABLE: IN STD_LOGIC;--_VECTOR(N-1 DOWNTO 0);
        READ_ADD1, READ_ADD2: IN STD_LOGIC_VECTOR(2 DOWNTO 0):="000";
        WRITE_ADD: IN  STD_LOGIC_VECTOR(2 DOWNTO 0):="000";
        READ_PORT1, READ_PORT2: OUT STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS=>'0');
        WRITE_PORT: IN STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
END COMPONENT;

COMPONENT Sign_Extension_Unit IS
GENERIC(N:INTEGER:=16;
M:INTEGER:=32);
PORT(INPUT: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
OUTPUT: OUT STD_LOGIC_VECTOR(M-1 DOWNTO 0)
);
END COMPONENT;

--\*-----------------------------------------------------------------------------------------------------------------*/
--\*--------------------------------------------Execution Stage COMPONENTS---------------------------------------------*/
--ALU COMPONENT

COMPONENT EX_MEM IS 
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
ReadData2: IN STD_LOGIC_VECTOR(15 DOWNTO 0);--this will be the Write_Data for  next stage,it's now double propagated
--note, VVI: In phase-2, we would need to propagate the zero flag to check for branching instructions
--the shifted PC address for branch instructions
CLK,EN,RST: IN STD_LOGIC;
i_ALU_OPERATION: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
i_PC: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
-------------------OUTPUTS note X_op means output
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
END COMPONENT;

--\*--------------------------------------------Memory Stage COMPONENTS---------------------------------------------*/
COMPONENT MEM_WB IS 
PORT(  --WB SIGNALS, MemtoReg AND RegWrite
MemtoReg: IN STD_LOGIC;
RegWrite: IN STD_LOGIC;
-- addresses WB_ADDRESS (the value multiplexed from rt and rd(rdst) in the Execution stage)
WB_ADDRESS: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
--propagated data 
ALU_OUPUT: IN STD_LOGIC_VECTOR(15 DOWNTO 0); --double propagated now
ReadData: IN STD_LOGIC_VECTOR(15 DOWNTO 0); --data read from memory for Load instruction
-- For phase-2 this might be 32-bits to allow for accessing two consecutive words
CLK,EN,RST: IN STD_LOGIC;
-------------------OUTPUTS--------------------------note X_op means output
MemtoReg_op: OUT STD_LOGIC;
RegWrite_op: OUT STD_LOGIC;
-- addresses rt and rd(rdst)
WB_ADDRESS_op:OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
ALU_OUPUT_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
ReadData_op: OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;
---------------------------------------------SP and SP_HandlingCircuit--------------------------------------------
COMPONENT SP_Reg IS 
PORT(CLK,EN,RST: IN STD_LOGIC;
SP_INPUT: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
SP_OUTPUT: OUT STD_LOGIC_VECTOR(9 DOWNTO 0):=(OTHERS=>'1')
);
END COMPONENT;

COMPONENT SP_HandlingCircuit IS
PORT(Instruction: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
INTERRUPT_SIG: IN STD_LOGIC;
SP_Old: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
-- SP_Rdst: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
-- SP_DataMem_SP: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
SP_op: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
);
END COMPONENT;

COMPONENT DcacheAddSelector IS 
PORT
(
    OPCODE:IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    ALU_COMPUTED_ADDRESS: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    SP: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    INTERRUPT: IN STD_LOGIC;
    ALuOutputorSP: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END COMPONENT;

-- COMPONENT DcacheDataSelector IS 
-- PORT
-- (
--     OPCODE:IN STD_LOGIC_VECTOR(4 DOWNTO 0);
--     IF_ID_MOST_SIG: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
--     INTERRUPT: IN STD_LOGIC;
--     CCR_REG_VALUES: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
--     PC: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--     NormalData: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
--     DataToCommit: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
--     -- ALuOutputorSP: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
-- );
-- END COMPONENT;
--\*-----------------------------------------------------------------------------------------------------------------*/


COMPONENT Fetch is
PORT(CLK1: IN STD_LOGIC;
EN1: IN STD_LOGIC;
RST1: IN STD_LOGIC;
pcNumber: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
PipeOut: Out STD_LOGIC_VECTOR(15 downto 0)
);
END COMPONENT;


COMPONENT mux_2x1 is 
port(I0,I1,S:in std_logic;
Y:out std_logic);
end COMPONENT mux_2x1;

COMPONENT MUX_2X1_GENERIC IS
GENERIC(N: INTEGER:=8);
PORT(
I0,I1: IN STD_LOGIC_VECTOR( N-1 DOWNTO 0);
S: IN STD_LOGIC;
Y: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END COMPONENT;
COMPONENT MUX_4X1_GENERIC IS
GENERIC(N: INTEGER:=8);
PORT(
I0,I1,I2,I3: IN STD_LOGIC_VECTOR( N-1 DOWNTO 0);
Sel: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
Y: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
);
END COMPONENT;
COMPONENT MemStage is
  PORT (
            CLK: IN STD_LOGIC;
--- outputs of the first buffer to the next buffer 
            i_aluData           : IN STD_LOGIC_VECTOR(15 downto 0) ; ----- THE ADDRESS TO THE MEMORY
            i_readData1         : IN STD_LOGIC_VECTOR(15 downto 0); -- The WRITEDATA TO THE MEMORY
            i_controlSignalMemWriteEn    : IN STD_LOGIC;--- Memory write enable
            i_controlSignalMemReadEn    : IN STD_LOGIC;--- Memory read enable
            i_writeAddressWriteBack : IN STD_LOGIC_VECTOR(2 downto 0); ---write address of writeback 
                  --ADDED BY ME--
                  --these will enter the whole memory stage, and come out, but will only pass through the internal buffer
            i_controlSignalMemtoRegEn: IN STD_LOGIC;
            i_controlSignalRegWriteEn: IN STD_LOGIC; 
---added by me 
memoryoutput: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
ALU_OUTPUT: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);--it'll be read from the internal buffer immediately
secondbuff_writebackaddress: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);--read from the internal buffer
--ADDED BY ME
            o_controlSignalMemtoRegEn: OUT STD_LOGIC;
            o_controlSignalRegWriteEn: OUT STD_LOGIC 
  );
END COMPONENT ;

COMPONENT dataMemory IS
PORT (
	CLK             : IN STD_LOGIC;
        i_writeEnable   : IN STD_LOGIC; -- from the buffer
        i_readEnable    : IN STD_LOGIC; -- from the buffer
        i_address       : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- from the buffer for now to be adjusted to be from MUX2x1
        i_writeData     : IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- Size of register from the buffer for now to be adjusted to be from MUX2x1
        i_SP            : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
  o_dataout       : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); -- Size of Register (output of the memory)
	  -- DataMem_M0: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- DataMem_M1: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DataMem_SP: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    DataMem_SPPLUS1: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        FLAG_WRITE_ENABLE: IN STD_LOGIC;
    i_FLAGS: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    FLAGS: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END COMPONENT;


-- COMPONENT SIGNALDELAYBUFFER IS
-- PORT(
-- CLK: IN STD_LOGIC;
-- EN: IN STD_LOGIC;
-- RST: IN STD_LOGIC;
-- MEMTOREG: IN STD_LOGIC;
-- REGWRITE: IN STD_LOGIC;
-- WRITEADDRESS: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
-- R_type_ALUOUTPUT: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
-- MEMTOREG_OP: OUT STD_LOGIC;
-- REGWRITE_OP: OUT STD_LOGIC;
-- WRITEADDRESS_OP: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
-- R_type_ALUOUTPUT_OP: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
-- );
-- END COMPONENT;

--------------------------FlushingCircuit-----------------
COMPONENT FlushingCircuit IS 
PORT
(
    OPCODE:IN STD_LOGIC_VECTOR(4 DOWNTO 0);
    ZF,CF: IN STD_LOGIC;
    -- ALU_COMPUTED_ADDRESS: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- SP: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    INTERRUPT: IN STD_LOGIC;
    -- ALuOutputorSP: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
if_idflush: OUT STD_LOGIC
);
END COMPONENT;




COMPONENT Forwarding IS 
PORT(
    	--EX/MEM WB SIGNAL and Address IN MEMORY STAGE 1
WB_EX_MEM: IN STD_LOGIC;
WB_Address_EX_MEM: IN STD_LOGIC_VECTOR (2 DOWNTO 0);

  	--MEM/MEM WB SIGNAL and Address IN MEMORY STAGE 2
WB_MEM_MEM: IN STD_LOGIC;
WB_Address_MEM_MEM: IN STD_LOGIC_VECTOR (2 DOWNTO 0);

	--MEM/WB WB SIGNAL and Address IN WRITE BACK STAGE
WB_MEM_WB: IN STD_LOGIC;
WB_Address_MEM_WB: IN STD_LOGIC_VECTOR (2 DOWNTO 0);

	-- Adresses of RS , RT IN DECODE STAGE
RS_Address: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
RT_Address: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
FIRST_ALU_INPUT_SELECTOR: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
SECOND_ALU_INPUT_SELECTOR: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
);
END COMPONENT;







------------------------------------------END OF COMPONENTS---------------------------------------------------------
                ---------------------------------------------------------------------------------
-------------------------------------------------SIGNALS--------------------------------------------------------
-------------------------------fetch stage SIGNALS------------------------------
CONSTANT NOP_CONST: STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS=>'0');
SIGNAL IntrHandlerIF_ID_Selector,IntrHandlerPC_Disable: STD_LOGIC;
SIGNAL INTERRUPT_IN_ACTION:STD_LOGIC;--:='0';--all interrupt signals fed into 
-- subcircuits should be modified to be INTERRUPT_IN_ACTION
SIGNAL PC:  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL PCCOUNT: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL PCReset:  STD_LOGIC:='0';
SIGNAL fetchEn:  STD_LOGIC:='1';
SIGNAL fetchRst:  STD_LOGIC:='0';
SIGNAL instruction,IF_ID_op:  STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS=>'0');
SIGNAL PC_EN: STD_LOGIC:='1';
SIGNAL SignExtend_op: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL PC_Old,PC_HandlingCircuit_OP,PC_Rdst,
PC_InstMEM_M0,PC_InstMEM_M1,PC_DataMem_SP,PC_FOR_CALL:STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL InstCache_op: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL InstCache_opPLUS1: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IF_ID_PC: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL IF_ID_INPUT: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL if_idflush,id_exflush: STD_LOGIC:='0';
SIGNAL IF_ID_FLUSHER_SIGNAL,ID_EX_FLUSHER_SIGNAL: STD_LOGIC:='0';
---------------------------CONTROL UNIT OUTPUTS------------
SIGNAL Control_RegDst,Control_ALUSrc,Control_Branch, Control_MemRead, Control_MemWrite, Control_RegWrite,Control_MemtoReg,
Control_ReadAnotherSegment,InputPortCheck, OutputPortCheck:  STD_LOGIC;
SIGNAL ALUOperation:  STD_LOGIC_VECTOR(4 DOWNTO 0):="00000";
-----------------------------------------register file signals----------------------------------------------
SIGNAL registerfileReset,RegFileWriteEn:  STD_LOGIC;
SIGNAL RegFileWriteAddress:  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL RegFileReadPort1,RegFileReadPort2,RegFileWritePort:  STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS=>'0');
SIGNAL ZeroSet,CarrySet: STD_LOGIC;
SIGNAL i_ID_EX_input1,i_ID_EX_input2: STD_LOGIC_VECTOR(15 DOWNTO 0):=(OTHERS=>'0');
SIGNAL RS_RegFile_or_WB, RT_RegFile_or_WB: STD_LOGIC_VECTOR(15 DOWNTO 0);

--ID_EX BUFFER OUTPUTS
--outputs
SIGNAL ID_EX_MemtoReg, ID_EX_RegWrite, ID_EX_MemRead, ID_EX_MemWrite, ID_EX_ALUSrc, ID_EX_RegDst,
ID_EX_InputPortCheck: STD_LOGIC;
SIGNAL if_idplus:STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL ID_EX_rt,ID_EX_rd:  STD_LOGIC_VECTOR(2 DOWNTO 0);--ADDRESSES THAT WOULD BECOME THE WRITEBACK ADDRESS
SIGNAL ID_EX_ALUOP:  STD_LOGIC_VECTOR(4 DOWNTO 0);--ALU OPERATION SIGNAL
SIGNAL ID_EX_ReadData1, ID_EX_ReadData2, ID_EX_SignExtend:  STD_LOGIC_VECTOR(15 DOWNTO 0);--DATA
SIGNAL ID_EX_PC:  STD_LOGIC_VECTOR(15 DOWNTO 0);--ALU OPERATION SIGNAL

SIGNAL O_PC_REG_HDU_DISABLE, O_IF_ID_HDU_DISABLE,ID_EX_CONTROL_SELECTOR: STD_LOGIC;

SIGNAL i_IDEX_MemRead,i_IDEX_MemWrite,i_IDEXREGWRITE: STD_LOGIC;
SIGNAL i_IDEX_ALU_OP: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL ID_EX_rs: STD_LOGIC_VECTOR(2 DOWNTO 0);


SIGNAL RS_SELECTOR,rt_selector: STD_LOGIC;
----------------------ALU INPUTS AND OUTPUTS SIGNALS----------
SIGNAL OPERAND1,OPERAND2,ALU_OUTPUT:  STD_LOGIC_VECTOR(15 DOWNTO 0);--BOTH ARE MULTIPLEXER OUTPUTS
SIGNAL ZF,NF,CF: STD_LOGIC;
SIGNAL CCR:  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL rt_rd_selectedEX: STD_LOGIC_VECTOR(2 DOWNTO 0);--will further propagate into EX_MEM stage
SIGNAL FU_ALU_OP1_Selector,FU_ALU_OP2_Selector: STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL OUT_SIGNAL: STD_LOGIC;
--------------------------------EX_MEM OUTPUT SIGNALS----------------------
SIGNAL EX_MEM_MemtoReg,EX_MEM_RegWrite,EX_MEM_MemRead,EX_MEM_MemWrite: STD_LOGIC;
SIGNAL EX_MEM_WRITEBACKADDRESS: STD_LOGIC_VECTOR(2 DOWNTO 0); --the writeback register address for R_type??
SIGNAL EX_MEM_ALUOUTPUT: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL EX_MEM_READDATA2: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL EX_MEM_ALU_OPERATION: STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL EX_MEM_PC: STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL SIGNALDELAYBUFFER_ALU_OPERATION: STD_LOGIC_VECTOR(4 DOWNTO 0);--ADDED ON 17/6/2023
SIGNAL CCR_REGISTER_OP,CCR_REGISTER_IN: STD_LOGIC_VECTOR(2 DOWNTO 0);


---------------------------Memory Stage outputs
--thse are the ones that should go into the MEM_WB buffer

SIGNAL DataCacheOutput,MemStage_ALUOutput_op: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL MemStage_WBAddress_op: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL MemStage_RegWrite_op, MemStage_MemtoReg_op: STD_LOGIC;
---MEM_WB OUTPUT SIGNALS 
SIGNAL MEM_WB_MemtoReg, MEM_WB_RegWrite: STD_LOGIC;
SIGNAL MEM_WB_MemoryRead_Data,MEM_WB_ALUResult: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL MEM_WB_WBAddres_3rdprop: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL DataMem_M0, DataMem_M1,DataMem_SP,DataMem_SPPLUS1: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL InstMem_M0,InstMem_M1: STD_LOGIC_VECTOR(15 DOWNTO 0);

-------signals that were in the MEMStage
SIGNAL MemWriteEnableOP : STD_LOGIC;--- the write enable of memory o/p to buffer
SIGNAL MemReadEnableOP : STD_LOGIC;-- the read enable of memory o/p to buffer
SIGNAL ALUaddressOP: STD_LOGIC_VECTOR(15 downto 0);--- the address to read or write from the alu  o/p to buffer
SIGNAL readdata1OP: STD_LOGIC_VECTOR(15 downto 0); --- the data to be written o/p to buffer
SIGNAL writeAddressWriteBackOP:STD_LOGIC_VECTOR(2 downto 0); -- the address of the write back o/p to buffer
SIGNAL OutputMemoryData : STD_LOGIC_VECTOR(15 DOWNTO 0);---OutPut of data memory
--added by MOHAMED GAMAL
SIGNAL InternalBuffer_RegWrite_op, InternalBuffer_MemtoReg_op,
secondREGWRITEBUFFER_OP,secondMEMTOREGBUFFER_OP: STD_LOGIC;
SIGNAL InternalBuffer_WRITEADDRESS,i_NEWBUFFERWRITEBACKADDRESS: STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL i_NewBuffer_ALUoutput: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL DECODE_WB_SELECTOR_RS, DECODE_WB_SELECTOR_RT:STD_LOGIC;

SIGNAL SP,SP_HandlingCircuit_OP: STD_LOGIC_VECTOR(9 DOWNTO 0);
-- SIGNAL SP_REG_EN: STD_LOGIC;
SIGNAL SP_EXTENDED: STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL Dcache_SelectedAddress, Dcache_SelectedData: STD_LOGIC_VECTOR(15 DOWNTO 0);

-----------------------------------Reset and Enable Signals---------------------------------
SIGNAL IF_ID_RESET:STD_LOGIC:='0';
SIGNAL IF_ID_ENABLE:STD_LOGIC:='1';
SIGNAL ID_EX_RESET:STD_LOGIC:='0';
SIGNAL ID_EX_ENABLE:STD_LOGIC:='1';
SIGNAL EX_MEM_RESET:STD_LOGIC:='0';
SIGNAL EX_MEM_ENABLE:STD_LOGIC:='1';
SIGNAL MEM_WB_RESET:STD_LOGIC:='0';
SIGNAL MEM_WB_ENABLE:STD_LOGIC:='1';
SIGNAL SIGDELAYBUFFER_RESET:STD_LOGIC:='0';
SIGNAL SIGDELAYBUFFER_ENABLE:STD_LOGIC:='1';
SIGNAL PC_REG_RESET:STD_LOGIC:='0';
SIGNAL PC_REG_ENABLE:STD_LOGIC:='1';
SIGNAL SP_REG_RESET:STD_LOGIC:='0';
SIGNAL SP_REG_ENABLE:STD_LOGIC:='1';

SIGNAL EX_MEMWrite_OR_INTERRUPT:STD_LOGIC:='0';



SIGNAL CCR_SIG,CCR_ZNF: STD_LOGIC_VECTOR(2 DOWNTO 0);

SIGNAL i_FLAGS: STD_LOGIC_VECTOR(2 DOWNTO 0); 
SIGNAL FLAGS: STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL PICK_FLAGS_FROM_RTI:STD_LOGIC;
-------------------------------------------END OF SIGNALS----------------------------------------------------------
                    ----------------------------------------------------------------

BEGIN
---------------------------------------------beginning of ARCHITECTURE------------------------------------------------
--PORT MAPS

--\*-----------------------------------------------------------------------------------------------------------------*/
--\*----------------------------------------------------Fetch stage---------------------------------------------------*/
--\*-----------------------------------------------------------------------------------------------------------------*/
-- FETCH_INSTANCE: Fetch PORT MAP(CLK,fetchEn,RESET,PCCOUNT, IF_ID_op);--IF,ID is the instruction
-- this now needs to be taken out 
OUTP_SIGNAL<=OutputPort;

--PC_HandlingCircuit IN EXECUTION
PC_HandlingCircuit_INST: ENTITY WORK.PC_HandlingCircuit PORT MAP
(ID_EX_ALUOP,
Function_field,
InstCache_op(15 DOWNTO 11),
EX_MEM_ALU_OPERATION,
SIGNALDELAYBUFFER_ALU_OPERATION,
CCR_REGISTER_OP(2),
CCR_REGISTER_OP(0),
CCR_REGISTER_OP(1),
INTERRUPT_IN_ACTION,RESET,PC,PC_Rdst,PC_DataMem_SP,PC_InstMEM_M0,PC_InstMEM_M1,PC_FOR_CALL, PC_HandlingCircuit_OP);
PC_InstMEM_M0<=InstMem_M0;
PC_InstMEM_M1<=InstMem_M1;
--15/6/2023 replaced ZF and CF with CCR_REGISTER_OP values
-- added today 18/5/2023 
-- PC_Rdst<=OPERAND1; --wla na5do mn el selka bta3t i_ID_EX_input1??
PC_Rdst<=OPERAND2;
--W DEH asln 8lbn 7n8yrha 34an yb2a el JMP zy el call
-- added 19/5


PC_FOR_CALL<=OPERAND2;
PC_DataMem_SP<=DataMem_SPPLUS1;--be very careful this is DM[SP+1]
-- PC_REG_ENABLE<=NOT INTERRUPT;




PC_REG_INSTANCE: PC_Reg PORT MAP(CLK,PC_REG_ENABLE,'0',
PC_HandlingCircuit_OP,PC);

-- -----------Instruction Cache Port Map----------------(to be edited)
InstructionCache_INST: InstructionCache PORT MAP(
  PC,
  InstCache_op,
  InstCache_opPLUS1,
  InstMem_M0,
  InstMem_M1);--SHOULD HAVE CLOCK INPUT

-- -------IF/ID PORT MAP 
-- --************NOTE: THE EN and RST signals should NOT be hardcoded****************
-- flushingIF_ID_mux: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(InstCache_op,NOP_CONST,IF_ID_RESET,IF_ID_INPUT);
INSTANCE_IF_ID: ENTITY WORK.IF_ID PORT MAP(IF_ID_INPUT,InstCache_opPLUS1,PC, 
CLK,IF_ID_ENABLE,IF_ID_RESET,IF_ID_FLUSHER_SIGNAL, IF_ID_op,if_idplus,IF_ID_PC);
-- IF_ID_RESET<=IF_ID_FLUSHER_SIGNAL;--21/6/2023
-- ID_EX_RESET<=ID_EX_FLUSHER_SIGNAL;
--\*-----------------------------------------------------------------------------------------------------------------*/
--\*----------------------------------------------------Decode Stage----------------------------------------------*/
--\*-----------------------------------------------------------------------------------------------------------------*/


Forwarding_Inst: Forwarding PORT MAP(
EX_MEM_RegWrite,
EX_MEM_WRITEBACKADDRESS,
secondREGWRITEBUFFER_OP,
i_NEWBUFFERWRITEBACKADDRESS,
MEM_WB_RegWrite,
MEM_WB_WBAddres_3rdprop,
ID_EX_rs,
ID_EX_rt,
FU_ALU_OP1_Selector,
FU_ALU_OP2_Selector
);

registerForwarding: WB_DEC_UNIT 
PORT MAP(
  MEM_WB_WBAddres_3rdprop,
  MEM_WB_RegWrite,
IF_ID_OP(7 DOWNTO 5),
IF_ID_OP(10 DOWNTO 8),
rs_selector,
rt_selector);

RS_RegFile_or_WB_MUX: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP
(RegFileReadPort1,RegFileWritePort,rs_Selector,RS_RegFile_or_WB);
--   -- i_ID_EX_input1,RegFileWritePort); 

Rt_RegFile_or_WB_MUX: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP
(RegFileReadPort2,RegFileWritePort,rt_Selector,RT_RegFile_or_WB);

operand1_mux_aftTransfer: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(
  RS_RegFile_or_WB,InputPort,InputPortCheck,i_ID_EX_input1);

operand2_mux: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(RT_RegFile_or_WB,if_idplus,Control_ALUSrc,i_ID_EX_input2);

-- RS_RegFile_or_WB_MUX: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP
-- (RegFileReadPort1,InputPort,InputPortCheck,i_ID_EX_input1);
--   -- i_ID_EX_input1,RegFileWritePort); 

-- Rt_RegFile_or_WB_MUX: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP
-- (RegFileReadPort2,if_idplus,Control_ALUSrc,i_ID_EX_input2);

-- operand1_mux_aftTransfer: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(
--   RS_RegFile_or_WB,InputPort,InputPortCheck,i_ID_EX_input1);


-- OPERAND1<=ID_EX_ReadData1; -- would need to be multiplexed with the forwarding input later
---2nd operand mux, to decide whether the ALU 2nd operand will be the output of the the second readport of 
--the register file or the sign extend in case of I-type instructions
-- operand2_mux: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(ID_EX_ReadData2,ID_EX_SignExtend,ID_EX_ALUSrc,OPERAND2);
-- W Leh astna a-multiplex ben el immediate wel readdata2 fel execution, lma momkn a3ml dah fl decode
-- operand2_mux: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(RT_RegFile_or_WB,if_idplus,Control_ALUSrc,i_ID_EX_input2);
-- -- OPERAND2<=ID_EX_ReadData2;

---THE ORIGINAL---****************************************-----------------------------------------------------
-- operand1_mux_aftTransfer: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(
--   RegFileReadPort1,InputPort,InputPortCheck,i_ID_EX_input1);
-- operand2_mux: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(RegFileReadPort2,if_idplus,Control_ALUSrc,i_ID_EX_input2);
-- OPERAND2<=ID_EX_ReadData2;


--Flushing and Stalling related architecture 
--stalling for data hazards is for any given number of cycles to freeze(disable) both the PC register and IF_ID buffer
-- and masking/clearing (make =0) the control signals going into the ID_EX buffer
--flushing is passing NOP into the IF_ID buffer as well as masking/clearing going into the ID_EX BUFFER
--remember that if a non-branch instruction does NOT write in the register file or in memory, it does NOT do anything
--i.e. if it doesn't write, it doesn't do anything, so it's always enough to only clear the RegWrite/MemWrite signals
HDU_INST: ENTITY WORK.HDU PORT MAP
(
CLK,
ID_EX_MemRead,
ID_EX_ALUOP,
ID_EX_rt,
IF_ID_OP(7 DOWNTO 5),
IF_ID_OP(10 DOWNTO 8),
EX_MEM_MemRead,
EX_MEM_ALU_OPERATION,
EX_MEM_WRITEBACKADDRESS,
O_PC_REG_HDU_DISABLE,
O_IF_ID_HDU_DISABLE,
ID_EX_CONTROL_SELECTOR
);

flusher_inst: ENTITY WORK.Flusher PORT MAP(ID_EX_ALUOP,Function_field,EX_MEM_ALU_OPERATION,SIGNALDELAYBUFFER_ALU_OPERATION,
ZF,CF,NF,INTERRUPT_IN_ACTION,
if_idflush,id_exflush);
--on 15/6/2023 if_idflush was replaced by IF_ID_FLUSHER_SIGNAL but returned it again because of the 
--interrupt handler circuit input 

--the following two lines are related to Stalling
-- PC_REG_ENABLE<=NOT O_PC_REG_HDU_DISABLE;
PC_REG_ENABLE<=NOT (O_PC_REG_HDU_DISABLE OR IntrHandlerPC_Disable);
-- IF_ID_ENABLE<=NOT O_IF_ID_HDU_DISABLE;
IF_ID_ENABLE<=NOT (O_IF_ID_HDU_DISABLE OR IntrHandlerIF_ID_Selector);

-- IF_ID_RegWrite_SEL: mux_2x1 GENERIC MAP(1) PORT MAP()

--ID_EX_CONTROL_SELECTOR will now be replaced with a signal that is the ORing of ID_EX_CONTROL_SELECTOR and id_exflush

ID_EX_FLUSHER_SIGNAL<=id_exflush OR ID_EX_CONTROL_SELECTOR OR RTI_RET_EXTRAFLUSH;
-- ID_EX_FLUSHER_SIGNAL<=ID_EX_CONTROL_SELECTOR;
IF_ID_FLUSHER_SIGNAL<=if_idflush OR RTI_RET_EXTRAFLUSH;
-- IF_ID_FLUSHER_SIGNAL<=if_idflush OR IntrHandlerIF_ID_Selector;--DEH KDA 8LBN 8LT
IF_ID_SELECT: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(InstCache_op,NOP_CONST,IF_ID_FLUSHER_SIGNAL,IF_ID_INPUT);
ID_EX_RegWrite_SEL: mux_2x1  PORT MAP(Control_RegWrite,'0',ID_EX_FLUSHER_SIGNAL,i_IDEXREGWRITE);
ID_EX_MemWrite_SEL: mux_2x1  PORT MAP(Control_MemWrite,'0',ID_EX_FLUSHER_SIGNAL,i_IDEX_MemWrite);
ID_EX_MemRead_SEL: mux_2x1  PORT MAP(Control_MemRead,'0',ID_EX_FLUSHER_SIGNAL,i_IDEX_MemRead);
ID_EX_ALUOP_SEL: MUX_2X1_GENERIC GENERIC MAP(5) PORT MAP(ALUOPERATION,"00000",ID_EX_FLUSHER_SIGNAL,i_IDEX_ALU_OP);
--the ALU_OP too must be flushed to avoid performing any action that plays with the flags


---------------------------------------------SIGN EXTEND PORT Map------------------------------------------
-- SignExtensionUnit: Sign_Extension_Unit GENERIC MAP(5,16) PORT MAP(IF_ID_op(4 DOWNTO 0),SignExtend_op);

--------------------------------------Control Unit Port Map------------------------------------

ControlUnitMap: ENTITY WORK.ControlUnit PORT MAP(IF_ID_op(15 DOWNTO 11),IF_ID_OP(2 DOWNTO 0),
ZF,
CF,
INTERRUPT_IN_ACTION,
ALUOperation,
Control_RegDst,Control_ALUSrc,Control_Branch,
Control_MemRead,Control_MemWrite,Control_RegWrite,
Control_MemtoReg,Control_ReadAnotherSegment,
InputPortCheck,OutputPortCheck,
ZeroSet,CarrySet
);
-----------------------------------------REGISTER FILE PORT MAP---------------------
--be very very very cautious here
--the reset of the register file should mostly be always zero
RegFile: CustomRegisterFile PORT MAP('0',CLK,RegFileWriteEn,IF_ID_op(10 DOWNTO 8),
IF_ID_op(7 DOWNTO 5),RegFileWriteAddress,RegFileReadPort1,RegFileReadPort2,RegFileWritePort);

--******************VVVVVVVVVI, RegFileWriteEn(the 3rd input to the register file) should be multiplexed
--as well as RegFileWriteAddress, RegFileWritePort-----------------
----------------------------------------ID_EX PORT MAP----------------------------
---NEEDS REVISION
ID_EX_buffer: ENTITY WORK.ID_EX PORT MAP(
Control_MemtoReg,
i_IDEXREGWRITE,
i_IDEX_MemRead,
i_IDEX_MemWrite,
 Control_ALUSrc,Control_RegDst,
InputPortCheck,
i_IDEX_ALU_OP,
IF_ID_OP(10 DOWNTO 8),
IF_ID_op(7 DOWNTO 5), 
IF_ID_op(4 DOWNTO 2),
i_ID_EX_input1,
i_ID_EX_input2,
if_idplus,
IF_ID_PC,

IF_ID_OP(2 DOWNTO 0),

CLK,ID_EX_ENABLE,ID_EX_RESET,
ID_EX_MemtoReg,ID_EX_RegWrite,ID_EX_MemRead,ID_EX_MemWrite,ID_EX_ALUSrc,ID_EX_RegDst,ID_EX_InputPortCheck,
ID_EX_ALUOP,
ID_EX_rs,
ID_EX_rt,ID_EX_rd,ID_EX_ReadData1,ID_EX_ReadData2,ID_EX_SignExtend,
ID_EX_PC,
Function_field);

--RegFileReadPort1 replaced by i_ID_EX_input1
--RegFileReadPort2 replaced by i_ID_EX_input2
--\*-----------------------------------------------------------------------------------------------------------------*/
--\*----------------------------------------------------Execution Stage----------------------------------------------*/
--\*-----------------------------------------------------------------------------------------------------------------*/

--------------------------------------------ALU PORT MAP and its INPUTS---------------------
-----------ALU inputs selectors------------
---1st operand mux, only for the case of input port will it pass the value on the input port
-- operand1_mux: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(ID_EX_ReadData1,InputPort,ID_EX_InputPortCheck,OPERAND1);

--19/5/2023 this mux will be transferred one stage earlier 
-- the multiplexing will be in the previous stage between RegFileReadPort1 and InPort and o/p is ID_EX_ReadData2


--- now this will need to be edit again to multiplex between 
op_FU_readData1_mux: MUX_4X1_GENERIC GENERIC MAP(16)
PORT MAP(ID_EX_ReadData1,
EX_MEM_ALUOUTPUT,
i_NewBuffer_ALUoutput,
RegFileWritePort,
FU_ALU_OP1_Selector,
OPERAND1);

op_FU_readData2_mux: MUX_4X1_GENERIC GENERIC MAP(16)
PORT MAP(ID_EX_ReadData2,
EX_MEM_ALUOUTPUT,
i_NewBuffer_ALUoutput,
RegFileWritePort,
FU_ALU_OP2_Selector,
OPERAND2);



-- ID_EX_SignExtend<=InstCache_opPLUS1;
-- SignExtend_op<=InstCache_opPLUS1;
ALUPortMap: ENTITY WORK.p_ALU GENERIC MAP(16) PORT MAP(OPERAND1,OPERAND2,ID_EX_ALUOP,INTERRUPT_IN_ACTION,
PC_DataMem_SP(15 DOWNTO 13),
Function_field,
clk,
OUT_SIGNAL,
OUTP_SIGNAL,
OutputPort,
ALU_OUTPUT,ZF,NF,CF,CCR);
---rd/rt selector
rd_rt_EXECUTION_MUX: MUX_2X1_GENERIC GENERIC MAP(3) PORT MAP(ID_EX_rt,ID_EX_rd,ID_EX_RegDst,rt_rd_selectedEX);


-------------------------------------EX_MEM BUFFER------------------------------ 
--NEEDS REVISION
EX_MEM_INSTANCE: EX_MEM PORT MAP(ID_EX_MemtoReg,ID_EX_RegWrite,ID_EX_MemRead,ID_EX_MemWrite,rt_rd_selectedEX,
ALU_OUTPUT,OPERAND2,
CLK,EX_MEM_ENABLE,EX_MEM_RESET,ID_EX_ALUOP,
ID_EX_PC,
EX_MEM_MemtoReg,EX_MEM_RegWrite,EX_MEM_MemRead,EX_MEM_MemWrite,
EX_MEM_WRITEBACKADDRESS,EX_MEM_ALUOUTPUT,EX_MEM_READDATA2,
EX_MEM_ALU_OPERATION,
EX_MEM_PC);

--\*-----------------------------------------------------------------------------------------------------------------*/
--\*----------------------------------------------------Memory Stage----------------------------------------------*/
--\*-----------------------------------------------------------------------------------------------------------------*/
-----------------------------------DATA CACHE PORT MAP------------------

SP_EXTENDED<="000000"&SP;
CACHEADDRESS_SELECT: DcacheAddSelector PORT MAP(EX_MEM_ALU_OPERATION,
EX_MEM_ALUOUTPUT,
SP_EXTENDED,
INTERRUPT_IN_ACTION,
Dcache_SelectedAddress);

CACHEDATA_SELECT: ENTITY WORK.DcacheDataSelector PORT MAP(
EX_MEM_ALU_OPERATION,
IF_ID_OP(15 DOWNTO 11),
INTERRUPT_IN_ACTION,
CCR_REGISTER_OP,
PC, 
EX_MEM_PC,
EX_MEM_READDATA2,
Dcache_SelectedData);

-- EX_MEM_PC

-- critical point we would now need to change EX_MEM_READDATA2 TO EX_MEM_ALUOUTPUT
--i.e. all instructions will pass through the ALU
--results in catastrophe

-- The Memory cache Write Address (currently EX_MEM_ALUOUTPUT)
-- will now need to be multiplexed with the SP based on the operation
-- as well as the data, not just the address
-- RECALL THAT EX_MEM_READDATA2 IS IN PASSIVE FORM, i.e. it is the READ (past participle) the data that will be committed
-- EX_MEM_ALUOUTPUT WILL NOW BE REPLACED BY Dcache_SelectedAddress
--19/5 EX_MEM_READDATA2 will now want to be multiplexed with the PC or PC+1, replaced by DataCacheOutput
--EX_MEMWRITE IS RPELACED BY AN ORRING WITH INTERRUPT


--COMMENTED OUT ON 15/6/2023
-- CCR_SIG<=ZF&NF&CF;
-- CCR_REG: A_REGISTER GENERIC MAP(3) PORT MAP(i_FLAGS,CLK,'1','0',CCR_ZNF);
-- PICK_FLAGS_FROM_RTI<='1' WHEN ID_EX_ALUOP="01110"
-- ELSE '0';
-- FLAGS_SELECTOR: MUX_2X1_GENERIC GENERIC MAP (3) PORT MAP(CCR_SIG,FLAGS(2 DOWNTO 0),PICK_FLAGS_FROM_RTI,i_FLAGS);



Memdata: dataMemory port map( clk,
			      EX_MEMWRITE_OR_INTERRUPT,
			      EX_MEM_MemRead,
            Dcache_SelectedAddress,
			      Dcache_SelectedData,
            SP,
			      DataCacheOutput,
            DataMem_SP,
            DataMem_SPPLUS1,
            INTERRUPT_IN_ACTION,
    i_FLAGS,
    FLAGS);
            -- DataCacheOutput<=OutputMemoryData;--ADDED BY ME MOHAMED GAMAL
EX_MEMWrite_OR_INTERRUPT<=INTERRUPT_IN_ACTION OR EX_MEM_MemWrite;--I especially don't understand this replacement
--of interrupt with INTERRUPT_IN_ACTION
SIGNALSBUFFER: ENTITY WORK.SIGNALDELAYBUFFER PORT MAP(
  CLK,
  SIGDELAYBUFFER_ENABLE,
  SIGDELAYBUFFER_RESET,
EX_MEM_MemtoReg,EX_MEM_RegWrite,
EX_MEM_WRITEBACKADDRESS,EX_MEM_ALUOUTPUT,
EX_MEM_ALU_OPERATION,
secondMEMTOREGBUFFER_OP,
secondREGWRITEBUFFER_OP,
i_NEWBUFFERWRITEBACKADDRESS,
i_NewBuffer_ALUoutput,
SIGNALDELAYBUFFER_ALU_OPERATION
);

-- dol brdo momkn n3mlhom replacement 3ltoul
          MemStage_WBAddress_op<=i_NEWBUFFERWRITEBACKADDRESS;
          MemStage_ALUOutput_op<=i_NewBuffer_ALUoutput;--last edit 19/4 9:48 PM, 
          --y3ni lazm yta5d mn buffer kman 
            MemStage_MemtoReg_op<=secondMEMTOREGBUFFER_OP;
            MemStage_RegWrite_op<=secondREGWRITEBUFFER_OP;




SP_Reg_Inst: SP_Reg PORT MAP(CLK,SP_REG_ENABLE,SP_REG_RESET,SP_HandlingCircuit_OP,SP);
---------This is very critical, is the interrupt piped?*************************
SP_HandlingCircuit_INST: SP_HandlingCircuit PORT MAP(EX_MEM_ALU_OPERATION,
INTERRUPT_IN_ACTION,SP,SP_HandlingCircuit_OP); 

--NOTE VVI: THE WRITEBACK ADDRESS WOULD BE TAKEN FROM HERE TO THE NEXT BUFFER MEM_WB
----MEM_WB BUFFER---------
-- DataCacheOutput the memory stage output
--\*----------------------------------------------------Writeback Stage----------------------------------------------*/
--\*-----------------------------------------------------------------------------------------------------------------*/
MEM_WB_INSTANCE: MEM_WB PORT MAP(
MemStage_MemtoReg_op,MemStage_RegWrite_op,MemStage_WBAddress_op,
MemStage_ALUOutput_op,
DataCacheOutput,
CLK,MEM_WB_ENABLE,MEM_WB_RESET,
MEM_WB_MemtoReg,MEM_WB_RegWrite,MEM_WB_WBAddres_3rdprop,
MEM_WB_ALUResult,MEM_WB_MemoryRead_Data);

--LAST MULTIPLEXER 
last_mux: MUX_2X1_GENERIC GENERIC MAP(16) PORT MAP(MEM_WB_ALUResult,MEM_WB_MemoryRead_Data,
MEM_WB_MemtoReg,RegFileWritePort);
--THE OUTPUT IS THE REGISTER WRITE-DATA
RegFileWriteAddress<=MEM_WB_WBAddres_3rdprop;
RegFileWriteEn<=MEM_WB_RegWrite;

---new additions added on 15/6/2023 by MOHAMED GAMAL
CCR_REG_INST:ENTITY WORK.CCR_REGISTER PORT MAP(CLK,'1','0',CCR_REGISTER_IN,CCR_REGISTER_OP);
CCR_SIG<=ZF&NF&CF;--FROM ALU

PICK_FLAGS_FROM_RTI<='1' WHEN ID_EX_ALUOP="01110"
ELSE '0';
FLAGS_SELECTOR: MUX_2X1_GENERIC GENERIC MAP (3) PORT MAP(CCR_SIG,PC_DataMem_SP(15 DOWNTO 13),
PICK_FLAGS_FROM_RTI,CCR_REGISTER_IN);


InterruptHandler_INSTANCE: ENTITY WORK.InterruptHandler PORT MAP(CLK,INTERRUPT,IntrHandlerPC_Disable,
IntrHandlerIF_ID_Selector,INTERRUPT_IN_ACTION);


-- DECODE_ALUOP<=IF_ID_OP(15 DOWNTO 11);

RTI_RET_EXTRAFLUSH<='1' WHEN EX_MEM_ALU_OPERATION="01101" OR EX_MEM_ALU_OPERATION="01110" OR SIGNALDELAYBUFFER_ALU_OPERATION="01101" 
OR SIGNALDELAYBUFFER_ALU_OPERATION="01110"
ELSE '0';  
END ARCHITECTURE ARC;

-- important notes:
-- the call/push/pop/ret/rti instructions, though don't specifically use the ALU, they do a lot of tasks distributed
-- over the other stages
-- for example, CALL instruction is the same as JMP in that once  it is [CALL] in the Execution stage you have to flush
-- the previous buffers and re-fetch from the new address that is now one of the operands but you're NOT done as it needs 
-- to write its PC+1 into the memory in the next stage 
-- it is a very good idea to propagate the PC with you  through the pipe
--with a six-stage pipe of Memory1 and Memory2, there is the extra headache of having a load instruction separated 
-- by another instruction to a use 
-- eg.
-- LDD R1,R5 
-- DEC R0,R0 
-- MOV R2,R1 
-- this too needs a stall for one cycle 
-- NOTE: RET and RTI instructions can ONLY edit the PC when they are in Memory-2 stage as memory reads only happen in
-- Memory-2 stage..i.e. RET and RTI effectively cause 5-cycle stalls in the pipeline, you need to flush the 
-- fetch and decode buffers as long as the RET and RTI are in EX,M1,or M2


-- available opcodes 
-- 00010--CMP
-- 01001
-- 10110
-- 11010
-- 11100
-- 10110
-- 11101--SHL
-- 11111--SHR 



--JNZ FIELD 11 , JNC FIELD 11
--JMP : ON 5 BITS, JLE,JGE,JAE,JBE,JL,JG,JA,JB,JNA,JNB,JNG,JNL