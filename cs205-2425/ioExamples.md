[Back to index](index.html)
 ```haskell
import Data.Char
```
# Example of IO programs


Example of chaining two operations together: first we read a character from
the command line with getChar :: IO Char, then we pass this Char to the
function putChar :: Char -> IO () which will print it out when executed
```haskell

chainEx1 :: IO ()
chainEx1 = getChar >>= putChar

chainEx2 :: IO Char
chainEx2 = getChar >>= \c ->      -- note that I am skipping lines for readability
           putChar (toUpper c) >> -- only - this is customary when writing long
           putChar '\n' >>        -- chains of >>= and >>, which happens a lot
           return c               -- with IO

```
to help you parse how the λ notation is used, here is the equivalent version
on a single line with more parentheses

```haskell
 getChar >>= (\c -> putChar (toUpper c) >> (putChar '\n' >> return c))
```

Now, let us look at the same example with the two kind of do notations
(from the pov of ghc(i), they are literally the same as chainEx2)

The first one has braces and semicolons.
```haskell
chainEx1Do1 :: IO ()
chainEx1Do1 = do {
                   x <- getChar;
                   putChar x
                 }

chainEx2Do1 :: IO Char
chainEx2Do1 = do {
                   c <- getChar;
                   putChar (toUpper c);
                   putChar '\n';
                   return c
                 }
```
   Braces are used to begin/start one do block, the semicolons delimit single 
   "instruction"; an "instruction" is either a single expression of type `IO a`
   for some `a`, or an expression `variable <- ioExpression` where `ioExpression`
   is an arbitrary expression of type IO a, and variable is going to declared
   to have type a in further instuction.
   The last instruction should not contain such a variable assignment, and the
   type of the last expression determines the type of the whole IO block

   It is a good exercise to see how it is translated into the first example.

   For the other kind of do notations, it is the same except we drop braces and
   semicolons; in that case, the block is determined solely by indentation, so
   you have to be much more careful with that! I would recommend avoiding that
   if you are not disciplined.
```haskell

chainEx1Do2 :: IO ()
chainEx1Do2 = do 
                 x <- getChar
                 putChar x
                 

chainEx2Do2 :: IO Char
chainEx2Do2 = do 
                   c <- getChar
                   putChar (toUpper c)
                   putChar '\n'
                   return c
                 

```
   As per the explanation above, IO expressions in do blocks/>>= can be
   arbitrarily complicated; let us look at an example to see an instance of
   recursion/nesting (with the two kinds of notations)
```haskell

askForADigitDo :: IO Int
askForADigitDo = do {
                      c <- getChar;
                      if isDigit c then
                        return (digitToInt c)
                      else
                        do {
                              putStrLn "This is not a digit! Try again";
                              askForADigitDo
                           }
                    }
 
askForADigitBind :: IO Int
askForADigitBind =  getChar >>= \c ->
                      if isDigit c then
                        return (digitToInt c)
                      else
                        putStrLn "This is not a digit! Try again" >>
                        askForADigitBind
```
[Back to index](index.html)
