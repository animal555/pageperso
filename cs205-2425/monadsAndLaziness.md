[Back to index](index.html)


# Why is IO set up this way and some other topics.

```haskell
import Data.Array ( (!), array )
import Data.Char ( ord )


```
   This question is a good excuse to:

   * see how the do notation is actually compiled

   * reveal the existence of monads (and demystify the notion)

   * talk some more about lazy evalutation

## Desugaring the do notation (recalling the context of IO)

   First, let us recall how the do notation for IO is translated to a bunch
   of function applications (that is what ghc will do under the hood).
  
   To translate *every* instance of the do notation we have seen so far,
   we only need one basic function (written as an infix operator and commonly
   called 'bind')

```haskell
   (>>=) :: IO a -> (a -> IO b) -> IO b
```

   that allows to chain IO inputs.
   To build some familiarity with this, let us first consider a simpler
   sequence operator

```haskell
   (>>) :: IO a -> IO b -> IO b
``` 

  which is defined by
```haskell
     x >> y  =  x >>= \_ -> y
```

   We don't need to read that definition right now to build intuitions:
   `x >> y` corresponds to performing the action in `x`, then the action in `y`
   and return the same result as `y`.
```haskell
ioSeqEx :: IO ()
ioSeqEx = putStrLn "Hi" >> putStrLn "Bye"
```
   This is the same as
```haskell
ioSeqExDo :: IO ()
ioSeqExDo = do {
                 putStrLn "Hi";
                 putStrLn "Bye"
               }
```
   and in general, any expression of the shape
```haskell 
   do
   {
      t;
      u;
      ...
   }
```

for `t` and `u` programs of type `IO a` (without assignment) is translated
to

```
t >> u >> ...
```

The more general `(>>=)` is needed precisely to handle variable assignments
Let's take a non-trivial example.

```haskell
(>>=) :: IO a -> (a -> IO b) -> IO b
```

```haskell



copycatDo :: IO ()
copycatDo = do {
                  x <- getLine;
                  putStrLn (x ++ "!")
               }

```
  This is equivalent to
```haskell
copycatBind :: IO ()
copycatBind = getLine >>= \x -> putStrLn (x ++ "!")

```
   We are now ready to look at what the first program of the file looks like
   when we translate the do notation using these combinators.
   Recall that the definition was
```haskell

doIO1 :: IO String 
doIO1 = do {
             a <- getLine;
             b <- getLine;
             putStrLn (b ++ a);
             return (b ++ a)
           } 
 
```
   Now let us look at the equivalent variant using (>>=) and (>>) and using a
   suggestive indentation
```haskell

bindIO :: IO String
bindIO = getLine >>= \a ->
         getLine >>= \b ->
         putStrLn (b ++ a) >>
         return (b ++ a)

```
   And that is all that is behind the do notations!

## The do notation: some (puzzling) examples

The do notation as we used it so far for IO
```haskell

doIO :: IO String 
doIO = do {
            a <- getLine;
            b <- getLine;
            putStrLn (b ++ a);
            return (b ++ a)
          } 

``` But in fact the do notations is also applicable in other contexts!
 (What is below is a teaser with two examples, not an explanation)

1) do notation for list comprehensions
```haskell
doList :: [(Int,Char)]
doList = do {
              x <- [1..5];
              y <- ['a','z'];
              return (x,y)
            }

-- [(x,y) | x <- [1..5], y <- ['a','z']]

-- >>> doList
-- [(1,'a'),(1,'z'),(2,'a'),(2,'z'),(3,'a'),(3,'z'),(4,'a'),(4,'z'),(5,'a'),(5,'z')]

```
 2) do notation for chaining Maybe computations
```haskell

divMaybe :: Int -> Int -> Maybe Int
divMaybe x 0 = Nothing
divMaybe x y = Just (x `div` y)

doMaybe :: Int -> Int -> Int -> Maybe Int
doMaybe x y z = do {
                      a <- divMaybe x y;
                      b <- divMaybe z a;
                      return (a + b)
                   }

-- >>> doMaybe 1 0 0
-- Nothing

-- >>> doMaybe 1 2 0

-- >>> doMaybe 1 1 0

```
## The most general type for (>>=)

Even for the non-IO examples above such as
```haskell

doList1 :: [(Int,Char)]
doList1 = do {
              x <- [1..5];
              y <- ['a','z'];
              return (x,y)
             }
```
   the translation from the do notation to combinators is the same
