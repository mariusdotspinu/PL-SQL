DROP TRIGGER add_game;
/
DROP TRIGGER delete_trainer;
/
DROP TRIGGER delete_team;
/
ALTER TABLE echipe DROP CONSTRAINT echipe_to_antrenor;
ALTER TABLE jucatori DROP CONSTRAINT jucatori_to_echipe;
ALTER TABLE intermediatee DROP CONSTRAINT intermediate_to_echipe;
ALTER TABLE intermediatee DROP CONSTRAINT intermediate_to_meciuri;

DROP table jucatori;

DROP table antrenor;

DROP table echipe;

DROP table meciuri;

DROP table intermediatee;

CREATE TABLE jucatori (
	codj INTEGER NOT NULL ,
	numej varchar2(25),
	data_n date NOT NULL,
	sex char(1),
	loc_nastere varchar2(25),
	goluri INTEGER DEFAULT 0,
	meciuri_jucate INTEGER DEFAULT 0,
	cod_e int,
	PRIMARY KEY(codj)
);

CREATE TABLE antrenor (
	coda INTEGER NOT NULL ,
	nume_a varchar2(25),
	data_n date NOT NULL,
	sex char(1),
	loc_nastere varchar2(25),
	salariu INTEGER NOT NULL,
	PRIMARY KEY(coda)
);

CREATE TABLE echipe (
	cod_e INTEGER NOT NULL ,
	nume varchar2(25),
	data_infiintare date NOT NULL,
	meciuri INTEGER DEFAULT 0,
	wins INTEGER DEFAULT 0,
	loss INTEGER DEFAULT 0,
	equal INTEGER DEFAULT 0,
	coda int,
	PRIMARY KEY(cod_e)
);
CREATE TABLE meciuri (
	codm INTEGER NOT NULL ,
	datam date NOT NULL,
	meci_jucat char(1),
	locatie varchar2(25),
	cod_echipa1 INTEGER NOT NULL ,
	cod_echipa2 INTEGER NOT NULL ,
	PRIMARY KEY(codm)
);


CREATE TABLE intermediatee (
	codi INTEGER NOT NULL ,
	cod_e INTEGER NOT NULL ,
	codm INTEGER NOT NULL ,
	PRIMARY KEY(codi)
);

  ALTER TABLE echipe ADD CONSTRAINT echipe_to_antrenor FOREIGN KEY (coda)
  REFERENCES antrenor(coda);
  ALTER TABLE jucatori ADD CONSTRAINT jucatori_to_echipe FOREIGN KEY (cod_e)
  REFERENCES echipe(cod_e);
  ALTER TABLE intermediatee ADD CONSTRAINT intermediate_to_echipe FOREIGN KEY (cod_e)
  REFERENCES echipe(cod_e);
  ALTER TABLE intermediatee ADD CONSTRAINT intermediate_to_meciuri FOREIGN KEY (codm)
	REFERENCES meciuri(codm);
