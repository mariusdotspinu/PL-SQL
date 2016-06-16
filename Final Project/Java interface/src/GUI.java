import javafx.application.Application;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * Created by marius on 5/15/16.
 */
public class GUI extends Application {

    private TextField inputLine;
    private TextArea resultArea;
    private TextArea descrTable;
    private Connection conn;
    private TableView<ObservableList> tableView;
    private Button objectMap;
    private Button insert,delete,update,select;
    SQLOperations sqlOp;

    public GUI() throws SQLException {
        insert = new Button();
        objectMap = new Button();
        delete = new Button();
        update = new Button();
        select = new Button();
        inputLine = new TextField();
        sqlOp = new SQLOperations();
        this.conn = sqlOp.getConnection();
        resultArea = new TextArea();
        resultArea.setWrapText(true);
        resultArea.setPrefHeight(800);
        resultArea.setEditable(false);
        descrTable = new TextArea();
        tableView = new TableView<>();
        descrTable.setEditable(false);
    }

    public static void main(String[] args){
        launch(args);
    }

    @Override
    public void start(Stage primaryStage) throws SQLException {
        Masina ma = new Masina();
        ma.setCod(1);
        ma.setGreutate(25);
        ma.setAnFabricatie(1995);
        ma.setHorse_p(500);
        ma.setMarca("jaguar");
        ma.setModel("XS");
        ma.setNrViteze(5);

        ToggleGroup group = new ToggleGroup();

        RadioButton r1 = new RadioButton("JUCATORI");
        r1.setSelected(true);
        r1.setToggleGroup(group);
        RadioButton r2 = new RadioButton("ANTRENOR");
        r2.setToggleGroup(group);
        RadioButton r3 = new RadioButton("INTERMEDIATEE");
        r3.setToggleGroup(group);
        RadioButton r4 = new RadioButton("MECIURI");
        r4.setToggleGroup(group);
        RadioButton r5 = new RadioButton("ECHIPE");
        r5.setToggleGroup(group);

        Button crud = new Button();
        Button jucatori = new Button("JUCATORI");
        Button intermediatee = new Button("INTERMEDIATEE");
        Button meciuri = new Button("MECIURI");
        Button echipe = new Button("ECHIPE");
        Button antrenor = new Button("ANTRENOR");
        Button championship = new Button("championship");
        Button dbInfo = new Button("dbInfo");
        Button mecilocatie = new Button("meciuri(GALATI)");
        Button checkIfPayerHasNewMatch = new Button("checkIfPayerHasNewMatch");
        Button getPlayersFromTeam = new Button("getPlayersFromTeam");
        Button team_with_most_pending_matches = new Button("TEAMmost_pending_matches");
        Button best_team = new Button("best_team");
        Button find_goalgetter = new Button("find_goalgetter");
        Button show_average_salary_trainers = new Button("average_salary_trainers");
        Button salary_sum = new Button("salary_sum");
        Button drop_tables = new Button("DROP TABLES");
        Button importB = new Button("IMPORT");
        Button export_tables = new Button("EXPORT");
        Button selectWithIndex = new Button("SELECT(INDEX,LIKE)");
        Button selectWithoutLike = new Button("SELECT(INDEX)");


        objectMap.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try {
                    sqlOp.SerializeMasina(ma);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        });

