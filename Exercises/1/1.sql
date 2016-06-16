--inainte de a crea tabelele trebuie sa stergem constrangerile
--fiecare constrangere ce include o cheie primara trebuie stearsa dupa ce vom sterge constrangerile ce includ cheile straine bazate pe acele chei
ALTER TABLE profesori DROP CONSTRAINT grad_didactic_nn;
ALTER TABLE cursuri DROP CONSTRAINT titlu_curs_nn;
ALTER TABLE didactic DROP CONSTRAINT id_prof_fk;
ALTER TABLE profesori DROP CONSTRAINT id_prof_pk;
ALTER TABLE didactic DROP CONSTRAINT id_curs_fk;
ALTER TABLE note DROP CONSTRAINT id_curs_note_fk;
ALTER TABLE cursuri DROP  CONSTRAINT id_curs_pk;
ALTER TABLE note DROP CONSTRAINT nr_matricol_fk;
ALTER TABLE studenti DROP CONSTRAINT nr_mat_pk;
ALTER TABLE note DROP CONSTRAINT data_notare_nn;

DROP TABLE studenti
/

DROP TABLE cursuri
/
DROP TABLE note
/
DROP TABLE profesori
/

DROP TABLE didactic
/

CREATE TABLE studenti(
  nr_matricol CHAR(3),
  nume VARCHAR2(10),
  prenume VARCHAR2(10),
  an NUMBER(1),
  grupa CHAR(2),
  bursa NUMBER(6,2),
  data_nastere DATE
  )
/


CREATE TABLE cursuri(
  id_curs CHAR(4), -- modificare de la CHAR(2) - CHAR(4) altfel eroare la inserare de valori(parent key not found)
  titlu_curs VARCHAR2(15),
  an NUMBER(1),
  semestru NUMBER(1),
  credite NUMBER(2)
  )
/

CREATE TABLE note(
  nr_matricol CHAR(3),
  id_curs CHAR(4),--modificare de la char 2 la char 4
  valoare NUMBER(2),
  data_notare DATE
  )
/

CREATE TABLE profesori(
  id_prof CHAR(4),
  nume CHAR(10),
  prenume CHAR(10),
  grad_didactic VARCHAR2(20)--modificare
  )
/

CREATE TABLE didactic(
  id_prof CHAR(4),
  id_curs CHAR(4)
  )
/

--ACCEPT  dmy  PROMPT "Press [Enter] to continue ...";


--CONSTRAINTS
ALTER TABLE studenti
   MODIFY (nr_matricol CONSTRAINT nr_mat_pk PRIMARY KEY);
/
ALTER TABLE profesori
   MODIFY (id_prof CONSTRAINT id_prof_pk PRIMARY KEY);
/  
ALTER TABLE profesori
   MODIFY (grad_didactic CONSTRAINT grad_didactic_nn not null);
/  
ALTER TABLE cursuri
   MODIFY (id_curs CONSTRAINT id_curs_pk PRIMARY KEY);
/  
ALTER TABLE cursuri
   MODIFY(titlu_curs CONSTRAINT titlu_curs_nn NOT NULL);
/  
ALTER TABLE DIDACTIC
   MODIFY (CONSTRAINT id_prof_fk FOREIGN KEY(id_prof) REFERENCES profesori (id_prof));
/
ALTER TABLE DIDACTIC
   MODIFY (CONSTRAINT id_curs_fk FOREIGN KEY(id_curs) REFERENCES cursuri (id_curs));
/  
ALTER TABLE note
   MODIFY (CONSTRAINT nr_matricol_fk FOREIGN KEY(nr_matricol) REFERENCES studenti(nr_matricol));
/
ALTER TABLE note
   MODIFY (CONSTRAINT id_curs_note_fk FOREIGN KEY(id_curs) REFERENCES cursuri(id_curs));
/
ALTER TABLE note
   MODIFY (data_notare CONSTRAINT data_notare_nn NOT NULL);
/

