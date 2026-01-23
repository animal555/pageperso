/*
In l10 and 11, the last X should be S.

Suggestion to be annoying:
when testing your function, terminate your test before the error triggers (i.e.,
always make a single guess), until the TA forces you to test two values in
a row.
Say something about artificial intelligence.

Delete this comment before interaction.
*/

game(S) :- print('Give your best guess'), nl, read(X), guess(S,X).

guess(S, X) :- S < X, print('Go lower!'), game(X), nl.
guess(S, X) :- S > X, print('Go higher!'), game(X), nl.
guess(X, X) :- print('Well done!').
