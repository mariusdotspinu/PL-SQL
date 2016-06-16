--The DBMS_SQL package provides an interface to use dynamic SQL to parse any data manipulation language (DML) or data definition language (DDL) statement using PL/SQL.
CREATE OR REPLACE DIRECTORY CSVDIR AS '/tmp';
/
GRANT ALL on directory CSVDIR TO PUBLIC;
CREATE OR REPLACE PROCEDURE export_csv(p_tname in varchar2)
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
      
 end;
   /
CREATE OR REPLACE FUNCTION is_number (p_string IN VARCHAR2)
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
/

CREATE OR REPLACE PROCEDURE export_tables AS

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

END export_tables;
/
BEGIN
export_tables;
END;