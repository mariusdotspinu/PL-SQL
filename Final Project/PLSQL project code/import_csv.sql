CREATE OR REPLACE PROCEDURE import_csv IS
v_file utl_file.file_type;
buffer VARCHAR2(30000);
p_table_name VARCHAR2(40);
BEGIN
settle_for_import;

v_file := utl_file.fopen('CSVDIR', 'empdata.csv','r');

IF utl_file.is_open(v_file) THEN

LOOP
BEGIN
utl_file.get_line(v_file, buffer );

  IF buffer NOT LIKE '%,%' AND buffer NOT LIKE '%"%' AND buffer NOT LIKE '%CHR(10)||CHR(13)%'THEN
     p_table_name := trim(trailing chr(13) from buffer);
      DBMS_OUTPUT.PUT_LINE(length(p_table_name)||p_table_name);
      
   ELSE IF buffer LIKE '%,%' AND buffer NOT LIKE '%"%' THEN
       IF(length(p_table_name) > 0) THEN
        EXECUTE IMMEDIATE  'INSERT INTO ' ||p_table_name || ' VALUES (' ||buffer||')';
       END IF;
     END IF;
 END IF;
 
EXCEPTION
WHEN NO_DATA_FOUND THEN
EXIT;

END;
END LOOP;
END IF;
utl_file.fclose(v_file);

END import_csv;
/
CREATE OR REPLACE PROCEDURE settle_for_import
AS

BEGIN 
EXECUTE IMMEDIATE
'DROP TRIGGER add_game;
/
DROP TRIGGER delete_trainer;
/
DROP TRIGGER delete_team;
/
ALTER TABLE echipe DROP CONSTRAINT echipe_to_antrenor;
ALTER TABLE jucatori DROP CONSTRAINT jucatori_to_echipe;
ALTER TABLE intermediatee DROP CONSTRAINT intermediate_to_echipe;
ALTER TABLE intermediatee DROP CONSTRAINT intermediate_to_meciuri;

DROP table jucatori;

DROP table antrenor;

DROP table echipe;

DROP table meciuri;

DROP table intermediatee;

CREATE TABLE jucatori (
	codj int NOT NULL ,
	numej varchar2(25),
	data_n date NOT NULL,
	sex char(1),
	loc_nastere varchar2(25),
	goluri int DEFAULT 0,
	meciuri_jucate int DEFAULT 0,
	cod_e int,
	PRIMARY KEY(codj)
);

CREATE TABLE antrenor (
	coda int NOT NULL ,
	nume_a varchar2(25),
	data_n date NOT NULL,
	sex char(1),
	loc_nastere varchar2(25),
	salariu int NOT NULL,
	PRIMARY KEY(coda)
);

CREATE TABLE echipe (
	cod_e int NOT NULL ,
	nume varchar2(25),
	data_infiintare date NOT NULL,
	meciuri int DEFAULT 0,
	wins int DEFAULT 0,
	loss int DEFAULT 0,
	equal int DEFAULT 0,
	coda int,
	PRIMARY KEY(cod_e)
);

CREATE TABLE meciuri (
	codm int NOT NULL ,
	datam date NOT NULL,
	meci_jucat char(1),
	locatie varchar2(25),
	cod_echipa1 int NOT NULL ,
	cod_echipa2 int NOT NULL ,
	PRIMARY KEY(codm)
);


CREATE TABLE intermediatee (
	codi int NOT NULL ,
	cod_e int NOT NULL ,
	codm int NOT NULL ,
	PRIMARY KEY(codi)
);

  ALTER TABLE echipe ADD CONSTRAINT echipe_to_antrenor FOREIGN KEY (coda)
  REFERENCES antrenor(coda);
  ALTER TABLE jucatori ADD CONSTRAINT jucatori_to_echipe FOREIGN KEY (cod_e)
  REFERENCES echipe(cod_e);
  ALTER TABLE intermediatee ADD CONSTRAINT intermediate_to_echipe FOREIGN KEY (cod_e)
  REFERENCES echipe(cod_e);
  ALTER TABLE intermediatee ADD CONSTRAINT intermediate_to_meciuri FOREIGN KEY (codm)
	REFERENCES meciuri(codm);
  ';
END settle_for_import;
set serveroutput on;
BEGIN
import_csv;
COMMIT;
END;