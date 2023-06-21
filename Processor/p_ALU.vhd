LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY p_ALU IS
GENERIC(N:INTEGER:=8);
PORT(A,B: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SELECTION: IN STD_LOGIC_VECTOR(4 DOWNTO 0):="00001";
INTERRUPT: IN STD_LOGIC;
ReFed_Flags: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
Least2Bits_IP: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
clk: in std_logic;
OUT_SIGNAL: OUT STD_LOGIC;
OLD_OUTPORTVALUE: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
NEW_OUTPORTVALUE: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
F: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
ZF: INOUT STD_LOGIC:='0';--ZERO FLAG
NF: INOUT STD_LOGIC:='0';--NEGATIVE FLAG
CF: INOUT STD_LOGIC:='0'; --CARRAY FLAG
CCR: OUT STD_LOGIC_VECTOR(2 DOWNTO 0):="000";--ZF,NF,CF
Branch:OUT STD_LOGIC
);
END p_ALU;


ARCHITECTURE ARC OF p_ALU IS 
CONSTANT ZEROS:STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'0');
CONSTANT ONES: STD_LOGIC_VECTOR(N-1 DOWNTO 0):=(OTHERS=>'1');
CONSTANT INTEGERONES: INTEGER:=2**N-1;
SIGNAL SEE: INTEGER;
SIGNAL ZF_S,CF_S,NF_S: STD_LOGIC;
SIGNAL MODE,COUT,OverFlow,SIGN,CARRY,ZERO: STD_LOGIC;
SIGNAL F_nFA: STD_LOGIC_VECTOR(N-1 DOWNTO 0);


BEGIN

-- nfAinst: ENTITY WORK.nFA GENERIC MAP(16) PORT MAP(A,B,MODE,F_nFA,cout,OverFlow);
--NOTE: VHDL doesn't care if all last outputs are not driven out, but nothing in the middle




mainprocess: PROCESS(A,B, SELECTION)
VARIABLE TEMP,TEMP2:INTEGER;
VARIABLE TEMPSTD: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
VARIABLE ZFVAR,NFVAR,CFVAR:STD_LOGIC;
BEGIN

IF INTERRUPT<='1' THEN 
CF_S<=CF;
NF_S<=NF;
ZF_S<=ZF;
END IF;

IF SELECTION="10111" THEN 
OUT_SIGNAL<='1';
F<=B;
ELSE 
OUT_SIGNAL<='0';
NEW_OUTPORTVALUE<=OLD_OUTPORTVALUE;
END IF;
--MAJOR LOOP
---------------------------------NOP INSTRUCTION--------------------------------------
IF SELECTION="00000" THEN --NOP 
F<=(OTHERS=>'0');
---------------------------------NOT INSTRUCTION---------------------------------------
ELSIF SELECTION="10101" THEN --NOT
TEMPSTD:= NOT A;
F<=NOT A; --WE WILL ASSUME BE IS rt, a NOT instruction like NOT r5,r1 means r5=r1', it's written as 10101 001 XXX 101 XX
--just as INC instruction, we will treat NOT as a special R-type instruction, where we only care about the first operand (the source) and the third 
--operand (the destination), the second operand is a don't care and as such the signal RegDst is also a don't care in this instruction
IF TEMPSTD=ZEROS THEN 
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
NF<=TEMPSTD(N-1);
--CARRY FLAG IS NOT UPDATED


------------------------AND INSTRUCTION---------------------------------------------------------------
ELSIF SELECTION="10011" THEN--AND  10011 ....... 10011 RSRC1(A) RSRC2(B) RDST XX.
-- e.g. AND R1,R2,R3-> 10011 010 011 001 XX
TEMPSTD:=A AND B;
F<=A AND B;
IF TEMPSTD=ZEROS THEN
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
IF TEMPSTD(N-1)='1' THEN
NF<='1';
ELSE
NF<='0';
END IF;

