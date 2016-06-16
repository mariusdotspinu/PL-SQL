--pachet pentru import/export
CREATE OR REPLACE DIRECTORY CSVDIR AS '/tmp';
/
CREATE OR REPLACE TYPE v_array is varray(100) of varchar2(300);
/
CREATE OR REPLACE PACKAGE IE IS
PROCEDURE export_csv(p_tname in varchar2);
PROCEDURE import_csv(status OUT VARCHAR2);
PROCEDURE export_tables(status OUT VARCHAR2);
FUNCTION is_number (p_string IN VARCHAR2) RETURN INT;
PROCEDURE drop_everything(status OUT VARCHAR2);
END IE;
/

CREATE OR REPLACE PACKAGE BODY IE IS

--The DBMS_SQL package provides an interface to use dynamic SQL to parse any data manipulation language (DML) or data definition language (DDL) statement using PL/SQL.

 PROCEDURE export_csv(p_tname in varchar2)
    is
        v_file        utl_file.file_type;
        v_cursor     integer default dbms_sql.open_cursor;
        v_c_value   varchar2(4000);
        l_status        integer;
        v_select         varchar2(1000)
                       default 'select * from ' || p_tname;
       v_col_count        number := 0;
       v_comma     varchar2(1);
       v_table_descript       dbms_sql.desc_tab;
       
   begin
         v_file :=
      UTL_FILE.fopen('CSVDIR',
                      'empdata.csv',
                      'a',
                      1000);
      
      
      dbms_sql.parse(v_cursor,v_select, dbms_sql.native );
      dbms_sql.describe_columns( v_cursor, v_col_count, v_table_descript );
   
       utl_file.put(v_file,p_tname);
       utl_file.put(v_file,CHR(13)||CHR(10));
     
      for i in 1 .. v_col_count loop
         utl_file.put( v_file, v_comma || '"' || v_table_descript(i).col_name || '"');
          dbms_sql.define_column( v_cursor, i, v_c_value, 4000 );
          v_comma := ',';
          
      end loop;
      utl_file.new_line( v_file );
   
       l_status := dbms_sql.execute(v_cursor);
   
      while (dbms_sql.fetch_rows(v_cursor) > 0 ) loop
           v_comma := '';
          for i in 1 .. v_col_count loop
              dbms_sql.column_value( v_cursor, i, v_c_value );
               IF (is_number(v_c_value) = 0) THEN
               v_c_value := ''''||v_c_value ||'''';
               END IF;
              utl_file.put( v_file, v_comma || v_c_value );
               v_comma := ',';
           end loop;
          utl_file.new_line( v_file );
      end loop;
       utl_file.put(v_file,CHR(13)||CHR(10));
       dbms_sql.close_cursor(v_cursor);
      utl_file.fclose( v_file );
      
 end export_csv;
   
 FUNCTION is_number (p_string IN VARCHAR2)
   RETURN INT
IS
   v_num NUMBER;
BEGIN
   v_num := TO_NUMBER(p_string);
   RETURN 1;
EXCEPTION
WHEN VALUE_ERROR THEN
   RETURN 0;
END is_number;


 PROCEDURE export_tables(status OUT VARCHAR2) IS

 CURSOR get_all_tables IS
  SELECT object_name
  FROM user_objects
  WHERE object_type IN ('TABLE')
  ORDER BY created;
  
  v_table varchar2(20);
  v_file  utl_file.file_type;

BEGIN
  v_file:= UTL_FILE.fopen('CSVDIR','empdata.csv','w',1000);
   
   utl_file.put(v_file,'');
   utl_file.fclose( v_file );
   OPEN get_all_tables;
  
   LOOP
   
   FETCH get_all_tables INTO v_table;
   EXIT WHEN get_all_tables%NOTFOUND;
   export_csv(v_table);
  
   END LOOP;
  CLOSE get_all_tables;
  status :='exported';
EXCEPTION WHEN OTHERS THEN
IF (SQLCODE = 29283) THEN
 status := 'INVALID PATH';
 ELSE
 status :='other error';
END IF;
END export_tables;


PROCEDURE import_csv(status OUT VARCHAR2) IS
v_file utl_file.file_type;
buffer VARCHAR2(30000);
p_table_name VARCHAR2(40);
BEGIN

v_file := utl_file.fopen('CSVDIR', 'empdata.csv','r');

IF utl_file.is_open(v_file) THEN