INSERT INTO antrenor VALUES (1,'ADRIAN SZADO',to_date('1960-03-01','yyyy-mm-dd'),'M','TECUCI',6200);
INSERT INTO antrenor VALUES (2,'FLORIN MARIN',to_date('1965-04-01','yyyy-mm-dd'),'F','BUCURESTI',5200);
INSERT INTO antrenor VALUES (3,'MIRCEA REDNIC',to_date('1980-02-01','yyyy-mm-dd'),'M','TULCEA',3400);
INSERT INTO antrenor VALUES (4,'NICOLO NAPOLI',to_date('1965-03-01','yyyy-mm-dd'),'M','BRASOV',15000);
INSERT INTO antrenor VALUES (5,'CRISTIANO BERGODI',to_date('1975-05-01','yyyy-mm-dd'),'M','FOCSANI',1500);
INSERT INTO antrenor VALUES (6,'EDUARD IORDANESCU',to_date('1970-06-01','yyyy-mm-dd'),'M','GALATI',1000);
INSERT INTO antrenor VALUES (7,'GHEORGHE HAGI',to_date('1980-08-01','yyyy-mm-dd'),'M','IASI',1000);
INSERT INTO antrenor VALUES (8,'VANJA RADINOVIC',to_date('1975-06-01','yyyy-mm-dd'),'M','GIURGIU',7500);
INSERT INTO antrenor VALUES (9,'FLAVIUS STOIAN',to_date('1959-03-01','yyyy-mm-dd'),'M','SIBIU',8200);
INSERT INTO antrenor VALUES (10,'MARIUS BACIU',to_date('1980-01-01','yyyy-mm-dd'),'M','BARLAD',6000);
INSERT INTO antrenor VALUES (11,'EUGEN TRICA',to_date('1970-05-01','yyyy-mm-dd'),'M','GALATI',3540);
INSERT INTO antrenor VALUES (12,'EMIL SANDOI',to_date('1965-10-01','yyyy-mm-dd'),'M','TECUCI',1500);
INSERT INTO antrenor VALUES (13,'ADRIAN FALUB',to_date('1985-06-01','yyyy-mm-dd'),'M','TECUCI',15000);
INSERT INTO antrenor VALUES (15,'LEONTIN GROZAVU',to_date('1960-08-01','yyyy-mm-dd'),'M','IASI',12333);
INSERT INTO antrenor VALUES (16,'ION BALAUR',to_date('1990-09-01','yyyy-mm-dd'),'M','VASLUI',11000);
INSERT INTO antrenor VALUES (17,'CONSTANTIN GALCA',to_date('1985-12-01','yyyy-mm-dd'),'M','CERNAVODA',5000);
INSERT INTO antrenor VALUES (18,'MARIUS SUMUDILA',to_date('1990-01-01','yyyy-mm-dd'),'M','IASI',3200);
INSERT INTO antrenor VALUES (14,'LIVIU CIOBANU',to_date('1980-01-01','yyyy-mm-dd'),'M','GALATI',3000);
INSERT INTO antrenor VALUES (0,'DUMMY VALUE',to_date('1980-01-01','yyyy-mm-dd'),'m','WONDERLAND',0);
	
INSERT INTO echipe VALUES (1,'ASA TG. MURES',to_date('1975-01-01','yyyy-mm-dd'),30,19,8,3,14);
INSERT INTO echipe VALUES (2,'CONCORDIA CHIAJNA',to_date('1980-01-01','yyyy-mm-dd'),30,7,13,10,10);
INSERT INTO echipe VALUES (3,'VIITORUL VOLUNTARI',to_date('1960-01-01','yyyy-mm-dd'),30,11,9,10,7);
INSERT INTO echipe VALUES (4,'CS. UNIVERSITATEA CRAIOVA',to_date('1965-01-01','yyyy-mm-dd'),30,12,12,6,12);
INSERT INTO echipe VALUES (5,'ASTRA GIURGIU',to_date('1980-01-01','yyyy-mm-dd'),29,11,11,7,18);
INSERT INTO echipe VALUES (6,'PETROLUL PLOIESTI',to_date('1985-03-01','yyyy-mm-dd'),29,13,9,7,3);
INSERT INTO echipe VALUES (7,'RAPID BUCURESTI',to_date('1983-06-01','yyyy-mm-dd'),29,7,8,14,15);
INSERT INTO echipe VALUES (8,'DINAMO BUCURESTI',to_date('1956-05-01','yyyy-mm-dd'),29,11,8,11,9);
INSERT INTO echipe VALUES (9,'PANDURII TG. JIU',to_date('1986-05-01','yyyy-mm-dd'),30,9,8,13,6);
INSERT INTO echipe VALUES (10,'GAZ METAN MEDIAS',to_date('1975-05-01','yyyy-mm-dd'),29,6,12,11,16);
INSERT INTO echipe VALUES (11,'OTELUL GALATI',to_date('1982-05-01','yyyy-mm-dd'),29,4,10,15,2);
INSERT INTO echipe VALUES (12,'STEAUA BUCURESTI',to_date('1956-03-01','yyyy-mm-dd'),29,19,3,7,17);
INSERT INTO echipe VALUES (13,'FC BOTOSANI',to_date('1987-05-01','yyyy-mm-dd'),30,12,9,9,15);
INSERT INTO echipe VALUES (14,'U CLUJ',to_date('1962-05-01','yyyy-mm-dd'),29,7,9,13,13);
INSERT INTO echipe VALUES (15,'CFR CLUJ',to_date('1950-01-01','yyyy-mm-dd'),30,13,9,8,11);
INSERT INTO echipe VALUES (16,'CSMS IASI',to_date('1978-05-01','yyyy-mm-dd'),29,10,8,11,4);
INSERT INTO echipe VALUES (17,'CEAHLAUL PIATRA NEAMT',to_date('1976-08-01','yyyy-mm-dd'),29,5,9,15,8);
INSERT INTO echipe VALUES (18,'FC BRASOV',to_date('1978-12-01','yyyy-mm-dd'),30,8,8,14,1);
INSERT INTO echipe VALUES (0,'DUMMY VALUE',to_date('1978-12-01','yyyy-mm-dd'),30,8,8,14,1);
  																							   		
