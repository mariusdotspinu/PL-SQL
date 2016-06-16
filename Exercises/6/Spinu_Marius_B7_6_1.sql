ALTER TABLE studenti
DROP CONSTRAINT uniq;
/
ALTER TABLE studenti
ADD CONSTRAINT uniq UNIQUE (nr_matricol);
/
CREATE TABLE studenti_transferati(
  nr_matricol CHAR(4) NOT NULL,
  nume VARCHAR2(10),
  prenume VARCHAR2(10)
)
/
INSERT INTO studenti_transferati VALUES ('111', 'alexei', 'robert');
INSERT INTO studenti_transferati VALUES ('112', 'lars', 'ulricht');
INSERT INTO studenti_transferati VALUES ('113', 'richard', 'harris');
INSERT INTO studenti_transferati VALUES ('114', 'eleanor', 'guthrie');
INSERT INTO studenti_transferati VALUES ('115', 'james', 'flint');

INSERT INTO studenti_transferati VALUES ('160', 'clint', 'eastwood');
INSERT INTO studenti_transferati VALUES ('161', 'mark', 'wahlberg');
INSERT INTO studenti_transferati VALUES ('162', 'penelope', 'cruz');
INSERT INTO studenti_transferati VALUES ('163', 'whatever', 'whatever');
INSERT INTO studenti_transferati VALUES ('164', '.', '.');

COMMIT;
/
CREATE OR REPLACE PACKAGE college IS 
     
     id_prof profesori.id_prof%TYPE;
     id_course didactic.id_curs%TYPE;
     
     PROCEDURE add_student (id_stud studenti.nr_matricol%type, name_stud studenti.nume%type, surname_stud studenti.prenume%type);
     PROCEDURE remove_student (id_stud studenti.nr_matricol%type);
     PROCEDURE insert_grade (id_stud studenti.nr_matricol%type, name_prof profesori.nume%type , title cursuri.titlu_curs%type, grade_value INTEGER);
     PROCEDURE get_sheet(id_stud studenti.nr_matricol%type);

     

