-- MULTIPLEXOR --
ENTITY mux4a1 IS 
PORT ( a,b,c,d,sel1,sel0: IN BIT;
      f: OUT BIT);
END mux4a1;

ARCHITECTURE logicaretard OF mux4a1 IS
BEGIN 

f <= (((NOT sel1) AND (NOT sel0)) AND a) OR
     ((NOT sel1) AND sel0 AND b) OR
     (sel1 AND (NOT sel0) AND c) OR
     (sel1 AND sel0 AND d) AFTER 2 ns;
END logicaretard;

ARCHITECTURE ifthen OF mux4a1 IS
BEGIN
PROCESS (a,b,c,d,sel1,sel0)
BEGIN
IF sel1 = '0' AND sel0 = '0' THEN f <= a AFTER 2 ns;
ELSIF sel1 = '0' AND sel0 = '1' THEN f <= b AFTER 2 ns;
ELSIF sel1 = '1' AND sel0 = '0' THEN f <= c AFTER 2 ns;
ELSIF sel1 = '1' AND sel0 = '1' THEN f <= d AFTER 2 ns;
END IF;
END PROCESS;
END ifthen;


--FF--

ENTITY FF_D IS
PORT (D,Clk,Pre: IN BIT;
      Q: OUT BIT);
END FF_D;

ARCHITECTURE ifthen of FF_D IS
   SIGNAL qint: BIT;
BEGIN
   PROCESS (D,Clk,Pre)
BEGIN 
IF Pre = '0' THEN qint <= '1' AFTER 2 ns;
ELSIF Clk'EVENT AND Clk = '1' THEN qint <= D AFTER 2 ns;
END IF;
END PROCESS;
Q <= qint;
END ifthen;


-- REGISTRE--
ENTITY registre IS
PORT( a2,a1,a0,sel1,sel0,E,Clk: IN BIT;
     Q2,Q1,Q0: OUT BIT);
END registre;

ARCHITECTURE estructural OF registre IS
COMPONENT mux4a1 IS
PORT(a,b,c,d,sel1,sel0 : IN BIT;
     f: OUT BIT);
END COMPONENT;

COMPONENT FF_D IS
PORT(D,Clk,Pre: IN BIT;
     Q: OUT BIT);
END COMPONENT;
--sortides internes: (q_ per els ff,mux_ per el mux)--
SIGNAL q_2,q_1,q_0,mux_2,mux_1,mux_0: BIT;

FOR DUT1: mux4a1 USE ENTITY WORK.mux4a1(ifthen);
FOR DUT2: FF_D USE ENTITY WORK.FF_D(ifthen);
FOR DUT3: mux4a1 USE ENTITY WORK.mux4a1(ifthen);
FOR DUT4: FF_D USE ENTITY WORK.FF_D(ifthen);
FOR DUT5: mux4a1 USE ENTITY WORK.mux4a1(ifthen);
FOR DUT6: FF_D USE ENTITY WORK.FF_D(ifthen);

BEGIN
DUT1: mux4a1 PORT MAP('1',q_2,a2,E,sel1,sel0,mux_2);
DUT2: FF_D PORT MAP(mux_2,Clk,'1',q_2);
DUT3: mux4a1 PORT MAP('1',q_1,a1,q_2,sel1,sel0,mux_1);
DUT4: FF_D PORT MAP(mux_1,Clk,'1',q_1);
DUT5: mux4a1 PORT MAP('1',q_0,a0,q_1,sel1,sel0,mux_0);
DUT6: FF_D PORT MAP(mux_0,Clk,'1',q_0);

Q2 <= q_2;
Q1 <= q_1;
Q0 <= q_0;
END estructural;

--BANC DE PROVES--

ENTITY bdp IS
END bdp;

ARCHITECTURE test OF bdp IS
COMPONENT registre IS
PORT( a2,a1,a0,sel1,sel0,E,Clk: IN BIT;
     Q2,Q1,Q0: OUT BIT);
END COMPONENT;
SIGNAL a2,a1,a0,sel1,sel0,E,Clk,Q2,Q1,Q0: BIT;

FOR DUT1: registre USE ENTITY WORK.registre(estructural);
BEGIN
DUT1: registre PORT MAP(a2,a1,a0,sel1,sel0,E,Clk,Q2,Q1,Q0);

PROCESS(a2,a1,a0,sel1,sel0,E,Clk,Q0,Q1,Q2)
BEGIN 
a2 <= NOT a2 AFTER 80 ns;
a1 <= NOT a1 AFTER 40 ns;
a0 <= NOT a0 AFTER 20 ns;
E <= NOT E AFTER 200 ns;
sel1 <= NOT sel1 AFTER 30 ns;
sel0 <= NOT sel0 AFTER 15 ns;
Clk <= NOT Clk AFTER 50 ns;
END PROCESS;
END test;
    