INSERT INTO jucatori VALUES (1,'ANGHEL EDUARD',to_date('1980-01-01','yyyy-mm-dd'),'M','GALATI',83,210,1);
INSERT INTO jucatori VALUES (2,'GHIMPU DANIEL',to_date('1986-05-01','yyyy-mm-dd'),'M','TECUCI',56,120,1);
INSERT INTO jucatori VALUES (3,'BUGEAC DANIEL',to_date('1990-08-01','yyyy-mm-dd'),'M','FOCSANI',10,150,1);
INSERT INTO jucatori VALUES (4,'ANGHEL NICUSOR',to_date('1995-12-12','yyyy-mm-dd'),'M','BUCURESTI',300,150,12);
INSERT INTO jucatori VALUES (5,'OPREA SILVIU',to_date('1991-12-10','yyyy-mm-dd'),'M','ROMAN',125,125,12);
INSERT INTO jucatori VALUES (6,'SECIU COSMIN',to_date('1986-11-06','yyyy-mm-dd'),'M','BOTOSANI',125,174,12);
INSERT INTO jucatori VALUES (7,'TOADER SORIN',to_date('1984-11-08','yyyy-mm-dd'),'M','MOVILENI',215,325,6);
INSERT INTO jucatori VALUES (8,'BANEL NICOLITA',to_date('1980-11-03','yyyy-mm-dd'),'M','BRASOV',45,85,6);
INSERT INTO jucatori VALUES (9,'LAMPARD COSTITA',to_date('1985-12-06','yyyy-mm-dd'),'M','TULCEA',85,123,6);
INSERT INTO jucatori VALUES (10,'CATANA BOGDAN',to_date('1980-02-10','yyyy-mm-dd'),'M','TURDA',45,60,4);
INSERT INTO jucatori VALUES (11,'TANASE CRISTI',to_date('1987-01-01','yyyy-mm-dd'),'M','SIBIU',85,152,4);
INSERT INTO jucatori VALUES (12,'ROMAS GHEORGHE',to_date('1974-08-14','yyyy-mm-dd'),'M','HUSI',45,321,4);
INSERT INTO jucatori VALUES (13,'LAMIR TOMAS',to_date('1980-06-01','yyyy-mm-dd'),'M','CLUJ',68,123,5);
INSERT INTO jucatori VALUES (14,'BAMOS CODRIN',to_date('1984-11-04','yyyy-mm-dd'),'M','SEVERIN',95,78,5);
INSERT INTO jucatori VALUES (15,'TOMA VLAD',to_date('1985-03-01','yyyy-mm-dd'),'M','SIBIU',65,42,5);
INSERT INTO jucatori VALUES (16,'LEO GICOMAN',to_date('1987-06-01','yyyy-mm-dd'),'M','TURDA',132,112,3);
INSERT INTO jucatori VALUES (17,'REMUS ALIN',to_date('1978-02-19','yyyy-mm-dd'),'M','TECUCI',43,200,3);
INSERT INTO jucatori VALUES (18,'COMAN ADRIAN',to_date('1984-08-16','yyyy-mm-dd'),'M','TECUCI',65,120,3);
INSERT INTO jucatori VALUES (19,'VREBIE ARON',to_date('1974-02-19','yyyy-mm-dd'),'M','GALATI',63,85,13);
INSERT INTO jucatori VALUES (20,'KOMIR DUVAM',to_date('1975-12-03','yyyy-mm-dd'),'M','IVESTI',68,121,13);
INSERT INTO jucatori VALUES (21,'DUMEA NELUCU',to_date('1985-03-15','yyyy-mm-dd'),'M','IASI',87,191,13);
INSERT INTO jucatori VALUES (22,'JECU CATALIN',to_date('1981-11-13','yyyy-mm-dd'),'M','GALATI',78,123,8);
INSERT INTO jucatori VALUES (23,'BRATIE FANUT',to_date('1987-05-13','yyyy-mm-dd'),'M','BUCURESTI',75,111,8);
INSERT INTO jucatori VALUES (24,'DANCA DRAGOS',to_date('1982-05-13','yyyy-mm-dd'),'M','PLOIESTI',32,100,16);
INSERT INTO jucatori VALUES (25,'DIMA SERGIU',to_date('1987-08-18','yyyy-mm-dd'),'M','CALARASI',65,74,16);
INSERT INTO jucatori VALUES (26,'HORATIU ROMICA',to_date('1980-01-01','yyyy-mm-dd'),'M','SIGHISOARA',84,32,9);
INSERT INTO jucatori VALUES (27,'FORCU GELU',to_date('1979-08-08','yyyy-mm-dd'),'M','REGHIN',54,98,9);
INSERT INTO jucatori VALUES (28,'LUCACI NICUSOR',to_date('1983-05-07','yyyy-mm-dd'),'M','CARACAL',87,185,2);
INSERT INTO jucatori VALUES (29,'LUCA DORULET',to_date('1991-09-04','yyyy-mm-dd'),'M','SIBIU',52,65,2);
INSERT INTO jucatori VALUES (30,'PAVEL COSTEL',to_date('1985-12-01','yyyy-mm-dd'),'M','ROMAN',65,65,18);
INSERT INTO jucatori VALUES (31,'MOSCU CATALIN',to_date('1979-03-01','yyyy-mm-dd'),'M','MOVILENI',83,78,18);
INSERT INTO jucatori VALUES (32,'MOSCU ROBERT',to_date('1987-08-01','yyyy-mm-dd'),'M','TECUCI',47,94,10);
INSERT INTO jucatori VALUES (33,'POPA ANDREI',to_date('1979-03-03','yyyy-mm-dd'),'M','TELEORMAN',65,65,10);
INSERT INTO jucatori VALUES (34,'NELSON DANI',to_date('1982-02-02','yyyy-mm-dd'),'M','CLUJ',85,75,14);
INSERT INTO jucatori VALUES (35,'FLORENTIO RAZVAN',to_date('1987-05-05','yyyy-mm-dd'),'M','TURDA',32,68,14);
INSERT INTO jucatori VALUES (36,'ANGHEL IONEL',to_date('1981-07-07','yyyy-mm-dd'),'M','BUCURESTI',32,54,7);
INSERT INTO jucatori VALUES (37,'CUMON DRAGOS',to_date('1993-01-01','yyyy-mm-dd'),'M','URZICENI',54,100,7);
INSERT INTO jucatori VALUES (38,'ION ION',to_date('1977-07-07','yyyy-mm-dd'),'M','CLUJ',45,152,15);
INSERT INTO jucatori VALUES (39,'UDRES COSTEL',to_date('1994-01-01','yyyy-mm-dd'),'M','HARGHITA',65,211,15);
INSERT INTO jucatori VALUES (40,'MITICA FLORENTIN',to_date('1981-05-08','yyyy-mm-dd'),'M','IASI',65,21,17);
INSERT INTO jucatori VALUES (41,'COMAN ADRIAN',to_date('1983-01-01','yyyy-mm-dd'),'M','NADLAC',45,210,17);
INSERT INTO jucatori VALUES (42,'CARAGATA ADRIAN',to_date('1986-10-03','yyyy-mm-dd'),'M','TECUCI',32,10,11);
INSERT INTO jucatori VALUES (43,'RADU VLADIMIR',to_date('1985-12-01','yyyy-mm-dd'),'M','CLUJ',98,213,11);

