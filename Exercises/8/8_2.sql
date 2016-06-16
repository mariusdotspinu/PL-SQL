--GRANT CREATE ANY DIRECTORY TO USER;
--GRANT EXECUTE ON SYS.UTL_FILE TO USER;
--treaba dba
CREATE OR REPLACE DIRECTORY dir AS '/home/marius/Desktop/Backup';
/
CREATE OR REPLACE type v_data is varray(1000) of varchar2(10000);
/
CREATE OR REPLACE PROCEDURE EXPORT_DATA AS 
export_file  UTL_FILE.FILE_TYPE;

my_objects v_data;


 CURSOR get_objects IS
    SELECT object_type, object_name 
      FROM user_objects 
      WHERE object_type IN ('PROCEDURE','FUNCTION','TABLE','VIEW','TRIGGER');

BEGIN

export_file:= UTL_FILE.FOPEN('dir', 'test.sql' , 'A');

FOR v_object IN get_objects LOOP
  UTL_FILE.PUT_LINE(export_file, DBMS_METADATA.GET_DDL(v_object.object_type, 
                                                    v_object.object_name));
UTL_FILE.PUT_LINE(export_file, '/');
END LOOP;

SELECT text BULK COLLECT INTO my_objects from user_source;
FOR i in 1..my_objects.count LOOP
UTL_FILE.PUT_LINE(export_file,my_objects(i));
END LOOP;


UTL_FILE.FCLOSE(export_file);

END EXPORT_DATA;
/
BEGIN
EXPORT_DATA;
END;