LOOP
utl_file.get_line(v_file, buffer );

  IF buffer NOT LIKE '%,%' AND buffer NOT LIKE '%"%' AND buffer NOT LIKE '%CHR(10)||CHR(13)%'THEN
     p_table_name := trim(trailing chr(13) from buffer);
   ELSE IF buffer LIKE '%,%' AND buffer NOT LIKE '%"%' THEN
       IF(length(p_table_name) > 0) THEN
        EXECUTE IMMEDIATE  'INSERT INTO ' ||p_table_name || ' VALUES (' ||buffer||')';
       END IF;
     END IF;
 END IF;
 
END LOOP;

END IF;
EXCEPTION WHEN OTHERS THEN
IF (SQLCODE = -29283) THEN
 DBMS_OUTPUT.PUT_LINE('INVALID FILEPATH');
 status := 'INVALID FILEPATH';
 ELSE
  status := 'VALUES ALREADY IN TABLE';
END IF;

utl_file.fclose(v_file);

status := 'IMPORTED';
END import_csv;
  
PROCEDURE drop_everything(status OUT VARCHAR2)
IS
v_log v_array;

BEGIN



SELECT 'DROP '||OBJECT_TYPE || ' '||OBJECT_NAME BULK COLLECT into v_log
FROM user_objects 
WHERE OBJECT_TYPE IN ('TRIGGER','TABLE')
ORDER BY created desc;

EXECUTE IMMEDIATE ' ALTER TABLE echipe DROP CONSTRAINT echipe_to_antrenor ';
EXECUTE IMMEDIATE ' ALTER TABLE jucatori DROP CONSTRAINT jucatori_to_echipe ';
EXECUTE IMMEDIATE ' ALTER TABLE intermediatee DROP CONSTRAINT intermediate_to_echipe ';
EXECUTE IMMEDIATE ' ALTER TABLE intermediatee DROP CONSTRAINT intermediate_to_meciuri ';

FOR i in 1..v_log.count LOOP
DBMS_OUTPUT.PUT_LINE(v_log(i));
EXECUTE IMMEDIATE v_log(i);
END LOOP;


EXECUTE IMMEDIATE 
'CREATE TABLE jucatori (
	 codj int NOT NULL , 
	 numej varchar2(25), 
	data_n date NOT NULL, 
	sex char(1),  
  loc_nastere varchar2(25),
	goluri int DEFAULT 0,
	meciuri_jucate int DEFAULT 0, 
	cod_e int,
	PRIMARY KEY(codj) 
  ) ';
EXECUTE IMMEDIATE 
' CREATE TABLE antrenor ( 
   coda int NOT NULL ,
	 nume_a varchar2(25), 
	 data_n date NOT NULL, 
	 sex char(1), 
	 loc_nastere varchar2(25), 
	 salariu int NOT NULL, 
	PRIMARY KEY(coda)
 ) ';
EXECUTE IMMEDIATE 
' CREATE TABLE echipe ( 
	 cod_e int NOT NULL , 
   nume varchar2(25), 
	 data_infiintare date NOT NULL, 
	 meciuri int DEFAULT 0, 
	 wins int DEFAULT 0, 
	 loss int DEFAULT 0, 
	 equal int DEFAULT 0, 
	 coda int, 
	 PRIMARY KEY(cod_e) 
 ) ';
EXECUTE IMMEDIATE 
'CREATE TABLE meciuri (
	 codm int NOT NULL , 
	 datam date NOT NULL, 
	 meci_jucat char(1), 
	 locatie varchar2(25),
	 cod_echipa1 int NOT NULL , 
	 cod_echipa2 int NOT NULL , 
	 PRIMARY KEY(codm) 
 ) ';
 
EXECUTE IMMEDIATE 
' CREATE TABLE intermediatee ( 
	 codi int NOT NULL , 
	 cod_e int NOT NULL , 
	 codm int NOT NULL , 
	 PRIMARY KEY(codi) 
 ) ';
 COMMIT;
 DBMS_OUTPUT.PUT_LINE('DROPPED');
 status := 'DROPPED';
 EXCEPTION WHEN OTHERS THEN
 DBMS_OUTPUT.PUT_LINE('ERROR');
 status := 'ERROR';
END drop_everything;

END IE;
/
DECLARE
hello varchar2(500);
BEGIN
IE.import_csv(hello);
END;
