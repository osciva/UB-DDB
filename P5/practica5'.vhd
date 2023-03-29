ENTITY portaand2 IS
PORT( 
a, b: IN BIT; 
z: OUT BIT);
END portaand2;

--ARCHITECTURES OF AND2:

ARCHITECTURE logicaretard OF portaand2 IS
BEGIN
z <= a AND b AFTER 3 ns;
END logicaretard;


ENTITY portaor2 IS
PORT( 
a, b: IN BIT; 
z: OUT BIT);
END portaor2;

ARCHITECTURE logicaretard OF portaor2 IS
BEGIN
z <= a OR b AFTER 3 ns;
END logicaretard;

ENTITY portaxor2 IS
PORT (
a, b: IN BIT;
z: OUT BIT);
END portaxor2;

--ARCHITECTURES OF XOR2:


ARCHITECTURE logicaretard OF portaxor2 IS
BEGIN
z <= a XOR b AFTER 3 ns;
END logicaretard;



ENTITY FF_T IS
PORT(
T, Clk, Pre: IN BIT;
Q: OUT BIT);
END FF_T;

ARCHITECTURE ifthen OF FF_T IS
  SIGNAL qint: BIT;
  BEGIN
    PROCESS(T, Clk, Pre)
      BEGIN
       
        IF Pre = '0' THEN qint <= '1' AFTER 3 ns;
        --FF TOGGLE POSITIVE EDGE-TRIGGERED
        ELSIF Clk'EVENT AND Clk = '0' THEN
            IF T = '1' THEN qint <= NOT qint AFTER 3 ns;
            ELSIF T = '0' THEN qint <= qint AFTER 3 ns;
            END IF;
        END IF;
    END PROCESS;
    Q <= qint;
   
END ifthen;

ENTITY FF_JK IS
  PORT(
    J, K, Clk: IN BIT;
    Q: OUT BIT);
END FF_JK;

--ARCHITECTURE OF FF_JK
ARCHITECTURE ifthen OF FF_JK IS
  SIGNAL qint: BIT;
  BEGIN
    PROCESS (J, K, Clk)
      BEGIN
        
        --FF JK POSITIVE EDGE-TRIGGERED
        IF Clk'EVENT AND Clk = '1' THEN
            IF J = '0' AND K = '0' THEN qint <= qint AFTER 3 ns;
            ELSIF J = '0' AND K = '1' THEN qint <= '0' AFTER 3 ns;
            ELSIF J = '1' AND K = '0' THEN qint <= '1' AFTER 3 ns;
            ELSIF J = '1' AND K = '1' THEN qint <= NOT qint AFTER 3 ns;
            END IF;
        END IF;
    END PROCESS;
  Q <= qint;

END ifthen;



ENTITY sumador IS
  PORT(
    a, b, c: IN BIT;
    s, c1: OUT BIT);
END sumador;

ARCHITECTURE estructural of sumador IS

COMPONENT portaand2 IS
PORT (
a, b: IN BIT; 
z: OUT BIT);
END COMPONENT;

COMPONENT portaor2 IS
PORT (
a, b: IN BIT; 
z: OUT BIT);
END COMPONENT;

COMPONENT portaxor2 IS
PORT (
a, b: IN BIT; 
z: OUT BIT);
END COMPONENT;

SIGNAL sort_xor, sort_and2_ba, sort_or2_ab, sort_and2_sortc: BIT;

FOR DUT1: portaxor2 USE ENTITY WORK.portaxor2(logicaretard);
FOR DUT2: portaxor2 USE ENTITY WORK.portaxor2(logicaretard);
FOR DUT3: portaand2 USE ENTITY WORK.portaand2(logicaretard);
FOR DUT4: portaor2 USE ENTITY WORK.portaor2(logicaretard);
FOR DUT5: portaand2 USE ENTITY WORK.portaand2(logicaretard);
FOR DUT6: portaor2 USE ENTITY WORK.portaor2(logicaretard);

BEGIN
--ASSIGNNING SIGNALS
DUT1: portaxor2 PORT MAP(a, b, sort_xor);
DUT2: portaxor2 PORT MAP(sort_xor, c, s);
DUT3: portaand2 PORT MAP(a, b, sort_and2_ba);
DUT4: portaor2 PORT MAP(a, b, sort_or2_ab);
DUT5: portaand2 PORT MAP(sort_or2_ab, c, sort_and2_sortc);
DUT6: portaor2 PORT MAP(sort_and2_ba, sort_and2_sortc, c1);

END estructural;

ENTITY circuit IS
  PORT(
    Clk, X, Y: IN BIT;
    Z: OUT BIT);
END circuit;


ARCHITECTURE estructural of circuit IS

COMPONENT FF_T IS
PORT (
T, Clk, Pre: IN BIT;
Q: OUT BIT);
END COMPONENT;

COMPONENT sumador IS
PORT (
 a, b, c: IN BIT;
 s, c1: OUT BIT);
END COMPONENT;

COMPONENT FF_JK IS
PORT (
J, K, Clk: IN BIT;
Q: OUT BIT);
END COMPONENT;

SIGNAL sort_q1, sort_cout, sort_s: BIT;

FOR DUT1: FF_T USE ENTITY WORK.FF_T(ifthen);
FOR DUT2: sumador USE ENTITY WORK.sumador(estructural);
FOR DUT3: FF_JK USE ENTITY WORK.FF_JK(ifthen);


BEGIN
--ASSIGNNING SIGNALS
DUT1: FF_T PORT MAP(x, y, Clk, sort_q1);
DUT2: sumador PORT MAP(Clk, Clk, sort_q1, sort_cout, sort_s);
DUT3: FF_JK PORT MAP(sort_cout, sort_s, Clk, z);


END estructural;

ENTITY bdp_Pr05b IS
END bdp_Pr05b;

ARCHITECTURE test_Pr05b OF bdp_Pr05b IS

--COMPONENT TO TEST
COMPONENT circuit IS
PORT (
    Clk, X, Y: IN BIT;
    Z: OUT BIT);
END COMPONENT;

--ASSIGNING SIGNALS TO TEST OUT LOGICA AND ESTRUCTURAL STRUCTURES
SIGNAL Clk, X, Y: BIT;
SIGNAL Z: BIT;


FOR DUT1: circuit USE ENTITY WORK.circuit(estructural);


BEGIN
DUT1: circuit PORT MAP(Clk, X, Y, Z);


Clk <= NOT Clk after 50 ns;
X <= '1' ,'0' AFTER 120 ns, '1' AFTER 150 ns, '0' AFTER 240 ns, '1' AFTER 310 ns, '0' AFTER 340 ns, '1' AFTER 420 ns, '0' AFTER 510 ns, '1' AFTER 540 ns, '0' AFTER 570 ns, '1' AFTER 590 ns,  '0' AFTER 660 ns,  '1' AFTER 720 ns;
Y <= '1', '0' AFTER 60 ns, '1' AFTER 80 ns, '0' AFTER 360 ns, '1' AFTER 440 ns, '0' AFTER 630 ns, '1' AFTER 690 ns;

END test_Pr05b;
