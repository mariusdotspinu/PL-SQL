import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by marius on 5/25/16.
 */
public class SelectLayout {
    private SQLOperations sqlOperations;
    private TextField input;
    private Label label;
    private Button select;
    private TableView tableV;
    public SelectLayout(ToggleGroup group,Stage primaryStage,TableView tableView){
        select = new Button("OK");
        tableV = new TableView();
        tableV = tableView;
        label = new Label("Column name : \n");

        select.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try {
                    sqlOperations = new SQLOperations();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                try{
                    RadioButton r1 = (RadioButton)group.getSelectedToggle();
                    tableV = sqlOperations.paging(r1.getText(),input.getText());
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                Stage dialog = new Stage();
                dialog.initModality(Modality.NONE);
                dialog.initOwner(primaryStage);
                VBox dialogBox = new VBox();

                dialogBox.getChildren().add(tableV);
                tableV.setPrefHeight(800);
                Scene dialogScene = new Scene(dialogBox, Double.MAX_VALUE, Double.MAX_VALUE);
                dialog.setScene(dialogScene);

                dialog.show();
            }
        });



        input = new TextField();


        Stage dialog = new Stage();
        dialog.initModality(Modality.NONE);
        dialog.initOwner(primaryStage);

        VBox box = new VBox();
        box.setAlignment(Pos.CENTER);



        box.getChildren().addAll(label,input,select);

        Scene dialogScene = new Scene(box, Double.MAX_VALUE, Double.MAX_VALUE);
        dialog.setScene(dialogScene);

        dialog.show();







    }
}