INSERT INTO meciuri VALUES (1,to_date('2015-10-02','yyyy-mm-dd'),'T','BUCURESTI',1,12);
INSERT INTO meciuri VALUES (2,to_date('2015-9-10','yyyy-mm-dd'),'F','CLUJ',6,4);
INSERT INTO meciuri VALUES (3,to_date('2015-9-02','yyyy-mm-dd'),'F','CLUJ',5,3);
INSERT INTO meciuri VALUES (4,to_date('2015-9-13','yyyy-mm-dd'),'F','TECUCI',13,8);
INSERT INTO meciuri VALUES (5,to_date('2015-9-09','yyyy-mm-dd'),'F','GALATI',16,9);
INSERT INTO meciuri VALUES (6,to_date('2015-10-05','yyyy-mm-dd'),'T','BRASOV',2,18);
INSERT INTO meciuri VALUES (7,to_date('2015-9-14','yyyy-mm-dd'),'F','GALATI',10,14);
INSERT INTO meciuri VALUES (8,to_date('2015-9-21','yyyy-mm-dd'),'F','TECUCI',7,15);
INSERT INTO meciuri VALUES (9,to_date('2015-1-10','yyyy-mm-dd'),'T','BUCURESTI',17,11);
INSERT INTO meciuri VALUES (10,to_date('2015-9-01','yyyy-mm-dd'),'F','BRASOV',12,7);
INSERT INTO meciuri VALUES (11,to_date('2015-9-02','yyyy-mm-dd'),'F','FOCSANI',12,11);
INSERT INTO meciuri VALUES (12,to_date('2015-9-13','yyyy-mm-dd'),'F','BRASOV',4,2);
INSERT INTO meciuri VALUES (13,to_date('2015-1-15','yyyy-mm-dd'),'T','CLUJ',8,17);
INSERT INTO meciuri VALUES (14,to_date('2015-9-25','yyyy-mm-dd'),'F','GALATI',6,15);
INSERT INTO meciuri VALUES (15,to_date('2015-9-29','yyyy-mm-dd'),'F','BRASOV',12,15);
INSERT INTO meciuri VALUES (16,to_date('2015-1-10','yyyy-mm-dd'),'T','FOCSANI',8,7);
INSERT INTO meciuri VALUES (17,to_date('2015-9-20','yyyy-mm-dd'),'F','TECUCI',4,5);
INSERT INTO meciuri VALUES (18,to_date('2015-9-03','yyyy-mm-dd'),'F','BUCURESTI',4,3);
INSERT INTO meciuri VALUES (19,to_date('2015-9-02','yyyy-mm-dd'),'F','GALATI',4,17);
INSERT INTO meciuri VALUES (0,to_date('1978-12-01','yyyy-mm-dd'),'M','WONDERLAND',12,17);

