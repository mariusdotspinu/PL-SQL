set serveroutput on;

CREATE OR REPLACE PROCEDURE get_all_tables_and_views AS

type v_array is varray(100) of VARCHAR2(100);

v_tables_n_views v_array;

BEGIN
        SELECT 'Tip : ' ||table_type||' nume : ' ||table_name
        BULK COLLECT INTO v_tables_n_views 
        FROM user_catalog
        WHERE table_type in ('TABLE','VIEW') AND length(table_name) <=10;


  DBMS_OUTPUT.PUT_LINE('Tabelele si viewurile sunt : ');
  
  FOR i in 1..v_tables_n_views.count LOOP
   DBMS_OUTPUT.PUT_LINE(v_tables_n_views(i) || ' ');
  END LOOP;
  
   DBMS_OUTPUT.PUT_LINE(' ');

END get_all_tables_and_views;
/
CREATE OR REPLACE PROCEDURE get_some_user_source AS

type v_array is varray(100) of varchar2(100);

v_source_array v_array;



BEGIN

SELECT distinct type ||' '|| name BULK COLLECT INTO v_source_array
FROM user_source
WHERE type in ('PROCEDURE','FUNCTION','TRIGGER');

  DBMS_OUTPUT.PUT_LINE('Obiectele sunt : ');
  
  FOR i in 1..v_source_array.count LOOP
   DBMS_OUTPUT.PUT_LINE(v_source_array(i) || ' ');
  END LOOP;
  
   DBMS_OUTPUT.PUT_LINE(' ');

END get_some_user_source;
/
BEGIN
get_all_tables_and_views;
get_some_user_source;
END;