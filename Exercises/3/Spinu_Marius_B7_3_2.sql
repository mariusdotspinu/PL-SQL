DROP TABLE NUMBERS
/
DROP TABLE SENTENCES
/

CREATE TABLE NUMBERS
(
numar NUMBER(2)  NOT NULL
);

CREATE TABLE SENTENCES
(
sentence VARCHAR2 (50) NOT NULL
);


DECLARE

v_random_value numbers.numar%TYPE;
v_aux numbers.numar%TYPE;
v_contor INTEGER := 0;

BEGIN

WHILE (v_contor <= 10) LOOP

v_random_value := 21 + MOD(ABS(DBMS_RANDOM.RANDOM), 79);

BEGIN

SELECT * INTO v_aux FROM NUMBERS WHERE v_random_value = numar;

EXCEPTION

   WHEN no_data_found THEN
      v_aux := NULL;
END;

IF (v_aux IS NULL) --daca nu se afla in tabel introduc valoarea
       THEN
            INSERT INTO NUMBERS VALUES(v_random_value);
            COMMIT;
            v_contor := v_contor + 1;
END IF;

END LOOP;

END;

/

DECLARE 


CURSOR myCursor IS

SELECT NUMBERS.numar ,n1.numar
FROM NUMBERS 
join NUMBERS n1 on n1.numar > NUMBERS.numar; --daca numarul e mai mare din tabela self joined atunci TRUE else nu se combina

v_first_number numbers.numar%TYPE;
v_second_number numbers.numar%TYPE;
clone_first INTEGER;
clone_second INTEGER;

BEGIN

OPEN myCursor;

LOOP

FETCH myCursor INTO v_first_number , v_second_number;

EXIT when myCursor%NOTFOUND;

clone_first := v_first_number;
clone_second := v_second_number;

--Nichomachus

 WHILE (clone_first != clone_second) LOOP
 
  IF(clone_first > clone_second)
      THEN
        clone_first := clone_first - clone_second;
  END IF;
   
   IF (clone_second > clone_first)
      THEN
        clone_second := clone_second - clone_first;
   END IF;
   
 END LOOP;

  IF (clone_first != 1)
      THEN
           INSERT INTO SENTENCES VALUES('CMMDC al numerelor '|| v_first_number ||' si ' || v_second_number|| ' este ' ||clone_first||'.');
           COMMIT;
  
  END IF;

END LOOP;

CLOSE myCursor;

END;
