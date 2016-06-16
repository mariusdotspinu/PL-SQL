DROP FUNCTION getSituation;
/
DROP FUNCTION getNote;
/

CREATE OR REPLACE FUNCTION getNote(p_nr_mat CHAR)
RETURN VARCHAR2 AS

v_nota note.valoare%TYPE;
v_all_Note VARCHAR2(30) := '';

CURSOR getN IS

SELECT valoare
FROM note
WHERE nr_matricol = p_nr_mat;

BEGIN

OPEN getN;

LOOP

FETCH getN into v_nota;

EXIT WHEN getN%NOTFOUND;

v_all_Note := v_all_Note || to_char(v_nota)||' , ';

END LOOP;

CLOSE getN;

return v_all_Note;

END;
/

CREATE OR REPLACE FUNCTION getSituation(p_ID CHAR)
RETURN varchar2 AS

v_situatie varchar2(1000);
v_value_2014 FLOAT;
v_value_2015 FLOAT;
v_note VARCHAR2(30);
BEGIN

averageValues(p_ID => p_ID, p_value_2014 =>v_value_2014,p_value_2015 =>v_value_2015);

IF (v_value_2014 = 0 AND v_value_2015 = 0)
         THEN
         v_situatie := 'Studentul cu id-ul ' || p_ID || ' nu are situatie ';
ELSE
         v_note := getNote(p_ID);
         v_situatie := 'Studentul cu id-ul ' || p_ID || ' are media pe 2014 ' || v_value_2014 || ' si media pe 2015 ' || v_value_2015 || ' si notele ' || v_note;
END IF;

return v_situatie;

END;

/

set serveroutput on;

DECLARE
v_situatie varchar2(1000);
v_id note.nr_matricol%TYPE;

CURSOR myC IS

SELECT DISTINCT trim(nr_matricol) from note;

BEGIN

OPEN myC;

LOOP

FETCH myC INTO v_id;

EXIT WHEN myC%NOTFOUND;

SELECT getSituation(v_id) INTO v_situatie FROM dual;

DBMS_OUTPUT.PUT_LINE(v_situatie);

END LOOP;

CLOSE myC;

END;