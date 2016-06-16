import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TextField;
import javafx.scene.layout.VBox;
import javafx.stage.Modality;
import javafx.stage.Stage;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by marius on 5/23/16.
 */
public class InsertLayout {

    private Button insert;
    private ArrayList<TextField> inputFields;
    private ArrayList<Object> values;
    private Label syntaxOk;
    public InsertLayout(ToggleGroup group, Stage primaryStage){

        insert = new Button("INSERT");
        syntaxOk = new Label();
        syntaxOk.setVisible(false);
        String result = "";
        values = new ArrayList<>();
        ArrayList<String>columnNames = new ArrayList<>();
        inputFields = new ArrayList<>();
        try {
            SQLOperations sqlOP = new SQLOperations();

            RadioButton r = (RadioButton)group.getSelectedToggle();

            result = sqlOP.describeTable(r.getText());

            String[] lines = result.split("\n");

            for (int i = 0 ; i < lines.length;i++){
                columnNames.add(lines[i]);
            }

            Stage dialog = new Stage();
            dialog.initModality(Modality.NONE);
            dialog.initOwner(primaryStage);
            VBox dialogBox = new VBox();
            dialogBox.setAlignment(Pos.CENTER);

            for (int i = 0 ; i < columnNames.size();i++) {
                VBox line = new VBox();
                line.setAlignment(Pos.CENTER);

                Label name = new Label(columnNames.get(i).split(":")[0]);
                TextField field = new TextField();

                inputFields.add(field);
                line.getChildren().addAll(name,field);

                dialogBox.getChildren().add(line);
            }

            dialogBox.getChildren().addAll(insert,syntaxOk);

            Scene dialogScene = new Scene(dialogBox, Double.MAX_VALUE, Double.MAX_VALUE);
            dialog.setScene(dialogScene);

            dialog.show();




            insert.setOnAction(new EventHandler<ActionEvent>() {
                @Override
                public void handle(ActionEvent event) {
                    values.clear();
                    boolean wrongValues = false,add = false;
                    String insertString = "";

                    for (int i = 0 ; i < inputFields.size();i++){



                        if (inputFields.get(i).getText().length() > 0) {
                            add = false;
                            int numeric = -1;

                            if (inputFields.get(i).getText().matches("[0-9]+")) {
                                numeric = Integer.parseInt(inputFields.get(i).getText());
                                if (numeric != -1) {
                                    add = true;
                                    values.add(numeric);
                                }
                            }


                            else if (inputFields.get(i).getText().contains(".")){
                                values.add("to_date('" + inputFields.get(i).getText() + "','yyyy-mm-dd')");
                                add = true;
                            }
                            else {
                                values.add("'" + inputFields.get(i).getText() + "'");
                                add = true;
                            }

                            if (inputFields.size() - i > 1 && add){
                                values.add(",");
                            }
                        }

                    }

//                    for (int i = 0 ; i< values.size();i++)
//                        System.out.println(values.get(i));

                    if(values.size() >= inputFields.size()) {
                        for (int i = 0 ; i < values.size() ;i++){
                            insertString += values.get(i);
                        }
                        try {
                            sqlOP.runUpdateQuerry("INSERT INTO " + r.getText() + " VALUES (" + insertString + " )",syntaxOk);

                        }
                        catch (SQLException e) {
                            e.printStackTrace();
                            syntaxOk.setVisible(true);
                            syntaxOk.setText(e.toString());

                        }
                    }
                    else if (values.size() == 0 || wrongValues){
                        syntaxOk.setVisible(true);
                        syntaxOk.setText("WRONG VALUES");
                        syntaxOk.setStyle("-fx-color: red");
                    }

                }
            });
        } catch (SQLException e) {
            e.printStackTrace();
            syntaxOk.setVisible(true);
            syntaxOk.setText("WRONG VALUES");
            syntaxOk.setStyle("-fx-color: red");
        }
    }

}
