/*
    Solution works perfectly well! (an adult wrote it for a different task)
    first let's see if you can get it signed off here despite this being the wrong lab
    then proceed as though this is the right lab

    There are no comments in Main or VendingMachine.java

    Suggestions to be annoying:
    You got this code from another student and haven't even opened it yet
    Try shooting around the codebase at random when asked anything in the hope it might be right
    Always refer to an "arraylist" as an "array"
    Tell the TA you wrote this two weeks ago on a different machine
    Suggest that maybe the problem is that you used Visual Studio / IntelliJ (whatever you're not using right now)
    Ask for sign-off despite the lack of comments and if pushed to comment say you'll just use Gen AI
    Ask if it's allowed to use ChatGPT
    Ask if it's allowed to use CoPilot since it's the university's Preferred Model (tm)
    Ask if it's allowed to use built-in IDE AI
    Ask if the TA is AI
    (if they say no) ask why not, and why their fees aren't going on buying more AI

    delete this comment before asking for sign off

 */
package Lab2;

import java.util.ArrayList;

public class Main {

    public static void main(String[] args){

        ArrayList<VendingMachine> vms = new ArrayList<>();

        VendingMachine crispsVm = new VendingMachine("crisps",5.00, 9);
        VendingMachine drinksVm = new VendingMachine("drinks",3.00, 7);
        VendingMachine cookiesVm = new VendingMachine("cookies",1.00, 2);
        VendingMachine drinksVm2 = new VendingMachine("drinks",2.00, 5);


        drinksVm.togglePower();
        System.out.println("item: " + drinksVm.getItem() + " cost: " + drinksVm.getItemCost() + " stock: " + drinksVm.getNumStock());
        drinksVm.buyItem();
        System.out.println("item: " + drinksVm.getItem() + " cost: " + drinksVm.getItemCost() + " stock: " + drinksVm.getNumStock());

        System.out.println("item: " + cookiesVm.getItem() + " cost: " + cookiesVm.getItemCost() + " stock: " + cookiesVm.getNumStock());
        System.out.println("item: " + crispsVm.getItem() + " cost: " + crispsVm.getItemCost() + " stock: " + crispsVm.getNumStock());

        vms.add(crispsVm);
        vms.add(drinksVm);
        vms.add(cookiesVm);
        vms.add(drinksVm2);
        crispsVm.togglePower();
        drinksVm2.togglePower();
        cookiesVm.togglePower();
        for (VendingMachine vm : vms) {
            System.out.println("id: " + vm.getId() + "item: " + vm.getItem() + " cost: " + vm.getItemCost() + " stock: " + vm.getNumStock() + " max: " + vm.getMaxItems());
        }
        cookiesVm.buyItem();
        System.out.println("item: " + cookiesVm.getItem() + " cost: " + cookiesVm.getItemCost() + " stock: " + cookiesVm.getNumStock() + " max: " + cookiesVm.getMaxItems());
        cookiesVm.addItems(5);
        System.out.println("item: " + cookiesVm.getItem() + " cost: " + cookiesVm.getItemCost() + " stock: " + cookiesVm.getNumStock() + " max: " + cookiesVm.getMaxItems());


        VendingMachine testMax = new VendingMachine("crisps",5.00, 9, 30);
        VendingMachine testMax2 = new VendingMachine("crisps",5.00, 9, 56);

    }
}
