set serveroutput on;
DECLARE
 v_nume_prof profesori.nume%TYPE;
 v_nota note.valoare%TYPE;
BEGIN
 SELECT * INTO v_nume_prof FROM (
                                SELECT nume 
                                FROM profesori 
                                JOIN didactic d on d.id_prof = profesori.id_prof 
                                GROUP BY d.id_prof,nume 
                                HAVING COUNT(d.id_curs) = (SELECT MAX(COUNT(id_curs)) FROM didactic GROUP BY id_curs)
                                ) WHERE ROWNUM = 1;
                                                                                                  
 DBMS_OUTPUT.PUT_LINE('Nume prof: ' || v_nume_prof || 'charactere ' || length(trim(v_nume_prof)));
        
 SELECT * INTO v_nota FROM (
                            SELECT valoare 
                            FROM note 
                            JOIN didactic d on d.id_curs = note.id_curs 
                            JOIN profesori p on p.id_prof = d.id_prof
                            WHERE valoare = 10 AND p.nume = v_nume_prof 
                            GROUP BY valoare
                            );
           
      
IF (v_nota = 10)
    THEN
      DBMS_OUTPUT.PUT_LINE('Da');
END IF;           
                            
EXCEPTION
   WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE('Nu');
END;

