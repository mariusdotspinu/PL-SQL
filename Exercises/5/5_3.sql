set serveroutput on;
DECLARE

CURSOR getColumns IS

SELECT nr_matricol ,nume,prenume , an
FROM studenti
WHERE nr_matricol IN('111','120','123');

TYPE collection IS TABLE OF getColumns%ROWTYPE;

v_my_collection collection := collection();
v_position INTEGER := 4;

PROCEDURE joinCollectionTable (p_collection IN collection) IS
  
  v_medie FLOAT := 0;
  
  BEGIN
  FOR i in p_collection.first..p_collection.last LOOP
  IF(p_collection(i).an IN (2,3))
    THEN
    SELECT AVG(n.valoare) INTO v_medie
    FROM note
    JOIN note n on n.nr_matricol = p_collection(i).nr_matricol;
    
    DBMS_OUTPUT.PUT_LINE('Nume :' || p_collection(i).nume || ' medie : ' || v_medie);
  END IF;
  
  END LOOP;
  
END joinCollectionTable;

BEGIN

OPEN getColumns;

LOOP

v_my_collection.extend(v_position);
FETCH getColumns into v_my_collection(v_position);
EXIT WHEN getColumns%NOTFOUND;


v_position := v_position + 4;

END LOOP;
CLOSE getColumns;

joinCollectionTable(p_collection => v_my_collection);


END;
