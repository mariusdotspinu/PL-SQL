ALTER TABLE studenti
MODIFY (nume varchar2(20),
        prenume varchar2(20)
        );
/
CREATE OR REPLACE PROCEDURE insertInNote(p_an IN NUMBER, p_nr_matricol IN CHAR) AS

v_nota_random note.valoare%TYPE;

v_course_id cursuri.id_curs%TYPE;

CURSOR getCoursesId IS

SELECT id_curs
FROM cursuri
WHERE an < p_an;

BEGIN 

  OPEN getCoursesId;
    
    LOOP
    
    FETCH getCoursesId into v_course_id;
    
    EXIT WHEN getCoursesId%NOTFOUND;
    
    v_nota_random := 4 + MOD(ABS(DBMS_RANDOM.RANDOM),10);
    
    INSERT INTO note VALUES (p_nr_matricol , v_course_id , v_nota_random,NULL);
    
    END LOOP;
    
  CLOSE getCoursesId;

  
END insertInNote;
/


CREATE OR REPLACE PROCEDURE generateStudents AS

v_nume studenti.nume%TYPE;

v_prenume studenti.prenume%TYPE;

v_grupa_semian CHAR(1);

v_grupa_numar CHAR(1);

v_grupa studenti.grupa%TYPE;

v_an studenti.an%TYPE;

v_bursa studenti.bursa%TYPE;

v_id INTEGER := 123;

v_contor INTEGER:= 1;


CURSOR getNume IS

SELECT DISTINCT n
FROM nume;

CURSOR getPrenume IS

SELECT DISTINCT p
FROM prenume;

BEGIN

OPEN getNume;

  LOOP

    FETCH getNume into v_nume;

    EXIT WHEN v_contor = 3000;

    OPEN getPrenume;

      LOOP

      FETCH getPrenume into v_prenume;

      EXIT WHEN v_contor = 3000 OR getPrenume%NOTFOUND;

        v_an := 1 + MOD(ABS(DBMS_RANDOM.RANDOM),3);

          IF ((1 + MOD(ABS(DBMS_RANDOM.RANDOM),2)) = 1)
                THEN
                   v_grupa_semian := 'B';
                ELSE
                   v_grupa_semian := 'A';
    
          END IF;

         v_grupa_numar := to_char(1 + MOD(ABS(DBMS_RANDOM.RANDOM),7));

         v_grupa := v_grupa_semian || v_grupa_numar;

         v_bursa := 1 + MOD(ABS(DBMS_RANDOM.RANDOM), 450);

         INSERT INTO studenti VALUES(to_char(v_id + v_contor),v_nume,v_prenume,v_an,v_grupa,v_bursa,NULL);
         
         IF(v_an > 1)
           THEN
           insertInNote(p_an => v_an , p_nr_matricol => to_char(v_id + v_contor));
         END IF;
         
         v_contor := v_contor + 1;

        END LOOP;

    CLOSE getPrenume;

  END LOOP;

CLOSE getNume;



END generateStudents;
/

BEGIN

generateStudents();

END;
/
COMMIT;