        selectWithoutLike.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new SelectWithIndex(group,primaryStage,tableView);
            }
        });

        selectWithIndex.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new SelectWithIndexAndWhere(group,primaryStage,tableView);
            }
        });

        export_tables.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(12,primaryStage,resultArea,sqlOp);
            }
        });

        importB.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(11,primaryStage,resultArea,sqlOp);
            }
        });

        drop_tables.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(10,primaryStage,resultArea,sqlOp);
            }
        });

        salary_sum.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(9,primaryStage,resultArea,sqlOp);
            }
        });


        show_average_salary_trainers.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(8,primaryStage,resultArea,sqlOp);
            }
        });


        find_goalgetter.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(7,primaryStage,resultArea,sqlOp);
            }
        });

        best_team.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(6,primaryStage,resultArea,sqlOp);
            }
        });


        team_with_most_pending_matches.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(5,primaryStage,resultArea,sqlOp);
            }
        });

        getPlayersFromTeam.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(4,primaryStage,resultArea,sqlOp,inputLine);
            }
        });

        checkIfPayerHasNewMatch.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(3,primaryStage,resultArea,sqlOp,inputLine);
            }
        });

        mecilocatie.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(2,primaryStage,resultArea,sqlOp,inputLine);
            }
        });

        championship.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(0,primaryStage,resultArea,sqlOp);
            }
        });

        dbInfo.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new ButtonDialog(1,primaryStage,resultArea,sqlOp);
            }
        });

        jucatori.setOnAction(
                new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {

                    new ButtonDialog(primaryStage, jucatori.getText(), tableView, sqlOp);

                }
        });

        intermediatee.setOnAction(
                new EventHandler<ActionEvent>() {
                    @Override
                    public void handle(ActionEvent event) {
                        new ButtonDialog(primaryStage, intermediatee.getText(), tableView, sqlOp);
                    }
                });

        meciuri.setOnAction(
                new EventHandler<ActionEvent>() {
                    @Override
                    public void handle(ActionEvent event) {
                        new ButtonDialog(primaryStage, meciuri.getText(), tableView, sqlOp);
                    }
                });

        echipe.setOnAction(
                new EventHandler<ActionEvent>() {
                    @Override
                    public void handle(ActionEvent event) {
                        new ButtonDialog(primaryStage, echipe.getText(), tableView, sqlOp);
                    }
                });

        antrenor.setOnAction(
                new EventHandler<ActionEvent>() {
                    @Override
                    public void handle(ActionEvent event) {
                        new ButtonDialog(primaryStage, antrenor.getText(), tableView, sqlOp);
                    }
                });


        descrTable.setText(sqlOp.describeTable(r1.getText()));

        group.selectedToggleProperty().addListener(new ChangeListener<Toggle>() {
            @Override
            public void changed(ObservableValue<? extends Toggle> ov, Toggle t, Toggle t1) {
                try {
                    RadioButton r = (RadioButton)t1.getToggleGroup().getSelectedToggle();

                        descrTable.setText(sqlOp.describeTable(r.getText()));


                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        });

        crud.setText("CRUD");
        crud.setOnAction(
                new EventHandler<ActionEvent>() {
                    @Override
                    public void handle(ActionEvent event) {
                        Stage dialog = new Stage();
                        dialog.initModality(Modality.NONE);
                        dialog.initOwner(primaryStage);
                        VBox dialogBox = new VBox(20);
                        dialogBox.getChildren().addAll(insert,delete,update,select);
                        Scene dialogScene = new Scene(dialogBox, 300, 200);
                        dialog.setScene(dialogScene);
                        dialog.show();
                    }
                });

        insert.setText("INSERT");
        insert.setOnAction(
                new EventHandler<ActionEvent>() {
                    @Override
                    public void handle(ActionEvent event) {
                       new InsertLayout(group,primaryStage);
                    }
                }
        );


        delete.setText("DELETE");
        delete.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try {
                    new DeleteLayout(group,primaryStage);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        });


        update.setText("UPDATE");
        update.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try {
                    new UpdateLayout(group,primaryStage);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        });

        select.setText("SELECT (paging)");
        select.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                new SelectLayout(group,primaryStage,tableView);
            }
        });

        VBox root = new VBox();
        ButtonBar firstBar = new ButtonBar();
        ButtonBar secondBar = new ButtonBar();
        ButtonBar thirdBar = new ButtonBar();

        thirdBar.getButtons().addAll(selectWithIndex,selectWithoutLike,objectMap);

        firstBar.getButtons().addAll(drop_tables,export_tables,importB,crud,jucatori,intermediatee,meciuri,echipe,antrenor);
        secondBar.getButtons().addAll(championship,dbInfo,mecilocatie,checkIfPayerHasNewMatch,getPlayersFromTeam,team_with_most_pending_matches,best_team,
                find_goalgetter,show_average_salary_trainers,salary_sum);

        root.setPadding(new Insets(10, 50, 50, 50));
        root.setSpacing(10);
        root.getChildren().addAll(r1,r2,r3,r4,r5,descrTable,firstBar,secondBar,thirdBar);


        primaryStage.setScene(new Scene(root, 800, 600));
        primaryStage.show();

        Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {

            public void run() {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }));
    }


}
