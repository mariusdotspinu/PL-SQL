DROP PROCEDURE averageValues;
/
CREATE OR REPLACE PROCEDURE  averageValues (p_ID IN CHAR ,p_value_2014 OUT FLOAT, p_value_2015 OUT FLOAT) AS

v_average_2014 FLOAT := null;
v_average_2015 FLOAT := null;
BEGIN

SELECT * INTO v_average_2014 FROM (SELECT AVG(valoare) 
                                                  FROM NOTE
                                                  WHERE to_char(data_notare,'dd/mm/yyyy') LIKE '%2014'AND 
                                                        nr_matricol = p_ID);
                                                        
SELECT * INTO v_average_2015 FROM (SELECT AVG(valoare) 
                                                  FROM NOTE
                                                  WHERE to_char(data_notare,'dd/mm/yyyy') LIKE '%2015'AND 
                                                        nr_matricol = p_ID);

IF (v_average_2014 IS NULL)
    THEN
    p_value_2014 := 0;
    
ELSE IF (v_average_2014 IS NOT NULL)
     THEN
     p_value_2014 := v_average_2014;
END IF;

END IF;

IF (v_average_2015 IS NULL)
    THEN
    p_value_2015 := 0;
    
ELSE IF (v_average_2015 IS NOT NULL)
     THEN
     p_value_2015 := v_average_2015;
     
END IF;

END IF;

END averageValues;
/

set serveroutput on;

DECLARE 
value_1 FLOAT;
value_2 FLOAT;

BEGIN
averageValues(p_ID =>'111',p_value_2014 => value_1,p_value_2015 => value_2);

DBMS_OUTPUT.PUT_LINE(value_1);
DBMS_OUTPUT.PUT_LINE(value_2);

END;
