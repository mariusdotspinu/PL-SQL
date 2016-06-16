 DECLARE
type v_array is varray(100) of varchar2(300);
v_log v_array;

BEGIN

SELECT 'DROP '||OBJECT_TYPE || ' '||OBJECT_NAME BULK COLLECT into v_log
FROM user_objects 
WHERE OBJECT_TYPE IN ('PROCEDURE','TABLE','FUNCTION','TRIGGER','VIEW','PACKAGE');



FOR i in 1..v_log.count LOOP
DBMS_OUTPUT.PUT_LINE(v_log(i));
EXECUTE IMMEDIATE v_log(i);
END LOOP;

END;