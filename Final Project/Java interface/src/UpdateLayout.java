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
public class UpdateLayout {
    
    private Button update;
    private Label label,i1,i2;
    private TextField input1,input2;
    private SQLOperations sqlOperations;
    private RadioButton r;
    private ArrayList<String> columnNames;
    private String result;
    public UpdateLayout(ToggleGroup group,Stage primaryStage) throws SQLException {
        update = new Button("UPDATE");
        label = new Label();
        columnNames = new ArrayList<>();
        label.setVisible(false);
        input1 = new TextField();
        input2 = new TextField();
        i1 = new Label("\nMODIFY\n");
        i2 = new Label("OLD");
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

        for (int i = 1 ; i < columnNames.size();i++) {
            Label name = new Label(columnNames.get(i).split(":")[0]);
            result = columnNames.get(i).split(":")[0];
            box.getChildren().add(name);
            break;

        }

        box.getChildren().addAll(i1,input1,i2,input2,update,label);

        Scene dialogScene = new Scene(box, Double.MAX_VALUE, Double.MAX_VALUE);
        dialog.setScene(dialogScene);
        dialog.show();

        update.setOnAction(new EventHandler<ActionEvent>() {
            @Override
            public void handle(ActionEvent event) {
                try {
                    String query = "UPDATE " + r.getText() + " SET " + result + " = " + "'"+input1.getText()+"'" +
                            " WHERE " + result + " = " + "'"+input2.getText()+"'";
                    int check = Integer.parseInt(sqlOperations.runUpdateQuerry(query,label));
                    if (check == 0) {
                        label.setVisible(true);
                        label.setText("0 rows updated");
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