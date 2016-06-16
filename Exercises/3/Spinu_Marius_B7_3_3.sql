DECLARE
TYPE bulk_type IS TABLE OF studenti%ROWTYPE;

v_info bulk_type;

CURSOR myC is 
SELECT nr_matricol,nume,prenume,an,grupa,bursa,data_nastere
FROM studenti;

BEGIN
open myC;

LOOP

FETCH myC bulk collect into v_info;

EXIT WHEN myC%NOTFOUND;


END LOOP;

CLOSE myC;

END;