INSERT INTO intermediatee VALUES (1,1,1);
INSERT INTO intermediatee VALUES (2,6,2);
INSERT INTO intermediatee VALUES (3,6,14);
INSERT INTO intermediatee VALUES (4,5,3);
INSERT INTO intermediatee VALUES (5,5,17);
INSERT INTO intermediatee VALUES (6,13,4);
INSERT INTO intermediatee VALUES (7,16,5);
INSERT INTO intermediatee VALUES (8,2,6);
INSERT INTO intermediatee VALUES (9,2,12);
INSERT INTO intermediatee VALUES (10,10,7);
INSERT INTO intermediatee VALUES (11,7,8);
INSERT INTO intermediatee VALUES (12,7,10);
INSERT INTO intermediatee VALUES (13,7,16);
INSERT INTO intermediatee VALUES (14,17,9);
INSERT INTO intermediatee VALUES (15,17,13);
INSERT INTO intermediatee VALUES (16,17,19);
INSERT INTO intermediatee VALUES (17,12,10);
INSERT INTO intermediatee VALUES (18,12,11);
INSERT INTO intermediatee VALUES (0,12,17);

/

--TRIGGERS
--Adaugarea unui meci
CREATE OR REPLACE TRIGGER add_game
  AFTER INSERT
  ON meciuri
  FOR EACH ROW
