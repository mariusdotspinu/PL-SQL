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
 * Created by marius on 5/23/16.
 */
public class DeleteLayout {

    private Button delete;
    private Label label;
    private TextField input;
    private SQLOperations sqlOperations;
    private RadioButton r;
    private ArrayList<String> columnNames;
    private String result;
    public DeleteLayout(ToggleGroup group,Stage primaryStage) throws SQLException {
        delete = new Button("DELETE");
        label = new Label();
        columnNames = new ArrayList<>();
        label.setVisible(false);
        input = new TextField();
        r = (RadioButton) group.getSelectedToggle();
        sqlOperations = new SQLOperations();
        result = sqlOperations.describeTable(r.getText());

        Stage dialog = new Stage();
        dialog.initModality(Modality.NONE);
        dialog.initOwner(primaryStage);

        VBox box = new VBox();
        box.setAlignment(Pos.CENTER);
        String[] lines = result.split("\n");

        for (int i = 0 ; i < lines.length;i++){
            columnNames.add(lines[i]);
        }

        for (int i = 0 ; i < columnNames.size();i++) {
            Label name = new Label(columnNames.get(i).split(":")[0]);
            result = columnNames.get(i).split(":")[0];
            box.getChildren().add(name);
            break;

        }






        box.getChildren().addAll(input,delete,label);

        Scene dialogScene = new Scene(box, Double.MAX_VALUE, Double.MAX_VALUE);
        dialog.setScene(dialogScene);

        dialog.show();

        delete.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try {

                    int check = Integer.parseInt(sqlOperations.runUpdateQuerry("DELETE FROM " + r.getText() + " WHERE " + result + " LIKE " +
                            input.getText(),label));
                    if (check == 0){
                        label.setVisible(true);
                        label.setText("0 rows deleted please enter another value");
                    }
                    else{
                        label.setVisible(false);
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    label.setVisible(true);
                    label.setText(e.getMessage());
                }
            }
        });
    }
}