--FLIP-FLOP--
--ENTITY FF_JK
ENTITY FF_JK IS
  PORT(
    J, K, clock: IN BIT;
    Q: OUT BIT);
END FF_JK;

--ARCHITECTURE IFTHEN OF FF_D
ARCHITECTURE ifthen OF FF_JK IS
  SIGNAL qint: BIT;
  BEGIN
    PROCESS (J, K, clock)
      BEGIN

        IF CLOCK'EVENT AND clock = '1' THEN 
          IF J = '0' AND K = '0' THEN qint <= qint AFTER 3 ns;
          ELSIF J = '0' AND K = '1' THEN qint <= '0' AFTER 3 ns;
          ELSIF J = '1' AND K = '0' THEN qint <= '1' AFTER 3 ns;
          ELSE qint <= NOT qint AFTER 3 ns;
          END IF;
        END IF;
    END PROCESS;
    Q <= qint;
END ifthen;


--ENTITY XNOR2
ENTITY xnor2 IS
  PORT(
    a, b: IN BIT; 
    z: OUT BIT);
END xnor2;

--ARCHITECTURE LOGICA_RETARD OF XNOR2
ARCHITECTURE logica_retard OF xnor2 IS
  BEGIN
    z <= a XNOR b AFTER 3 ns;
END logica_retard;

--ENTITY AND2
ENTITY and2 IS
  PORT(
    a, b: IN BIT;
    z: OUT BIT);
END and2;

--ARCHITECTURE LOGICA_RETARD OF AND2
ARCHITECTURE logica_retard OF and2 IS
  BEGIN
    z <= a AND b AFTER 3 ns;
END logica_retard;

--CIRCUIT--
--ENTITY CIRCUIT_PR05
ENTITY circuit_pr05 IS
  PORT(
    clock, X: IN BIT;
    Z2, Z1, Z0: OUT BIT);
END circuit_pr05;

--ARCHITECTURE ESTRUCTURAL OF circuit_pr05
ARCHITECTURE estructural OF circuit_pr05 IS
  
 
  COMPONENT FF_JK IS
    PORT(
      J, K, clock: IN BIT;
      Q: OUT BIT);
  END COMPONENT;

  COMPONENT and2 IS
    PORT(
      a, b: IN BIT;
      z: OUT BIT);
  END COMPONENT;
  
  COMPONENT xnor2 IS
    PORT(
      a, b: IN BIT;
      z: OUT BIT);
  END COMPONENT;
  
  --INTERNAL SIGNALS
  SIGNAL xnor2_sort, and2_sort: BIT; 
  SIGNAL q_2, q_1, q_0: BIT;

  FOR DUT1: xnor2 USE ENTITY WORK.xnor2(logica_retard);
  FOR DUT2: and2 USE ENTITY WORK.and2(logica_retard);
  FOR DUT3: FF_JK USE ENTITY WORK.FF_JK(ifthen);
  FOR DUT4: FF_JK USE ENTITY WORK.FF_JK(ifthen);
  FOR DUT5: FF_JK USE ENTITY WORK.FF_JK(ifthen);
  

  BEGIN
    DUT1: xnor2 PORT MAP(X, q_0, xnor2_sort);
    DUT2: and2 PORT MAP(q_1, xnor2_sort, and2_sort); 
    DUT3: FF_JK PORT MAP(and2_sort, and2_sort, clock, q_2);
    DUT4: FF_JK PORT MAP(xnor2_sort, xnor2_sort, clock, q_1);
    DUT5: FF_JK PORT MAP(X, '1', clock, q_0);  
    

  Z2 <= q_2;
  Z1 <= q_1;
  Z0 <= q_0;
END estructural;

--TESTBENCH--
--ENTITY OF TESTBENCH
ENTITY bdp_pr05 IS
END bdp_pr05;

--ARCHITECTURE OF TESTBENCH
ARCHITECTURE test_pr05 OF bdp_pr05 IS
  

  COMPONENT circuit_pr05 IS
    PORT(
      clock, X: IN BIT;
      Z2, Z1, Z0: OUT BIT);
  END COMPONENT;
  
  --ASSIGNING SIGNALS 
  --INPUTS
  SIGNAL clock, X: BIT;
  --OUTPUTS 
  SIGNAL Z2, Z1, Z0: BIT; 
    
  FOR DUT1: circuit_pr05 USE ENTITY WORK.circuit_pr05(estructural);
  

  BEGIN
    DUT1: circuit_pr05 PORT MAP(clock, X, Z2, Z1, Z0); 
      
      --SETTING UP INPUT VARIATION TIMES
      clock <= NOT clock AFTER 25 ns;
      X <= NOT X AFTER 150 ns;
END test_pr05;


--Al tenir a les portes lògiques un retràs de 3 ns, depenent del temps de variació que tenen les entrades clock i X,
-- el programa calcula malament el resultat. (o sigui que és possible que en alguns estats on teoricament
--s'hauria d'incrementar en 2 el seu valor, s'incrementi en 3 o un valor no corresponent.

--el funcionament de la màquina sense fer servir portes lògiques amb retràs, i el resultat 
--és correcte ja que no hi ha cap error de càlcul.
