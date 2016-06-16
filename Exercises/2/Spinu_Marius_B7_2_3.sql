set serveroutput on;
DECLARE
 v_nr_zile NUMBER(10);
BEGIN
 SELECT MAX(data_nastere) - MIN(data_nastere) INTO v_nr_zile FROM studenti;
 DBMS_OUTPUT.PUT_LINE('Nr zile ' || v_nr_zile);

EXCEPTION
   WHEN no_data_found THEN
      DBMS_OUTPUT.PUT_LINE('Nu sunt date');
END;
