Library ieee;
Use ieee.std_logic_1164.all;

ENTITY tb_ALU IS 
GENERIC(N:INTEGER:=8);
END ENTITY;


ARCHITECTURE ARC OF tb_ALU IS
COMPONENT ALU IS
--GENERIC(N:INTEGER:=16);
PORT(A,B: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SELECTION: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
CIN: IN STD_LOGIC;
F: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0);
COUT: OUT STD_LOGIC
);

END COMPONENT;

--SIGNALS--
SIGNAL TA,TB,TF:STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL TSELECTION: STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL TCIN,TCOUT: STd_LOGIC;
BEGIN
--PORT MAP
ALU_LOOP: ALU GENERIC MAP (N) PORT MAP(TA,TB,TSELECTION,TCIN,TF,TCOUT);
PROCESS
BEGIN



--testcases for part A

--TESTCASE1
TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"0";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"F0" and Tcout='0') report " A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

--TESTCASE2
TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"1";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"A0" and Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;


--TESTCASE3
TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"2";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"3F" and Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;


--TESTCASE4
TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"3";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"EF" and Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

--TESTCASE5
TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"0";
	Tcin <= '1';
	WAIT for 10 ns;
        assert(TF= x"F1" and Tcout='0') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;


--TESTCASE6
TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"1";
	Tcin <= '1';
	WAIT for 10 ns;
        assert(TF= x"A1" and Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

--TESTCASE7
TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"2";
	Tcin <= '1';
	WAIT for 10 ns;
        assert(TF= x"40" and Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

--TESTCASE8
TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"3";
	Tcin <= '1';
	WAIT for 10 ns;
        assert(TF= x"B0" and Tcout='0') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;








---old testcases end here
	TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"4";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"F0") report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;


	TA <= X"F0";
	TB <= X"0B";
	TSELECTION <= X"5";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"00") report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

	TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"6";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"0F") report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

        TA <= X"F0";
	TB <= X"0B";
	TSELECTION <= X"7";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"0F") report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

		TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"8";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"E0" or Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;


	TA <= X"F0";
	TB <= X"0B";
	TSELECTION <= X"9";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"E1" or Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

	TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"A";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"E0" or Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

        TA <= X"F0";
	TB <= X"0B";
	TSELECTION <= X"B";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"00" or Tcout='0') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

		TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"C";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"78" or Tcout='0') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;


	TA <= X"F0";
	TB <= X"0B";
	TSELECTION <= X"D";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"78" or Tcout='0') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

	TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"E";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"78" or Tcout='0') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

        TA <= X"F0";
	TB <= X"0B";
	TSELECTION <= X"F";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"F8" or Tcout='0') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

        TA <= X"F0";
	TB <= X"B0";
	TSELECTION <= X"A";
	Tcin <= '0';
	WAIT for 10 ns;
        assert(TF= x"E1" or Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;

        TA <= X"F0";
	TB <= X"0B";
	TSELECTION <= X"E";
	Tcin <= '1';
	WAIT for 10 ns;
        assert(TF= x"F8" or Tcout='1') report "A :"& to_hstring(TA)
				& "B :"& to_hstring(TB)
				& "F :"& to_hstring(TF)
                               severity error;




	

WAIT;
END PROCESS;


END ARC; 
