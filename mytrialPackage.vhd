Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

PACKAGE MYTRIALPACKAGE IS
-- LIKE AN ENTITY, HERE YOU JUST DECLARE YOUR CONSTANTS, TYPES, COMPONENTS, AND FUNCTIONS
--THE ACTUAL VALUE/FUNCTIONALITY/DESCRIPTION OF THOSE IS IN THE PACKAGE BODY 

---------------COMPONENTS---------------------------
--1) A function that returns an STD_LOGIC_VECTOR that is the bitwise AND of each corresponding bits in INPUT1 & INPUT2

--------------------CONSTANTS------------------------
CONSTANT pi: REAL; 	


-----------------ARITHMETIC FUNCTIONS-----------------
function IsEven(x:in integer)
      return integer;

function log2_unsigned( X:NATURAL ) 
return NATURAL;





--------------LOGIC FUNCTIONS--------------
function DOUBLE_SIGNAl_XOR (INPUT1: IN STD_LOGIC_VECTOR;
INPUT2: IN STD_LOGIC_VECTOR) 
RETURN STD_LOGIC_VECTOR;

-- FUNCTION DOUBLE_NOR (INPUT1: IN STD_LOGIC_VECTOR;
-- INPUT2: IN STD_LOGIC_VECTOR) 
-- RETURN STD_LOGIC_VECTOR;

-- FUNCTION SINGLE_AND (INPUT: IN STD_LOGIC_VECTOR) RETURN STD_LOGIC;
END PACKAGE;


PACKAGE BODY MYTRIALPACKAGE IS
---------------COMPONENTS---------------------------


-- COMPONENT DOUBLE_AND  --returns an STD_LOGIC_VECTOR that is the bitwise AND of each corresponding bits in INPUT1 & INPUT2
-- GENERIC(N:INTEGER:=32);
-- PORT(INPUT1:IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
-- INPUT2: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
-- OUTPUT: OUT STD_LOGIC);
-- END COMPONENT;


--COMPONENT;
--------------------CONSTANTS------------------------
CONSTANT pi: REAL:=3.14159; 	
function IsEven (x: in integer) return integer is
variable a:integer;
begin
a:=x mod 2;
if a=0 then
return 1;
else
return 0;
end if;
end IsEven; 


function Log2( input:integer ) return integer is
variable temp,log:integer;
begin
temp:=input;
log:=0;
while (temp /= 0) loop
temp:=temp/2;
log:=log+1;
end loop;
return log;
end function log2;


function DOUBLE_SIGNAl_XOR (INPUT1: IN STD_LOGIC_VECTOR;
INPUT2: IN STD_LOGIC_VECTOR) --NO NEED TO INPUT THE STD_LOGIC_VECTOR SIZE, WE CAN KNOW IT USING THE 'LENGTH FUNCTION OR 'RANGE 
RETURN STD_LOGIC_VECTOR IS 
--VARIABLES (IF ANY) ARE DECLARED HERE-- 
VARIABLE TEMP: STD_LOGIC_VECTOR(INPUT1'LENGTH -1 DOWNTO 0);
BEGIN
FOR i IN 0 TO INPUT1'LENGTH-1 
LOOP
TEMP(i):=INPUT1(i) XOR INPUT2(i);
END LOOP;
RETURN TEMP;
END DOUBLE_SIGNAl_XOR;

--A FUNCTION THAT BITWISE NOR-S TWO SIGNALS AND RETURNS A SIGNAL THAT HAS IS THE SAME WIDTH AS THE INPUT SIGNALS
FUNCTION DOUBLE_NOR (INPUT1: IN STD_LOGIC_VECTOR;
INPUT2: IN STD_LOGIC_VECTOR) 
RETURN STD_LOGIC_VECTOR IS
--HERE VARIABLE ARE DECLARED
VARIABLE TEMP:STD_LOGIC_VECTOR(INPUT1'LENGTH-1 DOWNTO 0);
BEGIN
FOR i IN 0 TO INPUT1'LENGTH-1 LOOP
TEMP(i):=INPUT1(i) NOR INPUT2(i);
END LOOP;
RETURN TEMP;
END DOUBLE_NOR;

--A FUNCTION THAT ANDS THE INDIVIDUAL BITS OF A SIGNAL
FUNCTION SINGLE_AND (INPUT: IN STD_LOGIC_VECTOR) RETURN STD_LOGIC IS
VARIABLE TEMP:STD_LOGIC:='1';--MUST BE INITIALIZED TO '1'
BEGIN
FOR i IN 0 TO INPUT'LENGTH-1
LOOP
TEMP:=TEMP AND INPUT(i);
IF TEMP='0' THEN
EXIT;
END IF;
END LOOP;
RETURN TEMP;
END SINGLE_AND;


function log2_unsigned ( x : natural ) return natural is
        variable temp : natural := x ;
        variable n : natural := 0 ;
    begin
        while temp > 1 loop
            temp := temp / 2 ;
            n := n + 1 ;
        end loop ;
        return n ;
    end function log2_unsigned ;

END MYTRIALPACKAGE;