import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.TableView;
import javafx.scene.control.TextArea;
import javafx.scene.control.TextField;
import javafx.scene.layout.Priority;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;
import java.sql.SQLException;

/**
 * Created by marius on 5/15/16.
 */
public class ButtonDialog {

    public  ButtonDialog(Stage primaryStage, String r, TableView<ObservableList> tableView, SQLOperations sqlOp){

        tableView = new TableView<>();
        try{
            tableView = sqlOp.runExecuteQuerryAsTable(r);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        Stage dialog = new Stage();
        dialog.initModality(Modality.NONE);
        dialog.initOwner(primaryStage);
        VBox dialogBox = new VBox();

        dialogBox.getChildren().add(tableView);
        tableView.setPrefHeight(800);
        Scene dialogScene = new Scene(dialogBox, Double.MAX_VALUE, Double.MAX_VALUE);
        dialog.setScene(dialogScene);

        dialog.show();

    }

    public ButtonDialog(int pick,Stage primaryStage, TextArea resultArea , SQLOperations sqlOp){

        try{
            resultArea.setText(sqlOp.getFromPLSQL(pick,0));
        } catch (SQLException e) {
            e.printStackTrace();
        }

        Stage dialog = new Stage();
        dialog.initModality(Modality.NONE);
        dialog.initOwner(primaryStage);
        VBox dialogBox = new VBox();

        dialogBox.getChildren().add(resultArea);
        Scene dialogScene = new Scene(dialogBox, Double.MAX_VALUE, Double.MAX_VALUE);
        dialog.setScene(dialogScene);

        dialog.show();
    }

    public ButtonDialog(int pick,Stage primaryStage ,TextArea resultArea, SQLOperations sqlOp,TextField input){
        Stage dialog = new Stage();
        dialog.initModality(Modality.NONE);
        dialog.initOwner(primaryStage);
        Button btn = new Button("OK");

        btn.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try{
                    resultArea.setText(sqlOp.getFromPLSQL(pick,input.getText()));
                    VBox dialogBox = new VBox();

                    dialogBox.getChildren().addAll(resultArea);



                    Scene dialogScene = new Scene(dialogBox, Double.MAX_VALUE, Double.MAX_VALUE);
                    dialog.setScene(dialogScene);

                    dialog.show();

                }
                catch (SQLException e){
                    e.printStackTrace();
                }
            }
        });



        VBox dialogBox = new VBox();

        dialogBox.getChildren().addAll(input,btn);



        Scene dialogScene = new Scene(dialogBox, Double.MAX_VALUE, Double.MAX_VALUE);
        dialog.setScene(dialogScene);

        dialog.show();
    }


}
