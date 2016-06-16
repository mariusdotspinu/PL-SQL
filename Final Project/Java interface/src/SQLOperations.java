import java.sql.*;
import javafx.beans.property.SimpleStringProperty;
import javafx.beans.value.ObservableValue;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.util.Callback;
import org.omg.CORBA.INTERNAL;

/**
 * Created by marius on 5/14/16.
 */
public class SQLOperations {

    private TableView<ObservableList> tableview;
    private Connection conn;

    public String describeTable(String r) throws SQLException {

        Statement stm = this.conn.createStatement();
        String myResult = "";

        try {
            ResultSet rs = stm.executeQuery("SELECT * FROM " + r);
            ResultSetMetaData rsmd = rs.getMetaData();
            for (int i = 1 ; i <= rsmd.getColumnCount(); i++){
                myResult += rsmd.getColumnName(i) + ":" + rsmd.getColumnTypeName(i) + "\n";
            }
        }
        catch (SQLException ignored){
            ignored.printStackTrace();
            System.out.println("Operatie gresita describe!");
            myResult = "Table not existent";
        }
        return myResult;
    }

    public String getFromPLSQL (int pick,Object parameter) throws SQLException {

        boolean dml = false;
        String myResult = "";
        CallableStatement stmt = null;
        try {

            switch (pick){
                case 0:
                    stmt = this.conn.prepareCall("{ ? = call football.championship_structure }");
                    stmt.registerOutParameter(1, Types.VARCHAR);
                    break;
                case 1:
                    stmt = this.conn.prepareCall("{ call football.get_db_info(?) }");
                    stmt.registerOutParameter(1, Types.VARCHAR);
                    break;
                case 2:
                    stmt = this.conn.prepareCall("{ ? = call football.get_location_match(?) }");
                    stmt.setString(2,(String) parameter);
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 3:
                    stmt = this.conn.prepareCall("{ ? = call football.check_if_player_has_new_match(?) }");
                    String par1 = (String) parameter;
                    if (par1.matches("[0-9]+")) {
                        stmt.setInt(2, Integer.parseInt((String) parameter));
                    }
                    else{
                        stmt.setInt(2,0);
                    }
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 4:
                    stmt = this.conn.prepareCall("{ ? = call football.get_all_players_from_team(?) }");
                    String par = (String) parameter;
                    if (par.matches("[0-9]+")) {
                        stmt.setInt(2, Integer.parseInt((String) parameter));
                    }
                    else{
                        stmt.setInt(2,0);
                    }
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 5:
                    stmt = this.conn.prepareCall("{ ? = call football.team_with_most_pending_matches }");
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 6:
                    stmt = this.conn.prepareCall("{ ? = call football.best_team }");
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 7:
                    stmt = this.conn.prepareCall("{ ? = call football.find_goalgetter }");
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 8:
                    stmt = this.conn.prepareCall("{ ? = call football.show_average_salary_trainers }");
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 9:
                    stmt = this.conn.prepareCall("{ call football.salary_sum(?) }");
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 10:
                    stmt = this.conn.prepareCall("{ call IE.drop_everything(?) }");
                    stmt.registerOutParameter(1,Types.VARCHAR);;
                    break;
                case 11:
                    stmt = this.conn.prepareCall("{ call IE.import_csv(?) }");
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
                case 12:
                    stmt = this.conn.prepareCall("{ call IE.export_tables(?) }");
                    stmt.registerOutParameter(1,Types.VARCHAR);
                    break;
            }
            //stmt.setInt(2, 254);
            if (stmt != null && !dml) {

                stmt.execute();
                myResult = (String) stmt.getObject(1);
            }
        }

        catch (SQLException e) {
            e.printStackTrace();
        }

        return myResult;
    }

    public TableView<ObservableList> selectIndexNoLike(String r,String column,String value) throws SQLException {
        tableview = new TableView<>();
        Statement stm = this.conn.createStatement();
        ObservableList<ObservableList> data = FXCollections.observableArrayList();

        try {
            ResultSet rs = stm.executeQuery("SELECT outer.*\n" +
                    "  FROM (SELECT ROWNUM rn, inner.*\n" +
                    "          FROM (  SELECT e.*\n" +
                    "                    FROM " + r + " e\n" +
                    "                ORDER BY " + column + " ) inner) outer\n" +
                    " WHERE outer.rn >= 0 AND outer.rn <= 15 AND upper(" + column + ") = " + value + "");

            for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){

                final int j = i;

                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));

                col.setCellValueFactory(new Callback<TableColumn.CellDataFeatures<ObservableList,Object>,ObservableValue<String>>(){

                    public ObservableValue<String> call(TableColumn.CellDataFeatures<ObservableList, Object> param) {
                        if (param.getValue() == null || param.getValue().get(j) == null){
                            return new SimpleStringProperty("");
                        }
                        return new SimpleStringProperty(param.getValue().get(j).toString());

                    }

                });

