Library ieee; 
Use ieee.std_logic_1164.all; 
USE IEEE.numeric_std.all;





entity MemoryBuff IS --- SP AND PC+1 NOT HANDLED IN THIS PHASE
    port(  
        ---inputs
            clk                    : IN STD_LOGIC ; 
           -- i_isFlush           : IN STD_LOGIC ;  
            i_aluData           : IN STD_LOGIC_VECTOR(15 downto 0) ; ----- THE ADDRESS TO THE MEMORY
            i_readData1         : IN STD_LOGIC_VECTOR(15 downto 0); -- The WRITEDATA TO THE MEMORY
            i_controlSignalMemWriteEn    : IN STD_LOGIC;--- Memory write enable
            i_controlSignalMemReadEn    : IN STD_LOGIC;--- Memory read enable
            i_writeAddressWriteBack : IN std_logic_vector(2 downto 0); ---write address of writeback 
            --ADDED BY ME
            i_controlSignalMemtoRegEn: IN STD_LOGIC;
            i_controlSignalRegWriteEn: IN STD_LOGIC;          
        ---outputs
           o_aluData           : OUT STD_LOGIC_VECTOR(15 downto 0) ;
           o_readData1         : OUT STD_LOGIC_VECTOR(15 downto 0);
           o_controlSignalMemWriteEn    : OUT STD_LOGIC;
           o_controlSignalMemReadEn    : OUT STD_LOGIC;
           o_writeAddressWriteBack : OUT std_logic_vector(2 downto 0);
             --ADDED BY ME
            o_controlSignalMemtoRegEn: OUT STD_LOGIC;
            o_controlSignalRegWriteEn: OUT STD_LOGIC    
        );
end MemoryBuff;
Architecture arch OF MemoryBuff IS
BEGIN
	process (clk)
	begin
        IF (rising_edge(clk) ) THEN
        o_aluData                 <=  i_aluData;
        o_readData1               <=  i_readData1;
        o_controlSignalMemWriteEn <=  i_controlSignalMemWriteEn;
        o_controlSignalMemReadEn  <=  i_controlSignalMemReadEn ;
        o_writeAddressWriteBack   <=  i_writeAddressWriteBack ;
        o_controlSignalMemtoRegEn <=  i_controlSignalMemtoRegEn;
        o_controlSignalRegWriteEn <=  i_controlSignalRegWriteEn;
      
        
        END IF;
	end process;
end arch;