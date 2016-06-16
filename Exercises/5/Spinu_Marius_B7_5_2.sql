set serveroutput on;
DECLARE

v_lista_prenume persoane.prenume%TYPE;
v_nume persoane.nume%TYPE;
v_numar INTEGER := 0;
v_has_at_least_one BOOLEAN := FALSE;

CURSOR getList IS

 SELECT nume,prenume
 FROM persoane;

BEGIN

   OPEN getList;

  DBMS_OUTPUT.PUT_LINE('Persoanele sunt :' || CHR(10));

       LOOP

          FETCH getList into  v_nume,v_lista_prenume;

          EXIT WHEN getList%NOTFOUND;
          
        
          
          FOR i in v_lista_prenume.FIRST..v_lista_prenume.LAST LOOP
          
               IF (v_lista_prenume(i) like '%u%')
                      THEN
                      v_has_at_least_one := TRUE;
                      v_numar := v_numar + 1;
                      EXIT WHEN v_has_at_least_one = TRUE;
               END IF;
               
          END LOOP;
                      IF (v_has_at_least_one = TRUE)
                          THEN
                          DBMS_OUTPUT.PUT_LINE('Nume : ' || v_nume);
                          
                          FOR i in v_lista_prenume.FIRST..v_lista_prenume.LAST LOOP
                            DBMS_OUTPUT.PUT_LINE('Prenume : ' || v_lista_prenume(i));
                          
                          END LOOP;
                          
                          DBMS_OUTPUT.PUT_LINE(CHR(10));
                          
                      END IF;
                      
          v_has_at_least_one := FALSE;
          
       END LOOP;
       
    CLOSE getList;
      
      DBMS_OUTPUT.PUT_LINE('Nr persoane : ' || to_char(v_numar));
END;