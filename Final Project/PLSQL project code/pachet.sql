CREATE OR REPLACE PACKAGE football IS
     all_info VARCHAR2(1000);
     v_sum INTEGER;
     v_number_of_trainers INTEGER := 0;
     FUNCTION show_average_salary_trainers RETURN VARCHAR2;--done
     FUNCTION find_goalgetter RETURN VARCHAR2;--done
     FUNCTION best_team RETURN VARCHAR2;--done
     FUNCTION team_with_most_pending_matches RETURN VARCHAR2;--done
     FUNCTION get_location_match(p_locatie meciuri.locatie%TYPE) RETURN VARCHAR2;--done
     FUNCTION championship_structure RETURN VARCHAR2;--done
     FUNCTION get_all_players_from_team (p_cod_e echipe.cod_e%TYPE) RETURN VARCHAR2;--done
     FUNCTION check_if_player_has_new_match (p_codj jucatori.codj%TYPE) RETURN VARCHAR2;--done
     FUNCTION get_nr_of_persons RETURN INTEGER;
     FUNCTION get_nr_of_matches RETURN INTEGER;
     FUNCTION get_nr_of_teams RETURN INTEGER;
     PROCEDURE salary_sum(p_sum OUT VARCHAR2);--done
     PROCEDURE get_db_info(p_all_info OUT VARCHAR2);--done
     FUNCTION get_all_info RETURN VARCHAR2;
     FUNCTION get_v_sum RETURN VARCHAR2;
     FUNCTION get_v_number_of_trainers RETURN INTEGER;
     