END college;
/
CREATE OR REPLACE PACKAGE BODY college IS

     PROCEDURE add_student (id_stud studenti.nr_matricol%type,name_stud studenti.nume%type , surname_stud studenti.prenume%type) IS
         
         checker INTEGER;
         already_is exception;
        
        BEGIN
        
          SELECT * INTO checker from  (SELECT COUNT(*) FROM studenti where nr_matricol = id_stud);
                  
            IF (checker > 0) THEN
            raise already_is;
            ELSE
             INSERT INTO studenti VALUES(id_stud,name_stud,surname_stud ,NULL,NULL,NULL,NULL);
            END IF;
            
        exception
          when already_is then
                DBMS_OUTPUT.PUT_LINE('Nr matricol existent -> adaugati cu alt nr_matricol');
          
        END add_student;
      
     PROCEDURE remove_student(id_stud studenti.nr_matricol%type) IS
         
         checker INTEGER;
         not_nr exception;
     
        BEGIN
        
        
        SELECT * INTO checker from  (SELECT COUNT(*) FROM studenti where nr_matricol = id_stud);
                  
         IF (checker = 0) THEN
            raise not_nr;
         ELSE
         
           DELETE FROM studenti
           WHERE studenti.nr_matricol = id_stud;
        END IF;
        
        exception
         when not_nr then
                DBMS_OUTPUT.PUT_LINE('Nr matricol inexistent -> introduceti alt nr_matricol pentru stergere');
         
        END remove_student;
        
     
     PROCEDURE insert_grade (id_stud studenti.nr_matricol%type, name_prof profesori.nume%type , title cursuri.titlu_curs%type, grade_value INTEGER) IS
        
        id_dupa_materie cursuri.id_curs%type;
        materie_incorecta exception;
       
     
        BEGIN
        
           SELECT * INTO id_prof FROM(
                                       SELECT id_prof
                                       FROM profesori
                                       WHERE name_prof = profesori.nume
                                       );
                                       
           SELECT d.id_curs into id_course
           FROM didactic d
           WHERE d.id_prof = id_prof AND rownum < 2;

           DBMS_OUTPUT.PUT_LINE(id_prof || id_course);
 
            SELECT * INTO id_dupa_materie FROM(
                                              SELECT id_curs
                                              FROM cursuri
                                              WHERE titlu_curs = title
                                              );
                                            

         IF (id_dupa_materie = id_course) THEN                              
              INSERT INTO NOTE VALUES(id_stud , id_course,grade_value,NULL);
         ELSE
            raise materie_incorecta;
         END IF;
         
         exception
           when materie_incorecta then
             DBMS_OUTPUT.PUT_LINE('Acest profesor nu are materia : ' || title);
         
         
        END insert_grade;
    
    FUNCTION get_all_grades (id_stud studenti.nr_matricol%type) RETURN VARCHAR2 IS
       
       grade INTEGER := 0;
       course cursuri.titlu_curs%type;
       
       final_result VARCHAR2(1000) := '';
       
       CURSOR get_grades IS
       SELECT valoare,c.titlu_curs
       FROM note
       JOIN cursuri c on c.id_curs = note.id_curs
       WHERE note.nr_matricol = id_stud
       GROUP BY valoare,c.titlu_curs;
       
       BEGIN
       
        OPEN get_grades;
        final_result := final_result || 'Elevul cu nr mat. ' || id_stud || CHR(13) ||CHR(10); 
        LOOP
      
        FETCH get_grades INTO grade,course;
        EXIT WHEN get_grades%NOTFOUND;
        
        final_result := final_result || ' are nota : ' || to_char(grade) || ' la materia : ' || course || CHR(13) || CHR(10);
        
        END LOOP;
        
        CLOSE get_grades;
       
       
       return final_result;
       
       END get_all_grades;
       
    FUNCTION get_avg(id_stud studenti.nr_matricol%type) RETURN VARCHAR2 IS
    
      medie_an_1 FLOAT := 0;
      medie_an_2 FLOAT :=0;
      medie_an_3 FLOAT :=0;
      
      final_string VARCHAR2(1000) := '';
      BEGIN
         
                      /* SELECT * into medie_an_1,medie_an_2,medie_an_3 FROM(
                                                           SELECT AVG(note.valoare), AVG(n.valoare), AVG(n1.valoare)
                                                            FROM note
                                                            JOIN note n on n.nr_matricol = id_stud
                                                            JOIN note n1 on n1.nr_matricol = id_stud
                                                            JOIN cursuri c on c.id_curs = n.id_curs
                                                            JOIN cursuri c1 on c1.id_curs = note.id_curs
                                                            JOIN cursuri c2 on c2.id_curs = n1.id_curs
                                                            WHERE note.nr_matricol = id_stud AND c.an = 1 AND c1.an = 2 AND c2.an = 3
                                                            );
          */

        SELECT * INTO medie_an_1 FROM(
                                     SELECT AVG(note.valoare)
                                     FROM note
                                     JOIN cursuri c on c.id_curs = note.id_curs
                                     WHERE note.nr_matricol = id_stud AND c.an = 1
                                     );
                                     
        SELECT * INTO medie_an_2 FROM(
                                     SELECT AVG(note.valoare)
                                     FROM note
                                     JOIN cursuri c on c.id_curs = note.id_curs
                                     WHERE note.nr_matricol = id_stud AND c.an = 2
                                     );
                                     
        SELECT * INTO medie_an_3 FROM(
                                     SELECT AVG(note.valoare)
                                     FROM note
                                     JOIN cursuri c on c.id_curs = note.id_curs
                                     WHERE note.nr_matricol = id_stud AND c.an = 3
                                     );
                                                            
        final_string := final_string || 'Media : '|| to_char(medie_an_1) || ' an1 ' ||'Media : ' || to_char(medie_an_2) || ' an2 ' ||
        'Media : ' ||to_char(medie_an_3) || ' an3' ||CHR(13) ||CHR(10);
        
        return final_string;
        
    END get_avg;
        
    PROCEDURE get_sheet (id_stud studenti.nr_matricol%type) IS
       
       averages VARCHAR2(1000) :='';
       all_grades_courses VARCHAR2(1000) := '';
       
       BEGIN
       
       averages := get_avg(id_stud);
       all_grades_courses := all_grades_courses || get_all_grades(id_stud);
       
       DBMS_OUTPUT.PUT_LINE(averages || all_grades_courses);
       
       END get_sheet;
        
 END college;
/

CREATE OR REPLACE FUNCTION isDuplicate(id_stud studenti_transferati.nr_matricol%type) RETURN BOOLEAN IS

  checker INTEGER;

  BEGIN
     
     SELECT * INTO checker FROM (SELECT COUNT(*) FROM studenti where studenti.nr_matricol = id_stud);
     
     IF (checker > 0) THEN
         return TRUE;
     ELSE
         return FALSE;
     END IF;
      
  END isDuplicate;
/
set serveroutput on;
DECLARE

st_nume studenti_transferati.nume%type;
st_nr_mat studenti_transferati.nr_matricol%type;
st_prenume studenti_transferati.prenume%type;

CURSOR st_transf IS

SELECT *
FROM studenti_transferati;

BEGIN
college.add_student('144','Spinu','Marius');
college.remove_student('112');
college.insert_grade ('144','Frasinaru','Java',10);
college.get_sheet('111');

OPEN st_transf;

LOOP

  FETCH st_transf INTO st_nr_mat,st_nume,st_prenume;
  EXIT WHEN st_transf%NOTFOUND;
  
  IF (isDuplicate(st_nr_mat) = FALSE) THEN
     INSERT INTO studenti VALUES(st_nr_mat,st_nume,st_prenume,NULL,NULL,NULL,NULL);
  ELSE
     DBMS_OUTPUT.PUT_LINE('Studentul : ' || st_nume || ' contine un nr_matricol existent , prin urmare nu a fost introdus in bd ');
  END IF;
  
END LOOP;

CLOSE st_transf;


COMMIT;
END;
/
DROP TABLE studenti_transferati;