```haskell

bindList :: [(Int,Char)]
bindList = [1..5]    >>= \x ->
           ['a','z'] >>= \y ->
           return (x, y)

-- >>> doList1 == bindList
-- True

```
   This does not tell us however what is the meaning of (>>=) when applied
   to things which are not IO. If we ask GHC what is the type of (>>=) and
   return, we have

```haskell
return :: Monad m => a -> m a
   (>>=) :: Monad m => m a -> (a -> m b) -> m b
```
  
   These functions are actually methods of the typeclass Monad.
  
> **Side-note**: this typeclass has one feature we have not encountered yet.
> The argument m of "Monad m" is not a type, but a type constructor.
> (jargon: it has higher kind * -> * instead of the ground kind * for types)
>   
>    * Examples of types (kind *):
>             Int, Char, [Int]
>   
>    * Examples of type constructors of kind * -> *: 
>             lists ([_]), Maybe, IO, Either Int
>   
>    * Examples of type constructors of kind * -> * -> *:
>             tupling (_,_), Either

  
   Monad is just one of the many typeclasses defined in Prelude, but it is such
   a useful abstraction (in particular because it is used for IO).
  
   Many type constructors come with a rather natural Monad instance such as [_]
   and Maybe which are pretty useful. As we have seen in the examples, the
   list monad gives some powerful combinators to implement list comprehensions.
   The official definition of the operators (>>=) and return for lists is the
   following:

```haskell
   return a = [a]
  
   [] >>= _ = []
   (x : xs) >>= f = f x ++ (xs >>= f)
``` 
   The instance Monad Maybe on the other hand gives us combinators to easily
   chain computations with a "fail state" represented by Nothing.
   return is taken to be
```haskell 
   return = Just
```  
   and the `bind` constructor is asked as part of an optional task for Lab 5 ;)
   It is also pretty natural to define a primitive
  
```haskell
fail = Nothing
```
  
   to write very natural programs using the do notation!
  
   There are many more Monad instances in the base library which are useful for
   a variety of purposes: for instance, there is a ST that allows to compute
   pure functions with a suitable facilities to emulate "mutable variables" as
   you would find them in imperative languages.
  
   Much like with any typeclasses, advanced users can also define their own
   instances.
  
## Why do we need to use a IO type constructor again?
  
   Other major functional programming OCaml does not. Up to syntax and naming
   conventions (the following code snippets are fictional!), that language has
```haskell
     putStrLn :: String -> ()
     getLine :: () -> String
```
   and a chaining operator
```haskell
     (;) :: a -> b -> b
```
   so that
```haskell
   f = let z = getLine () in
       let y = getLine () in
       putStrLn z;
       10
```

   is a valid program of type Int that performs side-effects along the way.
  
   So why does Haskell force us to wrap our side-effects inside the IO monad?
  
   One (slightly disingenuous) answer: because Haskell wants to reflect that
   computations that are impure are distinguished at the type-level, and that is
   good for programmers!
  
   A stronger reason: because programs in Haskell are lazyly evaluated, having
   that design decision would make the order in which operations are executed
   highly counter-intuitive.
   Wrapping impure computations inside an IO monad actually forces evaluation
   of commands to be executed in order.
  
   Example: if we evaluate the program f above eagerly, the instructions would
   all be executed in sequence. But if we are lazy and want to obtain the
   integer value of f while evaluating as little as possible, it is possible
   to do so without performing any input/output action!
   
## Defining your own typeclass instances 
  
   Here I will declare a new typeclass and we will see how to define typeclass
   instances.
  
   The typeclass that I am going to define is going to be called Size and will
   simply provide, for every type a such that Size a is defined, a canonical
   function a -> Int meant to define the size of the type a.
   First, we need to declare that
```haskell

class Sized a where
  size :: a -> Int

```
   The syntax is `class NameOfTheClass typeParameter1 ... typeParameterN where`
   followed by type signatures of particular functions called _methods_ of the
   typeclass. We can check their actual types, and see that it corresponds to
   the declaration above
```haskell

-- >>> :t size
-- size :: Size a => a -> Int

```
   Methods can be used to declare new functions sharing those sort of typeclass
   constraints
```haskell
isBig :: Sized a => a -> Bool
isBig x = size x >= 51


```
   Now that we have declared the typeclass, now would be a good time to give
   some values of size for some datatypes where it makes sense! These values
   are called _instances_ and are defined using the following syntax for base
   types
```haskell

instance Sized Bool where
  size _ = 1


-- >>> isBig True
-- False

instance Sized () where
  size () = 1

instance Sized Int where
  size i = 64 

instance Sized Char where
  size _ = 8 

instance Sized Integer where
  size = ceiling . log . fromIntegral

```
   It is possible to declare family of instances which can be implemented using
   other typeclass instances: here are a few examples:
