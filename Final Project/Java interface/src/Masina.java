/**
 * Created by marius on 5/25/16.
 */
public class Masina {
    private int horse_p;
    private String model;
    private String marca;
    private int greutate,anFabricatie;
    private int nrViteze;
    private int cod;





    public void setCod(int cod){
        this.cod = cod;
    }

    public int getCod(){
        return this.cod;
    }

    public void setHorse_p(int horse_p){
        this.horse_p = horse_p;
    }

    public void setModel(String model){
        this.model = model;
    }

    public void setMarca(String marca){
        this.marca = marca;
    }

    public void setGreutate(int greutate){
        this.greutate = greutate;
    }

    public void setAnFabricatie(int anFabricatie){
        this.anFabricatie = anFabricatie;
    }

    public void setNrViteze(int nrViteze){
        this.nrViteze = nrViteze;
    }

    public int getHorse_p(){
        return this.horse_p;
    }

    public int getGreutate(){
        return this.greutate;
    }

    public int getAnFabricatie(){
        return this.anFabricatie;
    }

    public int getNrViteze(){
        return this.nrViteze;
    }

    public String getModel(){
        return this.model;
    }

    public String getMarca(){
        return this.marca;
    }
}