DECLARE
v_max_key INTEGER := 0;
BEGIN

  SELECT MAX(codi) INTO v_max_key FROM intermediatee;
  
  INSERT INTO INTERMEDIATEE VALUES (v_max_key + 1 , :new.cod_echipa1,:new.codm);
  INSERT INTO INTERMEDIATEE VALUES (v_max_key + 2, :new.cod_echipa2 , :new.codm);
END;
/
--Stergerea unui antrenor
CREATE OR REPLACE TRIGGER delete_trainer

  BEFORE DELETE
  ON antrenor
  FOR EACH ROW
BEGIN

  UPDATE echipe SET coda = 0 WHERE :old.coda = coda;

END;
/

--Stergerea unei echipe
CREATE OR REPLACE TRIGGER delete_team
  BEFORE DELETE
  ON echipe
  FOR EACH ROW
BEGIN
  UPDATE jucatori SET cod_e = 0 WHERE :old.cod_e = cod_e;
  DELETE FROM intermediatee WHERE :old.cod_e = cod_e;
  UPDATE meciuri SET cod_echipa1=0  where cod_echipa1= :old.cod_e;
  UPDATE meciuri SET cod_echipa2=0  where cod_echipa2= :old.cod_e;
END;
/
--Stergere intermediate
CREATE OR REPLACE TRIGGER delete_intermediatee
  BEFORE DELETE
  ON intermediatee
  FOR EACH ROW
BEGIN
  UPDATE meciuri SET cod_echipa1=0  where cod_echipa1= :old.cod_e;
  UPDATE meciuri SET cod_echipa2=0  where cod_echipa2= :old.cod_e;
END;
/
--Stergerea unui meci
CREATE OR REPLACE TRIGGER delete_game
  BEFORE DELETE
  ON meciuri
  FOR EACH ROW
BEGIN
  UPDATE intermediatee SET codm = 0 where codm = :old.codm;
  UPDATE intermediatee SET cod_e=0  where cod_e = :old.cod_echipa1 OR cod_e = :old.cod_echipa2;
END;
/
--Sfarsit Triggere


--INSERT INTO MECIURI VALUES (20,to_date('1995-9-02','yyyy-mm-dd'),'F','ere',4,17);
--DELETE FROM ANTRENOR WHERE coda = 14;
--DELETE FROM ECHIPE WHERE cod_e = 15;
--DELETE FROM INTERMEDIATEE WHERE codi = 8;
--DELETE FROM MECIURI WHERE codm = 1;



COMMIT;
/