```haskell

instance Sized a => Sized [a] where
  size = sum . map size

instance (Sized a, Sized b) => Sized (a,b) where
  size (x,y) = size x + size y

-- >>> size ("abc",["aa","noooo","please"])
-- 80

-- >>> isBig "aaaaaaaaaaaaaaaa"
-- True

```
   As we have seen above with Monad, typeclasses can also be defined in more
   complex situations where we have type families, but the general principles
   remain the same.


## Lazy vs eager evaluation
  
   First, let us give a rough idea of one way of picturing the difference
   between lazy and eager evaluation. Given a function application
 
```
   (\y -> \x -> (x,x)) (2^5) 2
```
   
   the lazy evaluator will first try to substitute the arguments in the function
   body, delaying the evaluation of the arguments themselves until the last
   moment. One way of representing this computation on our example is

```
   (\y -> \x -> x+x) (2^12) (2+2)    (initial value)
--    → (\x -> x+1) (2 + 2)          (replace y by the expression 2^5)
--    → (2 + 2) + 1                  (replace x by the expression 2 + 2)
--    → 4 + 1                      
--    → 5                         
```

   Eager evaluators will first evaluate the arguments of their functions before
   substituting within the function body.

```
   (\y -> \x -> x+x) (2^12) (2+2)          (initial value)
      → (\y -> \x -> x+1) 4096 (2 + 2)     (compute 2^5)
      → (\y -> \x -> x+1) 4096 4           (compute 2+2)
      → (\x -> x+1) 4                      (replace y by 4096)
      → 4 + 1                        
      → 5                           
```
   The choice of having lazy evaluation vs eager evaluation can be a contentious
   issue in language design; there are pros and cons to both.
  
   * Lazy > Eager:
     - lazy evaluation can avoid costly intermediate computations
     - easier to code recursive functions that terminate in a lazy setting
   * Eager > Lazy:
     - a bit more intuitive to compute the running time
     - meshes well with IO and imperative programming without a sophisticated
       type system
  
   Since we are studying Haskell, which is lazy, I feel it would be best to
   leave you with a few examples of laziness in action, some of which are useful
   in practice!

### Laziness example 1: infinite intermediate data structure

Note that the following declaration is perfectly legal in Haskell, while it
is impossible to do in eager languages such as OCaml (and analogon that would
typecheck would typically loop and crash)
```haskell

allPositiveList :: [Int]
allPositiveList = 0 : map (+1) allPositiveList

```
   Trying to display this using show would lead to an infinite loop.
   But thanks to laziness, this can safely be used to compute finitary
   data.
```haskell

-- >>> take 10 allPositiveList
-- [0,1,2,3,4,5,6,7,8,9]

```
### Laziness example 2: dynamic programming
  
   Take a good look at the implementation of binomial below. Ignoring
   the trivial case where k > n, the main routine uses a local (immutable)
   array which seemingly gets initialized with the solution provided by a
   recursive function!
  
   This is one elegant of way of doing dynamic programming in Haskell that is
   unavailable in languages with eager evaluation. For instance, to accomplish
   the same task in OCaml, we would typically need to use side-effects.
```haskell

binomial :: Int -> Int -> Int
binomial k n | k > n     = 0
             | otherwise = a ! (k, n)
                  where a = array ((0,0),(k,n))
                                 [ ((i,j), b i j) | i <- [0..k], j <- [0..n]]
                        b 0 k = 1
                        b i j | i == j = 1
                        b i j = (a ! (i,j-1)) + (a ! (i-1,j-1))

-- >>> binomial 5 10
-- 252

```
### Laziness example 3: ignoring (some) diverging computations

Compare and contrast the following definitions:

```haskell

andl :: Bool -> Bool -> Bool
False `andl` _ = False
_ `andl` False = False
True `andl` True = True

andr :: Bool -> Bool -> Bool
_ `andr` False = False
False `andr` _ = False
True `andr` True = True

``` Take an ill-founded recursive definition; trying to evaluate this would
   not go well! ```haskell
bot :: a
bot = bot

-- >>> bot
-- loops forever

-- >>> False `andl` bot
-- False

-- >>> bot `andl` False
-- loops forever

-- >>> bot `andr` False
-- False

```
 [Here](http://math.andrej.com/2007/09/28/seemingly-impossible-functional-programs/)
 are Math-oriented examples (that can be patched to work in an eager language,
 but laziness makes definition easier to go through) which are very fun!
```haskell
```
[Back to index](index.html)