------------------------INC INSTRUCTION--------------------------------------------------------------------------------
ELSIF SELECTION="00001" THEN --INC OPERATION INC Rdst,R1--> Rdst=value(R1)+1
--if INC R7,R1--> 00001 001 XXX 111 XX  i.e. A will contain value(R1) B is don't care
--a writeback signal is invoked for the instruction to be written in the register file in register 7
TEMP:=TO_INTEGER(UNSIGNED(A));
TEMP:=TEMP+1;
TEMPSTD:=STD_LOGIC_VECTOR(TO_UNSIGNED(temp,F'LENGTH));
F<=STD_LOGIC_VECTOR(TO_UNSIGNED(temp,TEMPSTD'LENGTH));
IF TEMPSTD=ZEROS THEN 
ZF<='1';
CF<='1';
ZFVAR:='1';
CFVAR:='1';
ELSE 
ZF<='0';
CF<='0';
ZFVAR:='0';
CFVAR:='0';
END IF;
NF<=TEMPSTD(N-1);


------------------------DEC INSTRUCTION--------------------------------------------------------------------------------
ELSIF SELECTION="00011" THEN --INC OPERATION DEC Rdst,R1--> Rdst=value(R1)+1
--if DEC R7,R1--> 00011 001 XXX 111 XX  i.e. A will contain value(R1) B is don't care
--a writeback signal is invoked for the instruction to be written in the register file in register 7
TEMP:=TO_INTEGER(UNSIGNED(A));
TEMP:=TEMP-1;
TEMPSTD:=STD_LOGIC_VECTOR(TO_UNSIGNED(temp,F'LENGTH));
F<=STD_LOGIC_VECTOR(TO_UNSIGNED(temp,TEMPSTD'LENGTH));
IF TEMPSTD=ZEROS THEN 
ZF<='1';
CF<='1';
ZFVAR:='1';
CFVAR:='1';
ELSE 
ZF<='0';
CF<='0';
ZFVAR:='0';
CFVAR:='0';
END IF;
NF<=TEMPSTD(N-1);

------------------------------------LDD INSTRUCTION---------------------------------------------------------------
ELSIF SELECTION="00110" THEN--LDD OPERATION (PHASE-1 LOAD)
--EXAMPLE: LW $t0, 24($t3) --> 00110 011 000 11000 i.e. load opcode, t3 (rs), t0(rdst), 24 (offset) i.e. t0=[t3+24]
--note bnktb f tani 3 bits ely hwa "000" hna, f 7n5ly el RegDst Signal=0
TEMP:=TO_INTEGER(UNSIGNED(A));--rs 
-- TEMP2:=TO_INTEGER(UNSIGNED(B));--sign extended offset
-- TEMP:=TEMP+TEMP2;
F<=STD_LOGIC_VECTOR(TO_UNSIGNED(TEMP,TEMPSTD'LENGTH));--the address in the memory which it should load from

---------------------------------PUSH INSTRUCTION--------------------------------------
ELSIF SELECTION="01010" THEN --PUSH 
-- F<=A;

TEMP:=TO_INTEGER(UNSIGNED(A));
F<=STD_LOGIC_VECTOR(TO_UNSIGNED(TEMP,TEMPSTD'LENGTH));
---------------------------------STD INSTRUCTION--------------------------------------
ELSIF SELECTION="00101" THEN --STD OPERATION PHASE-1

--According to document, STD Rsrc2,Rsrc1 means memory location(value(Rsrc2))=value(Rsrc1
--note that Rsrc2 here is the first operand 
--STD R2,R1 -> 00101 001 010 XXXXX  
TEMP:=TO_INTEGER(UNSIGNED(A));
F<=STD_LOGIC_VECTOR(TO_UNSIGNED(TEMP,TEMPSTD'LENGTH));

---------------------------------------------OR INSTRUCTION---------------------------------------------------------
ELSIF SELECTION="10100" THEN--OR OPERATION OR  
TEMPSTD:=A OR B;
F<=A OR B;
IF TEMPSTD=ZEROS THEN
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
IF TEMPSTD(N-1)='1' THEN
NFVAR:='1';
NF<='1';
ELSE
NFVAR:='0';
NF<='0';
END IF;

---------------------------------------------ADD INSTRUCTION--------------------------------------
ELSIF SELECTION="10000" THEN --ADD 
TEMP:=TO_INTEGER(UNSIGNED(A));
TEMP:=TEMP+TO_INTEGER(UNSIGNED(B));--IF TEMP IS LARGER THAN 16 ONES, SO THERE'S CARRY 
TEMPSTD:=STD_LOGIC_VECTOR(TO_UNSIGNED(TEMP,TEMPSTD'LENGTH));
F<=TEMPSTD;
IF TEMPSTD=ZEROS THEN 
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
IF TEMP>INTEGERONES THEN 
CFVAR:='1';
CF<='1';
ELSE 
CFVAR:='0';
CF<='0';
END IF;
IF TEMPSTD(N-1)='1' THEN
NFVAR:='1';
NF<='1';
ELSE
NFVAR:='0';
NF<='0';
END IF;
---------------------------------------------SUB INSTRUCTION--------------------------------------
ELSIF SELECTION="10001" THEN --SUB 
TEMP:=TO_INTEGER(UNSIGNED(A));
TEMP:=TEMP-TO_INTEGER(UNSIGNED(B));--IF TEMP IS LARGER THAN 16 ONES, SO THERE'S CARRY 
TEMPSTD:=STD_LOGIC_VECTOR(TO_UNSIGNED(TEMP,TEMPSTD'LENGTH));
F<=TEMPSTD;
IF TEMPSTD=ZEROS THEN 
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
IF TEMP>INTEGERONES THEN 
CFVAR:='1';
CF<='1';
ELSE 
CFVAR:='0';
CF<='0';
END IF;
IF TEMPSTD(N-1)='1' THEN
NFVAR:='1';
NF<='1';
ELSE
NFVAR:='0';
NF<='0';
END IF;
---------------------------------------------IADD INSTRUCTION--------------------------------------
ELSIF SELECTION="10010" THEN --IADD Operation
TEMP:=TO_INTEGER(UNSIGNED(A));
TEMP:=TEMP+TO_INTEGER(UNSIGNED(B));--IF TEMP IS LARGER THAN 16 ONES, SO THERE'S CARRY 
TEMPSTD:=STD_LOGIC_VECTOR(TO_UNSIGNED(TEMP,TEMPSTD'LENGTH));
F<=TEMPSTD;
IF TEMPSTD=ZEROS THEN 
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
IF TEMP>INTEGERONES THEN 
CFVAR:='1';
CF<='1';
ELSE 
CFVAR:='0';
CF<='0';
END IF;
IF TEMPSTD(N-1)='1' THEN
NFVAR:='1';
NF<='1';
ELSE
NFVAR:='0';
NF<='0';
END IF;


------------------------------------------------IN INSTRUCTION--------------------------------------------------------
ELSIF SELECTION="01000" THEN --IN Operation
F<=A;

---------------------------------OUT INSTRUCTION--------------------------------------

ELSIF SELECTION="10111" THEN --OUT Operation
F<=A;


------------------------------------------------SETC INSTRUCTION--------------------------------------------------------
ELSIF SELECTION="11110" THEN --SETC OPERATION

CFVAR:='1';
CF<='1';
---------------------------CLRC INSTRUCTION--------------------------------------------------------
ELSIF SELECTION="00100" THEN --CLRC OPERATION
CFVAR:='0';
CF<='0';

-- ELSIF SELECTION="11001" THEN 
-- IF CF='1' THEN CFVAR:='0';
-- end if;
--COMMENTED ON 17/6/2023
---------------------------MOV INSTRUCTION--------------------------------------------------------
ELSIF SELECTION="01111" THEN --MOV OPERATION
--e.g. MOV R2,R1 01111 001 010 XXXXX
F<=A;
---------------------------------LDM INSTRUCTION--------------------------------------
ELSIF SELECTION="00111" THEN -- LDM PHASE-2 LOAD
F<=B;
---------------------------------JMP INSTRUCTION--------------------------------------
ELSIF SELECTION="11011" THEN --JMP 
F<=B;
---------------------------------JZ INSTRUCTION--------------------------------------
ELSIF SELECTION="11000" THEN --JZ 
F<=B;

---------------------------------JC INSTRUCTION--------------------------------------
ELSIF SELECTION="11001" THEN --JC 
F<=B;

---------------------------------POP INSTRUCTION--------------------------------------
ELSIF SELECTION="01011" THEN --POP
---------------------------------RTI INSTRUCTION--------------------------------------
ELSIF SELECTION="01110" THEN --RTI 
-- ZF<=ZF_S;
-- CF<=ZF_S; 
-- NF<=NF_S;
ZF<=ReFed_Flags(2);
NF<=ReFed_Flags(1);
CF<=ReFed_Flags(0);
---------------------------------CALL INSTRUCTION--------------------------------------
ELSIF SELECTION="01100" THEN 

---------------------------------RET INSTRUCTION--------------------------------------
ELSIF SELECTION="01101" THEN --RET 
---------------------------------SHL INSTRUCTION--------------------------------------
ELSIF SELECTION="11101" THEN --SHL 
TEMPSTD:='0'&A(15 DOWNTO 1);
F<=TEMPSTD;
IF TEMPSTD=ZEROS THEN 
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
IF TEMP>INTEGERONES THEN 
CFVAR:='1';
CF<='1';
ELSE 
CFVAR:='0';
CF<='0';
END IF;
IF TEMPSTD(N-1)='1' THEN
NFVAR:='1';
NF<='1';
ELSE
NFVAR:='0';
NF<='0';
END IF;
---------------------------------SHR INSTRUCTION--------------------------------------
ELSIF SELECTION="11111" THEN --SHR 
TEMPSTD:=A(14 DOWNTO 0)&'0';
F<=TEMPSTD;
IF TEMPSTD=ZEROS THEN 
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
IF TEMP>INTEGERONES THEN 
CFVAR:='1';
CF<='1';
ELSE 
CFVAR:='0';
CF<='0';
END IF;
IF TEMPSTD(N-1)='1' THEN
NFVAR:='1';
NF<='1';
ELSE
NFVAR:='0';
NF<='0';
END IF;


---------------------------------------------CMP INSTRUCTION--------------------------------------
ELSIF SELECTION="00010" THEN --CMP 
TEMP:=TO_INTEGER(UNSIGNED(A));
TEMP:=TEMP-TO_INTEGER(UNSIGNED(B));--IF TEMP IS LARGER THAN 16 ONES, SO THERE'S CARRY 
TEMPSTD:=STD_LOGIC_VECTOR(TO_UNSIGNED(TEMP,TEMPSTD'LENGTH));
F<=TEMPSTD;
IF TEMPSTD=ZEROS THEN 
ZF<='1';
ZFVAR:='1';
ELSE 
ZF<='0';
ZFVAR:='0';
END IF;
IF TEMP>INTEGERONES OR UNSIGNED(A)<UNSIGNED(B) THEN 
CFVAR:='1';
CF<='1';
ELSE 
CFVAR:='0';
CF<='0';
END IF;
IF TEMPSTD(N-1)='1' THEN
NFVAR:='1';
NF<='1';
ELSE
NFVAR:='0';
NF<='0';
END IF;


END IF;
SEE<=TEMP;
-- CCR FLAGS CONCATENATION
CCR<=ZFVAR&NFVAR&CFVAR;

END PROCESS;

END ARC;


