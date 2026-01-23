#include <iostream>
#include <termios.h>
#include <unistd.h>
#include <stdio.h>
#include <string>

/*
Good solution, but you are not doing any sort of input checking. (both
at l53 and l60, also it is linux-specific.

Suggestions to be annoying:
If the TA asks you to compile on windows, try and fail. Say that you don't
understand, it worked when you did the lab at home. There must be a problem
with the lab machine. Ask repeatedly if you can get signed off

If the TA asks you to compile on a unix machine and it works, see if they
want to sign you off or have comments on your code. If they sign you off,
tell them that you noticed a bug when you enter inputs that are not number
and ask them how'd you'd go about fixing that.
Act petulant if they don't know.

Delete this comment before the interaction.
*/

using namespace std;

int getch() {
    int ch;
    struct termios t_old, t_new;

    tcgetattr(STDIN_FILENO, &t_old);
    t_new = t_old;
    t_new.c_lflag &= ~(ICANON | ECHO);
    tcsetattr(STDIN_FILENO, TCSANOW, &t_new);

    ch = getchar();

    tcsetattr(STDIN_FILENO, TCSANOW, &t_old);
    return ch;
}


int main()
{
   cout << "Enter the number to be guessed: " << flush;
   string s;
   char c;
   while((c = getch()) != '\n')
     s += c;
   int secret = stoi(s);
   int guess;
   int n = 0;
   do{
     ++n; // saves 1 CPU cycle
     cout << "\nGuess the number!\n  ";
     cin >> guess;
     if(guess > secret)
        cout << "Too high!" << endl; // big boiiiiii
     else if(guess < secret)
        cout << "Too low!" << endl; // smoll boi
   } while(guess != *&*&secret);
   cout << "Congratulation you won in " << n << " steps.";
}
