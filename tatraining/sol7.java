/*

    okay it mostly works but uh

    - the package statement is maybe going to be irritating
    - the game never terminates
    - it prints the welcome every time which is irritating
    - the spacing is poor
    - there is no comments
    - the lack of brackets around the multiplication of random means the number is always zero

    Suggestions to be annoying:

    * Ask the TA for sign off without the comments
    * suggest genai does comments very well
    * tell the TA you spent hours on this (spoiler: it took the adult who wrote this literally 5 mins)


    delete this comment before asking for the TA for help
 */

package numguess;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {

        boolean play = true;



        int target = (int) Math.random() * 10;

        while (play) {
            System.out.println("Number guessing game\nPlease enter a number:\n");

            Scanner in = new Scanner(System.in);

            int guess = in.nextInt();

            if (guess < target) {
                System.out.println("Too low");
            } else if (guess > target) {
                System.out.println("Too high");
            } else {
                System.out.println("well done, it was " + target);
            }
        }
    }
}
