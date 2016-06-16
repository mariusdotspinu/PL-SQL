DROP PROCEDURE curbaGauss;
/
CREATE OR REPLACE PROCEDURE curbaGauss(p_ID_curs IN CHAR , p_schita OUT VARCHAR2)
AS

v_numar_total_note NUMBER := 0;

v_numar_note_5 NUMBER := 0;

v_numar_note_6 NUMBER := 0;

v_numar_note_7 NUMBER := 0;

v_numar_note_8 NUMBER := 0;

v_numar_note_9 NUMBER := 0;

v_numar_note_10 NUMBER := 0;

v_rata_5 VARCHAR2(20) := '';

v_rata_6 VARCHAR2(20) := '';

v_rata_7 VARCHAR2(20) := '';

v_rata_8 VARCHAR2(20) := '';

v_rata_9 VARCHAR2(20) := '';

v_rata_10 VARCHAR2(20) := '';

v_numar_note_bigeq_5 NUMBER := 0;

v_nume_materie VARCHAR2(20) := null;

v_it INTEGER := 0;

v_rata_promov FLOAT;

BEGIN

SELECT * INTO v_nume_materie FROM (
                                  SELECT titlu_curs 
                                  FROM cursuri
                                  WHERE id_curs = p_ID_curs
                                  );
                                  
SELECT * INTO v_numar_total_note FROM (
                                      SELECT COUNT (n.valoare)
                                      FROM cursuri
                                      JOIN note n on n.id_curs = p_id_curs
                                      );
                                      
SELECT * INTO v_numar_note_bigeq_5 FROM (
                                    SELECT COUNT (n.valoare)
                                    FROM cursuri
                                    JOIN note n on n.id_curs = p_id_curs
                                    WHERE n.valoare >= 5
                                    );

SELECT * INTO v_numar_note_5 FROM (
                                    SELECT COUNT (n.valoare)
                                    FROM cursuri
                                    JOIN note n on n.id_curs = p_id_curs
                                    WHERE n.valoare = 5
                                    );
SELECT * INTO v_numar_note_6 FROM (
                                    SELECT COUNT (n.valoare)
                                    FROM cursuri
                                    JOIN note n on n.id_curs = p_id_curs
                                    WHERE n.valoare = 6
                                    );
                                  
SELECT * INTO v_numar_note_7 FROM (
                                    SELECT COUNT (n.valoare)
                                    FROM cursuri
                                    JOIN note n on n.id_curs = p_id_curs
                                    WHERE n.valoare = 7
                                    );


SELECT * INTO v_numar_note_8 FROM (
                                    SELECT COUNT (n.valoare)
                                    FROM cursuri
                                    JOIN note n on n.id_curs = p_id_curs
                                    WHERE n.valoare = 8
                                    );

SELECT * INTO v_numar_note_9 FROM (
                                    SELECT COUNT (n.valoare)
                                    FROM cursuri
                                    JOIN note n on n.id_curs = p_id_curs
                                    WHERE n.valoare = 9
                                    );

SELECT * INTO v_numar_note_10 FROM (
                                    SELECT COUNT (n.valoare)
                                    FROM cursuri
                                    JOIN note n on n.id_curs = p_id_curs
                                    WHERE n.valoare = 10
                                    );

v_rata_promov := (v_numar_note_bigeq_5 / v_numar_total_note) * 100;


FOR v_it in 1..(v_numar_note_5/v_numar_total_note)*10 LOOP
   v_rata_5 := v_rata_5 || '*';
END LOOP;

FOR v_it in 1..(v_numar_note_6/v_numar_total_note)*10 LOOP
   v_rata_6 := v_rata_6 || '*';   
END LOOP;

FOR v_it in 1..(v_numar_note_7/v_numar_total_note)*10 LOOP
   v_rata_7 := v_rata_7 || '*';
END LOOP;

FOR v_it in 1..(v_numar_note_8/v_numar_total_note)*10 LOOP
   v_rata_8 := v_rata_8 || '*';
END LOOP;

FOR v_it in 1..(v_numar_note_9/v_numar_total_note)*10 LOOP
   v_rata_9 := v_rata_9 || '*';
END LOOP;

FOR v_it in 1..(v_numar_note_10/v_numar_total_note)*10 LOOP
   v_rata_10 := v_rata_10 || '*';   
END LOOP;

p_schita := 'Materia : '|| v_nume_materie || CHR(10)||'Rata promovabilitate ' || v_rata_promov || '%' || CHR(10) || 'Nota 5 : ' || v_rata_5 || CHR(10) || 'Nota 6: ' || v_rata_6 || CHR(10) || 'Nota 7: ' || v_rata_7 ||CHR(10)||
            'Nota 8: ' || v_rata_8 || CHR(10) || 'Nota 9: ' || v_rata_9 ||CHR(10) || 'Nota 10: ' || v_rata_10;

END curbaGauss;
/

set serveroutput on;

DECLARE

curba CLOB;

BEGIN 

curbaGauss(p_ID_curs =>'24',p_schita => curba);

DBMS_OUTPUT.PUT_LINE(curba);

END;
