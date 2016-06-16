--concatenare in afisare
set serveroutput on;
DECLARE
  v_nume_student studenti.nume%TYPE;
  v_prenume_student studenti.prenume%TYPE;
BEGIN
SELECT * INTO v_nume_student ,v_prenume_student FROM(
                                                    SELECT nume,prenume  
                                                    FROM studenti 
                                                    ORDER BY dbms_random.value
                                                    )  
                                                    WHERE rownum = 1;
  DBMS_OUTPUT.PUT_LINE('Nume,prenume: ' || v_nume_student || ' ' || v_prenume_student);
  
  EXCEPTION
   WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE('Nu sunt date');
END;
/

--concatenare in select
set serveroutput on;
DECLARE
  v_nume_intreg VARCHAR2(1000);
BEGIN
SELECT * INTO v_nume_intreg FROM(
                                SELECT nume|| ' ' ||prenume  
                                FROM studenti 
                                ORDER BY dbms_random.value
                                )  
                                WHERE rownum = 1;
  DBMS_OUTPUT.PUT_LINE('Nume,prenume: ' || v_nume_intreg);
  
EXCEPTION
   WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE('Nu sunt date');
END;