                tableview.getColumns().addAll(col);

            }

            while(rs.next()){

                ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    row.add(rs.getString(i));

                }

                data.add(row);

            }


            tableview.setItems(data);
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("Error on Building Data");
        }

        //stretch to content
        tableview.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);

        return tableview;
    }

    public void SerializeMasina(Masina masina) throws SQLException {
        String request = "{call serialize_masina(?, ?, ?, ?, ?, ?, ?)}";

        CallableStatement stmt = this.conn.prepareCall(request);
        stmt.setInt(1,masina.getCod());
        stmt.setString(2, masina.getMarca());
        stmt.setString(3, masina.getModel());
        stmt.setInt(4, masina.getHorse_p());
        stmt.setInt(5, masina.getNrViteze());
        stmt.setInt(6, masina.getGreutate());
        stmt.setInt(7, masina.getAnFabricatie());

        stmt.execute();
        stmt.close();
    }

    public void deserializeMasina(String model) throws SQLException {
        String query = "SELECT horse_p FROM masina WHERE _model = '" + model + "'";

        Statement stmt = this.conn.createStatement();
        ResultSet rs = stmt.executeQuery(query);

        while (rs.next()) {
            Masina masina = (Masina) rs.getObject("horse_p");
            System.out.println(masina.getMarca());
        }
    }

    public TableView<ObservableList> selectIndex(String r,String column,String value) throws SQLException {
        tableview = new TableView<>();
        Statement stm = this.conn.createStatement();
        ObservableList<ObservableList> data = FXCollections.observableArrayList();

        try {
            ResultSet rs = stm.executeQuery("SELECT outer.*\n" +
                    "  FROM (SELECT ROWNUM rn, inner.*\n" +
                    "          FROM (  SELECT e.*\n" +
                    "                    FROM " + r + " e\n" +
                    "                ORDER BY " + column + " ) inner) outer\n" +
                    " WHERE outer.rn >= 0 AND outer.rn <= 15 AND upper(" + column + ") like '%" + value + "'");

            for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){

                final int j = i;

                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));

                col.setCellValueFactory(new Callback<TableColumn.CellDataFeatures<ObservableList,Object>,ObservableValue<String>>(){

                    public ObservableValue<String> call(TableColumn.CellDataFeatures<ObservableList, Object> param) {
                        if (param.getValue() == null || param.getValue().get(j) == null){
                            return new SimpleStringProperty("");
                        }
                        return new SimpleStringProperty(param.getValue().get(j).toString());

                    }

                });

                tableview.getColumns().addAll(col);

            }

            while(rs.next()){

                ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    row.add(rs.getString(i));

                }

                data.add(row);

            }


            tableview.setItems(data);
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("Error on Building Data");
        }

        //stretch to content
        tableview.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);

        return tableview;
    }



    public TableView<ObservableList> paging(String r,String column) throws SQLException {
        tableview = new TableView<>();
        Statement stm = this.conn.createStatement();
        ObservableList<ObservableList> data = FXCollections.observableArrayList();

        try {
            ResultSet rs = stm.executeQuery("SELECT outer.*\n" +
                    "  FROM (SELECT ROWNUM rn, inner.*\n" +
                    "          FROM (  SELECT e.*\n" +
                    "                    FROM " + r + " e\n" +
                    "                ORDER BY " + column + " ) inner) outer\n" +
                    " WHERE outer.rn >= 10 AND outer.rn <= 15");

            for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){

                final int j = i;

                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));

                col.setCellValueFactory(new Callback<TableColumn.CellDataFeatures<ObservableList,Object>,ObservableValue<String>>(){

                    public ObservableValue<String> call(TableColumn.CellDataFeatures<ObservableList, Object> param) {
                        if (param.getValue() == null || param.getValue().get(j) == null){
                            return new SimpleStringProperty("");
                        }
                        return new SimpleStringProperty(param.getValue().get(j).toString());

                    }

                });

                tableview.getColumns().addAll(col);

            }

            while(rs.next()){

                ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    row.add(rs.getString(i));

                }

                data.add(row);

            }


            tableview.setItems(data);
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("Error on Building Data");
        }

        //stretch to content
        tableview.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);

        return tableview;
    }



    public TableView<ObservableList> runExecuteQuerryAsTable(String r) throws SQLException {
        tableview = new TableView<>();
        Statement stm = this.conn.createStatement();
        ObservableList<ObservableList> data = FXCollections.observableArrayList();

        try {
            ResultSet rs = stm.executeQuery("SELECT * FROM " + r);

            for(int i=0 ; i<rs.getMetaData().getColumnCount(); i++){

                final int j = i;

                TableColumn col = new TableColumn(rs.getMetaData().getColumnName(i+1));

                col.setCellValueFactory(new Callback<TableColumn.CellDataFeatures<ObservableList,Object>,ObservableValue<String>>(){

                    public ObservableValue<String> call(TableColumn.CellDataFeatures<ObservableList, Object> param) {
                        if (param.getValue() == null || param.getValue().get(j) == null){
                            return new SimpleStringProperty("");
                        }
                        return new SimpleStringProperty(param.getValue().get(j).toString());

                    }

                });

                tableview.getColumns().addAll(col);

            }

            while(rs.next()){

                ObservableList<String> row = FXCollections.observableArrayList();
                for(int i=1 ; i<=rs.getMetaData().getColumnCount(); i++){
                    row.add(rs.getString(i));

                }

                data.add(row);

            }


            tableview.setItems(data);
        }catch(Exception e){
            e.printStackTrace();
            System.out.println("Error on Building Data");
        }

        //stretch to content
        tableview.setColumnResizePolicy(TableView.CONSTRAINED_RESIZE_POLICY);

        return tableview;
    }

    public String runUpdateQuerry(String s, Label label) throws SQLException {

        Statement stm = this.conn.createStatement();
        String myResult = "";

        try {
            myResult = stm.executeUpdate(s)+"";
            label.setVisible(false);

        }
        catch (SQLException ignored){
            ignored.printStackTrace();
            label.setVisible(true);
            label.setText(ignored.getMessage());
            myResult = "SYNTAX ERROR OR INVALID STATEMENT!";
        }
        return myResult;

    }

    public void setConnection () throws SQLException {


        try  {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            this.conn = DriverManager.getConnection( "jdbc:oracle:thin:@localhost:1521:XE", "MARIUS", "mypas95");
        }
        catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        catch (SQLException e){
            e.printStackTrace();
            System.out.println("Not working");
        }

    }

    public Connection getConnection(){
        return this.conn;
    }

    public SQLOperations() throws SQLException {
        this.setConnection();
    }
}
