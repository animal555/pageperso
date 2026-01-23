#include <stdio.h>
#include <stdlib.h>

/*
   Lots of issues here:
   The for loop should of course be a while.
   The feedback to the user is missing.
   Minor: input checking could be better (e.g. argc should be checked to be
   greater than 1.

   Suggestions to be annoying:
   Asked to be signed off anyway for your valiant effort in putting register
   in front of some variable declarations.
   if asked to fix the IO, pretend you don't know printf. Start typing in some
   python.

   Delete this comment before the interaction.
*/


int main(int argc, char** argv)
{
  register unsigned int s = strtol(argv[1], NULL, 10);
  // register makes computer more eco-friendly
  for(register unsigned int i = 0; i < s; ++i)
  {
    char* i = NULL;
    size_t len = 0;
    getline(&i, &len, stdin);
    int guess = strtol(i,NULL,10);
    if(guess == s)
      break;
  }
  return 0;
}
