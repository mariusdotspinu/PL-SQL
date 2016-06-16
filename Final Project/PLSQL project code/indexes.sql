DROP INDEX nameIndex;
/
DROP INDEX functionNameIndex;
/
--DROP INDEX sexIndex;
--DROP INDEX meciJucat;
--/
DROP INDEX dateIndex;
/
DROP INDEX birthPlaceIndex;
/
CREATE INDEX nameIndex on jucatori(numej);

CREATE INDEX functionNameIndex on jucatori(upper(numej));

--CREATE BITMAP INDEX sexIndex on jucatori (sex);
--CREATE BITMAP INDEX meciJucat on meciuri(meci_jucat);

CREATE INDEX dateIndex ON echipe(trunc(data_infiintare));--prealuarea inregistrarilor pentru o anumita data > midnight prima zi

CREATE INDEX birthPlaceIndex on antrenor(UPPER(loc_nastere));

--planul nu utilizeaza indexul pe numej
select * from jucatori where trim(numej) = 'ANGHEL NICUSOR';

-- planul utilizeaza indexul pe functie
select * from jucatori where upper(numej) = 'ANGHEL NICUSOR'; 

-- planul utilizeaza indexul pe functie
select * from jucatori where upper(numej) like 'ANGHEL NI%';

-- planul NU utilizeaza indexul pe functie
select * from jucatori where upper(numej) like '%EL NICUSOR';

--planul utilizeaza indexul pe coloana
--select * from jucatori where sex like 'M';

--planul nu utilizeaza indexul pe coloana date coresp
select * from echipe where data_infiintare = to_date('1978-05-01','yyyy-mm-dd');

--planul utilizeaza coresp
select * from echipe where TRUNC(data_infiintare) = to_date('1978-05-01','yyyy-mm-dd');

--planul nu utilizeaza coresp loc_nastere
select nume_a from antrenor where loc_nastere = 'GALATI';

--planul utilizeaza coresp loc_nastere
select nume_a from antrenor where UPPER(loc_nastere) = 'GALATI';