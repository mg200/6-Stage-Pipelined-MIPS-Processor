Library ieee;
Use ieee.std_logic_1164.all;
USE IEEE.numeric_std.all;

entity array_registerfile is
    generic(N: INTEGER:=3);
    PORT(
        RESET : IN STD_LOGIC;
        CLK: IN STD_LOGIC;
        WRITE_ENABLE: IN STD_LOGIC;--_VECTOR(N-1 DOWNTO 0);
        READ_ADD1, READ_ADD2: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        WRITE_ADD: IN  STD_LOGIC_VECTOR(N-1 DOWNTO 0);
        READ_PORT1, READ_PORT2: OUT STD_LOGIC_VECTOR((2**N)-1 DOWNTO 0);
        WRITE_PORT: IN STD_LOGIC_VECTOR ((2**N)-1 DOWNTO 0)
        );
end array_registerfile;

architecture arch of array_registerfile is    
COMPONENT decoder  IS
GENERIC (N:INTEGER:=3);
PORT(
EN: IN STD_LOGIC;
RESET : IN STD_LOGIC;
input: IN STD_LOGIC_VECTOR(n-1 downto 0);
output: OUT STD_LOGIC_VECTOR(n-1 downto 0)
);
END COMPONENT;
-- type t_array is array (0 to 7) of STD_LOGIC_VECTOR (7 downto 0);
-- signal arr_var: t_array;
-- SIGNAL tENable: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
   
TYPE register_type IS ARRAY(0 TO (2**N)-1) of STD_LOGIC_VECTOR ((2**N)-1 DOWNTO 0);
SIGNAL reg : register_type:=(others=>(others=>'0')) ;

BEGIN
    REGpROCESS: PROCESS (CLK)
    begin
 IF rising_edge(clk) THEN

 if WRITE_ENABLE='1'then
 reg(to_integer(unsigned(WRITE_ADD))) <= WRITE_PORT;
    end if;
IF RESET='1' THEN
 reg(0 TO (2**N)-1)<=(OTHERS=>(others=>'0')); --contest whether this should be '0' or "0"
END IF;
    end if;
Read_PORT1<=
reg(to_integer(unsigned(READ_ADD1)));
Read_PORT2<=
reg(to_integer(unsigned(READ_ADD2)));
        END PROCESS;

end arch ; -- arch



