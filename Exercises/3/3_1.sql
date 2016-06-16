set serveroutput on;

DECLARE 
c_text  CONSTANT VARCHAR2(50) := 'Ana are mere , banana';

v_index INTEGER := 0;

v_number_of_vochals INTEGER := 0;

v_element VARCHAR2(1);
BEGIN

FOR v_index IN 1..length(c_text) LOOP
 SELECT SUBSTR(c_text,v_index,1) INTO v_element FROM DUAL;
 
      IF( v_element = 'a' 
         OR v_element = 'A' 
         OR v_element = 'e' 
         OR v_element = 'E' 
         OR v_element = 'I' 
         OR v_element = 'i' 
         OR v_element = 'O' 
         OR v_element = 'o' 
         OR v_element = 'U' 
         OR v_element ='u'
         ) 
            THEN
            v_number_of_vochals := v_number_of_vochals + 1;
      END IF;
  
END LOOP;

DBMS_OUTPUT.PUT_LINE('Nr vocale : ' || v_number_of_vochals);

END;
