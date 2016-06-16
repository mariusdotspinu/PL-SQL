set serveroutput on;

DECLARE

v_row_count_1 INTEGER := 0;

v_column_count_1 INTEGER := 0;

v_row_count_2 INTEGER := 0;

v_column_count_2 INTEGER := 0;



v_can_be_multiplied BOOLEAN := FALSE;

  TYPE vector IS TABLE OF INTEGER INDEX BY PLS_INTEGER;

  TYPE MATRIX IS TABLE OF vector INDEX BY PLS_INTEGER;

v_matrix_1 MATRIX;
v_matrix_2 MATRIX;
v_multiplied_matrix MATRIX;

v_contor_row INTEGER;
     
v_contor_column INTEGER;

v_contor_column_second INTEGER;

v_contor_row_sceond INTEGER;

v_my_value INTEGER := 0;

v_rows INTEGER := 0;

v_my_row vector;


BEGIN


     WHILE (v_can_be_multiplied = FALSE) LOOP

          v_row_count_1 := 2 + MOD(ABS(DBMS_RANDOM.RANDOM),5);

          v_column_count_1 := 2 + MOD(ABS(DBMS_RANDOM.RANDOM),5);

          v_row_count_2 := 2 + MOD(ABS(DBMS_RANDOM.RANDOM),5);

          v_column_count_2 := 2 + MOD(ABS(DBMS_RANDOM.RANDOM),5);
          
          IF (v_column_count_1 = v_row_count_2)
              THEN
              v_can_be_multiplied := TRUE;
          END IF;
        

     END LOOP;
     
     --building firstMatrix
     
 
     
     FOR v_contor_row IN 0..v_row_count_1 LOOP
         FOR v_contor_column IN 0..v_column_count_1 LOOP
           v_my_row(v_contor_column) :=  0 + MOD(ABS(DBMS_RANDOM.RANDOM),30);
         END LOOP;
         
         v_matrix_1(v_contor_row) := v_my_row;
       
     END LOOP;
     
     
     --building secondMatrix
     
     FOR v_contor_row IN 0..v_row_count_2 LOOP
         FOR v_contor_column IN 0..v_column_count_2 LOOP
           v_my_row(v_contor_column) :=  0 + MOD(ABS(DBMS_RANDOM.RANDOM),30);
         END LOOP;
         
         v_matrix_2(v_contor_row) := v_my_row;
       
     END LOOP;
     
     --printing firstMatrix
     
     DBMS_OUTPUT.PUT_LINE('Prima matrice :');
     DBMS_OUTPUT.PUT_LINE('');
     
      FOR i in v_matrix_1.first..v_matrix_1.last LOOP
            FOR j in v_matrix_1(i).first..v_matrix_1(i).last LOOP
               IF (v_matrix_1(i)(j) < 10) THEN
               DBMS_OUTPUT.PUT(' '||v_matrix_1(i)(j)|| ' ');
               END IF;
               IF (v_matrix_1(i)(j) >=10) THEN
               DBMS_OUTPUT.PUT(v_matrix_1(i)(j) || ' ');
               END IF;
            END LOOP;
               DBMS_OUTPUT.PUT_LINE(CHR(10));
         END LOOP;
         
         DBMS_OUTPUT.PUT_LINE(CHR(10));
         
     --printing secondMatrix
     
     DBMS_OUTPUT.PUT_LINE('A doua matrice :');
     DBMS_OUTPUT.PUT_LINE('');
     
      FOR i in v_matrix_2.first..v_matrix_2.last LOOP
            FOR j in v_matrix_2(i).first..v_matrix_2(i).last LOOP
               IF (v_matrix_2(i)(j) < 10) THEN
               DBMS_OUTPUT.PUT(' '||v_matrix_2(i)(j)|| ' ');
               END IF;
               IF (v_matrix_2(i)(j) >=10) THEN
               DBMS_OUTPUT.PUT(v_matrix_2(i)(j) || ' ');
               END IF;
            END LOOP;
               DBMS_OUTPUT.PUT_LINE(CHR(10));
         END LOOP;
         
         DBMS_OUTPUT.PUT_LINE(CHR(10));
    
    --inmultirea
    
    FOR v_contor_row IN 0..v_row_count_1 LOOP
        FOR v_contor_column_second IN 0..v_column_count_2 LOOP
         FOR v_contor_row_second IN 0..v_row_count_2 LOOP
            v_my_value := v_my_value + v_matrix_1(v_contor_row)(v_contor_row_second)
            * v_matrix_2(v_contor_row_second)(v_contor_column_second);
        END LOOP;
        v_multiplied_matrix(v_contor_row)(v_contor_column_second) := v_my_value;
        v_my_value := 0;
       END LOOP;
     END LOOP;
    
     --printing multipliedMatrix
     
     DBMS_OUTPUT.PUT_LINE('Matricea rezultat :');
     DBMS_OUTPUT.PUT_LINE('');
     
    FOR i in v_multiplied_matrix.first..v_multiplied_matrix.last LOOP
      FOR j in v_multiplied_matrix(i).first..v_multiplied_matrix(i).last LOOP
               IF (v_multiplied_matrix(i)(j) < 10) THEN
               DBMS_OUTPUT.PUT('    '||v_multiplied_matrix(i)(j)|| ' ');
               END IF;
               IF (v_multiplied_matrix(i)(j) >=10 AND v_multiplied_matrix(i)(j) <=100) THEN
               DBMS_OUTPUT.PUT('   '||v_multiplied_matrix(i)(j) || ' ');
               END IF;
               IF (v_multiplied_matrix(i)(j) >= 100 AND v_multiplied_matrix(i)(j) <= 1000) THEN
               DBMS_OUTPUT.PUT('  ' || v_multiplied_matrix(i)(j) || ' ');
               END IF;
               IF (v_multiplied_matrix(i)(j) >= 1000) THEN
               DBMS_OUTPUT.PUT(' '||v_multiplied_matrix(i)(j) || ' ');
               END IF;
               
      END LOOP;
          DBMS_OUTPUT.PUT_LINE(CHR(10));
      END LOOP;
         
          DBMS_OUTPUT.PUT_LINE(CHR(10));
END;
