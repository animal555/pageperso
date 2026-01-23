package Lab2;

public class VendingMachine {

    private Boolean power;
    private String item;
    private double itemCost;
    private int numStock;
    private static final int MAX_QUANTITY_LIMIT = 50;
    private final int MAX_ITEMS;
    private int id;
    private static int nextID = 1000;

    public VendingMachine(String item, double itemCost, int numStock){
        power = false;
        setItem(item);
        this.itemCost = itemCost;
        this.numStock = numStock;
        this.id = nextID;
        nextID++;
        MAX_ITEMS = 10;
    }

    public VendingMachine(String item, double itemCost, int numStock, int limit){
        power = false;
        setItem(item);
        this.itemCost = itemCost;
        this.numStock = numStock;
        this.id = nextID;
        nextID++;
        if(limit>MAX_QUANTITY_LIMIT){
            System.out.println("exceeded limit, max set as limit");
            MAX_ITEMS = 50;
        }else {
            this.MAX_ITEMS = limit;
        }
    }

    public Boolean getPower() {
        return power;
    }

    public void setPower(Boolean power) {
        this.power = power;
    }

    public void togglePower(){
        power=!power;
    }

    public String getItem() {
        if(power){
            return item;
        } else {
            return "No power";
        }
    }

    public void setItem(String item) {
        if(item.equals("drinks")||item.equals("crisps")||item.equals("cookies")){
            this.item = item;
        } else {
            System.out.println("invalid item");
        }
    }

    public double getItemCost() {
        if(power){
            return itemCost;
        } else {
            System.out.println("No power");
            return 0;
        }
    }

    public void setCost(double itemCost) {
        this.itemCost = itemCost;
    }

    public int getNumStock() {
        if(power){
            return numStock;
        } else {
            System.out.println("No power");
            return 0;
        }
    }

    public void setNumStock(int numStock) {
        this.numStock = numStock;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMaxItems() {
        return MAX_ITEMS;
    }

    public void buyItem(){
        System.out.println("item purchased");
        numStock--;
        checkStock();
    }

    public void addItems(int quantity){
        System.out.println("restock");
        numStock+=quantity;
    }

    public void checkStock(){
        int tenPercent = (int)(MAX_ITEMS*(10/100.0f));
        System.out.println("10:"+ tenPercent);
        if(numStock<=tenPercent){
            System.out.println("Warning");
        }
    }
}
