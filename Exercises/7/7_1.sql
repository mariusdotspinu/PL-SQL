--ex1
CREATE OR REPLACE TYPE harta FORCE AS OBJECT
(
locatie varchar2(1000),
artefact varchar2(1000),
autor varchar2(1000),
number_of_artefacts INTEGER,
CONSTRUCTOR FUNCTION harta(locatie VARCHAR2 ,artefact VARCHAR2, autor VARCHAR2) RETURN SELF AS RESULT,

NOT FINAL MEMBER PROCEDURE set_locatie(locatie IN VARCHAR2, artefact IN VARCHAR2),
MEMBER FUNCTION get_artefact RETURN VARCHAR2 ,
MEMBER PROCEDURE add_artefact(nume VARCHAR2),

MAP MEMBER FUNCTION get_number_of_artefacts RETURN INTEGER

)NOT FINAL
/

CREATE OR REPLACE TYPE BODY harta AS
   
   MEMBER PROCEDURE add_artefact(nume VARCHAR2) IS
   BEGIN
        SELF.artefact := nume;
        SELF.number_of_artefacts := SELF.number_of_artefacts + 1;
   END;

   MEMBER PROCEDURE set_locatie(locatie IN VARCHAR2, artefact IN VARCHAR2) IS
   BEGIN
        SELF.locatie := locatie;
        SELF.artefact := artefact;
        SELF.number_of_artefacts := SELF.number_of_artefacts + 1;
   END;
   
   MEMBER FUNCTION get_artefact
   RETURN VARCHAR2
   IS
   BEGIN
       IF SELF.artefact IS NOT NULL 
          THEN
          RETURN SELF.artefact;
       ELSE
          RETURN '0';
       END IF;
   END;
   
   MAP MEMBER FUNCTION get_number_of_artefacts
   RETURN INTEGER
   IS
   BEGIN
       
       RETURN SELF.number_of_artefacts;
       
   END;
   
   CONSTRUCTOR FUNCTION harta(locatie IN VARCHAR2,artefact VARCHAR2,autor IN VARCHAR2)
      RETURN SELF AS RESULT
   IS
   BEGIN
       SELF.locatie := locatie;
       SELF.artefact := artefact;
       SELF.autor := autor;
       SELF.number_of_artefacts := 1;
       
       RETURN;
   END;
   
END;
/




--ex 3
CREATE OR REPLACE TYPE art_info UNDER harta
(
   coord_x FLOAT,
   coord_y FLOAT,
   art VARCHAR2(1000),
   OVERRIDING member procedure set_locatie(locatie IN VARCHAR2, artefact IN VARCHAR2),
   member procedure set_locatie(x FLOAT,y FLOAT  , artefact VARCHAR2)--ex4
)
/
CREATE OR REPLACE TYPE BODY art_info AS
  OVERRIDING member procedure set_locatie(locatie VARCHAR2 , artefact VARCHAR2) IS
  BEGIN
   
   DBMS_OUTPUT.PUT_LINE('Artefactul : ' || artefact ||' se afla la : ' ||locatie);
      
  END set_locatie;
  
  member procedure set_locatie(x FLOAT,y FLOAT  , artefact VARCHAR2) IS--ex4
  BEGIN
   SELF.coord_x := x;
   SELF.coord_y := y;
   SELF.art := artefact;
      
  END set_locatie;
  
  
END;
/
DROP TYPE art_info;
--pentru a suprascrie o metoda trebuie ca signatura acesteia sa contina NOT FINAL



--ex2
CREATE TABLE harta_obj (map_id INTEGER, artefact harta);
/

set serveroutput on;

DECLARE

  v_harta_1 harta := harta('india','manuscris','unknown');
  v_harta_2 harta := harta('japonia','sabie','shogun');
  v_harta_3 harta := harta('cairo','mumie','unknown');
  v_harta_4 harta := harta('hawaii','oase','cineva sec 18');
  v_harta_5 harta := harta('hampshire','vase','regele arthur');
  
  
  obj harta_obj.artefact%type;
  

BEGIN

 v_harta_5.add_artefact(nume => 'pantaloni');
  
 INSERT INTO harta_obj VALUES (1,v_harta_1);
 INSERT INTO harta_obj VALUES (2,v_harta_2);
 INSERT INTO harta_obj VALUES (3,v_harta_3);
 INSERT INTO harta_obj VALUES (4,v_harta_4);
 INSERT INTO harta_obj VALUES (5,v_harta_5);
 COMMIT;



 FOR obj in (SELECT artefact AS ar FROM harta_obj ORDER BY artefact DESC)
   LOOP
     DBMS_OUTPUT.PUT_LINE(obj.ar.locatie ||' '|| obj.ar.artefact ||' '|| obj.ar.autor ||' '||obj.ar.number_of_artefacts ||  CHR(13) || CHR(10));
   END LOOP;

END;
/
DROP TABLE harta_obj;
/