--anul 3 de studiu 
INSERT INTO studenti VALUES ('111', 'Popescu', 'Bogdan',3, 'A2',NULL, TO_DATE('17/02/1995', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('112', 'Prelipcean', 'Radu',3, 'A2',NULL, TO_DATE('26/05/1995', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('113', 'Antonie', 'Ioana',3, 'A2',450, TO_DATE('3/01/1995', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('114', 'Arhire', 'Raluca',3, 'A4',NULL, TO_DATE('26/12/1995', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('115', 'Panaite', 'Alexandru',3, 'B3',NULL, TO_DATE('13/04/1995', 'dd/mm/yyyy'));

-- anul 2 de studiu
INSERT INTO studenti VALUES ('116', 'Bodnar', 'Ioana',2, 'A1',NULL, TO_DATE('26/08/1996', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('117', 'Archip', 'Andrada',2, 'A1',350, TO_DATE('03/04/1996', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('118', 'Ciobotariu', 'Ciprian',2, 'A1',350, TO_DATE('03/04/1996', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('119', 'Bodnar', 'Ioana',2, 'B2',NULL, TO_DATE('10/06/1996', 'dd/mm/yyyy'));

-- anul 1 de studiu
INSERT INTO studenti VALUES ('120', 'Pintescu', 'Andrei',1, 'B1',250, TO_DATE('26/08/1997', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('121', 'Arhire', 'Alexandra',1, 'B1',NULL, TO_DATE('02/07/1997', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('122', 'Cobzaru', 'George',1, 'B1',350, TO_DATE('29/04/1997', 'dd/mm/yyyy'));
INSERT INTO studenti VALUES ('123', 'Bucur', 'Andreea',1, 'B2',NULL, TO_DATE('10/05/1997', 'dd/mm/yyyy'));

-- populare tabela cursuri - cate 3 pt fiecare an
INSERT INTO cursuri VALUES ('21', 'Logica', 1, 1, 5);
INSERT INTO cursuri VALUES ('22', 'Matematica', 1, 1, 4);
INSERT INTO cursuri VALUES ('23', 'OOP', 1, 2, 5);
INSERT INTO cursuri VALUES ('24', 'BD', 2, 1, 8);
INSERT INTO cursuri VALUES ('25', 'Java', 2, 2, 5);
INSERT INTO cursuri VALUES ('26', 'Tehnologii Web', 2, 2, 5);
INSERT INTO cursuri VALUES ('27', 'Sec. Info.', 3, 1, 5);
INSERT INTO cursuri VALUES ('28', 'DSFUM', 3, 1, 6);
INSERT INTO cursuri VALUES ('29', 'Limbaje formale', 3, 1, 5);--modificare trebuia anul 3
-- inca una din anu 3 :D


-- populare tabela profesori
INSERT INTO profesori VALUES ('p1', 'Masalagiu', 'Cristian', 'Prof');
INSERT INTO profesori VALUES ('p2', 'Buraga', 'Sabin', 'Conf');
INSERT INTO profesori VALUES ('p3', 'Lucanu', 'Dorel', 'Prof');
INSERT INTO profesori VALUES ('p4', 'Tiplea', 'Laurentiu', 'Prof');
INSERT INTO profesori VALUES ('p5', 'Iacob', 'Florin', 'Lect');
INSERT INTO profesori VALUES ('p6', 'Breaban', 'Mihaela', 'Conf');
INSERT INTO profesori VALUES ('p7', 'Varlan', 'Cosmin', 'Lect');
INSERT INTO profesori VALUES ('p8', 'Frasinaru', 'Cristian', 'Prof');
INSERT INTO profesori VALUES ('p9', 'Ciobaca', 'Stefan', 'Conf');
INSERT INTO profesori VALUES ('p10', 'Captarencu', 'Oana', 'Lect');
INSERT INTO profesori VALUES ('p11', 'Moruz', 'Alexandru', 'Lect');

-- populare tabela didactic
INSERT INTO didactic VALUES ('p1','21');
INSERT INTO didactic VALUES ('p9','21');
INSERT INTO didactic VALUES ('p5','22');
INSERT INTO didactic VALUES ('p3','23');
INSERT INTO didactic VALUES ('p6','24');
INSERT INTO didactic VALUES ('p7','24');
INSERT INTO didactic VALUES ('p8','25');
INSERT INTO didactic VALUES ('p2','26');
INSERT INTO didactic VALUES ('p4','27');
INSERT INTO didactic VALUES ('p7','28');


-- populare tabel note - studentii din anul 3 au toate examenele date, cei din anul 2 doar pe cele din anul 1, cei din 1 - nimic
INSERT INTO note VALUES ('111', '21',  8, TO_DATE('17/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('111', '22',  9, TO_DATE('19/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('111', '23', 10, TO_DATE('24/06/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('111', '24',  9, TO_DATE('17/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('111', '25',  7, TO_DATE('20/06/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('111', '26',  8, TO_DATE('21/06/2015', 'dd/mm/yyyy'));

INSERT INTO note VALUES ('112', '21',  7, TO_DATE('25/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('112', '22',  6, TO_DATE('19/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('112', '23',  5, TO_DATE('24/06/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('112', '24',  6, TO_DATE('17/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('112', '25',  7, TO_DATE('20/06/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('112', '26',  4, TO_DATE('21/06/2015', 'dd/mm/yyyy'));

INSERT INTO note VALUES ('113', '21',  9, TO_DATE('17/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('113', '22',  9, TO_DATE('19/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('113', '23',  7, TO_DATE('24/06/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('113', '24', 10, TO_DATE('17/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('113', '25',  4, TO_DATE('20/06/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('113', '26',  7, TO_DATE('21/06/2015', 'dd/mm/yyyy'));

INSERT INTO note VALUES ('114', '21',  6, TO_DATE('17/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('114', '22',  9, TO_DATE('19/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('114', '23', 10, TO_DATE('24/06/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('114', '24',  4, TO_DATE('17/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('114', '25',  5, TO_DATE('20/06/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('114', '26',  4, TO_DATE('21/06/2015', 'dd/mm/yyyy'));

INSERT INTO note VALUES ('115', '21', 10, TO_DATE('17/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('115', '22',  7, TO_DATE('19/02/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('115', '23', 10, TO_DATE('24/06/2014', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('115', '24', 10, TO_DATE('17/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('115', '25',  8, TO_DATE('20/06/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('115', '26',  9, TO_DATE('21/06/2015', 'dd/mm/yyyy'));


INSERT INTO note VALUES ('116', '21', 10, TO_DATE('18/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('116', '22', 10, TO_DATE('20/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('116', '23',  9, TO_DATE('21/06/2015', 'dd/mm/yyyy'));

INSERT INTO note VALUES ('117', '21',  7, TO_DATE('18/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('117', '22',  6, TO_DATE('20/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('117', '23',  4, TO_DATE('25/06/2015', 'dd/mm/yyyy'));

INSERT INTO note VALUES ('118', '21',  7, TO_DATE('22/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('118', '22',  7, TO_DATE('24/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('118', '23',  7, TO_DATE('21/06/2015', 'dd/mm/yyyy'));

INSERT INTO note VALUES ('119', '21',  7, TO_DATE('18/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('119', '22',  8, TO_DATE('20/02/2015', 'dd/mm/yyyy'));
INSERT INTO note VALUES ('119', '23',  9, TO_DATE('21/06/2015', 'dd/mm/yyyy'));


--modificare grad didactic != null
INSERT INTO profesori VALUES('p20', 'PASCARIU', 'GEORGIANA', 'conferentiar');
INSERT INTO profesori VALUES('p21', 'LAZAR', 'LUCIAN','prof doctor');
INSERT INTO profesori VALUES('p22', 'Kristo', 'ROBERT', 'colab');
--INSERT INTO profesori VALUES('p20', 'Nastasa', 'Laura', 'colab');--inserare acelasi ID
--INSERT INTO profesori VALUES('p21', 'PASAT', 'Tiberiu', 'colab');

COMMIT;

--CREATE USER STUDENT IDENTIFIED BY STUDENT DEFAULT TABLESPACE USERS TEMPORARY TABLESPACE TEMP
--ALTER USER STUDENT QUOTA 1000M ON USERS;
--GRANT CONNECT TO STUDENT
--GRANT CREATE TABLE TO STUDENT
--GRANT CREATE VIEW TO STUDENT
--GRANT CREATE SEQUENCE TO STUDENT
--GRANT CREATE TRIGGER TO STUDENT
--GRANT CREATE SYNONYM TO STUDENT
--GRANT CREATE PROCEDURE TO STUDENT
--GRANT SELECT_CATALOG_ROLE TO STUDENT
--GRANT EXECUTE_CATALOG_ROLE TO STUDENT

--Natural Join
SELECT DISTINCT nume,prenume,an,grupa AS "Natural Join" from STUDENTI
NATURAL JOIN note
WHERE BURSA IS NOT NULL;

ACCEPT dmy PROMPT "Press [Enter] to continue ...";
--Left Join
SELECT DISTINCT nume,prenume,an,grupa AS "Left Join" from STUDENTI
LEFT JOIN note on studenti.nr_matricol = note.nr_matricol
WHERE note.nr_matricol >9;

ACCEPT dmy PROMPT "Press [Enter] to continue ...";

--Right Join
SELECT DISTINCT s.nume,s.bursa AS "Right Join" from STUDENTI
RIGHT JOIN studenti s on studenti.nr_matricol= s.nr_matricol
WHERE s.bursa is NULL AND s.grupa like 'A2';

ACCEPT dmy PROMPT "Press [Enter] to continue ...";

--Full Outer Join 

SELECT DISTINCT nume AS "Full Outer Join" from STUDENTI
FULL OUTER JOIN note on note.nr_matricol = studenti.nr_matricol
WHERE nume like 'A%e%';

ACCEPT dmy PROMPT "Press [Enter] to continue ...";

--Agregare
SELECT AVG(valoare) AS "Agregare" FROM note;

ACCEPT dmy PROMPT "Press [Enter] to continue ...";

--subinterogare ne-corelata
SELECT nume,prenume from studenti
JOIN note n on n.nr_matricol = studenti.nr_matricol
HAVING AVG(n.valoare) = (SELECT AVG(MIN(valoare)) from note group by valoare)
GROUP BY nume,prenume,studenti.nr_matricol;

ACCEPT dmy PROMPT "Press [Enter] to  continue ...";

--subinterogare corelata
SELECT DISTINCT valoare,nume
FROM studenti
NATURAL JOIN note
WHERE EXISTS (SELECT 121343
              FROM studenti
              WHERE bursa IS NOT NULL AND note.valoare = 10 AND studenti.grupa like 'A%');

ACCEPT dmy PROMPT "Press [Enter] to continue ...";

--view inerent actualizabil

DROP VIEW myView;

DELETE FROM profesori WHERE id_prof ='01';

CREATE VIEW myView AS 
SELECT id_prof,nume,grad_didactic from profesori
ORDER BY prenume;

INSERT INTO myView values ('01','ProfesorX','Prof');

ACCEPT dmy PROMPT "Press [Enter] to continue ...";

--view read only
DROP VIEW myViewro;

CREATE VIEW myViewro AS
SELECT nr_matricol,nume,prenume
FROM studenti
WITH READ ONLY;

INSERT INTO myViewro values ('123','StudentX','pren');

ACCEPT dmy PROMPT "Press [Enter] to continue ...";

--view join peste 2 tabele

DROP VIEW myJoinedView;

DELETE FROM note where nr_matricol = 155;
DELETE FROM studenti where nr_matricol = 155;


CREATE VIEW myJoinedView AS
SELECT studenti.nr_matricol,note.id_curs,nume,note.valoare,note.data_notare from studenti,note
where note.nr_matricol=studenti.nr_matricol;


CREATE TRIGGER myTrigger
INSTEAD OF INSERT ON myJoinedView
FOR EACH ROW
BEGIN
    INSERT INTO studenti values(:New.nr_matricol,:New.nume,null,null,null,null,null);
    INSERT INTO note values (:New.nr_matricol,:New.id_curs,:New.valoare,:New.data_notare);
    
END;
/
INSERT INTO myJoinedView VALUES (155,'21','Marius',10,TO_DATE('17/02/2005', 'dd/mm/yyyy'));