END football;
/
CREATE OR REPLACE PACKAGE BODY football IS

    PROCEDURE salary_sum(p_sum OUT VARCHAR2) IS
   BEGIN
        SELECT SUM(salariu) INTO v_sum FROM antrenor;
        SELECT COUNT(*)-1 INTO v_number_of_trainers FROM antrenor;
        p_sum := v_sum||'';
    EXCEPTION
        WHEN no_data_found THEN
             dbms_output.put_line( '-20022-> Date insuficiente!');
        WHEN others THEN
             dbms_output.put_line(  '-20033-> Date eronate!');
   END;
 
    FUNCTION show_average_salary_trainers RETURN VARCHAR2 AS    
     BEGIN
       IF (v_number_of_trainers = 0)
          THEN
              RETURN '-1';
          ELSE
              RETURN v_sum / v_number_of_trainers||'';
          END IF;
     END;
 
    FUNCTION find_goalgetter RETURN VARCHAR2 AS
        v_max INTEGER := 0;
        v_list VARCHAR2(1000) := '';
        counter number;
        no_players EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_players, -20001);
    BEGIN
    SELECT COUNT(*) INTO counter FROM jucatori;
        IF counter=0 THEN
            raise no_players;
        END IF;
        SELECT max(goluri) INTO v_max FROM jucatori;
        DECLARE
            v_juc jucatori.numej%TYPE;
            CURSOR get_goalgetter IS
                SELECT (numej) FROM jucatori
                WHERE goluri = v_max;
        BEGIN
            OPEN get_goalgetter;
            LOOP
            FETCH get_goalgetter INTO v_juc;
            EXIT WHEN get_goalgetter%NOTFOUND;            
            v_list := v_list || v_juc || ', ';           
            END LOOP;           
            CLOSE get_goalgetter;
        END;       
     RETURN v_list;  
     EXCEPTION
     WHEN no_players THEN
         RETURN '-20001-> Momentan nu exista jucatori in baza de date!';  
     WHEN no_data_found THEN
             RETURN '-20022-> Date insuficiente!';
     WHEN others THEN
             RETURN '-20033-> Date eronate!';
     END;

    FUNCTION best_team RETURN VARCHAR2 AS
        v_wins INTEGER := 0;
        v_list VARCHAR2(1000) := '';
        counter number;
        no_teams EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_teams, -20002);
    BEGIN 
        SELECT COUNT(*) INTO counter FROM echipe;
        IF counter=0 THEN
            raise no_teams;
        END IF;
       SELECT max(wins) INTO v_wins FROM echipe; 
       DECLARE
           v_echipa echipe.nume%TYPE;    
           CURSOR get_best IS
           SELECT (nume) FROM echipe
           WHERE wins = v_wins;     
       BEGIN      
            OPEN get_best;
            LOOP      
            FETCH get_best INTO v_echipa;
            EXIT WHEN get_best%NOTFOUND;      
            v_list := v_list || v_echipa || ', ';      
            END LOOP;      
            CLOSE get_best;      
       END;     
     RETURN v_list;
     EXCEPTION
     WHEN no_teams THEN
         RETURN '-20002-> Momentan nu exista echipe in baza de date!'; 
     WHEN no_data_found THEN
             RETURN '-20022-> Date insuficiente!';
     WHEN others THEN
             RETURN '-20033-> Date eronate!';
   END;
   
    FUNCTION get_location_match (p_locatie meciuri.locatie%TYPE) RETURN VARCHAR2 AS
   
   v_e1 meciuri.cod_echipa1%TYPE;
   v_e2 meciuri.cod_echipa2%TYPE;
   
   v_nume_e1 echipe.nume%TYPE;
   v_nume_e2 echipe.nume%TYPE;
   
   v_result VARCHAR2(1000) := 'Meciurile din : ' || p_locatie || CHR(13) || CHR(10);
 
   CURSOR list_matches IS
   SELECT DISTINCT cod_echipa1,cod_echipa2 FROM meciuri
   WHERE locatie = p_locatie AND cod_echipa1 <> 0 AND cod_echipa2 <> 0;
   v_mesaj varchar2(1000):='';
   counter number;  
   inexistent_location EXCEPTION;        
   PRAGMA EXCEPTION_INIT(inexistent_location, -20003);
   no_games EXCEPTION;        
   PRAGMA EXCEPTION_INIT(no_games, -20004);
   no_teams EXCEPTION;        
   PRAGMA EXCEPTION_INIT(no_teams, -20005);
 
   BEGIN
   SELECT COUNT(*) INTO counter FROM meciuri WHERE locatie = p_locatie;
      IF counter=0 THEN
          raise inexistent_location;
      END IF;
   SELECT COUNT(*) INTO counter FROM meciuri;
      IF counter=0 THEN
          raise no_games;
      END IF;  
   SELECT COUNT(*) INTO counter FROM echipe;
      IF counter=0 THEN
          raise no_teams;
      END IF;      
   OPEN list_matches;
   
   LOOP
   
     FETCH list_matches INTO v_e1,v_e2;
     EXIT WHEN list_matches%NOTFOUND;
     
     SELECT echipe.nume INTO v_nume_e1
     FROM echipe
     WHERE echipe.cod_e = v_e1;
     
     SELECT echipe.nume INTO v_nume_e2
     FROM echipe
     WHERE echipe.cod_e = v_e2;  
     v_result := v_result || v_nume_e1 || ' - ' || v_nume_e2 || CHR(13) || CHR(10);     
    END LOOP;  
    CLOSE list_matches;
     RETURN v_result;
    EXCEPTION
        WHEN inexistent_location THEN
            v_result:=v_result||'20003->Locatia nu se regaseste in baza de date!'||CHR(13)||CHR(10);
             RETURN v_result;
        WHEN no_games THEN
            v_result:=v_result||'20004->Momentan nu exista meciuri in baza de date!'||CHR(13)||CHR(10);
             RETURN v_result;
        WHEN no_teams THEN
            v_result:=v_result||'20005->Momentan nu exista echipe in baza de date!'||CHR(13)||CHR(10); 
        WHEN no_data_found THEN
             RETURN '-20022-> Date insuficiente!';
        WHEN others THEN
             RETURN '-20033-> Date eronate!';
      RETURN v_result;
 END; 

    FUNCTION get_nr_of_persons RETURN INTEGER AS
        v_number_of_tr INTEGER :=0;
        v_number_of_players INTEGER := 0;
        counter number;
        no_trainers EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_trainers, -20006);
        no_players EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_players, -20007);
   BEGIN
       SELECT COUNT(*) INTO counter FROM antrenor;
          IF counter=0 THEN
              raise no_trainers;
          END IF;
       SELECT COUNT(*) INTO counter FROM jucatori;
          IF counter=0 THEN
              raise no_players;
          END IF;  
        SELECT COUNT(*)-1 INTO v_number_of_tr FROM antrenor; 
        SELECT COUNT(*) -1 INTO v_number_of_players FROM jucatori;       
        RETURN v_number_of_tr + v_number_of_players;
        EXCEPTION
        WHEN no_trainers THEN
             RETURN -20006;
        WHEN no_players THEN
             RETURN -20007;
        WHEN no_data_found THEN
             RETURN -20022;
        WHEN others THEN
             RETURN -20033;
    END;

    FUNCTION get_nr_of_matches RETURN INTEGER AS
        v_number_of_matches INTEGER := 0;
        counter number;
        no_games EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_games, -20008);
    BEGIN
          SELECT COUNT(*) INTO counter FROM meciuri;
          IF counter=0 THEN
              raise no_games;
          END IF; 
        SELECT COUNT(*)-1 INTO v_number_of_matches FROM meciuri;  
        RETURN v_number_of_matches; 
        EXCEPTION
        WHEN no_games THEN
             RETURN -20008;
        WHEN no_data_found THEN
             RETURN -20022;
        WHEN others THEN
             RETURN -20033;
    END;

    FUNCTION get_nr_of_teams RETURN INTEGER AS
        v_number_of_teams INTEGER := 0;
        counter number;
        no_teams EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_teams, -20009);
    BEGIN  
          SELECT COUNT(*) INTO counter FROM echipe;
          IF counter=0 THEN
              raise no_teams;
          END IF;
        SELECT COUNT(*)-1 INTO v_number_of_teams FROM echipe;  
        RETURN v_number_of_teams;  
    EXCEPTION
        WHEN no_teams THEN
             RETURN -20009;
        WHEN no_data_found THEN
             RETURN -20022;
        WHEN others THEN
             RETURN -20033;
    END;

    FUNCTION get_all_players_from_team (p_cod_e echipe.cod_e%TYPE) RETURN VARCHAR2 AS  
        v_lista VARCHAR2(1000);
        v_team_list VARCHAR2(1000);
        CURSOR get_players IS
        SELECT (numej) || CHR(13) || CHR(10) FROM JUCATORI
        WHERE cod_e = p_cod_e;  
        counter number;
        inexistent_team EXCEPTION;        
        PRAGMA EXCEPTION_INIT(inexistent_team, -20010);
        no_players EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_players, -20011);
    BEGIN  
          SELECT COUNT(*) INTO counter FROM echipe where cod_e=p_cod_e;
          IF counter=0 THEN
              raise inexistent_team;
          END IF;
          SELECT COUNT(*) INTO counter FROM jucatori;
          IF counter=0 THEN
              raise no_players;
          END IF;
        OPEN get_players;  
        LOOP  
            FETCH get_players INTO v_lista;
            EXIT WHEN get_players%NOTFOUND;
            v_team_list := v_team_list || v_lista || CHR(13)||CHR(10);
        END LOOP;  
        CLOSE get_players;  
        RETURN v_team_list; 
        EXCEPTION
        WHEN inexistent_team THEN
             RETURN '-20010->Aceasta echipa nu se regaseste in baza de date';
        WHEN no_players THEN
             RETURN '-20011->Momentan nu exista jucatori in baza de date';
        WHEN no_data_found THEN
             RETURN '-20022-> Date insuficiente!';
        WHEN others THEN
             RETURN '-20033-> Date eronate!';

    END;

    FUNCTION championship_structure RETURN VARCHAR2 AS
        v_championship VARCHAR2(10000) := '= CAMPIONAT =' ||CHR(13) || CHR(10);   
        v_e1_nume echipe.nume%TYPE;
        v_e2_nume echipe.nume%TYPE;
        v_a1_nume antrenor.nume_a%TYPE;
        v_a2_nume antrenor.nume_a%TYPE;
        v_m_locatie meciuri.locatie%TYPE;
        v_m_codm meciuri.codm%TYPE; 
        CURSOR get_champ IS  
        SELECT me.codm,e1.nume,e2.nume,a1.nume_a,a2.nume_a,me.locatie
        FROM meciuri me
        JOIN echipe e1 on e1.cod_e = me.cod_echipa1
        JOIN echipe e2 on e2.cod_e = me.cod_echipa2
        JOIN antrenor a1 on a1.coda = e1.coda
        JOIN antrenor a2 on a2.coda = e2.coda
        WHERE me.codm <> 0 AND e1.cod_e <> 0 AND e2.cod_e <> 0 AND a1.coda <>0 AND a2.coda <>0;
        counter number;
        no_teams EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_teams, -20013);
        no_games EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_games, -20014);
        no_trainers EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_trainers, -20015);
    BEGIN    
          SELECT COUNT(*) INTO counter FROM echipe;
          IF counter=0 THEN
              raise no_teams;
          END IF;
          SELECT COUNT(*) INTO counter FROM antrenor;
          IF counter=0 THEN
              raise no_trainers;
          END IF;
          SELECT COUNT(*) INTO counter FROM meciuri;
          IF counter=0 THEN
              raise no_games;
          END IF;
        OPEN get_champ;    
        LOOP
        FETCH get_champ INTO v_m_codm,v_e1_nume ,v_e2_nume,v_a1_nume,v_a2_nume,v_m_locatie;
        EXIT WHEN get_champ%NOTFOUND;    
        v_championship := v_championship ||v_m_codm || CHR(13) || CHR(10) ||
        v_m_locatie || CHR(13) || CHR(10) || v_e1_nume || ' - ' || v_e2_nume||
        CHR(13) || CHR(10) || v_a1_nume || ' - ' ||v_a2_nume || CHR(13) ||CHR(10)
        ||CHR(13) || CHR(10);    
        END LOOP;    
        CLOSE get_champ;   
        RETURN v_championship; 
    EXCEPTION
        WHEN no_teams THEN
             RETURN '-20013->Momentan nu exista echipe in baza de date';
        WHEN no_trainers THEN
             RETURN '-20014->Momentan nu exista antrenori in baza de date';
        WHEN no_games THEN
             RETURN '-20015->Momentan nu exista meciuri in baza de date';
        WHEN no_data_found THEN
             RETURN '-20022-> Date insuficiente!';
        WHEN others THEN
             RETURN '-20033-> Date eronate!';

    END;

    FUNCTION team_with_most_pending_matches RETURN VARCHAR2 AS 
        v_max INTEGER;
        v_cod_e echipe.cod_e%TYPE;
        v_nume echipe.nume%TYPE;
        v_resultat VARCHAR2(1000);
        counter number;
        no_games EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_games, -20016);
        no_teams EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_teams, -20017);
    BEGIN    
        SELECT MAX(COUNT(cod_e)) INTO v_max FROM intermediatee GROUP BY cod_e;    
          SELECT COUNT(*) INTO counter FROM echipe;
          IF counter=0 THEN
              raise no_teams;
          END IF;
          SELECT COUNT(*) INTO counter FROM intermediatee;
          IF counter=0 THEN
              raise no_games;
          END IF;
        DECLARE    
            CURSOR get_teams IS    
            SELECT cod_e FROM intermediatee 
            GROUP BY cod_e
            HAVING count(cod_e) = v_max;           
        BEGIN    
            OPEN get_teams;    
            LOOP    
                FETCH get_teams INTO v_cod_e;
                EXIT WHEN get_teams%NOTFOUND; 
                SELECT nume INTO v_nume
                FROM echipe
                WHERE cod_e = v_cod_e;   
                v_resultat := v_resultat || v_nume || CHR(13) || CHR(10);    
            END LOOP;   
            CLOSE get_teams;   
        END; 
        RETURN v_resultat;
            EXCEPTION
        WHEN no_teams THEN
             RETURN '-20017->Momentan nu exista echipe in baza de date';
        WHEN no_games THEN
             RETURN '-20016->Momentan nu exista meciuri in baza de date';
        WHEN no_data_found THEN
             RETURN '-20022-> Date insuficiente!';
        WHEN others THEN
             RETURN '-20033-> Date eronate!';

  END;

    FUNCTION check_if_player_has_new_match (p_codj jucatori.codj%TYPE) RETURN VARCHAR2 AS 
        v_nr INTEGER; 
        counter number;
        inexistent_player EXCEPTION; 
        PRAGMA EXCEPTION_INIT(inexistent_player, -20018);
        no_players EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_players, -20019);
        no_games EXCEPTION;        
        PRAGMA EXCEPTION_INIT(no_games, -20020);
    BEGIN  
    
          SELECT COUNT(*) INTO counter FROM jucatori where codj=p_codj;
          IF counter=0 THEN
              raise inexistent_player;
          END IF;
          SELECT COUNT(*) INTO counter FROM jucatori;
          IF counter=0 THEN
              raise no_players;
          END IF;
          SELECT COUNT(*) INTO counter FROM meciuri;
          IF counter=0 THEN
              raise no_games;
          END IF;
        SELECT COUNT(intermediatee.cod_e) INTO v_nr 
          FROM intermediatee
          JOIN echipe ON intermediatee.cod_e = echipe.cod_e
          JOIN jucatori ON echipe.cod_e = jucatori.cod_e
          WHERE jucatori.codj = p_codj;   
        IF (v_nr > 0)
          THEN
            RETURN 'True';
          ELSE
            RETURN 'False';
        END IF;  
        EXCEPTION
        WHEN inexistent_player THEN
             RETURN '-20018->Aceasta echipa nu se regaseste in baza de date';
        WHEN no_players THEN
             RETURN '-20019->Momentan nu exista jucatori in baza de date';
        WHEN no_games THEN
             RETURN '-20020->Momentan nu exista meciuri in baza de date';
        WHEN no_data_found THEN
             RETURN '-20022-> Date insuficiente!';
        WHEN others THEN
             RETURN '-20033-> Date eronate!';
    END;


  PROCEDURE get_db_info(p_all_info OUT VARCHAR2) AS
  BEGIN 
      all_info := all_info || get_nr_of_persons || ' - persoane ' || CHR(13) || CHR(10)
      || get_nr_of_teams || ' - echipe ' || get_nr_of_matches || ' - meciuri ';
      
      p_all_info := p_all_info || get_nr_of_persons || ' - persoane ' || CHR(13) || CHR(10)
      || get_nr_of_teams || ' - echipe ' ||CHR(13) || CHR(10)|| get_nr_of_matches || ' - meciuri ';
  END;
  
  FUNCTION get_all_info RETURN VARCHAR2 AS
  
  BEGIN
   RETURN all_info;
  END;
  
  FUNCTION get_v_sum RETURN VARCHAR2 AS 
  
  BEGIN
    RETURN v_sum;
  END;
  
  FUNCTION get_v_number_of_trainers RETURN INTEGER AS
  
  BEGIN
    RETURN v_number_of_trainers;
  END;
  
END football;
/


set serveroutput on;
BEGIN
DBMS_OUTPUT.PUT_LINE(football.show_average_salary_trainers);
END;

